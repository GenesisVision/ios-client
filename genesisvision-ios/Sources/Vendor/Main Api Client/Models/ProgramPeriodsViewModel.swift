//
// ProgramPeriodsViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct ProgramPeriodsViewModel: Codable {


    public var periods: [ProgramPeriodViewModel]?

    public var total: Int?
    public init(periods: [ProgramPeriodViewModel]? = nil, total: Int? = nil) { 
        self.periods = periods
        self.total = total
    }

}
