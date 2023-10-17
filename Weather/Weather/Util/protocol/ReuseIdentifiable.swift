//
//  ReuseIdentifiable.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

/// 프로퍼티 명 id가 Identifiable 요구사항이랑 겹쳐서 충돌 생길수도
protocol ReuseIdentifiable {
    static var id: String { get }
}

extension ReuseIdentifiable {
    static var id: String {
        return String(describing: self)
    }
}
