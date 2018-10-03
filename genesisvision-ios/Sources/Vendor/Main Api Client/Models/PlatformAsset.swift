//
// PlatformAsset.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class PlatformAsset: Codable {

    public var id: UUID?
    public var name: String?
    public var symbol: String?
    public var description: String?
    public var icon: String?


    
    public init(id: UUID?, name: String?, symbol: String?, description: String?, icon: String?) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.description = description
        self.icon = icon
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(name, forKey: "name")
        try container.encodeIfPresent(symbol, forKey: "symbol")
        try container.encodeIfPresent(description, forKey: "description")
        try container.encodeIfPresent(icon, forKey: "icon")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        id = try container.decodeIfPresent(UUID.self, forKey: "id")
        name = try container.decodeIfPresent(String.self, forKey: "name")
        symbol = try container.decodeIfPresent(String.self, forKey: "symbol")
        description = try container.decodeIfPresent(String.self, forKey: "description")
        icon = try container.decodeIfPresent(String.self, forKey: "icon")
    }
}
