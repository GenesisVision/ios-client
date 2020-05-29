//
// MigrationRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct MigrationRequest: Codable {


    public var dateCreate: Date?

    public var newLeverage: Int?

    public var newBroker: Broker?
    public init(dateCreate: Date? = nil, newLeverage: Int? = nil, newBroker: Broker? = nil) { 
        self.dateCreate = dateCreate
        self.newLeverage = newLeverage
        self.newBroker = newBroker
    }

}
