//
//  Tooltips.swift
//  genesisvision–ios
//
//  Created by George on 24/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

extension String {
    struct Tooltitps {
        static var dashboard: String = myTokens + "\n············································\n" + myProfit + "\n············································\n" + periodDuration
    
        static var myTokens: String = "My tokens – the amount of manager tokens received from investing in this particular program.".localized
        static var myProfit: String = "My profit –  the all–time profit that you earned from this program.".localized
        static var periodDuration: String = "Period duration – a period that is defined by a manager at the end of which all trading positions are closed, with a subsequent profit distribution. Also during this period investors can join or leave the investment program, additional investment amounts are made and the commission is paid to a manager.".localized
        static var avgProfit: String = "Avg.profit – the average profit for the period in relation to the starting balance.".localized
        static var totalPortfolio: String = "Total portfolio value – the value of all your tokens from all investment programs.".localized
        static var totalProfit: String = "Total profit – the total all–time manager’s profit.".localized
        static var balance: String = "Balance –  the amount of funds on a trading account.".localized
        static var managementFee: String = "Management fee – an annual obligatory commission, regardless of the outcome (profit or loss).".localized
        static var successFee: String = "Success fee – a payment to the manager for successful trading, set as a percentage of your profit.".localized
        static var trades: String = "Trades – a history of financial operations conducted by the manager.".localized
        static var investors: String = "Investors – a number of investors who already invested in the manager.".localized
        static var availableTokens: String = "Available tokens – a number of tokens which can be bought or requested by investors.".localized
        static var managersFundsShare: String = "Manager’s funds share – a percentage showing the proportion of funds belonging to the manager.".localized
        static var portfolioValue: String = "Portfolio value – the value of all your tokens from all managers.".localized
        static var portfolioProfit: String = "Profit – your total profit (in GVT) from all investment programs.".localized
        static var portfolioInvested: String = "Invested – is a total amount of GVTs which were invested in all managers.".localized
        static var reinvest: String = "".localized
        static var chart: String = "Equity – current condition of a trading account. It is intended for maintaining Manager's opened positions.".localized
        
        static var programDetails: String = totalProfit + "\n············································\n" + avgProfit + "\n············································\n" + balance + "\n············································\n" + investors
        
        static var dashboardHeader: String = portfolioProfit + "\n············································\n" + portfolioInvested + "\n············································\n" + portfolioValue
        static var entryFee: String = "The entry fee is disabled for programs that have not reached level 3. It will be charged only for programs with level 3 or higher."
    }
}
