//
// InvestmentEventViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct InvestmentEventViewModel: Codable {


    public var title: String?

    public var logoUrl: String?

    public var date: Date?

    public var assetDetails: AssetDetails?

    public var amount: Double?

    public var currency: Currency?

    public var changeState: ChangeState?

    public var extendedInfo: [InvestmentEventItemViewModel]?

    public var feesInfo: [FeeDetails]?

    public var totalFeesAmount: Double?

    public var totalFeesCurrency: Currency?
    public init(title: String? = nil, logoUrl: String? = nil, date: Date? = nil, assetDetails: AssetDetails? = nil, amount: Double? = nil, currency: Currency? = nil, changeState: ChangeState? = nil, extendedInfo: [InvestmentEventItemViewModel]? = nil, feesInfo: [FeeDetails]? = nil, totalFeesAmount: Double? = nil, totalFeesCurrency: Currency? = nil) { 
        self.title = title
        self.logoUrl = logoUrl
        self.date = date
        self.assetDetails = assetDetails
        self.amount = amount
        self.currency = currency
        self.changeState = changeState
        self.extendedInfo = extendedInfo
        self.feesInfo = feesInfo
        self.totalFeesAmount = totalFeesAmount
        self.totalFeesCurrency = totalFeesCurrency
    }

}
