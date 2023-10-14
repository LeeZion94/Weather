//
//  WeatherViewControllerUseCase.swift
//  WeatherViewControllerUseCase
//
//  Created by Hyungmin Lee on 2023/10/14.
//

import Foundation

protocol WeatherViewControllerUseCaseType {
    
}

final class WeatherViewControllerUseCase: WeatherViewControllerUseCaseType {
    private let forecaseResult: ForecastResult
    
    init(forecaseResult: ForecastResult) {
        self.forecaseResult = forecaseResult
    }
}
