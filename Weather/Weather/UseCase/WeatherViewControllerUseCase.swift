//
//  WeatherViewControllerUseCase.swift
//  WeatherViewControllerUseCase
//
//  Created by Hyungmin Lee on 2023/10/14.
//

import Foundation

protocol WeatherViewControllerUseCaseType {
    func convertTodayWeatherDTO(forecastResult: ForecastResult) -> TodayWeatherDTO?
    func convertDayOfWeekString(forecastResult: ForecastResult) -> String?
    func convertHourlyWeatherDTOList(forecastResult: ForecastResult) -> [HourlyWeatherDTO]
    func convertWeeklyWeatherDTOList(forecastResult: ForecastResult) -> [WeeklyWeatherDTO]
}

final class WeatherViewControllerUseCase: WeatherViewControllerUseCaseType {
    private let dateConverter: DateConverterType
    
    init(dateConverter: DateConverterType) {
        self.dateConverter = dateConverter
    }
    
    func convertTodayWeatherDTO(forecastResult: ForecastResult) -> TodayWeatherDTO? {
        guard let todayListItem = forecastResult.list.first else { return nil }
        let todayWeather = todayListItem.weather

        return TodayWeatherDTO(cityName: forecastResult.city.name,
                               weatherDescription: todayWeather.first?.description ?? "",
                               temperature: "\(todayListItem.main.temp)°C")
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
                                    temperature: "\($0.main.temp)")
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
                                                    maxTemperature: "\(maxTemperatureList[day] ?? 0)",
                                                    minTemperature: "\(minTemperatureList[day] ?? 0)",
                                                    date: dateList[day] ?? Date())
            
            weelyWeatherDTOList.append(weeklyWeatherDTO)
        }
        
        return weelyWeatherDTOList.sorted(by: { (first, second) in
            return first.date < second.date
        })
    }
}
