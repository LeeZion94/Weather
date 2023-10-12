//
//  WeeklyWeatherDTO.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import Foundation

struct WeeklyWeatherDTO: Hashable, Identifiable {
    let id = UUID()
    let day: String
    let imageName: String
    let maxTemperature: String
    let minTemperature: String
}
