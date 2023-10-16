//
//  Location.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/16.
//

import Foundation

struct Location: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let coordiante: Coordinate
}
