//
// CreateWithdrawalRequestModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct CreateWithdrawalRequestModel: Codable {


    public var amount: Double?

    public var currency: Currency?

    public var address: String?

    public var twoFactorCode: String?
    public init(amount: Double? = nil, currency: Currency? = nil, address: String? = nil, twoFactorCode: String? = nil) { 
        self.amount = amount
        self.currency = currency
        self.address = address
        self.twoFactorCode = twoFactorCode
    }

}
