//
// InvestmentEventType.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

public enum InvestmentEventType: String, Codable {
    case all = "All"
    case assetStarted = "AssetStarted"
    case assetFinished = "AssetFinished"
    case assetPeriodStarted = "AssetPeriodStarted"
    case assetPeriodEnded = "AssetPeriodEnded"
    case assetPeriodEndedDueToStopOut = "AssetPeriodEndedDueToStopOut"
    case assetBrokerChanged = "AssetBrokerChanged"
    case assetInvestByInvestor = "AssetInvestByInvestor"
    case assetWithdrawalByInvestor = "AssetWithdrawalByInvestor"
    case assetInvestByManager = "AssetInvestByManager"
    case assetWithdrawalByManager = "AssetWithdrawalByManager"
    case assetPeriodProcessed = "AssetPeriodProcessed"
    case assetReallocation = "AssetReallocation"
    case assetSubscribeByInvestor = "AssetSubscribeByInvestor"
    case assetUnsubscribeByInvestor = "AssetUnsubscribeByInvestor"
    case assetTradeOpen = "AssetTradeOpen"
    case assetTradeClosed = "AssetTradeClosed"
    case assetSubscriptionEdit = "AssetSubscriptionEdit"
    case assetEnterInvestment = "AssetEnterInvestment"
    case assetWeeklyChallengeWinner = "AssetWeeklyChallengeWinner"
}