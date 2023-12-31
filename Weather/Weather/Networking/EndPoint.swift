//
//  EndPoint.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/09.
//

import Foundation

struct EndPoint {
    init (urlInformation: URLInformation) {
        self.urlInformation = urlInformation
    }
    
    private let urlInformation: URLInformation
    private let scheme: String = "https"
    private let host: String = "api.openweathermap.org"
    
    var url: URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = urlInformation.path
        urlComponents.queryItems = urlInformation.queryItems
        return urlComponents.url
    }
    
    enum URLInformation {
        case weather(latitude: String, longitude: String)
        
        var path: String {
            switch self {
            case .weather:
                return "/data/2.5/forecast"
            }
        }
        
        var queryItems: [URLQueryItem] {
            var queryItems: [URLQueryItem] = [.init(name: "appid", value: APIKeys.weather)]
            
            switch self {
            case .weather(let latitude, let longitude):
                queryItems.append(.init(name: "lat", value: latitude))
                queryItems.append(.init(name: "lon", value: longitude))
                queryItems.append(.init(name: "units", value: "metric"))
            }
            
            return queryItems
        }
    }
}
