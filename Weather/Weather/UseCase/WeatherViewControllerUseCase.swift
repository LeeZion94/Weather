//
//  WeatherViewControllerUseCase.swift
//  WeatherViewControllerUseCase
//
//  Created by Hyungmin Lee on 2023/10/14.
//

import Foundation

protocol WeatherViewControllerUseCaseType {
    func convertTodayWeatherDTO(forecaseResult: ForecastResult) -> TodayWeatherDTO?
}

final class WeatherViewControllerUseCase: WeatherViewControllerUseCaseType {
    private let dateConverter: DateConverterType
    
    init(dateConverter: DateConverterType) {
        self.dateConverter = dateConverter
    }
    
    func convertTodayWeatherDTO(forecaseResult: ForecastResult) -> TodayWeatherDTO? {
        guard let todayListItem = forecaseResult.list.first else { return nil }
        let todayWeather = todayListItem.weather

        return TodayWeatherDTO(cityName: forecaseResult.city.name,
                               weatherDescription: todayWeather.first?.description ?? "",
                               temperature: "\(todayListItem.main.temp)°C")
    }
}
