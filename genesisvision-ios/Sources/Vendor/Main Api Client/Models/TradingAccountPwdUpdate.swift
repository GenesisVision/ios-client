//
// TradingAccountPwdUpdate.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct TradingAccountPwdUpdate: Codable {


    public var password: String?

    public var twoFactorCode: String?

    public var _id: UUID?
    public init(password: String? = nil, twoFactorCode: String? = nil, _id: UUID? = nil) { 
        self.password = password
        self.twoFactorCode = twoFactorCode
        self._id = _id
    }
    public enum CodingKeys: String, CodingKey { 
        case password
        case twoFactorCode
        case _id = "id"
    }

}
