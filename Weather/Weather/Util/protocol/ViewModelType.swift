//
//  ViewModelType.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/17.
//

import Foundation

/// Redux 아는지 질문할수도
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
