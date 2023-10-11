//
//  WeatherRepository.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import Foundation
import RxSwift

protocol WeatherRepositoryType {
    func fetchWeatherData(cityName: String) -> Observable<Result<Weather, APIError>>
}

final class WeatherRepository: WeatherRepositoryType {
    private let urlSessionProvider: URLSessionProviderType
    
    init(urlSessionProvider: URLSessionProviderType) {
        self.urlSessionProvider = urlSessionProvider
    }
    
    func fetchWeatherData(cityName: String) -> Observable<Result<Weather, APIError>> {
        let endPoint = EndPoint(urlInformation: .weather(cityName: cityName))
        
        return urlSessionProvider.dataTask(url: endPoint.url).map { result in
            switch result {
            case .success(let data):
                guard let weatherData = try? JSONDecoder().decode(Weather.self, from: data) else {
                    return .failure(.decodingError)
                }
                
                return .success(weatherData)
            case .failure(let error):
                return .failure(error)
            }
        }.asObservable()
    }}
