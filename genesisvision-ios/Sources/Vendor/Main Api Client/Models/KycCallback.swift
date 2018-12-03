//
// KycCallback.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class KycCallback: Codable {

    public var applicantId: String?
    public var inspectionId: String?
    public var correlationId: String?
    public var externalUserId: String?
    public var success: Bool?
    public var details: Any?
    public var type: String?
    public var review: Review?


    
    public init(applicantId: String?, inspectionId: String?, correlationId: String?, externalUserId: String?, success: Bool?, details: Any?, type: String?, review: Review?) {
        self.applicantId = applicantId
        self.inspectionId = inspectionId
        self.correlationId = correlationId
        self.externalUserId = externalUserId
        self.success = success
        self.details = details
        self.type = type
        self.review = review
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(applicantId, forKey: "applicantId")
        try container.encodeIfPresent(inspectionId, forKey: "inspectionId")
        try container.encodeIfPresent(correlationId, forKey: "correlationId")
        try container.encodeIfPresent(externalUserId, forKey: "externalUserId")
        try container.encodeIfPresent(success, forKey: "success")
        try container.encodeIfPresent(details, forKey: "details")
        try container.encodeIfPresent(type, forKey: "type")
        try container.encodeIfPresent(review, forKey: "review")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        applicantId = try container.decodeIfPresent(String.self, forKey: "applicantId")
        inspectionId = try container.decodeIfPresent(String.self, forKey: "inspectionId")
        correlationId = try container.decodeIfPresent(String.self, forKey: "correlationId")
        externalUserId = try container.decodeIfPresent(String.self, forKey: "externalUserId")
        success = try container.decodeIfPresent(Bool.self, forKey: "success")
        details = try container.decodeIfPresent(Any.self, forKey: "details")
        type = try container.decodeIfPresent(String.self, forKey: "type")
        review = try container.decodeIfPresent(Review.self, forKey: "review")
    }
}

