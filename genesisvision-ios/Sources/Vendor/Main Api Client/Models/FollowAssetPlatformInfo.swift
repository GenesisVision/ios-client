//
// FollowAssetPlatformInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct FollowAssetPlatformInfo: Codable {


    public var facets: [AssetFacet]?

    public var tags: [Tag]?

    public var createFollowInfo: FollowCreateAssetPlatformInfo?

    public var subscribeFixedCurrencies: [String]?
    public init(facets: [AssetFacet]? = nil, tags: [Tag]? = nil, createFollowInfo: FollowCreateAssetPlatformInfo? = nil, subscribeFixedCurrencies: [String]? = nil) { 
        self.facets = facets
        self.tags = tags
        self.createFollowInfo = createFollowInfo
        self.subscribeFixedCurrencies = subscribeFixedCurrencies
    }

}
