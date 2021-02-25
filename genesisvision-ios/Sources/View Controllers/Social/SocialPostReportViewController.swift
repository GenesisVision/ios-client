//
//  SocialPostReportViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 24.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

class SocialPostReportViewController: BaseViewController {
    
    var viewModel: SocialPostReportViewModel!
    
    private let fieldsView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.spacing = 10
        view.distribution = .fillEqually
        view.axis = .vertical
        return view
    }()
    
    private let reportButton: ActionButton = {
        let button = ActionButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Report", for: .normal)
        return button
    }()
    
    private let reportReasons: [String] = ["Spam", "Adult content", "Misleading information", "Fraud", "Non-original content", "False news", "Hate speech", "Terrorism"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        title = "Report"
        view.addSubview(fieldsView)
        view.addSubview(reportButton)
        
        fieldsView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10))
        fieldsView.anchorSize(size: CGSize(width: 0, height: 300))
        
        reportButton.addTarget(self, action: #selector(reportButtonAction), for: .touchUpInside)
        
        reportButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20), size: CGSize(width: 0, height: 50))
        
        reportReasons.forEach { (reason) in
            let button = CustomRadioButton()
            fieldsView.addArrangedSubview(button)
            button.configure(delegate: self, tag: reason, labelText: reason, firstColor: nil, secondColor: nil, animatable: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    @objc private func reportButtonAction() {
        showProgressHUD()
        viewModel.report { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }

}

extension SocialPostReportViewController: CustomRadioButtonDelegate {
    func pressed(state: CustomRadioButtonState, tag: String) {
        viewModel.reasonText = reportReasons.first(where: {$0 == tag }) ?? ""
    }
}


final class SocialPostReportViewModel {
    
    private let postId: String
    
    var reasonText: String = ""
    var text: String = ""
    
    init(postId: UUID) {
        self.postId = postId.uuidString
    }
    
    
    func report(completion: @escaping CompletionBlock) {
        guard !reasonText.isEmpty else { return completion(.failure(errorType: .apiError(message: ""))) }
        SocialDataProvider.report(on: postId, reason: reasonText, text: text, completion: completion)
    }
}
