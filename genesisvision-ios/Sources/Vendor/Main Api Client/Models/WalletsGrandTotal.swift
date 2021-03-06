//
// WalletsGrandTotal.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct WalletsGrandTotal: Codable {


    public var currency: Currency?

    public var available: Double?

    public var invested: Double?

    public var trading: Double?

    public var total: Double?
    public init(currency: Currency? = nil, available: Double? = nil, invested: Double? = nil, trading: Double? = nil, total: Double? = nil) { 
        self.currency = currency
        self.available = available
        self.invested = invested
        self.trading = trading
        self.total = total
    }

}
