//
// PlatformEventType.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

public enum PlatformEventType: String, Codable {
    case undefined = "Undefined"
    case programStarted = "ProgramStarted"
    case fundStarted = "FundStarted"
    case newTradingStrategy = "NewTradingStrategy"
    case periodEnded = "PeriodEnded"
    case fundReallocated = "FundReallocated"
    case followTrade = "FollowTrade"
}