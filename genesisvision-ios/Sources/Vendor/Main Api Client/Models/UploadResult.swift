//
// UploadResult.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct UploadResult: Codable {


    public var _id: UUID?
    public init(_id: UUID? = nil) { 
        self._id = _id
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
    }

}
