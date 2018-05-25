//
// InvestmentProgramAccrual.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class InvestmentProgramAccrual: Codable {

    public var investmentProgramId: UUID?
    public var accruals: [InvestorAmount]?


    
    public init(investmentProgramId: UUID?, accruals: [InvestorAmount]?) {
        self.investmentProgramId = investmentProgramId
        self.accruals = accruals
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(investmentProgramId, forKey: "investmentProgramId")
        try container.encodeIfPresent(accruals, forKey: "accruals")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        investmentProgramId = try container.decodeIfPresent(UUID.self, forKey: "investmentProgramId")
        accruals = try container.decodeIfPresent([InvestorAmount].self, forKey: "accruals")
    }
}

