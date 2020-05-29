//
// TradesViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct TradesViewModel: Codable {


    public var showSwaps: Bool?

    public var showTickets: Bool?

    public var showDate: Bool?

    public var showDirection: Bool?

    public var showPrice: Bool?

    public var showPriceOpen: Bool?

    public var showProfit: Bool?

    public var tradesDelay: TradesDelay?

    public var items: [OrderModel]?

    public var total: Int?
    public init(showSwaps: Bool? = nil, showTickets: Bool? = nil, showDate: Bool? = nil, showDirection: Bool? = nil, showPrice: Bool? = nil, showPriceOpen: Bool? = nil, showProfit: Bool? = nil, tradesDelay: TradesDelay? = nil, items: [OrderModel]? = nil, total: Int? = nil) { 
        self.showSwaps = showSwaps
        self.showTickets = showTickets
        self.showDate = showDate
        self.showDirection = showDirection
        self.showPrice = showPrice
        self.showPriceOpen = showPriceOpen
        self.showProfit = showProfit
        self.tradesDelay = tradesDelay
        self.items = items
        self.total = total
    }

}
