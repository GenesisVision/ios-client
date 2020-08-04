//
//  TradingInfoContentView.swift
//  genesisvision-ios
//
//  Created by George on 23.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

protocol TradingInfoViewProtocol: DefaultHeaderProtocol {
    func didTapMainAction(_ assetType: AssetType)
}

class TradingInfoContentView: UIStackView {
    // MARK: - Variables
    weak var delegate: TradingInfoViewProtocol?
    
    var assetType: AssetType = .program
    var assetId: String?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: LargeTitleLabel!
    @IBOutlet weak var manageButton: UIButton! {
        didSet {
            manageButton.setTitle("Manage", for: .normal)
            manageButton.isHidden = true
            manageButton.tintColor = UIColor.primary
        }
    }
    
    @IBOutlet weak var topStackView: UIStackView! {
        didSet {
            topStackView.isHidden = true
        }
    }
    @IBOutlet weak var bottomStackView: UIStackView! {
           didSet {
               bottomStackView.isHidden = true
           }
       }
    
    @IBOutlet weak var disclaimerLabel: SubtitleLabel! {
        didSet {
            disclaimerLabel.isHidden = true
            disclaimerLabel.setLineSpacing(lineSpacing: 3.0)
            disclaimerLabel.textAlignment = .center
        }
    }
    @IBOutlet weak var mainButton: ActionButton! {
        didSet {
            mainButton.isHidden = true
        }
    }
    
    // MARK: - Actions
    @IBAction func mainButtonAction(_ sender: UIButton) {
        delegate?.didTapMainAction(assetType)
    }
    
    @IBAction func manageButtonAction(_ sender: UIButton) {
        delegate?.didTapManageAction(assetType)
    }
}

extension TradingInfoContentView {
    func configure(program asset: ProgramDetailsFull?, assetId: String?, delegate: TradingInfoViewProtocol?) {
        self.delegate = delegate
        
        if let assetId = assetId {
            self.assetId = assetId
        }
        
        titleLabel.text = assetType.rawValue

        disclaimerLabel.text = "Make your account an investment program so that you can attract investors to manage their funds. \nEarn on commissions."
        mainButton.setTitle("Create program", for: .normal)
        mainButton.isHidden = asset != nil
        guard let asset = asset else {
            disclaimerLabel.isHidden = false
            return
        }
        manageButton.isHidden = false
        
        topStackView.removeAllArrangedSubviews()
        
        if let value = asset.availableInvestmentBase {
            addToStackView(topStackView, value: "\(value)%", header: "av. to invest")
        }
        if let value = asset.stopOutLevelCurrent {
            addToStackView(topStackView, value: "\(value)%", header: "stop out")
        }
        
        bottomStackView.removeAllArrangedSubviews()
        if let value = asset.managementFeeCurrent {
            addToStackView(bottomStackView, value: "\(value)%", header: "management fee")
        }
        if let value = asset.successFeeCurrent {
            addToStackView(bottomStackView, value: "\(value)%", header: "success fee")
        }
    }
    func configure(fund asset: FundDetailsFull?, assetId: String?, delegate: TradingInfoViewProtocol?) {
        self.delegate = delegate
        if let assetId = assetId {
            self.assetId = assetId
        }
        
        titleLabel.text = assetType.rawValue
        
        mainButton.isHidden = asset != nil
        guard let asset = asset else {
            disclaimerLabel.isHidden = false
            return
        }
        manageButton.isHidden = false
        
        topStackView.removeAllArrangedSubviews()
        
        if let value = asset.entryFeeCurrent {
            addToStackView(topStackView, value: "\(value)%", header: "management fee")
        }
        if let value = asset.exitFeeCurrent {
            addToStackView(topStackView, value: "\(value)%", header: "exit fee")
        }
    }
    func configure(follow asset: FollowDetailsFull?, assetId: String?, delegate: TradingInfoViewProtocol?) {
        self.delegate = delegate
        if let assetId = assetId {
            self.assetId = assetId
        }
        
        titleLabel.text = assetType.rawValue
        
        disclaimerLabel.text = "Make your account a signal provider so that other users can copy your trades and bring you an extra income."
        mainButton.setTitle("Make a signal provider", for: .normal)
        mainButton.isHidden = asset != nil
        guard let asset = asset else {
            mainButton.isHidden = true
            disclaimerLabel.isHidden = false
            return
        }
        manageButton.isHidden = false
        
        topStackView.removeAllArrangedSubviews()
        
        if let value = asset.signalSettings?.signalSuccessFee {
            addToStackView(topStackView, value: "\(value)%", header: "success fee")
        }
        if let value = asset.signalSettings?.signalVolumeFee {
            addToStackView(topStackView, value: "\(value)%", header: "volume fee")
        }
    }
    
    func addToStackView(_ stackView: UIStackView, value: String, header: String) {
        stackView.isHidden = false
        
        let sibtitleLabel = SubtitleLabel()
        sibtitleLabel.text = header
        sibtitleLabel.textAlignment = .left
        
        let titleLabel = TitleLabel()
        titleLabel.text = value
        titleLabel.textAlignment = .left
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, sibtitleLabel])
        vStack.axis = .vertical
        vStack.spacing = 8.0
        vStack.alignment = .leading
        vStack.distribution = .fillProportionally

        stackView.addArrangedSubview(vStack)
    }
}
