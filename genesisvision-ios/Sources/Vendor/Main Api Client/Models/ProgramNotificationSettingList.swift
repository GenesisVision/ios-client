//
// ProgramNotificationSettingList.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct ProgramNotificationSettingList: Codable {


    public var level: Int?

    public var levelProgress: Double?

    public var settingsCustom: [NotificationSettingViewModel]?

    public var assetId: UUID?

    public var title: String?

    public var url: String?

    public var logoUrl: String?

    public var color: String?

    public var settingsGeneral: [NotificationSettingViewModel]?
    public init(level: Int? = nil, levelProgress: Double? = nil, settingsCustom: [NotificationSettingViewModel]? = nil, assetId: UUID? = nil, title: String? = nil, url: String? = nil, logoUrl: String? = nil, color: String? = nil, settingsGeneral: [NotificationSettingViewModel]? = nil) { 
        self.level = level
        self.levelProgress = levelProgress
        self.settingsCustom = settingsCustom
        self.assetId = assetId
        self.title = title
        self.url = url
        self.logoUrl = logoUrl
        self.color = color
        self.settingsGeneral = settingsGeneral
    }

}
