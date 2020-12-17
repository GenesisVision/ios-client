//
// BinanceRawFuturesBuySellVolumeRatio.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawFuturesBuySellVolumeRatio: Codable {


    public var buySellRatio: Double?

    public var buyVolume: Double?

    public var sellVolume: Double?

    public var timestamp: Date?
    public init(buySellRatio: Double? = nil, buyVolume: Double? = nil, sellVolume: Double? = nil, timestamp: Date? = nil) { 
        self.buySellRatio = buySellRatio
        self.buyVolume = buyVolume
        self.sellVolume = sellVolume
        self.timestamp = timestamp
    }

}