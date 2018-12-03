//
// ProgramDetailsRating.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class ProgramDetailsRating: Codable {

    public var rating: Int?
    public var profit: Double?
    public var canLevelUp: Bool?


    
    public init(rating: Int?, profit: Double?, canLevelUp: Bool?) {
        self.rating = rating
        self.profit = profit
        self.canLevelUp = canLevelUp
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(rating, forKey: "rating")
        try container.encodeIfPresent(profit, forKey: "profit")
        try container.encodeIfPresent(canLevelUp, forKey: "canLevelUp")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        rating = try container.decodeIfPresent(Int.self, forKey: "rating")
        profit = try container.decodeIfPresent(Double.self, forKey: "profit")
        canLevelUp = try container.decodeIfPresent(Bool.self, forKey: "canLevelUp")
    }
}

