//
// SignalTradingEvent.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct SignalTradingEvent: Codable {


    public var date: Date?

    public var message: String?
    public init(date: Date? = nil, message: String? = nil) { 
        self.date = date
        self.message = message
    }

}
