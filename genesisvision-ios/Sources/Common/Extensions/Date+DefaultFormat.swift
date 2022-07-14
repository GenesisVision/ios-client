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
        case .year, .all:
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
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: self)
    }
    
    var dateAndTimeFormatString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY hh:mm a"
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: self)
    }
    
    var dateAndFullTimeFormatString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM hh:mm:ss a"
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: self)
    }
    
    var textDateAndHours: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY hh:mm:ss"
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: self)
    }
    
    var dateForSocialPost: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY, hh:mm a"
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: self)
    }
    
    var dateForSocialUserAge: String {
        let calendar = Calendar.current
        let years = calendar.component(.year, from: Date()) - calendar.component(.year, from: self)
        let months = calendar.component(.month, from: Date()) - calendar.component(.month, from: self)
        
        var monthsString: String = ""
        
        if months < 2 {
            monthsString = String(months) + " month"
        } else {
            monthsString = String(months) + " months"
        }
        
        var yearsString: String = ""
        
        if years < 2 {
            yearsString = String(years) + " year"
        } else {
            yearsString = String(years) + " years"
        }
        
        if years < 1 {
            return monthsString
        } else {
            return yearsString
        }
    }
    
    static func getDateFormatFromeBinanceKlineInterval(interval: BinanceKlineInterval) -> String {
        switch interval {
        case .oneMinute, .threeMinutes, .fiveMinutes, .fifteenMinutes,
                .thirtyMinutes, .oneHour, .twoHour, .fourHour, .sixHour, .eightHour, .twelveHour, .oneDay:
            return "h:mm a"
        case .threeDay, .oneWeek:
            return "E, h:mm"
        case .oneMonth:
            return "MMM d, h:mm a"
        }
    }
}

