//
// ProgramAssetDetails.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct ProgramAssetDetails: Codable {


    public var level: Int?

    public var levelProgress: Double?
    public init(level: Int? = nil, levelProgress: Double? = nil) { 
        self.level = level
        self.levelProgress = levelProgress
    }

}