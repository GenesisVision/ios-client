//
// MakeSelfManagedFundPublicRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct MakeSelfManagedFundPublicRequest: Codable {


    public var _id: UUID?

    public var title: String?

    public var _description: String?

    public var entryFee: Double?

    public var exitFee: Double?
    public init(_id: UUID? = nil, title: String? = nil, _description: String? = nil, entryFee: Double? = nil, exitFee: Double? = nil) { 
        self._id = _id
        self.title = title
        self._description = _description
        self.entryFee = entryFee
        self.exitFee = exitFee
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case title
        case _description = "description"
        case entryFee
        case exitFee
    }

}
