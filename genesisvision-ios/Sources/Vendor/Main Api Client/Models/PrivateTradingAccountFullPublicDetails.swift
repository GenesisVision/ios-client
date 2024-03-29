//
// PrivateTradingAccountFullPublicDetails.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct PrivateTradingAccountFullPublicDetails: Codable {


    public var title: String?

    public var creationDate: Date?

    public var status: DashboardTradingAssetStatus?
    public init(title: String? = nil, creationDate: Date? = nil, status: DashboardTradingAssetStatus? = nil) { 
        self.title = title
        self.creationDate = creationDate
        self.status = status
    }

}
