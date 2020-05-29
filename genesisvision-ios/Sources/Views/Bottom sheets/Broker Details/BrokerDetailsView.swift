//
//  BrokerDetailsView.swift
//  genesisvision-ios
//
//  Created by George on 06.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

protocol BrokerDetailsViewProtocol: class {
    func showTermsButtonDidPress(_ url: String?)
    func viewHeight(_ height: CGFloat)
    func closeButtonDidPress()
}

class BrokerDetailsView: UIView {
    // MARK: - Variables
    weak var delegate: BrokerDetailsViewProtocol?
    
    var model: Broker?
    
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
    func configure(_ model: Broker?, delegate: BrokerDetailsViewProtocol?) {
        self.delegate = delegate
        self.model = model
        
        if let title = self.model?.name {
            topStackView.titleLabel.text = title
        }
        
        if let about = self.model?._description {
            stackView.aboutStackView.subtitleLabel.text = "About"
            stackView.aboutStackView.titleLabel.text = about
        }
        if let accountTypes = self.model?.accountTypes?.first?.currencies?.joined(separator: ", ") {
            stackView.accountTypeStackView.subtitleLabel.text = "Account type"
            stackView.accountTypeStackView.titleLabel.text = accountTypes
        }
        if let type = self.model?.accountTypes?.first?.type?.rawValue {
            stackView.tradingPlatformStackView.subtitleLabel.text = "Trading platform"
            stackView.tradingPlatformStackView.titleLabel.text = type
        }
        
        stackView.termsStackView.subtitleLabel.text = "Terms"
        stackView.termsStackView.titleLabel.text = "Read terms"
        
        if self.model?.terms != nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showTermsButtonAction))
            tapGesture.numberOfTapsRequired = 1
            stackView.termsStackView.titleLabel.addGestureRecognizer(tapGesture)
            stackView.termsStackView.titleLabel.textColor = UIColor.primary
        }
        
        if let leverageMin = self.model?.leverageMin, let leverageMax = self.model?.leverageMax {
            stackView.leverageStackView.subtitleLabel.text = "Leverage"
            stackView.leverageStackView.titleLabel.text = leverageMin == leverageMax ? "1:\(leverageMin)" : "1:\(leverageMin) - 1:\(leverageMax)"
        }
        if let assets = self.model?.assets {
            stackView.assetsStackView.subtitleLabel.text = "Assets"
            stackView.assetsStackView.titleLabel.text = assets
        }
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
