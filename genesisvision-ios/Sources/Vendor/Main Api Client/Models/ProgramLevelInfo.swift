//
// ProgramLevelInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct ProgramLevelInfo: Codable {


    public var isKycPassed: Bool?

    public var level: Int?

    public var levelProgressPercent: Double?

    public var genesisRatio: Double?

    public var programAge: Double?

    public var weightedVolumeScale: Double?

    public var managerBalance: Double?

    public var investmentScale: Double?

    public var totalAvailableToInvest: Double?
    public init(isKycPassed: Bool? = nil, level: Int? = nil, levelProgressPercent: Double? = nil, genesisRatio: Double? = nil, programAge: Double? = nil, weightedVolumeScale: Double? = nil, managerBalance: Double? = nil, investmentScale: Double? = nil, totalAvailableToInvest: Double? = nil) { 
        self.isKycPassed = isKycPassed
        self.level = level
        self.levelProgressPercent = levelProgressPercent
        self.genesisRatio = genesisRatio
        self.programAge = programAge
        self.weightedVolumeScale = weightedVolumeScale
        self.managerBalance = managerBalance
        self.investmentScale = investmentScale
        self.totalAvailableToInvest = totalAvailableToInvest
    }

}
