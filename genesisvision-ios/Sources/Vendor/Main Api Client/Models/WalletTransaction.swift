//
// WalletTransaction.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class WalletTransaction: Codable {

    public enum SourceType: String, Codable { 
        case wallet = "Wallet"
        case program = "Program"
        case fund = "Fund"
        case programRequest = "ProgramRequest"
        case withdrawalRequest = "WithdrawalRequest"
        case paymentTransaction = "PaymentTransaction"
    }
    public enum SourceCurrency: String, Codable { 
        case eth = "ETH"
        case gvt = "GVT"
        case btc = "BTC"
        case undefined = "Undefined"
        case ada = "ADA"
        case usd = "USD"
        case eur = "EUR"
    }
    public enum Action: String, Codable { 
        case transfer = "Transfer"
        case programOpen = "ProgramOpen"
        case programProfit = "ProgramProfit"
        case programInvest = "ProgramInvest"
        case programWithdrawal = "ProgramWithdrawal"
        case programRefundPartialExecution = "ProgramRefundPartialExecution"
        case programRefundClose = "ProgramRefundClose"
        case programRequestInvest = "ProgramRequestInvest"
        case programRequestWithdrawal = "ProgramRequestWithdrawal"
        case programRequestCancel = "ProgramRequestCancel"
    }
    public enum DestinationType: String, Codable { 
        case wallet = "Wallet"
        case program = "Program"
        case fund = "Fund"
        case programRequest = "ProgramRequest"
        case withdrawalRequest = "WithdrawalRequest"
        case paymentTransaction = "PaymentTransaction"
    }
    public enum DestinationCurrency: String, Codable { 
        case eth = "ETH"
        case gvt = "GVT"
        case btc = "BTC"
        case undefined = "Undefined"
        case ada = "ADA"
        case usd = "USD"
        case eur = "EUR"
    }
    public var id: UUID?
    public var amount: Double?
    public var amountConverted: Double?
    public var date: Date?
    public var number: Int64?
    public var sourceId: UUID?
    public var sourceType: SourceType?
    public var sourceCurrency: SourceCurrency?
    public var action: Action?
    public var destinationId: UUID?
    public var destinationType: DestinationType?
    public var destinationCurrency: DestinationCurrency?


    
    public init(id: UUID?, amount: Double?, amountConverted: Double?, date: Date?, number: Int64?, sourceId: UUID?, sourceType: SourceType?, sourceCurrency: SourceCurrency?, action: Action?, destinationId: UUID?, destinationType: DestinationType?, destinationCurrency: DestinationCurrency?) {
        self.id = id
        self.amount = amount
        self.amountConverted = amountConverted
        self.date = date
        self.number = number
        self.sourceId = sourceId
        self.sourceType = sourceType
        self.sourceCurrency = sourceCurrency
        self.action = action
        self.destinationId = destinationId
        self.destinationType = destinationType
        self.destinationCurrency = destinationCurrency
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(amount, forKey: "amount")
        try container.encodeIfPresent(amountConverted, forKey: "amountConverted")
        try container.encodeIfPresent(date, forKey: "date")
        try container.encodeIfPresent(number, forKey: "number")
        try container.encodeIfPresent(sourceId, forKey: "sourceId")
        try container.encodeIfPresent(sourceType, forKey: "sourceType")
        try container.encodeIfPresent(sourceCurrency, forKey: "sourceCurrency")
        try container.encodeIfPresent(action, forKey: "action")
        try container.encodeIfPresent(destinationId, forKey: "destinationId")
        try container.encodeIfPresent(destinationType, forKey: "destinationType")
        try container.encodeIfPresent(destinationCurrency, forKey: "destinationCurrency")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        id = try container.decodeIfPresent(UUID.self, forKey: "id")
        amount = try container.decodeIfPresent(Double.self, forKey: "amount")
        amountConverted = try container.decodeIfPresent(Double.self, forKey: "amountConverted")
        date = try container.decodeIfPresent(Date.self, forKey: "date")
        number = try container.decodeIfPresent(Int64.self, forKey: "number")
        sourceId = try container.decodeIfPresent(UUID.self, forKey: "sourceId")
        sourceType = try container.decodeIfPresent(SourceType.self, forKey: "sourceType")
        sourceCurrency = try container.decodeIfPresent(SourceCurrency.self, forKey: "sourceCurrency")
        action = try container.decodeIfPresent(Action.self, forKey: "action")
        destinationId = try container.decodeIfPresent(UUID.self, forKey: "destinationId")
        destinationType = try container.decodeIfPresent(DestinationType.self, forKey: "destinationType")
        destinationCurrency = try container.decodeIfPresent(DestinationCurrency.self, forKey: "destinationCurrency")
    }
}

