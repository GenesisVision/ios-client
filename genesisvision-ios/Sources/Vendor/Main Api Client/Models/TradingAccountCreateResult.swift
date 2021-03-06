//
// TradingAccountCreateResult.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct TradingAccountCreateResult: Codable {


    public var _id: UUID?

    public var twoFactorRequired: Bool?

    public var twoFactor: TwoFactorAuthenticator?

    public var startDeposit: Double?
    public init(_id: UUID? = nil, twoFactorRequired: Bool? = nil, twoFactor: TwoFactorAuthenticator? = nil, startDeposit: Double? = nil) { 
        self._id = _id
        self.twoFactorRequired = twoFactorRequired
        self.twoFactor = twoFactor
        self.startDeposit = startDeposit
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case twoFactorRequired
        case twoFactor
        case startDeposit
    }

}
