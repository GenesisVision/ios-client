//
// PartnershipDetails.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct PartnershipDetails: Codable {


    public var totalReferralsL1: Int?

    public var totalReferralsL2: Int?

    public var totalAmount: Double?
    public init(totalReferralsL1: Int? = nil, totalReferralsL2: Int? = nil, totalAmount: Double? = nil) { 
        self.totalReferralsL1 = totalReferralsL1
        self.totalReferralsL2 = totalReferralsL2
        self.totalAmount = totalAmount
    }

}
