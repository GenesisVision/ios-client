//
//  ErrorHandler.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

class ErrorHandler {
    static func handleApiError(error: Error?, completion: @escaping CompletionBlock) {
        guard let errorResponse = error as? ErrorResponse else {
            return completion(.failure(reason: nil))
        }
        
        switch errorResponse {
        case .error(let code, let data, let properties):
            print("API ERROR with \(code) code\n Properties: \(properties)")
            
            guard code != 401 else {
                NotificationCenter.default.post(name: .signOut, object: nil)
                return completion(.failure(reason: nil))
            }
            
            guard let jsonData = data else {
                return completion(.failure(reason: nil))
            }
            
            var errorViewModel: ErrorViewModel?
            
            do {
                errorViewModel = try JSONDecoder().decode(ErrorViewModel.self, from: jsonData)
            } catch {}
            
            guard let errorsText = errorViewModel?.errors?.flatMap({$0.message}).joined(separator: "\n") else {
                return completion(.failure(reason: nil))
            }
            
            print("API ERROR text \(errorsText)")
            completion(.failure(reason: errorsText))
        }
    }
}
