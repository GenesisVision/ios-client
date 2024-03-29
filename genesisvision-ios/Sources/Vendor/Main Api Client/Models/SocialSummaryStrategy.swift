//
// SocialSummaryStrategy.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct SocialSummaryStrategy: Codable {


    public var _id: UUID?

    public var logoUrl: String?

    public var color: String?

    public var title: String?

    public var url: String?

    public var assetType: AssetType?

    public var programDetails: ProgramAssetDetails?

    public var investorsCount: Int?

    public var subscribersCount: Int?

    public var profitPercent: Double?
    public init(_id: UUID? = nil, logoUrl: String? = nil, color: String? = nil, title: String? = nil, url: String? = nil, assetType: AssetType? = nil, programDetails: ProgramAssetDetails? = nil, investorsCount: Int? = nil, subscribersCount: Int? = nil, profitPercent: Double? = nil) { 
        self._id = _id
        self.logoUrl = logoUrl
        self.color = color
        self.title = title
        self.url = url
        self.assetType = assetType
        self.programDetails = programDetails
        self.investorsCount = investorsCount
        self.subscribersCount = subscribersCount
        self.profitPercent = profitPercent
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case logoUrl
        case color
        case title
        case url
        case assetType
        case programDetails
        case investorsCount
        case subscribersCount
        case profitPercent
    }

}
