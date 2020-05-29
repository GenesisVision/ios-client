//
// ProfilePublicShort.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct ProfilePublicShort: Codable {


    public var _id: UUID?

    public var username: String?

    public var url: String?
    public init(_id: UUID? = nil, username: String? = nil, url: String? = nil) { 
        self._id = _id
        self.username = username
        self.url = url
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case username
        case url
    }

}
