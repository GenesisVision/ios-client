//
//  CreateProgramSecondViewController.swift
//  genesisvision-ios
//
//  Created by George on 10/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreateProgramSecondViewController: BaseViewControllerWithTableView {
    // MARK: - View Model
    var viewModel: CreateProgramSecondViewModel!
    
    // MARK: - Outlets
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    
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
//        navigationItem.setTitle(title: viewModel.title, subtitle: getFullVersion())
        
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
    
    private func selectBrokerServer() {
//        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
//        alert.view.tintColor = UIColor.primary
//
//        var selectedIndexRow = viewModel.selectedBrokerServerIndex
//        let values = viewModel.brokerServerValues()
        
//        let pickerViewValues: [[String]] = [values.map { $0 }]
//        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndexRow)
//
//        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
//            selectedIndexRow = index.row
//            self?.viewModel.updateTradeServerIndex(selectedIndexRow)
//            UIView.setAnimationsEnabled(false)
//            let indexPath = IndexPath(row: 2, section: 0)
//            self?.tableView.reloadRows(at: [indexPath], with: .none)
//            UIView.setAnimationsEnabled(true)
//        }
//
//        alert.addAction(title: "Cancel", style: .cancel)
//
//        alert.show()
    }
    
    private func selectLeverage() {
//        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
//        alert.view.tintColor = UIColor.primary
        
//        var selectedIndexRow = viewModel.selectedBrokerTradeServerLeverageIndex
//        let values = viewModel.brokerServerLeverageValues()
        
//        let pickerViewValues: [[String]] = [values.map { "\($0)" }]
//        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndexRow)
//
//        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
//            selectedIndexRow = index.row
//            self?.viewModel.selectedBrokerTradeServerLeverageIndex = selectedIndexRow
//            UIView.setAnimationsEnabled(false)
//            let indexPath = IndexPath(row: 3, section: 0)
//            self?.tableView.reloadRows(at: [indexPath], with: .none)
//            UIView.setAnimationsEnabled(true)
//        }
//
//        alert.addAction(title: "Cancel", style: .cancel)
//
//        alert.show()
    }
    
    private func selectPeriodLength() {
//        let alert = UIAlertController(style: .actionSheet, title: nil, message: nil)
//        alert.view.tintColor = UIColor.primary
        
//        var selectedIndexRow = viewModel.selectedPeriodLenghtIndex
//        let values = viewModel.periodLenthValues
        
//        let pickerViewValues: [[String]] = [values.map { "\($0)" }]
//        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndexRow)
//
//        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
//            selectedIndexRow = index.row
//            self?.viewModel.selectedPeriodLenghtIndex = selectedIndexRow
//            UIView.setAnimationsEnabled(false)
//            let indexPath = IndexPath(row: 4, section: 0)
//            self?.tableView.reloadRows(at: [indexPath], with: .none)
//            UIView.setAnimationsEnabled(true)
//        }
//
//        alert.addAction(title: "Cancel", style: .cancel)
//
//        alert.show()
    }
    
    // MARK: - Actions
    @IBAction func nextButtonAction(_ sender: UIButton) {
//        viewModel.nextStep()
    }
}

extension CreateProgramSecondViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if IQKeyboardManager.sharedManager().canGoNext {
            IQKeyboardManager.sharedManager().goNext()
        } else {
            IQKeyboardManager.sharedManager().resignFirstResponder()
        }
        
        return false
    }
}

extension CreateProgramSecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        guard let fieldType = viewModel.didSelect(indexPath) else {
//            return
//        }
//
//        switch fieldType {
//        case .brokerServer:
//            selectBrokerServer()
//        case .leverage:
//            guard viewModel.selectedBrokerTradeServer != nil else {
//                showAlertWithTitle(title: "", message: "Please first select the Broker Server", actionTitle: String.Alerts.okButtonText, cancelTitle: nil, handler: nil, cancelHandler: nil)
//                return
//            }
//
//            selectLeverage()
//        case .periodLength:
//            selectPeriodLength()
//        default:
//            break
//        }
    }
}
