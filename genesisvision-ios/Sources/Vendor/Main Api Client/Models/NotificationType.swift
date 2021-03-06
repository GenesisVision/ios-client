//
// NotificationType.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

public enum NotificationType: String, Codable {
    case platformNewsAndUpdates = "PlatformNewsAndUpdates"
    case platformEmergency = "PlatformEmergency"
    case platformOther = "PlatformOther"
    case profileUpdated = "ProfileUpdated"
    case profilePwdUpdated = "ProfilePwdUpdated"
    case profileVerification = "ProfileVerification"
    case profile2FA = "Profile2FA"
    case profileSecurity = "ProfileSecurity"
    case tradingAccountPwdUpdated = "TradingAccountPwdUpdated"
    case tradingAccountUpdated = "TradingAccountUpdated"
    case programNewsAndUpdates = "ProgramNewsAndUpdates"
    case programEndOfPeriod = "ProgramEndOfPeriod"
    case programCondition = "ProgramCondition"
    case programExceedInvestmentLimit = "ProgramExceedInvestmentLimit"
    case followNewsAndUpdates = "FollowNewsAndUpdates"
    case fundNewsAndUpdates = "FundNewsAndUpdates"
    case fundEndOfPeriod = "FundEndOfPeriod"
    case fundRebalancing = "FundRebalancing"
    case managerNewProgram = "ManagerNewProgram"
    case managerNewFund = "ManagerNewFund"
    case managerNewExternalSignalAccount = "ManagerNewExternalSignalAccount"
    case managerNewSignalProvider = "ManagerNewSignalProvider"
    case signals = "Signals"
    case externalSignals = "ExternalSignals"
    case social = "Social"
    case platformAsset = "PlatformAsset"
}