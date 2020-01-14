//
//  FiltersViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FiltersViewController: BaseViewControllerWithTableView {

    // MARK: - View Model
    var viewModel: FilterViewModel!
    
    // MARK: - Variables
    private var resetBarButtonItem: UIBarButtonItem?
    
    @IBOutlet override var tableView: UITableView! {
        didSet {
            setupTableConfiguration()
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var applyButton: ActionButton! {
        didSet {
            applyButton.setTitle("Apply", for: .normal)
        }
    }
    
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
        
        resetBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(resetButtonAction(_:)))
        resetBarButtonItem?.tintColor = UIColor.Button.red
        navigationItem.rightBarButtonItem = resetBarButtonItem

    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        showInfiniteIndicator(value: false)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    @objc func highToLowButtonAction() {
        viewModel.changeHighToLowValue()
        
        bottomSheetController.dismiss()
    }
    
    private func showCurrency() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 300
        
        bottomSheetController.addNavigationBar("Currency")
        
        bottomSheetController.addTableView { [weak self] tableView in
            viewModel.currencyDelegateManager?.tableView = tableView
            tableView.separatorStyle = .none
            
            guard let currencyDelegateManager = self?.viewModel.currencyDelegateManager else { return }
            tableView.registerNibs(for: currencyDelegateManager.cellModelsForRegistration)
            tableView.delegate = currencyDelegateManager
            tableView.dataSource = currencyDelegateManager
        }
        
        bottomSheetController.present()
    }
    
    private func showLevels() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.addNavigationBar("Levels")
        bottomSheetController.initializeHeight = 256
        if let levelsFilterView = viewModel.levelsFilterView {
            bottomSheetController.addContentsView(levelsFilterView)
            bottomSheetController.bottomSheetControllerProtocol = levelsFilterView
        }
        bottomSheetController.present()
    }
    
    private func showSort() {
        guard let manager = viewModel.sortingDelegateManager?.manager else { return }
        
        bottomSheetController = BottomSheetController()
        let normalImage = #imageLiteral(resourceName: "img_profit_filter_icon")
        let selectedImage = #imageLiteral(resourceName: "img_profit_filter_desc_icon")
        
        bottomSheetController.initializeHeight = 350
        bottomSheetController.addNavigationBar("Sort by", buttonTitle: "High to Low", buttonSelectedTitle: "Low to High", normalImage: normalImage, selectedImage: selectedImage, buttonAction: #selector(highToLowButtonAction), buttonTarget: self, buttonSelected: !manager.highToLowValue)
        
        bottomSheetController.addTableView { [weak self] tableView in
            if let sortingDelegateManager = self?.viewModel.sortingDelegateManager {
                tableView.registerNibs(for: sortingDelegateManager.cellModelsForRegistration)
                tableView.delegate = sortingDelegateManager
                tableView.dataSource = sortingDelegateManager
            }
            
            tableView.separatorStyle = .none
        }
        
        bottomSheetController.present()
    }
    
    private func showTags() {
        guard let manager = viewModel.tagsDelegateManager else { return }
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 350
        if viewModel.filterType == .programs {
            bottomSheetController.addNavigationBar("Tags")
        } else if viewModel.filterType == .funds {
            bottomSheetController.addNavigationBar("Assets")
        }
        
        bottomSheetController.addTableView { tableView in
            tableView.registerNibs(for: manager.cellModelsForRegistration)
            tableView.delegate = manager
            tableView.dataSource = manager
            tableView.separatorStyle = .none
        }
        
        bottomSheetController.present()
    }
    
    private func showDateRange() {
        guard let dateRangeView = viewModel.dateRangeView else { return }
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.addNavigationBar("Date range")
        bottomSheetController.initializeHeight = 370
        bottomSheetController.addContentsView(dateRangeView)
        bottomSheetController.bottomSheetControllerProtocol = dateRangeView
        bottomSheetController.present()
    }
    
    // MARK: - IBAction
    @IBAction func applyButtonAction(_ sender: UIButton) {
        showProgressHUD()
        
        viewModel.apply { [weak self] (result) in
            self?.hideAll()

            switch result {
            case .success:
                self?.viewModel.goToBack()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        viewModel.reset()
        reloadData()
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.model(for: indexPath)
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let rowType = viewModel.getRowType(for: indexPath)
        switch rowType {
        case .currency:
            showCurrency()
        case .levels:
            showLevels()
        case .sort:
            showSort()
        case .tags, .assets:
            showTags()
        case .dateRange:
            showDateRange()
        case .onlyActive:
            break
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.Cell.subtitle.withAlphaComponent(0.3)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.BaseView.bg
        }
    }
}
extension FiltersViewController: FilterViewModelProtocol {
    func didFilterReloadCell(_ row: Int) {
        bottomSheetController.dismiss()
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
}
