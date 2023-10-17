//
//  ViewModelType.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/17.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
