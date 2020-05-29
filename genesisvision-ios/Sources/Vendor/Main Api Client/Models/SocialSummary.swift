//
// SocialSummary.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct SocialSummary: Codable {


    public var trendHashTags: [String]?

    public var trendAssets: [AssetDetails]?

    public var trendPlatformAssets: [PlatformAsset]?
    public init(trendHashTags: [String]? = nil, trendAssets: [AssetDetails]? = nil, trendPlatformAssets: [PlatformAsset]? = nil) { 
        self.trendHashTags = trendHashTags
        self.trendAssets = trendAssets
        self.trendPlatformAssets = trendPlatformAssets
    }

}
