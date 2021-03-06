//
// TradingAccountAssetPlatformInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct TradingAccountAssetPlatformInfo: Codable {


    public var minAmounts: [TradingAccountMinCreateAmount]?

    public var maxAmounts: [TradingAccountMaxCreateAmount]?
    public init(minAmounts: [TradingAccountMinCreateAmount]? = nil, maxAmounts: [TradingAccountMaxCreateAmount]? = nil) { 
        self.minAmounts = minAmounts
        self.maxAmounts = maxAmounts
    }

}
