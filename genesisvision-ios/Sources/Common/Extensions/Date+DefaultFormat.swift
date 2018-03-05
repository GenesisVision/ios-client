//
//  Date+DefaultFormat.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

extension Date {
    var defaultFormatString: String {
        let template = "d MM y hh:mm"
        let dateFormatString = DateFormatter.dateFormat(fromTemplate: template,
                                                        options: 0,
                                                        locale: Bundle.main.locale)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.locale = Bundle.main.locale
        return dateFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}

