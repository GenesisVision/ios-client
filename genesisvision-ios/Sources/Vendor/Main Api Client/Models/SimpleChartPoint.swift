//
// SimpleChartPoint.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct SimpleChartPoint: Codable {


    public var date: Date?

    public var value: Double?
    public init(date: Date? = nil, value: Double? = nil) { 
        self.date = date
        self.value = value
    }

}
