//
// NewFundRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct NewFundRequest: Codable {


    public var title: String?

    public var _description: String?

    public var logo: String?

    public var assets: [FundAssetPart]?

    public var entryFee: Double?

    public var exitFee: Double?

    public var depositAmount: Double?

    public var depositWalletId: UUID?
    public init(title: String? = nil, _description: String? = nil, logo: String? = nil, assets: [FundAssetPart]? = nil, entryFee: Double? = nil, exitFee: Double? = nil, depositAmount: Double? = nil, depositWalletId: UUID? = nil) { 
        self.title = title
        self._description = _description
        self.logo = logo
        self.assets = assets
        self.entryFee = entryFee
        self.exitFee = exitFee
        self.depositAmount = depositAmount
        self.depositWalletId = depositWalletId
    }
    public enum CodingKeys: String, CodingKey { 
        case title
        case _description = "description"
        case logo
        case assets
        case entryFee
        case exitFee
        case depositAmount
        case depositWalletId
    }

}
