//
// InvestmentProgramRequestsFilter.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class InvestmentProgramRequestsFilter: Codable {

    public enum Status: String, Codable { 
        case new = "New"
        case executed = "Executed"
        case cancelled = "Cancelled"
    }
    public enum ModelType: String, Codable { 
        case invest = "Invest"
        case withdrawal = "Withdrawal"
    }
    public var investmentProgramId: UUID
    public var dateFrom: Date?
    public var dateTo: Date?
    public var status: Status?
    public var type: ModelType?
    public var skip: Int?
    public var take: Int?


    
    public init(investmentProgramId: UUID, dateFrom: Date?, dateTo: Date?, status: Status?, type: ModelType?, skip: Int?, take: Int?) {
        self.investmentProgramId = investmentProgramId
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.status = status
        self.type = type
        self.skip = skip
        self.take = take
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encode(investmentProgramId, forKey: "investmentProgramId")
        try container.encodeIfPresent(dateFrom, forKey: "dateFrom")
        try container.encodeIfPresent(dateTo, forKey: "dateTo")
        try container.encodeIfPresent(status, forKey: "status")
        try container.encodeIfPresent(type, forKey: "type")
        try container.encodeIfPresent(skip, forKey: "skip")
        try container.encodeIfPresent(take, forKey: "take")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        investmentProgramId = try container.decode(UUID.self, forKey: "investmentProgramId")
        dateFrom = try container.decodeIfPresent(Date.self, forKey: "dateFrom")
        dateTo = try container.decodeIfPresent(Date.self, forKey: "dateTo")
        status = try container.decodeIfPresent(Status.self, forKey: "status")
        type = try container.decodeIfPresent(ModelType.self, forKey: "type")
        skip = try container.decodeIfPresent(Int.self, forKey: "skip")
        take = try container.decodeIfPresent(Int.self, forKey: "take")
    }
}

