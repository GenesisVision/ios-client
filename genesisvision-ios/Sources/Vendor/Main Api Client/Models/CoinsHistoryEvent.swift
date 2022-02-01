//
// CoinsHistoryEvent.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct CoinsHistoryEvent: Codable {


    public var date: Date?

    public var trade: CoinsTrade?
    public init(date: Date? = nil, trade: CoinsTrade? = nil) { 
        self.date = date
        self.trade = trade
    }

}