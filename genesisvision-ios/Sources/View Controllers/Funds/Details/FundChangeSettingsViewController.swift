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
    
    @IBOutlet weak var updateButton: ActionButton! {
        didSet {
            updateButton.setEnabled(false)
        }
    }
    
    private let maxDecimalPartSize: Int = 4
    
    var viewModel: ChangeFundSettingsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let mode = viewModel?.changeSettingsMode else {
            setupEdit()
            return }
        
        mode == .create ? setupCreate() : setupEdit()
    }
    
    private func setupCreate() {
        title = "Create Fund"
        updateButton.setTitle("Next", for: .normal)
    }
    
    private func setupEdit() {
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
        guard let entryFeeText = entryFeeTextField.text, !entryFeeText.isEmpty, let value = Double(entryFeeText.replacingOccurrences(of: ",", with: ".")) else {
            checkActionButton()
            entryFeeTextField.text = ""
            return }
        
        guard let decimalPartCount = entryFeeText.decimalPartCount, decimalPartCount <= maxDecimalPartSize else {
            checkActionButton()
            entryFeeTextField.text = String(entryFeeText.dropLast())
            return
        }
        
        if value > 10 {
            entryFeeTextField.text = "10"
            viewModel?.newEntryFee = 10.0
        } else {
            viewModel?.newEntryFee = value
        }
        checkActionButton()
    }
    
    @objc private func exitFeeFieldDidChange() {
        guard let exitFeeText = exitFeeTextField.text, !exitFeeText.isEmpty, let value = Double(exitFeeText.replacingOccurrences(of: ",", with: ".")) else {
            checkActionButton()
            exitFeeTextField.text = ""
            return }
        
        guard let decimalPartCount = exitFeeText.decimalPartCount, decimalPartCount <= maxDecimalPartSize else {
            checkActionButton()
            exitFeeTextField.text = String(exitFeeText.dropLast())
            return
        }
        
        if value > 10 {
            exitFeeTextField.text = "10"
            viewModel?.newExitFee = 10.0
        } else {
            viewModel?.newExitFee = value
        }
        checkActionButton()
    }
    
    private func checkActionButton() {
        guard let entryFeeText = entryFeeTextField.text, !entryFeeText.isEmpty, let _ = Double(entryFeeText.replacingOccurrences(of: ",", with: ".")), let exitFeeText = exitFeeTextField.text, !exitFeeText.isEmpty, let _ = Double(exitFeeText.replacingOccurrences(of: ",", with: "."))  else {
            updateButton.setEnabled(false)
            return }
        updateButton.setEnabled(true)
        
    }
    
    @IBAction func updateButtonAction(_ sender: Any) {
        guard let mode = viewModel?.changeSettingsMode else {
            updateAction()
            return }
        
        mode == .create ? createAction() : updateAction()
    }
    
    private func createAction() {
        guard let viewController = FundDepositViewController.storyboardInstance(.fund) else { return }
        
        viewController.viewModel = FundDepositViewModel(viewController)
        viewController.viewModel.createViewModel = self.viewModel?.createViewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func updateAction() {
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
    
    var createViewModel: CreateNewFundViewModel?
    
    var assetId: String?
    var currentEntryFee: Double?
    var currentExitFee: Double?
    var newEntryFee: Double? {
        didSet {
            if changeSettingsMode == .create {
                createViewModel?.entryFee = newEntryFee
            }
        }
    }
    var newExitFee: Double? {
        didSet {
            if changeSettingsMode == .create {
                createViewModel?.exitFee = newExitFee
            }
        }
    }
    var fundDetails: FundDetailsFull?
    
    enum FundReallocationMode {
        case create
        case edit
    }
    
    var changeSettingsMode: FundReallocationMode = .create
    
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
        
        let model = ProgramUpdate(title: fundDetails?.publicInfo?.title, _description: fundDetails?.publicInfo?._description, logo: fundDetails?.publicInfo?.logo, entryFee: newEntryFee, exitFee: newExitFee, successFee: nil, stopOutLevel: nil, investmentLimit: nil, tradesDelay: nil, hourProcessing: nil, isProcessingRealTime: nil)
        
        AssetsDataProvider.updateFundAssetDetails(assetId, model: model, completion: completion)
    }
}
