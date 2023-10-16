//
//  APIError.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import Foundation

enum APIError: LocalizedError {
    case invalidUrl
    case httpError
    case decodingError
    
    var errorDescription: String {
        switch self {
        case .invalidUrl:
            return "URL Error가 발생했습니다"
        case .httpError:
            return "Http Error가 발생했습니다"
        case .decodingError:
            return "Decoding Error가 발생했습니다"
        }
    }
}
