//
//  URLSessionProvider.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import Foundation
import RxSwift
import RxCocoa

protocol URLSessionProviderType {
    func dataTask(url: URL?, header: [String: String]?, httpMethod: String) -> Observable<Result<Data, APIError>>
}

final class URLSessionProvider: URLSessionProviderType {
    private var dataTask: URLSessionDataTask?
    
    func dataTask(url: URL?, header: [String: String]?, httpMethod: String) -> Observable<Result<Data, APIError>> {
        guard let urlRequest = setUpUrlRequest(url: url, header: header, httpMethod: httpMethod) else {
            return Observable.just(.failure(.invalidUrl))
        }
        
        return URLSession.shared.rx.data(request: urlRequest)
            .map { data in
                return .success(data)
            }
            .catch({ error in
                return Observable.just(Result.failure(.httpError))
            })
            .asObservable()
    }
}

// MARK: - Private
extension URLSessionProvider {
    private func setUpUrlRequest(url: URL?, header: [String: String]?, httpMethod: String) -> URLRequest? {
        guard let url else { return nil }
        var urlRequest = URLRequest(url: url)
        
        header?.forEach { (key, value) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        urlRequest.httpMethod = httpMethod
        return urlRequest
    }
}
