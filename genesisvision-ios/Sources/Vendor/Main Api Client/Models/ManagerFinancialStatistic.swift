//
// ManagerFinancialStatistic.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct ManagerFinancialStatistic: Codable {


    public var successFee: Double?

    public var entryFee: Double?

    public var profit: Double?

    public var balance: Double?
    public init(successFee: Double? = nil, entryFee: Double? = nil, profit: Double? = nil, balance: Double? = nil) { 
        self.successFee = successFee
        self.entryFee = entryFee
        self.profit = profit
        self.balance = balance
    }

}
