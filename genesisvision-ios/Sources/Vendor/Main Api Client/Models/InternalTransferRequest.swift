//
// InternalTransferRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class InternalTransferRequest: Codable {

    public enum SourceType: String, Codable { 
        case undefined = "Undefined"
        case wallet = "Wallet"
    }
    public enum DestinationType: String, Codable { 
        case undefined = "Undefined"
        case wallet = "Wallet"
    }
    public var sourceId: UUID?
    public var sourceType: SourceType?
    public var destinationId: UUID?
    public var destinationType: DestinationType?
    public var amount: Double?


    
    public init(sourceId: UUID?, sourceType: SourceType?, destinationId: UUID?, destinationType: DestinationType?, amount: Double?) {
        self.sourceId = sourceId
        self.sourceType = sourceType
        self.destinationId = destinationId
        self.destinationType = destinationType
        self.amount = amount
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(sourceId, forKey: "sourceId")
        try container.encodeIfPresent(sourceType, forKey: "sourceType")
        try container.encodeIfPresent(destinationId, forKey: "destinationId")
        try container.encodeIfPresent(destinationType, forKey: "destinationType")
        try container.encodeIfPresent(amount, forKey: "amount")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        sourceId = try container.decodeIfPresent(UUID.self, forKey: "sourceId")
        sourceType = try container.decodeIfPresent(SourceType.self, forKey: "sourceType")
        destinationId = try container.decodeIfPresent(UUID.self, forKey: "destinationId")
        destinationType = try container.decodeIfPresent(DestinationType.self, forKey: "destinationType")
        amount = try container.decodeIfPresent(Double.self, forKey: "amount")
    }
}

