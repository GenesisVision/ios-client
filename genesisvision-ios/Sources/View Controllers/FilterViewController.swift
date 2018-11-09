//
//  FilterViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FilterViewController: BaseViewControllerWithTableView {

    // MARK: - View Model
    var viewModel: FilterViewModel!
    
    // MARK: - Variables
    private var resetBarButtonItem: UIBarButtonItem?
    private var levelsFilterView: LevelsFilterView!
    
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
        navigationItem.title = viewModel.title
        
        levelsFilterView = LevelsFilterView.viewFromNib()
        
        showInfiniteIndicator(value: false)
        
        resetBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(resetButtonAction(_:)))
        resetBarButtonItem?.tintColor = UIColor.Button.red
        navigationItem.rightBarButtonItem = resetBarButtonItem

    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.contentInset.bottom = applyButton.frame.height + 20.0 + 20.0
        
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
        if let sortingManager = viewModel.sortingDelegateManager.sortingManager {
            sortingManager.highToLowValue = !sortingManager.highToLowValue
        }
        
        bottomSheetController.dismiss()
    }
    
    private func showCurrency() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.addNavigationBar("Currency")
        bottomSheetController.initializeHeight = 380
        
        bottomSheetController.present()
    }
    
    private func showLevels() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.addNavigationBar("Levels")
        bottomSheetController.initializeHeight = 270
        bottomSheetController.addContentsView(levelsFilterView)
        bottomSheetController.bottomSheetControllerProtocol = levelsFilterView
        levelsFilterView.delegate = self
        bottomSheetController.present()
    }
    
    private func showSort() {
        guard let sortingManager = viewModel.sortingDelegateManager.sortingManager else { return }
        
        bottomSheetController = BottomSheetController()
        let normalImage = #imageLiteral(resourceName: "img_profit_filter_icon")
        let selectedImage = #imageLiteral(resourceName: "img_profit_filter_desc_icon")
        
        bottomSheetController.initializeHeight = 380
        bottomSheetController.addNavigationBar("Sort by", buttonTitle: "High to Low", buttonSelectedTitle: "Low to High", normalImage: normalImage, selectedImage: selectedImage, buttonAction: #selector(highToLowButtonAction), buttonTarget: self, buttonSelected: !sortingManager.highToLowValue)
        
        bottomSheetController.addTableView { [weak self] tableView in
            if let sortingDelegateManager = self?.viewModel.sortingDelegateManager {
                tableView.registerNibs(for: sortingDelegateManager.cellModelsForRegistration)
                tableView.delegate = sortingDelegateManager
                tableView.dataSource = sortingDelegateManager
            }
            
            tableView.separatorStyle = .none
        }
        
        viewModel.sortingDelegateManager.tableViewProtocol = self
        bottomSheetController.present()
    }
    
    private func showDateRange() {
        dateRangeButtonAction()
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

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {

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
        case .dateRange:
            showDateRange()
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

extension FilterViewController: SortingDelegate {
    func didSelectSorting() {
        bottomSheetController.dismiss()
    }
}

extension FilterViewController: LevelsFilterViewProtocol {
    func applyButtonDidPress(with levels: [Int]) {
        bottomSheetController.dismiss()
    }
}