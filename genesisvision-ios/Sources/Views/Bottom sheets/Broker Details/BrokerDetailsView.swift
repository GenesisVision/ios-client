//
//  BrokerDetailsView.swift
//  genesisvision-ios
//
//  Created by George on 06.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct BrokerDetailsModel {
    var title: String?
    var about: String?
    var accountType: String?
    var tradingPlatform: String?
    var terms: String?
    var leverage: String?
    var assets: String?
}

protocol BrokerDetailsViewProtocol: class {
    func showTermsButtonDidPress(_ url: String?)
    func viewHeight(_ height: CGFloat)
    func closeButtonDidPress()
}

class BrokerDetailsView: UIView {
    // MARK: - Variables
    weak var delegate: BrokerDetailsViewProtocol?
    
    var model: BrokerDetailsModel?
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topStackView: TopStackView!
    @IBOutlet weak var stackView: BrokerDetailsStackView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public Methods
    func configure(_ model: BrokerDetailsModel, delegate: BrokerDetailsViewProtocol?) {
        self.delegate = delegate
        self.model = model
        
        if let title = self.model?.title {
            topStackView.titleLabel.text = title
        }
        
        if let about = self.model?.about {
            stackView.aboutStackView.subtitleLabel.text = "About"
            stackView.aboutStackView.titleLabel.text = about
        }
        if let accountType = self.model?.accountType {
            stackView.accountTypeStackView.subtitleLabel.text = "Account type"
            stackView.accountTypeStackView.titleLabel.text = accountType
        }
        if let tradingPlatform = self.model?.tradingPlatform {
            stackView.tradingPlatformStackView.subtitleLabel.text = "Trading platform"
            stackView.tradingPlatformStackView.titleLabel.text = tradingPlatform
        }
        if let terms = self.model?.terms {
            print(terms)
            stackView.termsStackView.subtitleLabel.text = "Terms"
            stackView.termsStackView.titleLabel.text = "Read terms"
        }
        if let leverage = self.model?.leverage {
            stackView.leverageStackView.subtitleLabel.text = "Leverage"
            stackView.leverageStackView.titleLabel.text = leverage
        }
        if let assets = self.model?.assets {
            stackView.assetsStackView.subtitleLabel.text = "Assets"
            stackView.assetsStackView.titleLabel.text = assets
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showTermsButtonAction))
        tapGesture.numberOfTapsRequired = 1
        stackView.termsStackView.titleLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func showTermsButtonAction() {
        delegate?.showTermsButtonDidPress(self.model?.terms)
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        delegate?.closeButtonDidPress()
    }
}

extension BrokerDetailsView: BottomSheetControllerProtocol {
    func didHide() {
        
    }
}

class BrokerDetailsStackView: UIStackView {
    @IBOutlet weak var aboutStackView: DefaultStackView!
    @IBOutlet weak var accountTypeStackView: DefaultStackView!
    @IBOutlet weak var tradingPlatformStackView: DefaultStackView!
    @IBOutlet weak var termsStackView: TermsStackView!
    @IBOutlet weak var leverageStackView: DefaultStackView!
    @IBOutlet weak var assetsStackView: DefaultStackView!
}

class TermsStackView: DefaultStackView {
    override var titleLabel: TitleLabel! {
        didSet {
            titleLabel.textColor = UIColor.primary
            titleLabel.isUserInteractionEnabled = true
        }
    }
}
