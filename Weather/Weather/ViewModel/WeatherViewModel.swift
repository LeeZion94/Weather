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
        let weatherTrigger: Observable<String>
    }

    struct Output {
        let forecastResult: Observable<ForecastResult>
        let todayWeather: Observable<TodayWeatherDTO>
    }
    
    private let weatherRepository: WeatherRepositoryType
    private let weatherViewControllerUseCase: WeatherViewControllerUseCaseType
    
    init(weatherRepository: WeatherRepositoryType,
         weatherViewControllerUseCase: WeatherViewControllerUseCaseType) {
        self.weatherRepository = weatherRepository
        self.weatherViewControllerUseCase = weatherViewControllerUseCase
    }
    
    func transform(input: Input) -> Output {
        let forecastResult: Observable<ForecastResult> = input.weatherTrigger.flatMap { cityName in
            return self.weatherRepository.fetchWeatherData(cityName: cityName).compactMap { result in
                switch result {
                case .success(let forecastResult):
                    return forecastResult
                case .failure:
                    return nil
                }
            }
        }.share()
        
        let todayWeather: Observable<TodayWeatherDTO> = forecastResult.compactMap { forecastResult in
            return self.weatherViewControllerUseCase.convertTodayWeatherDTO(forecaseResult: forecastResult)
        }
        
        return Output(forecastResult: forecastResult,
                      todayWeather: todayWeather)
    }
}
