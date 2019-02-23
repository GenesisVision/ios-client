//
// FundSets.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class FundSets: Codable {

    public var sets: [FundFacet]?
    public var favoritesCount: Int?


    
    public init(sets: [FundFacet]?, favoritesCount: Int?) {
        self.sets = sets
        self.favoritesCount = favoritesCount
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(sets, forKey: "sets")
        try container.encodeIfPresent(favoritesCount, forKey: "favoritesCount")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        sets = try container.decodeIfPresent([FundFacet].self, forKey: "sets")
        favoritesCount = try container.decodeIfPresent(Int.self, forKey: "favoritesCount")
    }
}

