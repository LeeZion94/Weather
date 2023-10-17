//
//  ForecastResult.swift
//  ForecastResult
//
//  Created by Hyungmin Lee on 2023/10/11.
//

struct ForecastResult: Decodable {
//    let cod: String
//    let message: Int
    let cnt: Int
    let list: [Forecast]
    let city: City
    
    struct Forecast: Decodable {
        let dt: Int
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let pop: Double
        let sys: Sys
        let dt_txt: String
        
        struct Main: Decodable {
            let temp: Double
            let feels_like: Double
            let temp_min: Double
            let temp_max: Double
            let pressure: Int
            let sea_level: Int
            let grnd_level: Int
            let humidity: Int
            let temp_kf: Double
        }
        
        struct Weather: Decodable {
            let id: Int
            let main: String
            let description: String
            let icon: String
        }
        
        struct Clouds: Decodable {
            let all: Int
        }
        
        struct Wind: Decodable {
            let speed: Double
            let deg: Int
            let gust: Double
        }
        
        struct Sys: Decodable {
            let pod: String
        }
    }
    
    struct City: Decodable {
        let id: Int
        let name: String
        let cood: Coord
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
        
        struct Coord: Decodable {
            let lat: Double
            let lon: Double
        }
    }
}
