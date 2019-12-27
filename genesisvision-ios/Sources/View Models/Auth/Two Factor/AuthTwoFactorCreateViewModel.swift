//
//  AuthTwoFactorCreateViewModel.swift
//  genesisvision-ios
//
//  Created by George on 30/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

final class AuthTwoFactorCreateViewModel {
    // MARK: - Variables
    var title: String = "Get key"
    
    var topTitleText: String = String.ViewTitles.TwoFactor.createTopTitle
    var bottomTitleText: String = String.ViewTitles.TwoFactor.createBottomTitle
    
    public private(set) var sharedKey: String! {
        didSet {
            tabmanViewModel.sharedKey = sharedKey
        }
    }
    private var qrImage: UIImage?
    
    private var tabmanViewModel: AuthTwoFactorTabmanViewModel!
    private var router: TabmanRouter!
    
    // MARK: - Init
    init(withRouter router: TabmanRouter, tabmanViewModel: AuthTwoFactorTabmanViewModel) {
        self.router = router
        self.tabmanViewModel = tabmanViewModel
    }
    
    // MARK: - Public methods
    func getQRImage() -> UIImage {
        return qrImage ?? UIImage.placeholder
    }
    
    func fetch(completion: @escaping CompletionBlock, completionError: @escaping CompletionBlock) {
        getSharedKey(completion: { [weak self] (sharedKey, authenticatorUri) in
            guard var qrCode = QRCode(authenticatorUri)
                else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.sharedKey = sharedKey
            
            qrCode.size = CGSize(width: 300, height: 300)
            qrCode.color = CIColor(cgColor: UIColor.BaseView.bg.cgColor)
            qrCode.backgroundColor = CIColor(cgColor: UIColor.Cell.title.cgColor)
            self?.qrImage = qrCode.image
            completion(.success)
            }, completionError: completionError)
    }
    
    // MARK: - Navigation
    func nextStep() {
        router.next()
    }
    
    // MARK: - Private methods
    private func getSharedKey(completion: @escaping (_ sharedKey: String, _ authenticatorUri: String) -> Void, completionError: @escaping CompletionBlock) {
        TwoFactorDataProvider.create(completion: { (viewModel) in
            guard let sharedKey = viewModel?.sharedKey, let authenticatorUri = viewModel?.authenticatorUri else { return completionError(.failure(errorType: .apiError(message: nil)))
            }
            
            completion(sharedKey, authenticatorUri)
        }, errorCompletion: completionError)
    }
}
