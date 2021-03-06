//
// SocialSummary.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct SocialSummary: Codable {


    public var hotTopics: [SocialSummaryHashTag]?

    public var topStrategies: [SocialSummaryStrategy]?

    public var topAssets: [SocialPostPlatformAsset]?
    public init(hotTopics: [SocialSummaryHashTag]? = nil, topStrategies: [SocialSummaryStrategy]? = nil, topAssets: [SocialPostPlatformAsset]? = nil) { 
        self.hotTopics = hotTopics
        self.topStrategies = topStrategies
        self.topAssets = topAssets
    }

}
