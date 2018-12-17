//
//  UIButtonExtension.swift
//  RunForGood-ios
//
//  Created by George on 20/03/2018.
//

import Foundation

extension Date {
    var defaultFormatString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: self)
    }
   
    static func getFormatStringForChart(for date: Date, dateRangeType: DateRangeType) -> String {
        let dateFormatter = DateFormatter()
        switch dateRangeType {
        case .day:
            dateFormatter.dateFormat = "hh:mma"
        case .year, .allTime:
            dateFormatter.dateFormat = "dd.MM.yy"
        default:
            dateFormatter.dateFormat = "dd.MM"
        }
        
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: date)
    }
    
    var onlyDateFormatString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: self)
    }
    
    var onlyTimeFormatString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: self)
    }
    
    var dateAndTimeFormatString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM hh:mm a"
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: self)
    }
}

