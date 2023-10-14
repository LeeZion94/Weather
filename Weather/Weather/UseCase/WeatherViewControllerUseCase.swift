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
        let dayString = dateConverter.convertDayOfWeekFromLocalDate(timezone: forecastResult.city.timezone,
                                                                    date: todayListItem.dt_txt)
        
        return dayString
    }
}
