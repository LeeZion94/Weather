//
//  WeatherRepository.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import Foundation
import RxSwift

protocol WeatherRepositoryType {
    func fetchWeatherData(coordinate: Coordinate) -> Observable<Result<ForecastResult, APIError>>
}

final class WeatherRepository: WeatherRepositoryType {
    private let urlSessionProvider: URLSessionProviderType
    
    init(urlSessionProvider: URLSessionProviderType) {
        self.urlSessionProvider = urlSessionProvider
    }
    
    func fetchWeatherData(coordinate: Coordinate) -> Observable<Result<ForecastResult, APIError>> {
        let endPoint = EndPoint(urlInformation: .weather(latitude: coordinate.latitude,
                                                         longitude: coordinate.longitude))
        
        return urlSessionProvider.dataTask(url: endPoint.url, header: nil, httpMethod: "get").map { result in
            switch result {
            case .success(let data):
                guard let forecaseResult = try? JSONDecoder().decode(ForecastResult.self, from: data) else {
                    return .failure(.decodingError)
                }
                
                return .success(forecaseResult)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
}
