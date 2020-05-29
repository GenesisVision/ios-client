//
// FeeDetails.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct FeeDetails: Codable {


    public var title: String?

    public var _description: String?

    public var type: FeeType?

    public var amount: Double?

    public var currency: Currency?
    public init(title: String? = nil, _description: String? = nil, type: FeeType? = nil, amount: Double? = nil, currency: Currency? = nil) { 
        self.title = title
        self._description = _description
        self.type = type
        self.amount = amount
        self.currency = currency
    }
    public enum CodingKeys: String, CodingKey { 
        case title
        case _description = "description"
        case type
        case amount
        case currency
    }

}
