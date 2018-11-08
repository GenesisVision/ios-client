//
//  DateHelper.swift
//  genesisvision-ios
//
//  Created by George on 06/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

extension Date {
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        let unitFlags = Set<Calendar.Component>([comp])
        
        let dateComponents = currentCalendar.dateComponents(unitFlags, from: date, to: self)
        
        guard let seconds = dateComponents.second else { return 0 }
        
        return seconds
    }
    
    func getDateComponents(ofComponent comp: Calendar.Component, fromDate date: Date) -> DateComponents {
        
        let currentCalendar = Calendar.current
        
        let unitFlags = Set<Calendar.Component>([comp])
        
        let dateComponents = currentCalendar.dateComponents(unitFlags, from: date, to: self)
        
        return dateComponents
    }
    
    public mutating func setTime(day: Int? = nil, hour: Int, min: Int, sec: Int) {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        
        let cal = Calendar(identifier: .iso8601)
        var components = cal.dateComponents(x, from: self)
        
        if let day = day {
            components.day = day
        }
        
        components.hour = hour
        components.minute = min
        components.second = sec
        
        self = cal.date(from: components)!
    }
    
    func toString(_ format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dateAndTimetoString(_ format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func startOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year,.month], from: self)
        components.day = 1
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func nextDate() -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return nextDate ?? Date()
    }
    
    func previousDate() -> Date {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return previousDate ?? Date()
    }
    
    func addDays(_ numberOfDays: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .day, value: numberOfDays, to: self)
        return endDate ?? Date()
    }
    
    func removeDays(_ numberOfDays: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .day, value: -numberOfDays, to: self)
        return endDate ?? Date()
    }
    
    func addMonths(_ numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeMonths(_ numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: -numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func addYears(_ numberOfYears: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .year, value: numberOfYears, to: self)
        return endDate ?? Date()
    }
    
    func removeYears(_ numberOfYears: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .year, value: -numberOfYears, to: self)
        return endDate ?? Date()
    }
    
    func getHumanReadableDayString() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar = Calendar.current.component(.weekday, from: self)
        return weekdays[calendar - 1]
    }
    
    
    func daysSinceDate(fromDate: Date) -> String {
        let earliest = fromDate
        let latest = self
        
        let components: DateComponents = Calendar.current.dateComponents([.second, .minute, .hour, .day], from: earliest, to: latest)
        
        let day = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        
        if (day >= 2) {
            return "\(day) days"
        } else if (day == 1) {
            return "1 day"
        } else if (hours >= 2) {
            return "\(hours) hours"
        } else if (hours == 1){
            return "1 hour"
        } else if (minutes >= 2) {
            return "\(minutes) minutes"
        } else if (minutes == 1) {
            return "1 min"
        } else if (seconds >= 2) {
            return "\(seconds) sec"
        } else if (seconds == 1) {
            return "\(seconds) sec"
        } else {
            return ""
        }
        
    }
    
    func timeSinceDate(fromDate: Date) -> String {
        let earliest = fromDate
        let latest = self
        
        let components: DateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: earliest, to: latest)
        let year = components.year  ?? 0
        let month = components.month  ?? 0
        let week = components.weekOfYear  ?? 0
        let day = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        
        if year >= 2 {
            return "\(year) y"
        } else if (year >= 1) {
            return "1 year"
        } else if (month >= 2) {
            return "\(month) m"
        } else if (month >= 1) {
            return "1 month"
        } else  if (week >= 2) {
            return "\(week) w"
        } else if (week >= 1){
            return "1 week"
        } else if (day >= 2) {
            return "\(day) d"
        } else if (day >= 1) {
            return "1 day"
        } else if (hours >= 2) {
            return "\(hours) h"
        } else if (hours >= 1){
            return "1 hour"
        } else if (minutes >= 2) {
            return "\(minutes) min"
        } else if (minutes >= 1) {
            return "1 min"
        } else if (seconds >= 3) {
            return "\(seconds) sec"
        } else {
            return ""
        }
        
    }
}
