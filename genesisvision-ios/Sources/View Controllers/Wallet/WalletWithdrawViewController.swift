//
//  WalletWithdrawViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import AVFoundation

class WalletWithdrawViewController: BaseViewController {
    
    // MARK: - Variables
    private var withdrawButton: UIButton?
    private var readQRCodeButton: UIButton?
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - View Model
    var viewModel: WalletWithdrawViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = viewModel.title
    }
    
    // MARK: - Private methods
    private func setup() {
        //Setup
    }
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        hideKeyboard()
        
        guard let amountText = amountTextField.text,
            let amount = amountText.doubleValue,
            let address = addressTextField.text
            else { return showErrorHUD(subtitle: "Enter withdraw amount and data, please") }
        
        showProgressHUD()
        viewModel.withdraw(with: amount, address: address) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.showSuccessHUD(completion: { (success) in
                    self?.viewModel.goToBack()
                })
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    @IBAction func readQRCodeButtonAction(_ sender: UIButton) {
        readerVC.delegate = self
        
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
}

extension WalletWithdrawViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        feedback()
        
        self.addressTextField.text = result.value
        reader.dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
}
