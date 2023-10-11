//
//  WeatherRepository.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import Foundation
import RxSwift

protocol WeatherRepositoryType {
    func fetchWeatherData(cityName: String) -> Observable<Result<ForecastResult, APIError>>
}

final class WeatherRepository: WeatherRepositoryType {
    private let urlSessionProvider: URLSessionProviderType
    
    init(urlSessionProvider: URLSessionProviderType) {
        self.urlSessionProvider = urlSessionProvider
    }
    
    func fetchWeatherData(cityName: String) -> Observable<Result<ForecastResult, APIError>> {
        let endPoint = EndPoint(urlInformation: .weather(cityName: cityName))
        
        return urlSessionProvider.dataTask(url: endPoint.url).map { result in
            switch result {
            case .success(let data):
//                guard let forecaseResult = try? JSONDecoder().decode(ForecastResult.self, from: data) else {
//                    return .failure(.decodingError)
//                }
//                
//                return .success(forecaseResult)
                
                do {
                    let forecaseResult = try JSONDecoder().decode(ForecastResult.self, from: data)
                    
                    return .success(forecaseResult)
                } catch {
                    print(error)
                    return .failure(.decodingError)
                }
                
            case .failure(let error):
                return .failure(error)
            }
        }.asObservable()
    }
}
