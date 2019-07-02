//
// PersonalProgramDetailsFull.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class PersonalProgramDetailsFull: Codable {

    public enum Status: String, Codable { 
        case pending = "Pending"
        case active = "Active"
        case investing = "Investing"
        case withdrawing = "Withdrawing"
        case ended = "Ended"
    }
    public var isReinvest: Bool?
    public var gvtValue: Double?
    public var showTwoFactorButton: Bool?
    public var signalSubscription: SignalSubscription?
    public var login: String?
    public var notificationAvailableToInvestId: UUID?
    public var canMakeSignalProvider: Bool?
    public var canChangePassword: Bool?
    public var migration: MigrationRequest?
    public var isFavorite: Bool?
    public var isInvested: Bool?
    public var isOwnProgram: Bool?
    public var canCloseProgram: Bool?
    public var canCloseAsset: Bool?
    public var isFinishing: Bool?
    public var canInvest: Bool?
    public var canWithdraw: Bool?
    public var canClosePeriod: Bool?
    public var hasNotifications: Bool?
    public var value: Double?
    public var profit: Double?
    public var invested: Double?
    public var pendingInput: Double?
    public var pendingOutput: Double?
    public var pendingOutputIsWithdrawAll: Bool?
    public var status: Status?


    
    public init(isReinvest: Bool?, gvtValue: Double?, showTwoFactorButton: Bool?, signalSubscription: SignalSubscription?, login: String?, notificationAvailableToInvestId: UUID?, canMakeSignalProvider: Bool?, canChangePassword: Bool?, migration: MigrationRequest?, isFavorite: Bool?, isInvested: Bool?, isOwnProgram: Bool?, canCloseProgram: Bool?, canCloseAsset: Bool?, isFinishing: Bool?, canInvest: Bool?, canWithdraw: Bool?, canClosePeriod: Bool?, hasNotifications: Bool?, value: Double?, profit: Double?, invested: Double?, pendingInput: Double?, pendingOutput: Double?, pendingOutputIsWithdrawAll: Bool?, status: Status?) {
        self.isReinvest = isReinvest
        self.gvtValue = gvtValue
        self.showTwoFactorButton = showTwoFactorButton
        self.signalSubscription = signalSubscription
        self.login = login
        self.notificationAvailableToInvestId = notificationAvailableToInvestId
        self.canMakeSignalProvider = canMakeSignalProvider
        self.canChangePassword = canChangePassword
        self.migration = migration
        self.isFavorite = isFavorite
        self.isInvested = isInvested
        self.isOwnProgram = isOwnProgram
        self.canCloseProgram = canCloseProgram
        self.canCloseAsset = canCloseAsset
        self.isFinishing = isFinishing
        self.canInvest = canInvest
        self.canWithdraw = canWithdraw
        self.canClosePeriod = canClosePeriod
        self.hasNotifications = hasNotifications
        self.value = value
        self.profit = profit
        self.invested = invested
        self.pendingInput = pendingInput
        self.pendingOutput = pendingOutput
        self.pendingOutputIsWithdrawAll = pendingOutputIsWithdrawAll
        self.status = status
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(isReinvest, forKey: "isReinvest")
        try container.encodeIfPresent(gvtValue, forKey: "gvtValue")
        try container.encodeIfPresent(showTwoFactorButton, forKey: "showTwoFactorButton")
        try container.encodeIfPresent(signalSubscription, forKey: "signalSubscription")
        try container.encodeIfPresent(login, forKey: "login")
        try container.encodeIfPresent(notificationAvailableToInvestId, forKey: "notificationAvailableToInvestId")
        try container.encodeIfPresent(canMakeSignalProvider, forKey: "canMakeSignalProvider")
        try container.encodeIfPresent(canChangePassword, forKey: "canChangePassword")
        try container.encodeIfPresent(migration, forKey: "migration")
        try container.encodeIfPresent(isFavorite, forKey: "isFavorite")
        try container.encodeIfPresent(isInvested, forKey: "isInvested")
        try container.encodeIfPresent(isOwnProgram, forKey: "isOwnProgram")
        try container.encodeIfPresent(canCloseProgram, forKey: "canCloseProgram")
        try container.encodeIfPresent(canCloseAsset, forKey: "canCloseAsset")
        try container.encodeIfPresent(isFinishing, forKey: "isFinishing")
        try container.encodeIfPresent(canInvest, forKey: "canInvest")
        try container.encodeIfPresent(canWithdraw, forKey: "canWithdraw")
        try container.encodeIfPresent(canClosePeriod, forKey: "canClosePeriod")
        try container.encodeIfPresent(hasNotifications, forKey: "hasNotifications")
        try container.encodeIfPresent(value, forKey: "value")
        try container.encodeIfPresent(profit, forKey: "profit")
        try container.encodeIfPresent(invested, forKey: "invested")
        try container.encodeIfPresent(pendingInput, forKey: "pendingInput")
        try container.encodeIfPresent(pendingOutput, forKey: "pendingOutput")
        try container.encodeIfPresent(pendingOutputIsWithdrawAll, forKey: "pendingOutputIsWithdrawAll")
        try container.encodeIfPresent(status, forKey: "status")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        isReinvest = try container.decodeIfPresent(Bool.self, forKey: "isReinvest")
        gvtValue = try container.decodeIfPresent(Double.self, forKey: "gvtValue")
        showTwoFactorButton = try container.decodeIfPresent(Bool.self, forKey: "showTwoFactorButton")
        signalSubscription = try container.decodeIfPresent(SignalSubscription.self, forKey: "signalSubscription")
        login = try container.decodeIfPresent(String.self, forKey: "login")
        notificationAvailableToInvestId = try container.decodeIfPresent(UUID.self, forKey: "notificationAvailableToInvestId")
        canMakeSignalProvider = try container.decodeIfPresent(Bool.self, forKey: "canMakeSignalProvider")
        canChangePassword = try container.decodeIfPresent(Bool.self, forKey: "canChangePassword")
        migration = try container.decodeIfPresent(MigrationRequest.self, forKey: "migration")
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: "isFavorite")
        isInvested = try container.decodeIfPresent(Bool.self, forKey: "isInvested")
        isOwnProgram = try container.decodeIfPresent(Bool.self, forKey: "isOwnProgram")
        canCloseProgram = try container.decodeIfPresent(Bool.self, forKey: "canCloseProgram")
        canCloseAsset = try container.decodeIfPresent(Bool.self, forKey: "canCloseAsset")
        isFinishing = try container.decodeIfPresent(Bool.self, forKey: "isFinishing")
        canInvest = try container.decodeIfPresent(Bool.self, forKey: "canInvest")
        canWithdraw = try container.decodeIfPresent(Bool.self, forKey: "canWithdraw")
        canClosePeriod = try container.decodeIfPresent(Bool.self, forKey: "canClosePeriod")
        hasNotifications = try container.decodeIfPresent(Bool.self, forKey: "hasNotifications")
        value = try container.decodeIfPresent(Double.self, forKey: "value")
        profit = try container.decodeIfPresent(Double.self, forKey: "profit")
        invested = try container.decodeIfPresent(Double.self, forKey: "invested")
        pendingInput = try container.decodeIfPresent(Double.self, forKey: "pendingInput")
        pendingOutput = try container.decodeIfPresent(Double.self, forKey: "pendingOutput")
        pendingOutputIsWithdrawAll = try container.decodeIfPresent(Bool.self, forKey: "pendingOutputIsWithdrawAll")
        status = try container.decodeIfPresent(Status.self, forKey: "status")
    }
}

