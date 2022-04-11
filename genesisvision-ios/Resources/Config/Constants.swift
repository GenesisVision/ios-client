//
//  Constants.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

typealias ActionCompletionBlock = () -> Void
typealias CompletionBlock = (_ result: CompletionResult) -> Void
typealias CreateAccountCompletionBlock = (_ id: UUID?) -> Void
typealias SuccessCompletionBlock = (_ success: Bool) -> Void

final class Constants {
    static let headerHeight: CGFloat = 20.0
    
    struct HudDelay {
        static let `default`: Double = 2.0
        static let error: Double = 2.0
        static let success: Double = 1.0
    }
    
    struct Profile {
        static let minYear: Int = 0
    }
    
    struct SystemSizes {
        struct Cell {
            static let horizontalMarginValue: CGFloat = 10.0
            static let verticalMarginValue: CGFloat = 10.0
            static let lineSpacing: CGFloat = 10.0
            static let interitemSpacing: CGFloat = 10.0
        }
        
        static let cornerSize: CGFloat = 16.0
        static var chartCircleHeight: CGFloat = 9.0
        static let selectedSegmentedTitle: CGFloat = 23.0
        static let unselectedSegmentedTitle: CGFloat = 15.0
        
        static let imageViewBorderWidthPercentage: CGFloat = 0.04
    }
    
    static let gvtString = "GVT"
    static let projectStartDate = 1483228800
    
    struct CoinAssetsConstants {
        struct portfolioLabels {
            static let yourInvestments = "Your investments"
            static let amount = "Amount"
            static let price = "Price"
            static let change24h = "Change24h"
            static let total = "Total"
            static let AvaragePrice = "Avarage price"
            static let profit = "Profit"
        }
        
        static let about = "About"
        static let chart = "Chart"
        static let disclaimer = "The funds will be converted according to the current market price (Market order)."
        static let selectAWallet = "Select a wallet currency"
        static let fee = 0.001
        static let enterAmount = "Enter amount to transfer"
        static let from = "From"
        static let to = "To"
        static let minimalTransferDisclaimer = "Not enough money to transfer. Min $10"
        static let transferError = "Еransaction error. Please try again later"
    }
}
