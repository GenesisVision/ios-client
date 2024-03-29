//
// ErrorViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

/** GV copy of ErrorResult */
public struct ErrorViewModel: Codable {


    public var errors: [ErrorMessage]?

    public var code: ErrorCodes?
    public init(errors: [ErrorMessage]? = nil, code: ErrorCodes? = nil) { 
        self.errors = errors
        self.code = code
    }

}
