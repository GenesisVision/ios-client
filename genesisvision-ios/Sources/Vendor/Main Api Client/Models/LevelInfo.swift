//
// LevelInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct LevelInfo: Codable {


    public var level: Int?

    public var investmentLimit: Double?
    public init(level: Int? = nil, investmentLimit: Double? = nil) { 
        self.level = level
        self.investmentLimit = investmentLimit
    }

}
