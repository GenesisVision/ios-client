//
// PowResult.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct PowResult: Codable {


    public var _prefix: String?
    public init(_prefix: String? = nil) { 
        self._prefix = _prefix
    }
    public enum CodingKeys: String, CodingKey { 
        case _prefix = "prefix"
    }

}