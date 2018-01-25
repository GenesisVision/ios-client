//
//  ErrorHandler.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

class ErrorHandler {
    static func handleApiError(error: Error?, completion: @escaping ApiCompletionBlock) {guard let errorResponse = error as? ErrorResponse else {
            completion(ApiCompletionResult.failure(reason: nil))
            return
        }
        
        switch errorResponse {
        case .error(let code, let data, let properties):
            print("API ERROR with \(code) code\n Properties: \(properties)")
            
            guard let jsonData = data else {
                completion(ApiCompletionResult.failure(reason: nil))
                return
            }
            
            var errorViewModel: ErrorViewModel?
            
            do {
                errorViewModel = try JSONDecoder().decode(ErrorViewModel.self, from: jsonData)
            } catch {}
            
            guard let errorsText = errorViewModel?.errors?.flatMap({$0.message}).joined(separator: "\n") else {
                completion(ApiCompletionResult.failure(reason: nil))
                return
            }
            
            print("API ERROR text \(errorsText)")
            completion(ApiCompletionResult.failure(reason: errorsText))
        }
    }
}
