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
    public init(password: String? = nil, twoFactorCode: String? = nil) { 
        self.password = password
        self.twoFactorCode = twoFactorCode
    }

}
