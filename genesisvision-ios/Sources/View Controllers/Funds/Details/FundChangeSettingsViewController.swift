//
//  ChangeFundFeeViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 12.08.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

class FundChangeSettingsViewController: BaseViewController {
    
    @IBOutlet weak var entryFeeTextField: DesignableUITextField! {
        didSet {
            entryFeeTextField.addTarget(self, action: #selector(entryFeeFieldDidChange), for: .editingChanged)
        }
    }
    @IBOutlet weak var exitFeeTextField: DesignableUITextField! {
        didSet {
            exitFeeTextField.addTarget(self, action: #selector(exitFeeFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var entryFeeSubtitleLabel: SubtitleLabel! {
        didSet {
            entryFeeSubtitleLabel.text = "A entry fee is a fee charged to investors upon their investment to a GV Fund. The maximum entry fee is 10 %"
        }
    }
    @IBOutlet weak var exitFeeSubtitleLabel: SubtitleLabel! {
        didSet {
            exitFeeSubtitleLabel.text = "An exit fee is a fee charged to investors when they redeem shares from a GV Fund. The maximum exit fee is 10 %"
        }
    }
    
    var viewModel: ChangeFundSettingsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Change settings"
        
        viewModel?.fetch(completion: { (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.exitFeeTextField.text = self.viewModel?.currentExitFee?.toString()
                    self.entryFeeTextField.text = self.viewModel?.currentEntryFee?.toString()
                }
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        })
    }
    
    @objc private func entryFeeFieldDidChange() {
        guard let entryFeeText = entryFeeTextField.text, !entryFeeText.isEmpty, let value = Double(entryFeeText) else {
            entryFeeTextField.text = ""
            return }
        
        if value > 10 {
            entryFeeTextField.text = "10"
        }
        viewModel?.newEntryFee = value
    }
    
    @objc private func exitFeeFieldDidChange() {
        guard let exitFeeText = exitFeeTextField.text, !exitFeeText.isEmpty, let value = Double(exitFeeText)
            else {
            exitFeeTextField.text = ""
            return }
        
        if value > 10 {
            exitFeeTextField.text = "10"
        }
        viewModel?.newExitFee = value
    }
    
    @IBAction func updateButtonAction(_ sender: Any) {
        guard let _ = viewModel?.assetId else { return }

        viewModel?.updateAssetFees(completion: { (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.showSuccessHUD()
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(errorType: _):
                DispatchQueue.main.async {
                    self.showErrorHUD()
                }
            }
        })
    }
}


final class ChangeFundSettingsViewModel {
    
    var assetId: String?
    var currentEntryFee: Double?
    var currentExitFee: Double?
    var newEntryFee: Double?
    var newExitFee: Double?
    var fundDetails: FundDetailsFull?
    
    func fetch(completion: @escaping CompletionBlock) {
        guard let assetId = assetId else { return }
        FundsDataProvider.get(assetId, currencyType: .usdt, completion: { [weak self] (fundDetails) in
            if let fundDetails = fundDetails {
                self?.fundDetails = fundDetails
                self?.currentExitFee = fundDetails.exitFeeCurrent
                self?.currentEntryFee = fundDetails.entryFeeCurrent
            }
            completion(.success)
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(errorType: let errorType):
                completion(.failure(errorType: errorType))
            }
        }
    }
    
    func updateAssetFees(completion: @escaping CompletionBlock) {
        guard let assetId = assetId else { return }
        
        let model = ProgramUpdate(title: fundDetails?.publicInfo?.title, _description: fundDetails?.publicInfo?._description, logo: fundDetails?.publicInfo?.logo, entryFee: newEntryFee, exitFee: newExitFee, successFee: nil, stopOutLevel: nil, investmentLimit: nil, tradesDelay: nil, _id: nil)
        
        AssetsDataProvider.updateFundAssetDetails(assetId, model: model, completion: completion)
    }
}
