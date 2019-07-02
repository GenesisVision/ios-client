//
// LevelsParamsInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class LevelsParamsInfo: Codable {

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


    
    public init(minAvailableToInvest: Double?, maxAvailableToInvest: Double?, unverifiedAvailableToInvest: Double?, genesisRatioMin: Double?, genesisRatioMax: Double?, genesisRatioHighRisk: Double?, volumeScaleMin: Double?, volumeScaleMax: Double?, programAgeMax: Double?, ageByVolumeMax: Double?, investmentScaleMin: Double?, investmentScaleMax: Double?, investmentScaleHighRisk: Double?) {
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
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(minAvailableToInvest, forKey: "minAvailableToInvest")
        try container.encodeIfPresent(maxAvailableToInvest, forKey: "maxAvailableToInvest")
        try container.encodeIfPresent(unverifiedAvailableToInvest, forKey: "unverifiedAvailableToInvest")
        try container.encodeIfPresent(genesisRatioMin, forKey: "genesisRatioMin")
        try container.encodeIfPresent(genesisRatioMax, forKey: "genesisRatioMax")
        try container.encodeIfPresent(genesisRatioHighRisk, forKey: "genesisRatioHighRisk")
        try container.encodeIfPresent(volumeScaleMin, forKey: "volumeScaleMin")
        try container.encodeIfPresent(volumeScaleMax, forKey: "volumeScaleMax")
        try container.encodeIfPresent(programAgeMax, forKey: "programAgeMax")
        try container.encodeIfPresent(ageByVolumeMax, forKey: "ageByVolumeMax")
        try container.encodeIfPresent(investmentScaleMin, forKey: "investmentScaleMin")
        try container.encodeIfPresent(investmentScaleMax, forKey: "investmentScaleMax")
        try container.encodeIfPresent(investmentScaleHighRisk, forKey: "investmentScaleHighRisk")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        minAvailableToInvest = try container.decodeIfPresent(Double.self, forKey: "minAvailableToInvest")
        maxAvailableToInvest = try container.decodeIfPresent(Double.self, forKey: "maxAvailableToInvest")
        unverifiedAvailableToInvest = try container.decodeIfPresent(Double.self, forKey: "unverifiedAvailableToInvest")
        genesisRatioMin = try container.decodeIfPresent(Double.self, forKey: "genesisRatioMin")
        genesisRatioMax = try container.decodeIfPresent(Double.self, forKey: "genesisRatioMax")
        genesisRatioHighRisk = try container.decodeIfPresent(Double.self, forKey: "genesisRatioHighRisk")
        volumeScaleMin = try container.decodeIfPresent(Double.self, forKey: "volumeScaleMin")
        volumeScaleMax = try container.decodeIfPresent(Double.self, forKey: "volumeScaleMax")
        programAgeMax = try container.decodeIfPresent(Double.self, forKey: "programAgeMax")
        ageByVolumeMax = try container.decodeIfPresent(Double.self, forKey: "ageByVolumeMax")
        investmentScaleMin = try container.decodeIfPresent(Double.self, forKey: "investmentScaleMin")
        investmentScaleMax = try container.decodeIfPresent(Double.self, forKey: "investmentScaleMax")
        investmentScaleHighRisk = try container.decodeIfPresent(Double.self, forKey: "investmentScaleHighRisk")
    }
}

