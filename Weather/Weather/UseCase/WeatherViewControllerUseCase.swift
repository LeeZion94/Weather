//
//  WeatherViewControllerUseCase.swift
//  WeatherViewControllerUseCase
//
//  Created by Hyungmin Lee on 2023/10/14.
//

import Foundation

/// 제가 알기로는 데이터쪽 인터페이스도
/// 도메인 레이어에서 들고있어서 데이터가 도메인에 의존해야한다고 알고있는데
/// 넘 오래전에 공부해서 확인해보시면 좋을 듯 

/// 사실 전 클린아키에 부정적인 입장인데요,
/// 요 부분이 굳이 필요한가 의문이긴 해요
/// 그래서 이 과정에서 어떤 이득을 얻을 수 있는지, 하면 뭐가 좋은지 잘 설명해주시면 좋을 듯
protocol WeatherViewControllerUseCaseType {
    func convertTodayWeatherDTO(forecastResult: ForecastResult) -> TodayWeatherDTO?
    func convertDayOfWeekString(forecastResult: ForecastResult) -> String?
    func convertHourlyWeatherDTOList(forecastResult: ForecastResult) -> [HourlyWeatherDTO]
    func convertWeeklyWeatherDTOList(forecastResult: ForecastResult) -> [WeeklyWeatherDTO]
    func convertDetailWeatherDTOList(forecastResult: ForecastResult) -> [DetailWeatherDTO]?
}

final class WeatherViewControllerUseCase: WeatherViewControllerUseCaseType {
    private let dateConverter: DateConverterType
    
    init(dateConverter: DateConverterType) {
        self.dateConverter = dateConverter
    }
    
    func convertTodayWeatherDTO(forecastResult: ForecastResult) -> TodayWeatherDTO? {
        guard let todayListItem = forecastResult.list.first else { return nil }
        let todayWeather = todayListItem.weather

        return TodayWeatherDTO(weatherDescription: todayWeather.first?.description ?? "",
                               temperature: "\(Int(todayListItem.main.temp))°C")
    }
    
    func convertDayOfWeekString(forecastResult: ForecastResult) -> String? {
        guard let todayListItem = forecastResult.list.first else { return nil }
        let convertedDay = dateConverter.convertDayOfWeekFromLocalDate(timezone: forecastResult.city.timezone,
                                                                    date: todayListItem.dt_txt)
        
        return convertedDay
    }
    
    func convertHourlyWeatherDTOList(forecastResult: ForecastResult) -> [HourlyWeatherDTO] {
        let weatherLsit = forecastResult.list
        
        return weatherLsit.map {
            let convertedHour = dateConverter.convertHourFromLocalDate(timezone: forecastResult.city.timezone,
                                                                       date: $0.dt_txt)
            
            return HourlyWeatherDTO(hour: convertedHour,
                                    imageName: $0.weather.first?.icon ?? "",
                                    temperature: "\(Int($0.main.temp))°C")
        }
    }
    
    func convertWeeklyWeatherDTOList(forecastResult: ForecastResult) -> [WeeklyWeatherDTO] {
        var minTemperatureList = [String: Double]()
        var maxTemperatureList = [String: Double]()
        var dateList = [String: Date]()
        var iconList = [String: String]()
        
        for forecast in forecastResult.list {
            let day = dateConverter.convertDayOfWeekFromLocalDate(timezone: forecastResult.city.timezone,
                                                                  date: forecast.dt_txt)
            let date = dateConverter.convertLocalDateFromUTC(timezone: forecastResult.city.timezone,
                                                             string: forecast.dt_txt)
            
            minTemperatureList.merge([day: forecast.main.temp_min]) { oldValue, newValue in
                return oldValue > newValue ? newValue : oldValue
            }
            
            maxTemperatureList.merge([day: forecast.main.temp_max]) { oldValue, newValue in
                return oldValue > newValue ? oldValue : newValue
            }
            
            dateList.merge([day: date]) { oldValue, newValue in
                return oldValue
            }
            
            iconList.merge([day: forecast.weather.first?.icon ?? ""]) { oldValue, newValue in
                return oldValue
            }
        }
        
        return weeklyWeatherDTOList(minTemperatureList: minTemperatureList,
                                    maxTemperatureList: maxTemperatureList,
                                    dateList: dateList,
                                    iconList: iconList)
    }
    
    func convertDetailWeatherDTOList(forecastResult: ForecastResult) -> [DetailWeatherDTO]? {
        guard let detailWeather = forecastResult.list.first?.main else { return nil }
        
        let firstSection = DetailWeatherDTO(leftTitle: "humidity",
                                            leftValue: "\(detailWeather.humidity) %",
                                            rightTitle: "pressure",
                                            rightValue: "\(detailWeather.pressure) hPa")
        
        let secondSection = DetailWeatherDTO(leftTitle: "sea level pressure",
                                            leftValue: "\(detailWeather.sea_level) hPa",
                                            rightTitle: "groud level pressure",
                                            rightValue: "\(detailWeather.grnd_level) hPa")
        
        let thirdSection = DetailWeatherDTO(leftTitle: "wind",
                                            leftValue: "WNW \(forecastResult.list.first?.wind.deg ?? 0) m/s",
                                            rightTitle: "clouds",
                                            rightValue: "\(forecastResult.list.first?.clouds.all ?? 0) %")
        
        return [firstSection, secondSection, thirdSection]
    }
}

// MARK: - Private
extension WeatherViewControllerUseCase {
    private func weeklyWeatherDTOList(minTemperatureList: [String: Double],
                                      maxTemperatureList: [String: Double],
                                      dateList: [String: Date],
                                      iconList: [String: String]) -> [WeeklyWeatherDTO] {
        var weelyWeatherDTOList = [WeeklyWeatherDTO]()
        
        for day in minTemperatureList.keys {
            let weeklyWeatherDTO = WeeklyWeatherDTO(day: day,
                                                    imageName: iconList[day] ?? "",
                                                    maxTemperature: "\(Int(maxTemperatureList[day] ?? 0))°C",
                                                    minTemperature: "\(Int(minTemperatureList[day] ?? 0))°C",
                                                    date: dateList[day] ?? Date())
            
            weelyWeatherDTOList.append(weeklyWeatherDTO)
        }
        
        return weelyWeatherDTOList.sorted(by: { (first, second) in
            return first.date < second.date
        })
    }
}
