//
// LevelsParamsInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct LevelsParamsInfo: Codable {


    public var minAvailableToInvest: Double?

    public var maxAvailableToInvest: Double?

    public var unverifiedAvailableToInvest: Double?

    public var genesisRatioMin: Double?

    public var genesisRatioMax: Double?

    public var genesisRatioHighRisk: Double?

    public var volumeScaleMin: Double?

    public var volumeScaleMax: Double?

    public var programAgeMax: Double?

    public var ageByVolumeMax: Double?

    public var investmentScaleMin: Double?

    public var investmentScaleMax: Double?

    public var investmentScaleHighRisk: Double?
    public init(minAvailableToInvest: Double? = nil, maxAvailableToInvest: Double? = nil, unverifiedAvailableToInvest: Double? = nil, genesisRatioMin: Double? = nil, genesisRatioMax: Double? = nil, genesisRatioHighRisk: Double? = nil, volumeScaleMin: Double? = nil, volumeScaleMax: Double? = nil, programAgeMax: Double? = nil, ageByVolumeMax: Double? = nil, investmentScaleMin: Double? = nil, investmentScaleMax: Double? = nil, investmentScaleHighRisk: Double? = nil) { 
        self.minAvailableToInvest = minAvailableToInvest
        self.maxAvailableToInvest = maxAvailableToInvest
        self.unverifiedAvailableToInvest = unverifiedAvailableToInvest
        self.genesisRatioMin = genesisRatioMin
        self.genesisRatioMax = genesisRatioMax
        self.genesisRatioHighRisk = genesisRatioHighRisk
        self.volumeScaleMin = volumeScaleMin
        self.volumeScaleMax = volumeScaleMax
        self.programAgeMax = programAgeMax
        self.ageByVolumeMax = ageByVolumeMax
        self.investmentScaleMin = investmentScaleMin
        self.investmentScaleMax = investmentScaleMax
        self.investmentScaleHighRisk = investmentScaleHighRisk
    }

}
