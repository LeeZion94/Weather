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
        let weatherTrigger: Observable<Void>
    }

    struct Output {
        let forecastResult: Observable<ForecastResult?>
    }
    
    private let weatherRepository: WeatherRepositoryType
    
    init(weatherRepository: WeatherRepositoryType) {
        self.weatherRepository = weatherRepository
    }
    
    func transform(input: Input) -> Output {
        let cityName = "seoul"
        
        let forecastResult: Observable<ForecastResult?> = input.weatherTrigger.flatMap {
            return self.weatherRepository.fetchWeatherData(cityName: cityName).map { result in
                switch result {
                case .success(let forecastResult):
                    return forecastResult
                case .failure:
                    return nil
                }
            }
        }
        
        return Output(forecastResult: forecastResult)
    }
}
