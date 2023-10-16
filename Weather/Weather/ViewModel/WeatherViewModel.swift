//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import RxSwift
import RxCocoa



final class WeatherViewModel {
    struct Input {
        let weatherTrigger: Observable<Coordinate>
    }

    struct Output {
        let forecastResult: Observable<ForecastResult>
        let todayWeather: Observable<TodayWeatherDTO>
        let dayOfWeek: Observable<String>
        let hourlyWeather: Observable<[HourlyWeatherDTO]>
        let weeklyWeatehr: Observable<([WeeklyWeatherDTO], [DetailWeatherDTO])>
    }
    
    private let weatherRepository: WeatherRepositoryType
    private let weatherViewControllerUseCase: WeatherViewControllerUseCaseType
    
    init(weatherRepository: WeatherRepositoryType,
         weatherViewControllerUseCase: WeatherViewControllerUseCaseType) {
        self.weatherRepository = weatherRepository
        self.weatherViewControllerUseCase = weatherViewControllerUseCase
    }
    
    func transform(input: Input) -> Output {
        let forecastResult: Observable<ForecastResult> = input.weatherTrigger.flatMap { coordinate in
            return self.weatherRepository.fetchWeatherData(coordinate: coordinate).compactMap { result in
                switch result {
                case .success(let forecastResult):
                    return forecastResult
                case .failure:
                    return nil
                }
            }
        }.share()
        
        let todayWeather: Observable<TodayWeatherDTO> = forecastResult.compactMap { forecastResult in
            return self.weatherViewControllerUseCase.convertTodayWeatherDTO(forecastResult: forecastResult)
        }
        
        let dayOfWeek: Observable<String> = forecastResult.compactMap { forecastResult in
            return self.weatherViewControllerUseCase.convertDayOfWeekString(forecastResult: forecastResult)
        }
        
        let hourlyWeather: Observable<[HourlyWeatherDTO]> = forecastResult.map { forecastResult in
            return self.weatherViewControllerUseCase.convertHourlyWeatherDTOList(forecastResult: forecastResult)
        }
        
        let weeklyWeather: Observable<([WeeklyWeatherDTO], [DetailWeatherDTO])> = forecastResult.compactMap { forecastResult in
            guard let detailWeatherDTOList = self.weatherViewControllerUseCase.convertDetailWeatherDTOList(forecastResult: forecastResult) else { return nil }
            let weeklyWeatherDTOList = self.weatherViewControllerUseCase.convertWeeklyWeatherDTOList(forecastResult: forecastResult)
            
            return (weeklyWeatherDTOList, detailWeatherDTOList)
        }
        
        return Output(forecastResult: forecastResult,
                      todayWeather: todayWeather,
                      dayOfWeek: dayOfWeek,
                      hourlyWeather: hourlyWeather,
                      weeklyWeatehr: weeklyWeather)
    }
}
