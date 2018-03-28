//
//  ProgramFilterViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import TTRangeSlider

class ProgramFilterViewController: BaseViewControllerWithTableView {

    // MARK: - View Model
    var viewModel: ProgramFilterViewModel! {
        didSet {
            viewModel.sliderDelegate = self
        }
    }
    
    // MARK: - Variables
    private var resetBarButtonItem: UIBarButtonItem?
    
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var applyButton: ActionButton!
    
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
        title = viewModel.title
        
        view.backgroundColor = UIColor.Background.main
        
        resetBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(resetButtonAction(_:)))
        resetBarButtonItem?.tintColor = UIColor.Button.red
        navigationItem.rightBarButtonItem = resetBarButtonItem
    }
    
    private func setupTableConfiguration() {
        tableView.contentInset.bottom = applyButton.frame.height + 16.0 + 16.0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibs(for: ProgramFilterViewModel.cellModelsForRegistration)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - IBAction
    @IBAction func applyButtonAction(_ sender: UIButton) {
        showProgressHUD()
        
        viewModel.apply { [weak self] (result) in
            self?.hideHUD()
            
            switch result {
            case .success:
                self?.viewModel.goToBack()
            case .failure(let reason):
                print("Error with reason: ")
                print(reason ?? "")
            }
        }
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        viewModel.reset()
        reloadData()
    }
}

extension ProgramFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.model(for: indexPath)
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
}

extension ProgramFilterViewController: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        let type: SliderType = SliderType(rawValue: sender.tag)!
        
        switch type {
        case .level:
            viewModel.updateFilter(levelMin: Int(selectedMinimum), levelMax: Int(selectedMaximum))
        case .totalProfit:
            viewModel.updateFilter(profitTotalMin: Int(selectedMinimum), profitTotalMax: Int(selectedMaximum))
        case .avgProfit:
            viewModel.updateFilter(profitAvgPercentMin: Int(selectedMinimum), profitAvgPercentMax: Int(selectedMaximum))
        }
    }
}
