//
// PlatformStatus.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class PlatformStatus: Codable {

    public var isTournamentActive: Bool?
    public var isTournamentRegistrationActive: Bool?
    public var tournamentCurrentRound: Int?
    public var tournamentTotalRounds: Int?
    public var programsMinAvgProfit: Double?
    public var programsMaxAvgProfit: Double?
    public var programsMinTotalProfit: Double?
    public var programsMaxTotalProfit: Double?
    public var iOSVersion: IOsAppVersion?
    public var androidVersion: AndroidAppVersion?


    
    public init(isTournamentActive: Bool?, isTournamentRegistrationActive: Bool?, tournamentCurrentRound: Int?, tournamentTotalRounds: Int?, programsMinAvgProfit: Double?, programsMaxAvgProfit: Double?, programsMinTotalProfit: Double?, programsMaxTotalProfit: Double?, iOSVersion: IOsAppVersion?, androidVersion: AndroidAppVersion?) {
        self.isTournamentActive = isTournamentActive
        self.isTournamentRegistrationActive = isTournamentRegistrationActive
        self.tournamentCurrentRound = tournamentCurrentRound
        self.tournamentTotalRounds = tournamentTotalRounds
        self.programsMinAvgProfit = programsMinAvgProfit
        self.programsMaxAvgProfit = programsMaxAvgProfit
        self.programsMinTotalProfit = programsMinTotalProfit
        self.programsMaxTotalProfit = programsMaxTotalProfit
        self.iOSVersion = iOSVersion
        self.androidVersion = androidVersion
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(isTournamentActive, forKey: "isTournamentActive")
        try container.encodeIfPresent(isTournamentRegistrationActive, forKey: "isTournamentRegistrationActive")
        try container.encodeIfPresent(tournamentCurrentRound, forKey: "tournamentCurrentRound")
        try container.encodeIfPresent(tournamentTotalRounds, forKey: "tournamentTotalRounds")
        try container.encodeIfPresent(programsMinAvgProfit, forKey: "programsMinAvgProfit")
        try container.encodeIfPresent(programsMaxAvgProfit, forKey: "programsMaxAvgProfit")
        try container.encodeIfPresent(programsMinTotalProfit, forKey: "programsMinTotalProfit")
        try container.encodeIfPresent(programsMaxTotalProfit, forKey: "programsMaxTotalProfit")
        try container.encodeIfPresent(iOSVersion, forKey: "iOSVersion")
        try container.encodeIfPresent(androidVersion, forKey: "androidVersion")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        isTournamentActive = try container.decodeIfPresent(Bool.self, forKey: "isTournamentActive")
        isTournamentRegistrationActive = try container.decodeIfPresent(Bool.self, forKey: "isTournamentRegistrationActive")
        tournamentCurrentRound = try container.decodeIfPresent(Int.self, forKey: "tournamentCurrentRound")
        tournamentTotalRounds = try container.decodeIfPresent(Int.self, forKey: "tournamentTotalRounds")
        programsMinAvgProfit = try container.decodeIfPresent(Double.self, forKey: "programsMinAvgProfit")
        programsMaxAvgProfit = try container.decodeIfPresent(Double.self, forKey: "programsMaxAvgProfit")
        programsMinTotalProfit = try container.decodeIfPresent(Double.self, forKey: "programsMinTotalProfit")
        programsMaxTotalProfit = try container.decodeIfPresent(Double.self, forKey: "programsMaxTotalProfit")
        iOSVersion = try container.decodeIfPresent(IOsAppVersion.self, forKey: "iOSVersion")
        androidVersion = try container.decodeIfPresent(AndroidAppVersion.self, forKey: "androidVersion")
    }
}

