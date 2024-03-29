//
// ErrorViewModelWithToken.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct ErrorViewModelWithToken: Codable {


    public var errors: [ErrorMessage]?

    public var code: ErrorCodes?

    public var tempToken: String?
    public init(errors: [ErrorMessage]? = nil, code: ErrorCodes? = nil, tempToken: String? = nil) { 
        self.errors = errors
        self.code = code
        self.tempToken = tempToken
    }

}
