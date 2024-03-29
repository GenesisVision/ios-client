//
// BasePlatformAsset.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BasePlatformAsset: Codable {


    public var _id: UUID?

    public var name: String?

    public var asset: String?

    public var _description: String?

    public var logoUrl: String?

    public var color: String?

    public var url: String?

    public var provider: AssetProvider?
    public init(_id: UUID? = nil, name: String? = nil, asset: String? = nil, _description: String? = nil, logoUrl: String? = nil, color: String? = nil, url: String? = nil, provider: AssetProvider? = nil) { 
        self._id = _id
        self.name = name
        self.asset = asset
        self._description = _description
        self.logoUrl = logoUrl
        self.color = color
        self.url = url
        self.provider = provider
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case name
        case asset
        case _description = "description"
        case logoUrl
        case color
        case url
        case provider
    }

}
