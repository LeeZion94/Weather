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
    private let host: String = ""
    
    var url: URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = urlInformation.path
        urlComponents.queryItems = urlInformation.queryItems
        return urlComponents.url
    }
    
    enum URLInformation {
        case shortWeather
        
        var path: String {
            switch self {
            case .shortWeather:
                return ""
            }
        }
        
        var queryItems: [URLQueryItem] {
            var queryItems = [URLQueryItem]()
            
            switch self {
            case .shortWeather:
                queryItems.append(.init(name: "", value: ""))
            }
            
            return queryItems
        }
    }
}
