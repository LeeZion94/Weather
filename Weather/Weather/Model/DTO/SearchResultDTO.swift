//
//  SearchResultDTO.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/16.
//

import Foundation

struct SearchResultDTO: Hashable, Identifiable {
    let id = UUID()
    let cityName: String
}
