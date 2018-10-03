//
// DashboardPortfolioEvents.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class DashboardPortfolioEvents: Codable {

    public var events: [DashboardPortfolioEvent]?
    public var total: Int?


    
    public init(events: [DashboardPortfolioEvent]?, total: Int?) {
        self.events = events
        self.total = total
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(events, forKey: "events")
        try container.encodeIfPresent(total, forKey: "total")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        events = try container.decodeIfPresent([DashboardPortfolioEvent].self, forKey: "events")
        total = try container.decodeIfPresent(Int.self, forKey: "total")
    }
}
