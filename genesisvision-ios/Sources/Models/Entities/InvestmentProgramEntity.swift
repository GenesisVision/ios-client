//
//  InvestmentProgramEntity.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import RealmSwift

final class InvestmentProgramEntity: TemplatableObject, TemplateEntityProtocol {
    
    @objc dynamic var nickname: String = ""
    @objc dynamic var currency: String = Currency.gvt.rawValue
    @objc dynamic var dateFrom: Date?
    @objc dynamic var dateTo: Date?
    @objc dynamic var period: Int = 0
    @objc dynamic var feeSuccess: Double = 0.0
    @objc dynamic var feeManagement: Double = 0.0
    @objc dynamic var feeEntrance: Double = 0.0
    @objc dynamic var investMinAmount: Double = 0.0
    @objc dynamic var investMaxAmount: Double = 0.0
    @objc dynamic var programId: String?
    @objc dynamic var managerAccountId: String?
    @objc dynamic var managerTokensId: String?
    @objc dynamic var logo: String?
    @objc dynamic var programDescription: String?
    @objc dynamic var isEnabled: Bool = false
    @objc dynamic var rating: Double = 0.0
    @objc dynamic var ordersCount: Int = 0
    @objc dynamic var totalProfit: Double = 0.0
   
    
    func getCurrency() -> Currency {
        return Currency(rawValue: currency)!
    }
}

extension InvestmentProgramEntity {
    static var templateEntity: InvestmentProgramEntity {
        
        let nicknames = ["nick1", "nick12", "nick13"]

        let logos = ["https://goo.gl/images/tR9X4d", nil]
        
        let currency: [Currency] = [.gvt, .btc, .eth]
        
        let entity = InvestmentProgramEntity()
        entity.nickname = nicknames.rand!
        entity.currency = currency.rand!.rawValue
        entity.period = Int(arc4random_uniform(UInt32(10)))
        entity.logo = logos.rand!
        entity.rating = Double(arc4random_uniform(UInt32(10)))
        entity.ordersCount = Int(arc4random_uniform(UInt32(100)))
        entity.totalProfit = Double(arc4random_uniform(UInt32(10)))
        
        return entity
    }
    
    func traslation(fromInvestmentProgram program: InvestmentProgram) {
        self.nickname = program.account?.login ?? ""
        self.currency = program.account?.currency ?? ""
        self.dateFrom = program.investment?.dateFrom ?? nil
        self.dateTo = program.investment?.dateTo ?? nil
        self.period = program.investment?.period ?? 0
        self.feeSuccess = program.investment?.feeSuccess ?? 0.0
        self.feeManagement = program.investment?.feeManagement ?? 0.0
        self.feeEntrance = program.investment?.feeEntrance ?? 0.0
        self.investMinAmount = program.investment?.investMinAmount ?? 0.0
        self.investMaxAmount = program.investment?.investMaxAmount ?? 0.0
        self.programId = program.investment?.id?.uuidString ?? nil
        self.managerAccountId = program.investment?.managerAccountId?.uuidString ?? nil
        self.managerTokensId = program.investment?.managerTokensId?.uuidString ?? nil
        self.logo = program.investment?.logo ?? nil
        self.programDescription = program.investment?.description ?? nil
        self.isEnabled = program.investment?.isEnabled ?? false
        self.rating = program.investment?.rating ?? 0.0
        self.ordersCount = program.investment?.ordersCount ?? 0
        self.totalProfit = program.investment?.totalProfit ?? 0.0
    }
}
