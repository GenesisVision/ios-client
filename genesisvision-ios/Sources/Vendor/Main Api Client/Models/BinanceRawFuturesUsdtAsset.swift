//
// BinanceRawFuturesUsdtAsset.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawFuturesUsdtAsset: Codable {


    public var asset: String?

    public var marginAvailable: Bool?

    public var autoAssetExchange: Double?
    public init(asset: String? = nil, marginAvailable: Bool? = nil, autoAssetExchange: Double? = nil) { 
        self.asset = asset
        self.marginAvailable = marginAvailable
        self.autoAssetExchange = autoAssetExchange
    }

}
