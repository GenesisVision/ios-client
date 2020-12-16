//
//  KYCInfoViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 24.11.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

class KYCInfoViewController: BaseViewController {
    
    var viewModel: KYCInfoViewControllerViewModel!
    
    private let verifyButton: ActionButton = {
        let button = ActionButton()
        button.configure(with: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(verifyButtonAction(_:)), for: .touchUpInside)
        button.setTitle("Verify to remove the limit", for: .normal)
        return button
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setup()
        setupText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showProgressHUD()
        
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                self?.setupVerifyButton()
            case .failure(errorType: _):
                break
            }
        }
    }
    
    private func setupVerifyButton() {
        if viewModel.verificationStatus == .underReview {
            verifyButton.configure(with: .darkClear)
            verifyButton.setTitle("Under review", for: .normal)
            verifyButton.isUserInteractionEnabled = false
        }
    }
    
    private func setupUI() {
        view.addSubview(textView)
        view.addSubview(verifyButton)
        
        textView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 10, bottom: 150, right: 10))
        
        verifyButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20), size: CGSize(width: 0, height: 50))
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
    }
    
    private func setup() {
        title = "About KYC"
    }
    
    private func setupText() {
        
        let textAttributes = [
            NSAttributedString.Key.font: UIFont.getFont(.regular, size: 15),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        
        let paragraphTitlesAttributes = [
            NSAttributedString.Key.font: UIFont.getFont(.semibold, size: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let noteText = NSAttributedString(string: "Note KYC is an authetication mechanism required in the financial industry to help ensure companies are compliant with anti money laundering regulations.\n\n", attributes: textAttributes)
        
        let firstParagraphTitle = NSAttributedString(string: "Without KYC you can:\n\n", attributes: paragraphTitlesAttributes)
        let firstParagraphStringList = [
            "Deposit and withdraw crypto without limits", "Exchange cryptocurrencies",
            "Create crypto trading accounts",
            "Create Programs (with a maximum investment amount equivalent to $1,000) and Funds",
            "Bind your external trading account and use copy trading functionality (Follow)",
            "Invest in Programs and Funds up to $1,000 in total"
        ]
        
        let paragraphsIndent = "\n\n"
        
        let secondParagraphTitle = NSAttributedString(string: "After you pass KYC you also can:\n\n", attributes: paragraphTitlesAttributes)
        let secondParagraphStringList = [
            "Create Forex trading accounts",
            "Invest in Programs and Funds without limits",
            "Attract investments in your Programs beyond the KYC limit"
        ]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.maximumLineHeight = 22
        paragraphStyle.paragraphSpacing = 10
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]

        let paragraphsAttributes = [
            NSAttributedString.Key.font: UIFont.getFont(.regular, size: 15),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let firstParagraph = NSAttributedString(string: firstParagraphStringList.map({ "•\t\($0)" }).joined(separator: "\n"), attributes: paragraphsAttributes)
        let secondParagraph = NSAttributedString(string: secondParagraphStringList.map({ "•\t\($0)" }).joined(separator: "\n"), attributes: paragraphsAttributes)
        
        let allText = NSMutableAttributedString(attributedString: noteText)
        allText.append(firstParagraphTitle)
        allText.append(firstParagraph)
        allText.append(NSAttributedString(string: paragraphsIndent))
        allText.append(secondParagraphTitle)
        allText.append(secondParagraph)
        
        textView.attributedText = allText
    }
    
    @objc private func verifyButtonAction(_ sender: ActionButton) {
        guard viewModel.verificationStatus != .underReview ,let token = viewModel.verificationTokens.accessToken, let baseUrl = viewModel.verificationTokens.baseAddress, let flowName = viewModel.verificationTokens.flowName, let kycViewController = PlatformManager.shared.getKYCViewController(token: token, baseUrl: baseUrl, flowName: flowName) else { return }
        
        present(kycViewController, animated: true)
    }
}

final class KYCInfoViewControllerViewModel {
    
    public private(set) var verificationTokens: ExternalKycAccessToken
    public var verificationStatus: UserVerificationStatus?

    init(verificationTokens: ExternalKycAccessToken) {
        self.verificationTokens = verificationTokens
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        AuthManager.getProfile { [weak self] (viewModel) in
            if let viewModel = viewModel, let verificationstatus = viewModel.verificationStatus {
                self?.verificationStatus = verificationstatus
                completion(.success)
            }
        } completionError: { _ in
            completion(.failure(errorType: .apiError(message: "")))
        }
    }
}
