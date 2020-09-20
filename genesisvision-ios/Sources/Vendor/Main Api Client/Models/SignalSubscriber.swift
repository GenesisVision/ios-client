//
// SignalSubscriber.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct SignalSubscriber: Codable {


    public var number: Int?

    public var trades: Int?

    public var profit: Double?

    public var volume: Double?

    public var subscriptionDate: Date?

    public var unsubscriptionDate: Date?

    public var status: SignalSubscriberStatus?

    public var totalCommissionAmount: Double?

    public var totalCommissionCurrency: Currency?

    public var totalSuccessFeeAmount: Double?

    public var totalSuccessFeeCurrency: Currency?

    public var totalVolumeFeeAmount: Double?

    public var totalVolumeFeeCurrency: Currency?
    public init(number: Int? = nil, trades: Int? = nil, profit: Double? = nil, volume: Double? = nil, subscriptionDate: Date? = nil, unsubscriptionDate: Date? = nil, status: SignalSubscriberStatus? = nil, totalCommissionAmount: Double? = nil, totalCommissionCurrency: Currency? = nil, totalSuccessFeeAmount: Double? = nil, totalSuccessFeeCurrency: Currency? = nil, totalVolumeFeeAmount: Double? = nil, totalVolumeFeeCurrency: Currency? = nil) { 
        self.number = number
        self.trades = trades
        self.profit = profit
        self.volume = volume
        self.subscriptionDate = subscriptionDate
        self.unsubscriptionDate = unsubscriptionDate
        self.status = status
        self.totalCommissionAmount = totalCommissionAmount
        self.totalCommissionCurrency = totalCommissionCurrency
        self.totalSuccessFeeAmount = totalSuccessFeeAmount
        self.totalSuccessFeeCurrency = totalSuccessFeeCurrency
        self.totalVolumeFeeAmount = totalVolumeFeeAmount
        self.totalVolumeFeeCurrency = totalVolumeFeeCurrency
    }

}