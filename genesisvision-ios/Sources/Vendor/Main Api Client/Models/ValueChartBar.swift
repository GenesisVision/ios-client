//
// ValueChartBar.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class ValueChartBar: Codable {

    public var value: Double?
    public var date: Date?
    public var assets: [AssetsValue]?


    
    public init(value: Double?, date: Date?, assets: [AssetsValue]?) {
        self.value = value
        self.date = date
        self.assets = assets
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(value, forKey: "value")
        try container.encodeIfPresent(date, forKey: "date")
        try container.encodeIfPresent(assets, forKey: "assets")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        value = try container.decodeIfPresent(Double.self, forKey: "value")
        date = try container.decodeIfPresent(Date.self, forKey: "date")
        assets = try container.decodeIfPresent([AssetsValue].self, forKey: "assets")
    }
}
