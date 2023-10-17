//
//  URLSessionProvider.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import Foundation
import RxSwift
import RxCocoa

/// 현재 테스트 타겟은 없는거로 보이는데,
/// 테스트 코드는 짜는지, 이렇게 추상화하면 어떻게 테스터빌리티가 생기는지,
/// DI는 뭐가 좋고 나쁜지 등등 다양한 질문이 나올거 같네요
protocol URLSessionProviderType {
    func dataTask(url: URL?, header: [String: String]?, httpMethod: String) -> Observable<Result<Data, APIError>>
}

/// 1. 요 아이는 struct여도 될 거 같이 생겼는데 class여서
/// class와 struct의 차이부터 시작해서
/// 선정 기준이나 메모리에서 어떻게 동작하는지까지 물어볼거 같아요
/// 
/// 2. dataTask를 조금 더 고도화 할 수 있을거 같아요
/// Alamofire를 보면서 network interceptor 개념이나,
/// decoding, errorhandling 등을 분리해보는것도 좋은 경험일 것 같습니다.
/// 
/// 3. 일회성 이벤트의 경우 Single을 사용하는것도 고려해볼 수 있을거 같아요
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
    /// 파라미터 인코딩, 바디 인코딩에 대한 핸들링도 필요해보이네요
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
