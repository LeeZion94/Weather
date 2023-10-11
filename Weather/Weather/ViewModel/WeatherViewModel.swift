//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import RxSwift
import RxCocoa

struct Input {
    let weatherTrigger: Observable<Result<Weather, APIError>>
}

struct Output {
    let weatherList: Observable<Weather>
}

protocol WeatherViewModelType {
    func transform(input: Input) -> Output
}

final class WeatherViewModel: WeatherViewModelType {
    private let weatherRepository: WeatherRepositoryType
    
    init(weatherRepository: WeatherRepositoryType) {
        self.weatherRepository = weatherRepository
    }
    
    func transform(input: Input) -> Output {
        let output = input.weatherTrigger.map { result in
            switch result {
            case .success(let weather):
                return weather
            case .failure(let error):
                print("TEST: error -> \(error)")
                return Weather()
            }
        }
        
        return Output(weatherList: output)
    }
}
