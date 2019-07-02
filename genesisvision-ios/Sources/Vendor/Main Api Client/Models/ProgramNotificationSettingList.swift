//
// ProgramNotificationSettingList.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class ProgramNotificationSettingList: Codable {

    public var level: Int?
    public var levelProgress: Double?
    public var settingsCustom: [NotificationSettingViewModel]?
    public var assetId: UUID?
    public var title: String?
    public var url: String?
    public var logo: String?
    public var color: String?
    public var settingsGeneral: [NotificationSettingViewModel]?


    
    public init(level: Int?, levelProgress: Double?, settingsCustom: [NotificationSettingViewModel]?, assetId: UUID?, title: String?, url: String?, logo: String?, color: String?, settingsGeneral: [NotificationSettingViewModel]?) {
        self.level = level
        self.levelProgress = levelProgress
        self.settingsCustom = settingsCustom
        self.assetId = assetId
        self.title = title
        self.url = url
        self.logo = logo
        self.color = color
        self.settingsGeneral = settingsGeneral
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(level, forKey: "level")
        try container.encodeIfPresent(levelProgress, forKey: "levelProgress")
        try container.encodeIfPresent(settingsCustom, forKey: "settingsCustom")
        try container.encodeIfPresent(assetId, forKey: "assetId")
        try container.encodeIfPresent(title, forKey: "title")
        try container.encodeIfPresent(url, forKey: "url")
        try container.encodeIfPresent(logo, forKey: "logo")
        try container.encodeIfPresent(color, forKey: "color")
        try container.encodeIfPresent(settingsGeneral, forKey: "settingsGeneral")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        level = try container.decodeIfPresent(Int.self, forKey: "level")
        levelProgress = try container.decodeIfPresent(Double.self, forKey: "levelProgress")
        settingsCustom = try container.decodeIfPresent([NotificationSettingViewModel].self, forKey: "settingsCustom")
        assetId = try container.decodeIfPresent(UUID.self, forKey: "assetId")
        title = try container.decodeIfPresent(String.self, forKey: "title")
        url = try container.decodeIfPresent(String.self, forKey: "url")
        logo = try container.decodeIfPresent(String.self, forKey: "logo")
        color = try container.decodeIfPresent(String.self, forKey: "color")
        settingsGeneral = try container.decodeIfPresent([NotificationSettingViewModel].self, forKey: "settingsGeneral")
    }
}

