//
//  DetailWeatherDTO.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/11.
//

import Foundation

struct DetailWeatherDTO: Hashable, Identifiable {
    let id = UUID()
    let leftTitle: String
    let leftValue: String
    let rightTitle: String
    let rightValue: String
}
