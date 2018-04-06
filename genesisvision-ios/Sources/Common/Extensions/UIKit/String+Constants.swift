//
//  String+Constants.swift
//  genesisvision-ios
//
//  Created by George on 05/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

extension String {
    struct Info {
        static var signUpConfirmationSuccess: String { return "Please confirm \nyour email." }
        static var forgotPasswordSuccess: String = "We sent a password reset link to the email you specified.\n\nplease follow this link to reset your password."
        static var investmentRequestSuccess: String { return "At the end of the current trading period your GVT will be exchanged to the manager's tokens. \n\nIn case there won't be enough tokens for you, your extra GVT will be cashed back." }
        static var withdrawRequestSuccess: String { return "At the end of the current trading period the tokens will be returned to the manager and your funds are return to you." }
    }
}
