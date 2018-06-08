//
//  String+Constants.swift
//  genesisvision-ios
//
//  Created by George on 05/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

extension String {
    struct Info {
        static var signUpConfirmationSuccess: String = "Please confirm \nyour email.".localized
        static var forgotPasswordSuccess: String = "We sent a password reset link to the email you specified.\n\nplease follow this link to reset your password.".localized
        static var changePasswordSuccess: String = "You have been successfully changed your password.".localized
        static var investmentRequestSuccess: String = "You have been successfully invested <N> GVT in the investment program. Your tokens will be working for you only since the next reporting period.\n\nIn case you decide to cancel the investment before the start of the next reporting period, you will have to pay a commission, and you will get your GVT at the actual GVT exchange rate.".localized
        static var withdrawRequestSuccess: String = "At the end of the current trading period the tokens will be returned to the manager and your funds are return to you.".localized
        
        struct TwoFactor {
            static var twoFactorEnableSuccess: String = "You have just successfully configured two factor authentication. We will ask you for the 2FA Code in any potentially dangerous situation, such as logging in or withdrawing funds.".localized
            static var twoFactorEnableRecoveryCodes: String = "You can find your recovery codes below. You can use them in case you lost your 2FA key or lost your phone with the 2FA application installed. Each recovery code can be used only once. Save these codes on paper and put it in a safe place.".localized
            static var twoFactorDisableSuccess: String = "You have successfully disabled the two factor authentication. \nHowever, we strongly recommend you keep it enabled. This can protect your funds from being stolen.".localized
        }
    }
    
    struct Buttons {
        static var disableTwoFactorAuthentication: String = "Disable two factor authentication".localized
        static var enableTwoFactorAuthentication: String = "Enable two factor authentication".localized
    }
    
    struct ViewTitles {
        struct TwoFactor {
            static var signInTitle: String = "Enter code from \nGoogle Authenticator".localized
            
            static var createTopTitle: String = "Save this Key on paper. This key will allow you to receive your Google Authentication in case of phone loss.".localized
            static var createBottomTitle: String = "You can also add the key using a QR code".localized
            
            static var tutorialTopTitles: [String] = ["Install the Google Authenticator app".localized,
                                               "Open the Google Authenticator app".localized,
                                               "Select the Manual entry option".localized,
                                               "Enter any name for the Key.\nFor example, \"Genesis Vision\"".localized,
                                               "Google Authenticator will start generating a 6 digit code".localized]
            
            static var tutorialBottomTitles: [String] = ["You can use any third party implementation of Google Authenticator instead".localized,
                                                         "Press + in the top right".localized,
                                                         createBottomTitle,
                                                         "Enter a 2FA Key.\nYou can find it on next step".localized,
                                                         "Use it when the Genesis Vision app requires a 2FA confirmation".localized]
        }
        
        static let refreshControlTitle = "Loading...".localized
    }
    
    struct Alerts {
        static var cancelButtonText: String = "Cancel".localized
        static var okButtonText: String = "OK".localized
        
        struct NewVersionUpdate {
            static var alertTitle: String = "New version is available".localized
            static var alertMessage: String = "Please update to version ".localized
            static var skipThisVersionButtonText: String = "Skip this version".localized
            static var updateButtonText: String = "Update".localized
        }
        
        struct TwoFactorEnable {
            static var alertTitle: String = "Two Factor Authentication".localized
            static var alertMessage: String = "To protect your funds, we strongly recommend you to enable two factor authentication. \n\nYou can do it at any time from the Profile screen.".localized
            static var cancelButtonText: String = "No, thanks".localized
            static var enableButtonText: String = "Enable".localized
        }
        
        struct Feedback {
            static var alertTitle: String = "You can send your feedback to us with the following options:".localized
            static var websiteButtonText: String = "Visit feedback website".localized
            static var emailButtonText: String = "Send email".localized
        }
        
        struct PrivacySettings {
            static var alertTitle: String = "Privacy settings".localized
            static var settingsButtonText: String = "Settings".localized
        }
        
        struct ErrorMessages {
            static let noInternetConnection = "No Internet Connection".localized
            static let noDataText = "not enough data\n for the chart".localized
            
            struct MailErrorAlert {
                static let title = "Could not send e-mail".localized
                static let message = "Your device could not send e-mail. Please check e-mail configuration and try again.".localized
                static let cancelButtonText = String.Alerts.okButtonText
            }
        }
        
        static var noAvailableTokens = "There are currently no tokens available. Please check this program later - someone can withdraw their funds from this program.".localized
        static var comingSoon = "Coming soon".localized
        
    }
}
