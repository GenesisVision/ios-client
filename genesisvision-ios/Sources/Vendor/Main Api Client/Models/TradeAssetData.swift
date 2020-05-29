//
// TradeAssetData.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct TradeAssetData: Codable {


    public var logoUrl: String?

    public var hasAssetInfo: Bool?

    public var url: String?
    public init(logoUrl: String? = nil, hasAssetInfo: Bool? = nil, url: String? = nil) { 
        self.logoUrl = logoUrl
        self.hasAssetInfo = hasAssetInfo
        self.url = url
    }

}
