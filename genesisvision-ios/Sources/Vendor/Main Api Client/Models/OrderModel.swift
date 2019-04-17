//
// OrderModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class OrderModel: Codable {

    public enum Direction: String, Codable { 
        case buy = "Buy"
        case sell = "Sell"
        case balance = "Balance"
        case credit = "Credit"
        case undefined = "Undefined"
    }
    public enum Entry: String, Codable { 
        case _in = "In"
        case out = "Out"
        case _inout = "InOut"
        case outBy = "OutBy"
    }
    public var id: UUID?
    public var login: String?
    public var ticket: String?
    public var symbol: String?
    public var volume: Double?
    public var profit: Double?
    public var direction: Direction?
    public var date: Date?
    public var price: Double?
    public var priceCurrent: Double?
    public var entry: Entry?
    /** Volume in account currency. Only filled when trade have zero commission (for paying fees with GVT) */
    public var baseVolume: Double?
    /** Useful for spot markets profit calculation.  Huobi: sell - quote currency, buy - base currency */
    public var commission: Double?
    /** For signals */
    public var masterLogin: String?


    
    public init(id: UUID?, login: String?, ticket: String?, symbol: String?, volume: Double?, profit: Double?, direction: Direction?, date: Date?, price: Double?, priceCurrent: Double?, entry: Entry?, baseVolume: Double?, commission: Double?, masterLogin: String?) {
        self.id = id
        self.login = login
        self.ticket = ticket
        self.symbol = symbol
        self.volume = volume
        self.profit = profit
        self.direction = direction
        self.date = date
        self.price = price
        self.priceCurrent = priceCurrent
        self.entry = entry
        self.baseVolume = baseVolume
        self.commission = commission
        self.masterLogin = masterLogin
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(login, forKey: "login")
        try container.encodeIfPresent(ticket, forKey: "ticket")
        try container.encodeIfPresent(symbol, forKey: "symbol")
        try container.encodeIfPresent(volume, forKey: "volume")
        try container.encodeIfPresent(profit, forKey: "profit")
        try container.encodeIfPresent(direction, forKey: "direction")
        try container.encodeIfPresent(date, forKey: "date")
        try container.encodeIfPresent(price, forKey: "price")
        try container.encodeIfPresent(priceCurrent, forKey: "priceCurrent")
        try container.encodeIfPresent(entry, forKey: "entry")
        try container.encodeIfPresent(baseVolume, forKey: "baseVolume")
        try container.encodeIfPresent(commission, forKey: "commission")
        try container.encodeIfPresent(masterLogin, forKey: "masterLogin")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        id = try container.decodeIfPresent(UUID.self, forKey: "id")
        login = try container.decodeIfPresent(String.self, forKey: "login")
        ticket = try container.decodeIfPresent(String.self, forKey: "ticket")
        symbol = try container.decodeIfPresent(String.self, forKey: "symbol")
        volume = try container.decodeIfPresent(Double.self, forKey: "volume")
        profit = try container.decodeIfPresent(Double.self, forKey: "profit")
        direction = try container.decodeIfPresent(Direction.self, forKey: "direction")
        date = try container.decodeIfPresent(Date.self, forKey: "date")
        price = try container.decodeIfPresent(Double.self, forKey: "price")
        priceCurrent = try container.decodeIfPresent(Double.self, forKey: "priceCurrent")
        entry = try container.decodeIfPresent(Entry.self, forKey: "entry")
        baseVolume = try container.decodeIfPresent(Double.self, forKey: "baseVolume")
        commission = try container.decodeIfPresent(Double.self, forKey: "commission")
        masterLogin = try container.decodeIfPresent(String.self, forKey: "masterLogin")
    }
}

