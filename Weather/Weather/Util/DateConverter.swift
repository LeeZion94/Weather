//
//  DateConverter.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/14.
//

import Foundation

protocol DateConverterType {
    func convertDayOfWeekFromLocalDate(timezone: Int, date: String) -> String
    func convertHourFromLocalDate(timezone: Int, date: String) -> String
}

final class DateConverter: DateConverterType {
    func convertDayOfWeekFromLocalDate(timezone: Int, date: String) -> String {
        let date = convertLocalDateFromUTC(timezone: timezone, string: date)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    func convertHourFromLocalDate(timezone: Int, date: String) -> String {
        let date = convertLocalDateFromUTC(timezone: timezone, string: date)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "ha"
        return dateFormatter.string(from: date)
    }
}

// MARK: - Private
extension DateConverter {
    private func convertLocalDateFromUTC(timezone: Int, string: String) -> Date {
        let utcDate = convertUTCDate(from: string)
        
        return utcDate.addingTimeInterval(Double(timezone))
    }
    
    private func convertUTCDate(from string: String) -> Date {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: string) ?? Date()
    }
}
