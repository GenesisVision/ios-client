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
   
    static func getFormatStringForChart(for date: Date, chartDurationType: ChartDurationType) -> String {
        let dateFormatter = DateFormatter()
        switch chartDurationType {
        case .day:
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
        default:
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
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
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: self)
    }
}

