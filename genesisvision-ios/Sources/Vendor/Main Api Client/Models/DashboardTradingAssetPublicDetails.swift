//
// DashboardTradingAssetPublicDetails.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct DashboardTradingAssetPublicDetails: Codable {


    public var logoUrl: String?

    public var color: String?

    public var title: String?

    public var url: String?

    public var programDetails: ProgramAssetDetails?

    public var fundDetails: FundAssetDetails?
    public init(logoUrl: String? = nil, color: String? = nil, title: String? = nil, url: String? = nil, programDetails: ProgramAssetDetails? = nil, fundDetails: FundAssetDetails? = nil) { 
        self.logoUrl = logoUrl
        self.color = color
        self.title = title
        self.url = url
        self.programDetails = programDetails
        self.fundDetails = fundDetails
    }

}
