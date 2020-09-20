//
// CreateSignalProvider.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct CreateSignalProvider: Codable {


    /** AssetId */
    public var _id: UUID?

    public var volumeFee: Double?

    public var successFee: Double?
    public init(_id: UUID? = nil, volumeFee: Double? = nil, successFee: Double? = nil) { 
        self._id = _id
        self.volumeFee = volumeFee
        self.successFee = successFee
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case volumeFee
        case successFee
    }

}