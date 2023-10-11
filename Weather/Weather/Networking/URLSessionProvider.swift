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
    func dataTask(url: URL?) -> Observable<Result<Data, APIError>>
}

final class URLSessionProvider: URLSessionProviderType {
    private var dataTask: URLSessionDataTask?
    
    func dataTask(url: URL?) -> Observable<Result<Data, APIError>> {
        guard let urlRequest = setUpUrlRequest(url: url) else {
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
    private func setUpUrlRequest(url: URL?) -> URLRequest? {
        guard let url else { return nil }
        var urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
}
