//
//  ReuseIdentifiable.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

protocol ReuseIdentifiable {
    static var id: String { get }
}

extension ReuseIdentifiable {
    static var id: String {
        return String(describing: self)
    }
}
