//
//  HourlyWeatherDTO.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import Foundation

struct HourlyWeatherDTO: Hashable, Identifiable {
    let id = UUID()
    let hour: String
    let imageName: String
    let temperature: String
}
