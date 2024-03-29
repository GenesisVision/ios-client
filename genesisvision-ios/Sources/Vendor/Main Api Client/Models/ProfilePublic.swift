//
// ProfilePublic.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct ProfilePublic: Codable {


    public var _id: UUID?

    public var username: String?

    public var logoUrl: String?

    public var registrationDate: Date?

    public var url: String?

    public var socialLinks: [SocialLinkViewModel]?
    public init(_id: UUID? = nil, username: String? = nil, logoUrl: String? = nil, registrationDate: Date? = nil, url: String? = nil, socialLinks: [SocialLinkViewModel]? = nil) { 
        self._id = _id
        self.username = username
        self.logoUrl = logoUrl
        self.registrationDate = registrationDate
        self.url = url
        self.socialLinks = socialLinks
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case username
        case logoUrl
        case registrationDate
        case url
        case socialLinks
    }

}
