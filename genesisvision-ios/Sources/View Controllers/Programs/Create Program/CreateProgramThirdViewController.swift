//
//  CreateProgramThirdViewController.swift
//  genesisvision-ios
//
//  Created by George on 10/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreateProgramThirdViewController: BaseViewControllerWithTableView {
    // MARK: - View Model
    var viewModel: CreateProgramThirdViewModel!
    
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    @IBOutlet weak var createProgramButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = viewModel.title
        
        showInfiniteIndicator(value: false)
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
//        tableView.delegate = self
//        tableView.dataSource = viewModel.tableViewDataSourceAndDelegate
//        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    private func selectDateFrom() {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
        alert.view.tintColor = UIColor.primary
        
        alert.addDatePicker(mode: .dateAndTime, date: viewModel.temparyNewInvestmentRequest?.dateFrom, minimumDate: nil, maximumDate: nil) { [weak self] date in
//            self?.viewModel.update(dateFrom: date)
            UIView.setAnimationsEnabled(false)
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.reloadRows(at: [indexPath], with: .none)
            UIView.setAnimationsEnabled(true)
        }
        
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    // MARK: - Actions
    @IBAction func createProgramButtonAction(_ sender: UIButton) {
//        viewModel.createProgram(completion: { [weak self] (programID) in
//            if let programID = programID {
//                print(programID)
//                self?.viewModel.showSuccess(programId: programID)
//            }
//        }) { (result) in
//            switch result {
//            case .success:
//                break
//            case .failure(let errorType):
//                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
//            }
//        }
    }
}

extension CreateProgramThirdViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if IQKeyboardManager.sharedManager().canGoNext {
            IQKeyboardManager.sharedManager().goNext()
        } else {
            IQKeyboardManager.sharedManager().resignFirstResponder()
        }
        
        return false
    }
}

//extension CreateProgramThirdViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        guard let fieldType = viewModel.didSelect(indexPath) else {
//            return
//        }
//        
//        switch fieldType {
//        case .dateFrom:
//            selectDateFrom()
//        default:
//            break
//        }
//    }
//}
