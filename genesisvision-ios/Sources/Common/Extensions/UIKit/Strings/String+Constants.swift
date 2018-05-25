//
//  String+Constants.swift
//  genesisvision-ios
//
//  Created by George on 05/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

extension String {
    struct Info {
        static var signUpConfirmationSuccess: String { return "Please confirm \nyour email.".localized }
        static var forgotPasswordSuccess: String = "We sent a password reset link to the email you specified.\n\nplease follow this link to reset your password.".localized
        static var changePasswordSuccess: String = "You have been successfully changed your password.".localized
        static var investmentRequestSuccess: String { return "You have been successfully invested <N> GVT in the investment program. Your tokens will be working for you only since the next reporting period.\n\nIn case you decide to cancel the investment before the start of the next reporting period, you will have to pay a commission, and you will get your GVT at the actual GVT exchange rate.".localized }
        static var withdrawRequestSuccess: String { return "At the end of the current trading period the tokens will be returned to the manager and your funds are return to you.".localized }
    }
    
    struct Alerts {
        static var cancelButtonText: String = "Cancel"
        static var okButtonText: String = "OK"
        
        struct NewVersionUpdate {
            static var alertTitle: String = "New version is available"
            static var alertMessage: String = "Please update to version "
            static var skipThisVersionButtonText: String = "Skip this version"
            static var updateButtonText: String = "Update"
        }
        
        struct Feedback {
            static var alertTitle: String = "You can send your feedback to us with the following options:"
            static var websiteButtonText: String = "Visit feedback website"
            static var emailButtonText: String = "Send email"
        }
        
        struct PrivacySettings {
            static var alertTitle: String = "Privacy settings"
            static var settingsButtonText: String = "Settings"
        }
        
        struct ErrorMessages {
            static let noInternetConnection = "No Internet Connection"
            static let noDataText = "not enough data\n for the chart"
            
            struct MailErrorAlert {
                static let title = "Could not send e-mail"
                static let message = "Your device could not send e-mail. Please check e-mail configuration and try again."
                static let cancelButtonText = String.Alerts.okButtonText
            }
        }
        
        static var noAvailableTokens = "There are currently no tokens available. Please check this program later - someone can withdraw their funds from this program."
        static var comingSoon = "Coming soon"
        
    }
    
    struct Titles {
        static let refreshControlTitle = "Loading..."
    }
}
