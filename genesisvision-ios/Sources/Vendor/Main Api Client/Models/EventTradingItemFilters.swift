//
// EventTradingItemFilters.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct EventTradingItemFilters: Codable {


    public var follow: [FilterItemInfo]?

    public var all: [FilterItemInfo]?

    public var program: [FilterItemInfo]?

    public var fund: [FilterItemInfo]?
    public init(follow: [FilterItemInfo]? = nil, all: [FilterItemInfo]? = nil, program: [FilterItemInfo]? = nil, fund: [FilterItemInfo]? = nil) { 
        self.follow = follow
        self.all = all
        self.program = program
        self.fund = fund
    }

}
