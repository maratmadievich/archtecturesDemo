//
//  DateStringConverter.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 02.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

enum DateStringFormat: String {
    case timeWithTAndZ = "yyyy-MM-dd'T'HH:mm:ssZ"
    case dateTime = "dd.MM.yyyy HH:mm"
    case date = "dd.MM.yyyy"
    case time = "HH:mm"
}

struct DateStringConverter {
    
    private static let dateFormatter = DateFormatter()
    
    public static func getDate(from string: String, type: DateStringFormat) -> Date? {
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.locale = Locale(identifier: "ru_RU")
        guard let date = dateFormatter.date(from: string) else {
            print("Не удачно")
            return nil
        }
        return date
    }
    
    public static func getString(from date: Date?, type: DateStringFormat) -> String {
        guard let date = date else { return "" }
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
}
