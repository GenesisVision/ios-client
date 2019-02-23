//
// PlatformInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class PlatformInfo: Codable {

    public var iOSVersion: IOsAppVersion?
    public var androidVersion: AndroidAppVersion?
    public var programsFacets: [ProgramFacet]?
    public var fundsFacets: [FundFacet]?
    public var programsInfo: ProgramsInfo?
    public var currencies: [String]?
    public var platformCurrencies: [PlatformCurrency]?
    public var programTags: [ProgramTag]?


    
    public init(iOSVersion: IOsAppVersion?, androidVersion: AndroidAppVersion?, programsFacets: [ProgramFacet]?, fundsFacets: [FundFacet]?, programsInfo: ProgramsInfo?, currencies: [String]?, platformCurrencies: [PlatformCurrency]?, programTags: [ProgramTag]?) {
        self.iOSVersion = iOSVersion
        self.androidVersion = androidVersion
        self.programsFacets = programsFacets
        self.fundsFacets = fundsFacets
        self.programsInfo = programsInfo
        self.currencies = currencies
        self.platformCurrencies = platformCurrencies
        self.programTags = programTags
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(iOSVersion, forKey: "iOSVersion")
        try container.encodeIfPresent(androidVersion, forKey: "androidVersion")
        try container.encodeIfPresent(programsFacets, forKey: "programsFacets")
        try container.encodeIfPresent(fundsFacets, forKey: "fundsFacets")
        try container.encodeIfPresent(programsInfo, forKey: "programsInfo")
        try container.encodeIfPresent(currencies, forKey: "currencies")
        try container.encodeIfPresent(platformCurrencies, forKey: "platformCurrencies")
        try container.encodeIfPresent(programTags, forKey: "programTags")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        iOSVersion = try container.decodeIfPresent(IOsAppVersion.self, forKey: "iOSVersion")
        androidVersion = try container.decodeIfPresent(AndroidAppVersion.self, forKey: "androidVersion")
        programsFacets = try container.decodeIfPresent([ProgramFacet].self, forKey: "programsFacets")
        fundsFacets = try container.decodeIfPresent([FundFacet].self, forKey: "fundsFacets")
        programsInfo = try container.decodeIfPresent(ProgramsInfo.self, forKey: "programsInfo")
        currencies = try container.decodeIfPresent([String].self, forKey: "currencies")
        platformCurrencies = try container.decodeIfPresent([PlatformCurrency].self, forKey: "platformCurrencies")
        programTags = try container.decodeIfPresent([ProgramTag].self, forKey: "programTags")
    }
}

