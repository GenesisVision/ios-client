//
// PersonalProgramDetailsList.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class PersonalProgramDetailsList: Codable {

    public var isFavorite: Bool?
    public var isInvested: Bool?
    public var hasNotifications: Bool?


    
    public init(isFavorite: Bool?, isInvested: Bool?, hasNotifications: Bool?) {
        self.isFavorite = isFavorite
        self.isInvested = isInvested
        self.hasNotifications = hasNotifications
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(isFavorite, forKey: "isFavorite")
        try container.encodeIfPresent(isInvested, forKey: "isInvested")
        try container.encodeIfPresent(hasNotifications, forKey: "hasNotifications")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        isFavorite = try container.decodeIfPresent(Bool.self, forKey: "isFavorite")
        isInvested = try container.decodeIfPresent(Bool.self, forKey: "isInvested")
        hasNotifications = try container.decodeIfPresent(Bool.self, forKey: "hasNotifications")
    }
}

