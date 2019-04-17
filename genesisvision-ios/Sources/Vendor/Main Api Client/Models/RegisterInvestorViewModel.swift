//
// RegisterInvestorViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class RegisterInvestorViewModel: Codable {

    public var email: String
    public var password: String
    public var confirmPassword: String?
    public var refCode: String?
    public var isAuto: Bool?


    
    public init(email: String, password: String, confirmPassword: String?, refCode: String?, isAuto: Bool?) {
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.refCode = refCode
        self.isAuto = isAuto
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encode(email, forKey: "email")
        try container.encode(password, forKey: "password")
        try container.encodeIfPresent(confirmPassword, forKey: "confirmPassword")
        try container.encodeIfPresent(refCode, forKey: "refCode")
        try container.encodeIfPresent(isAuto, forKey: "isAuto")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        email = try container.decode(String.self, forKey: "email")
        password = try container.decode(String.self, forKey: "password")
        confirmPassword = try container.decodeIfPresent(String.self, forKey: "confirmPassword")
        refCode = try container.decodeIfPresent(String.self, forKey: "refCode")
        isAuto = try container.decodeIfPresent(Bool.self, forKey: "isAuto")
    }
}

