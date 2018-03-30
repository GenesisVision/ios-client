//
//  ErrorHandler.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import PKHUD

enum ErrorMessageType {
    case connectionError(message: String)
    case apiError(message: String?)
}

class ErrorHandler {
    static func handleApiError(error: Error?, completion: @escaping CompletionBlock) {
        guard let errorResponse = error as? ErrorResponse else {
            return completion(.failure(errorType: .apiError(message: nil)))
        }
        
        switch errorResponse {
        case .error(let code, let data, let properties):
            print("API ERROR with \(code) code\n Properties: \(properties)")
            
            guard code != 401 else {
                NotificationCenter.default.post(name: .signOut, object: nil)
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            guard let jsonData = data else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            var errorViewModel: ErrorViewModel?
            
            do {
                errorViewModel = try JSONDecoder().decode(ErrorViewModel.self, from: jsonData)
            } catch {}
            
            guard let errorsText = errorViewModel?.errors?.flatMap({$0.message}).joined(separator: "\n") else {
                return completion(.failure(errorType: .apiError(message: nil)))
            }
            
            print("API ERROR text \(errorsText)")
            completion(.failure(errorType: .apiError(message: errorsText)))
        }
    }
    
    static func handleError(with errorMessageType: ErrorMessageType, viewController: UIViewController? = nil, hud: Bool = false) {
        switch errorMessageType {
        case .apiError(let message):
            hud && viewController != nil
                ? message != nil ? viewController!.showErrorHUD(subtitle: message!) : viewController!.showErrorHUD()
                : message != nil ? print("Api Error with reason: " + message!) : print("Api Error without reason")
        case .connectionError(let message):
            if let vc = viewController {
                DispatchQueue.main.async {
                    vc.showFlashHUD(type: .label(message), delay: 1.5)
                }
            }
        }
    }
}

class ResponseHandler {
    static func handleApi(error: Error?, completion: @escaping CompletionBlock) {
        error == nil
            ? completion(CompletionResult.success)
            : ErrorHandler.handleApiError(error: error, completion: completion)
    }
}
