//
//  SocialPostReportViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 24.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit
import RadioGroup

class SocialPostReportViewController: BaseViewController {
    
    var viewModel: SocialPostReportViewModel!
    
//    private let fieldsView: UIStackView = {
//        let view = UIStackView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .clear
//        view.spacing = 10
//        view.distribution = .fillEqually
//        view.axis = .vertical
//        return view
//    }()
    
    private var radioGroup = RadioGroup()
    
    private let topLabel: SubtitleLabel = {
        let label = SubtitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getFont(.regular, size: 14.0)
        label.text = "Please select a reason"
        label.textAlignment = .left
        return label
    }()
    
    private let reportButton: ActionButton = {
        let button = ActionButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Report", for: .normal)
        button.setEnabled(false)
        return button
    }()
    
    private let problemTextfield: DesignableUITextField = {
        let textfield = DesignableUITextField()
        textfield.placeholder = "Describe the problem in more detail"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.setBottomLine()
        return textfield
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
        view.addSubview(reportButton)
        view.addSubview(topLabel)
        view.addSubview(problemTextfield)
        
        topLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10))
        topLabel.anchorSize(size: CGSize(width: 0, height: 50))
        
        radioGroup = RadioGroup(titles: reportReasons)
        radioGroup.translatesAutoresizingMaskIntoConstraints = false
        radioGroup.selectedColor = UIColor.Common.primary
        radioGroup.tintColor = UIColor.Cell.subtitle
        radioGroup.itemSpacing = 10
        radioGroup.spacing = 12
        radioGroup.selectedTintColor = UIColor.Common.primary
        radioGroup.titleFont = UIFont.getFont(.medium, size: 15.0)
        radioGroup.addTarget(self, action: #selector(optionSelected), for: .valueChanged)
        
        view.addSubview(radioGroup)
        
        radioGroup.anchor(top: topLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        radioGroup.anchorSize(size: CGSize(width: 0, height: 300))
        
        
        problemTextfield.anchor(top: radioGroup.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))
        
        
        reportButton.addTarget(self, action: #selector(reportButtonAction), for: .touchUpInside)
        
        reportButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20), size: CGSize(width: 0, height: 50))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    @objc private func reportButtonAction() {
        viewModel.problemText = problemTextfield.text ?? ""
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
    
    @objc private func optionSelected() {
        checkActionButton()
    }
    
    private func checkActionButton() {
        guard let reason = reportReasons[safe: radioGroup.selectedIndex] else {
            reportButton.setEnabled(false)
            return }
        reportButton.setEnabled(radioGroup.selectedIndex >= 0)
        viewModel.reasonText = reason
    }
}


final class SocialPostReportViewModel {
    
    private let postId: String
    
    var reasonText: String = ""
    var problemText: String = ""
    
    init(postId: UUID) {
        self.postId = postId.uuidString
    }
    
    
    func report(completion: @escaping CompletionBlock) {
        guard !reasonText.isEmpty else { return completion(.failure(errorType: .apiError(message: ""))) }
        SocialDataProvider.report(on: postId, reason: reasonText, text: problemText, completion: completion)
    }
}
