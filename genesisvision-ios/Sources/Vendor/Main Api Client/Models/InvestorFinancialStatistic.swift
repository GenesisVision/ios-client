//
// InvestorFinancialStatistic.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct InvestorFinancialStatistic: Codable {


    public var profit: Double?

    public var balance: Double?

    public var deposits: Double?

    public var withdrawals: Double?

    public var managerManagementFee: Double?

    public var managerSuccessFee: Double?

    public var platformSuccessFee: Double?
    public init(profit: Double? = nil, balance: Double? = nil, deposits: Double? = nil, withdrawals: Double? = nil, managerManagementFee: Double? = nil, managerSuccessFee: Double? = nil, platformSuccessFee: Double? = nil) { 
        self.profit = profit
        self.balance = balance
        self.deposits = deposits
        self.withdrawals = withdrawals
        self.managerManagementFee = managerManagementFee
        self.managerSuccessFee = managerSuccessFee
        self.platformSuccessFee = platformSuccessFee
    }

}
