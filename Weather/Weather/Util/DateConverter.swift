//
//  DateConverter.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/14.
//

protocol DateConverterType {
    
}

final class DateConverter: DateConverterType {
    private let timezone: Double
    
    init(timezone: Int) {
        self.timezone = Double(timezone)
    }
}
