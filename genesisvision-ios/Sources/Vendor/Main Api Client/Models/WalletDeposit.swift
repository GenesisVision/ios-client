//
// WalletDeposit.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct WalletDeposit: Codable {


    public var currency: Currency?

    public var depositAddress: String?
    public init(currency: Currency? = nil, depositAddress: String? = nil) { 
        self.currency = currency
        self.depositAddress = depositAddress
    }

}