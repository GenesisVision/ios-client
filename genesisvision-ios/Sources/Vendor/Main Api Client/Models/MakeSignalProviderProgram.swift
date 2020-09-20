//
// MakeSignalProviderProgram.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct MakeSignalProviderProgram: Codable {


    public var _id: UUID?

    public var periodLength: Int?

    public var stopOutLevel: Double?

    public var investmentLimit: Double?

    public var entryFee: Double?

    public var successFee: Double?
    public init(_id: UUID? = nil, periodLength: Int? = nil, stopOutLevel: Double? = nil, investmentLimit: Double? = nil, entryFee: Double? = nil, successFee: Double? = nil) { 
        self._id = _id
        self.periodLength = periodLength
        self.stopOutLevel = stopOutLevel
        self.investmentLimit = investmentLimit
        self.entryFee = entryFee
        self.successFee = successFee
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case periodLength
        case stopOutLevel
        case investmentLimit
        case entryFee
        case successFee
    }

}