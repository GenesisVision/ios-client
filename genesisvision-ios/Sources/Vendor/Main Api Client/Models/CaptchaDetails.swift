//
// CaptchaDetails.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct CaptchaDetails: Codable {


    public var captchaType: CaptchaType?

    public var _id: UUID?

    public var route: String?

    public var pow: PowDetails?

    public var geeTest: GeeTestDetails?
    public init(captchaType: CaptchaType? = nil, _id: UUID? = nil, route: String? = nil, pow: PowDetails? = nil, geeTest: GeeTestDetails? = nil) { 
        self.captchaType = captchaType
        self._id = _id
        self.route = route
        self.pow = pow
        self.geeTest = geeTest
    }
    public enum CodingKeys: String, CodingKey { 
        case captchaType
        case _id = "id"
        case route
        case pow
        case geeTest
    }

}
