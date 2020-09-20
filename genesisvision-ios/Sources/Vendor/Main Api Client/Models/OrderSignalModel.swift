//
// OrderSignalModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct OrderSignalModel: Codable {


    public var providers: [OrderSignalProgramInfo]?

    public var totalCommission: Double?

    public var totalCommissionByType: [FeeDetails]?

    public var tradingAccountId: UUID?

    public var currency: Currency?

    public var _id: UUID?

    public var login: String?

    public var ticket: String?

    public var symbol: String?

    public var volume: Double?

    public var profit: Double?

    public var profitCurrency: String?

    public var direction: TradeDirectionType?

    public var date: Date?

    public var price: Double?

    public var priceCurrent: Double?

    public var entry: TradeEntryType?

    /** Volume in account currency. Only filled when trade have zero commission (for paying fees with GVT) */
    public var baseVolume: Double?

    /** Huobi: sell - quote currency (right), buy - base symbol currency (left) */
    public var originalCommission: Double?

    public var originalCommissionCurrency: String?

    /** In account currency */
    public var commission: Double?

    public var swap: Double?

    public var showOriginalCommission: Bool?

    public var assetData: TradeAssetData?

    public var signalData: OrderModelSignalData?
    public init(providers: [OrderSignalProgramInfo]? = nil, totalCommission: Double? = nil, totalCommissionByType: [FeeDetails]? = nil, tradingAccountId: UUID? = nil, currency: Currency? = nil, _id: UUID? = nil, login: String? = nil, ticket: String? = nil, symbol: String? = nil, volume: Double? = nil, profit: Double? = nil, profitCurrency: String? = nil, direction: TradeDirectionType? = nil, date: Date? = nil, price: Double? = nil, priceCurrent: Double? = nil, entry: TradeEntryType? = nil, baseVolume: Double? = nil, originalCommission: Double? = nil, originalCommissionCurrency: String? = nil, commission: Double? = nil, swap: Double? = nil, showOriginalCommission: Bool? = nil, assetData: TradeAssetData? = nil, signalData: OrderModelSignalData? = nil) { 
        self.providers = providers
        self.totalCommission = totalCommission
        self.totalCommissionByType = totalCommissionByType
        self.tradingAccountId = tradingAccountId
        self.currency = currency
        self._id = _id
        self.login = login
        self.ticket = ticket
        self.symbol = symbol
        self.volume = volume
        self.profit = profit
        self.profitCurrency = profitCurrency
        self.direction = direction
        self.date = date
        self.price = price
        self.priceCurrent = priceCurrent
        self.entry = entry
        self.baseVolume = baseVolume
        self.originalCommission = originalCommission
        self.originalCommissionCurrency = originalCommissionCurrency
        self.commission = commission
        self.swap = swap
        self.showOriginalCommission = showOriginalCommission
        self.assetData = assetData
        self.signalData = signalData
    }
    public enum CodingKeys: String, CodingKey { 
        case providers
        case totalCommission
        case totalCommissionByType
        case tradingAccountId
        case currency
        case _id = "id"
        case login
        case ticket
        case symbol
        case volume
        case profit
        case profitCurrency
        case direction
        case date
        case price
        case priceCurrent
        case entry
        case baseVolume
        case originalCommission
        case originalCommissionCurrency
        case commission
        case swap
        case showOriginalCommission
        case assetData
        case signalData
    }

}