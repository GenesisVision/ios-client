//
//  WalletDepositViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

final class WalletDepositViewModel {
    // MARK: - Variables
    var title: String = "Deposit"

    private var router: WalletDepositRouter!
    
    private var address: String = ""
    private var qrImage: UIImage?
    
    // MARK: - Init
    init(withRouter router: WalletDepositRouter) {
        self.router = router
        
        setup()
    }
    
    // MARK: - Public methods
    func getAddress() -> String {
        return address
    }
    
    func getQRImage() -> UIImage {
        return qrImage ?? UIImage.placeholder
    }
    
    // MARK: - Navigation
    func copy(completion: @escaping CompletionBlock) {
        UIPasteboard.general.string = address
        completion(.success)
    }
    
    // MARK: - Private methods
    private func setup() {
        //get address
        getAddress { [weak self] (address) in
            guard let address = address,
                var qrCode = QRCode(address)
                else { return }
            
            self?.address = address
            qrCode.size = CGSize(width: 300, height: 300)
            qrCode.color = CIColor(cgColor: UIColor.Font.black.cgColor)
            qrCode.backgroundColor = CIColor(cgColor: UIColor.Background.main.cgColor)
            self?.qrImage = qrCode.image
        }
    }
    
    private func getAddress(completion: (_ address: String?) -> Void) {
        var address: String?
        address = "0xad01944aeb8aa224a0d0ed7dd5c220f8fl96ed62"
        //get from api
        
        completion(address)
    }
    
}

