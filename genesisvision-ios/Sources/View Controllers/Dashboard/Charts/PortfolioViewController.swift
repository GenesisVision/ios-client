//
//  PortfolioViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class PortfolioViewController: BaseViewController {

    // MARK: - View Model
    var viewModel: PortfolioViewModel!
    
    var vc: UIViewController!
    
    private var selectedChartAssetsView: SelectedChartAssetsView? {
        return viewModel.getDashboardVC().selectedChartAssetsView
    }

    private var tapGesture: UITapGestureRecognizer?
    // MARK: - Outlets
    @IBOutlet weak var amountTitleLabel: SubtitleLabel!
    @IBOutlet weak var amountValueLabel: TitleLabel!
    @IBOutlet weak var amountCurrencyLabel: MediumLabel!
    
    @IBOutlet weak var changeTitleLabel: SubtitleLabel!
    @IBOutlet weak var changePercentLabel: TitleLabel! {
        didSet {
            changePercentLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    @IBOutlet weak var changeValueLabel: TitleLabel!
    @IBOutlet weak var changeCurrencyLabel: MediumLabel!
    
    @IBOutlet weak var inRequestsStackView: UIStackView! {
        didSet {
            inRequestsStackView.isHidden = true
        }
    }
    @IBOutlet weak var inRequestsButton: UIButton! {
        didSet {
            inRequestsButton.isHidden = true
        }
    }
    @IBOutlet weak var inRequestsTitleLabel: SubtitleLabel!
    @IBOutlet weak var inRequestsValueLabel: TitleLabel!
    @IBOutlet weak var inRequestsCurrencyLabel: MediumLabel!
    
    @IBOutlet weak var chartView: ChartView! {
        didSet {
            chartView.backgroundColor = UIColor.BaseView.bg
            chartView.isHidden = true
            chartView.isUserInteractionEnabled = true
            chartView.delegate = self
        }
    }
    
    let circleView: UIView = {
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.SystemSizes.chartCircleHeight, height: Constants.SystemSizes.chartCircleHeight))
        circleView.backgroundColor = UIColor.BaseView.bg
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        circleView.layer.borderColor = UIColor.Common.white.cgColor
        circleView.layer.borderWidth = 2.0
        circleView.isHidden = true
        circleView.clipsToBounds = true
        
        return circleView
    }()
    
    @IBOutlet weak var chartViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            chartViewHeightConstraint.constant = 150.0
            chartView.isHidden = true
        }
    }
    @IBOutlet weak var inRequeststViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        bottomViewType = .dateRange
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupSelectedChartAssetsBottomSheetView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deselectChart()
    }

    // MARK: - Public methods
    func updateUI() {
        setupUI()
    }
    
    func updateViewConstraints(_ yOffset: CGFloat) {
        
    }
    
    func hideChart(_ value: Bool) {
        chartViewHeightConstraint.constant = value ? 0.0 : 150.0
        chartView.isHidden = value
    }
    
    // MARK: - Private methods
    private func setup() {
        //Selected Chart Assets Bottom Sheet View
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(deselectChart))
        tapGesture?.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture!)
        
        chartView.addSubview(circleView)
    }
    
    private func setupUI() {
        if let dashboardChartValue = viewModel.dashboardChartValue {
            if let lineChartData = dashboardChartValue.balanceChart, let barChartData = dashboardChartValue.investedProgramsInfo {
                chartView.setup(chartType: .dashboard, lineChartData: lineChartData, barChartData: barChartData, dateRangeModel: dateRangeModel)
            }
            
            amountTitleLabel.text = "Value"
            if let value = dashboardChartValue.value {
                amountValueLabel.text = value.rounded(with: .gvt).toString() + " " + Constants.gvtString
            }
            if let valueCurrency = dashboardChartValue.valueCurrency, let selectedCurrency = CurrencyType(rawValue: getSelectedCurrency()) {
                amountCurrencyLabel.text = valueCurrency.rounded(with: selectedCurrency).toString() + " \(getSelectedCurrency())"
            }
            
            changeTitleLabel.text = "Change"
            if let changePercent = dashboardChartValue.changePercent {
                changePercentLabel.text = changePercent.rounded(with: .undefined).toString() + "%"
                changePercentLabel.textColor = changePercent == 0 ? UIColor.Cell.subtitle : changePercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
            }
            if let changeValue = dashboardChartValue.changeValue {
                changeValueLabel.text = changeValue.rounded(with: .gvt).toString() + " " + Constants.gvtString
            }
            if let changeValueCurrency = dashboardChartValue.changeValueCurrency, let selectedCurrency = CurrencyType(rawValue: getSelectedCurrency()) {
                changeCurrencyLabel.text = changeValueCurrency.rounded(with: selectedCurrency).toString() + " \(getSelectedCurrency())"
            }
        
            if let programRequests = viewModel.programRequests {
                inRequestsTitleLabel.text = "In Requests"
                if let totalValue = programRequests.totalValue {
                    inRequestsValueLabel.text = totalValue.rounded(with: .gvt).toString() + " " + Constants.gvtString
                }
                
                if let totalValue = programRequests.totalValue, let rate = dashboardChartValue.rate, let selectedCurrency = CurrencyType(rawValue: getSelectedCurrency()) {
                    let inRequestsCurrency = totalValue * rate
                    inRequestsCurrencyLabel.text = inRequestsCurrency.rounded(with: selectedCurrency).toString() + " \(getSelectedCurrency())"
                }
            }
        }
    }
    
    private func setupSelectedChartAssetsBottomSheetView() {
//        if let topConstraint = self.selectedChartAssetsView?.topAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 0.0) {
//            topConstraint.priority = UILayoutPriority(rawValue: 999)
//            topConstraint.isActive = true
//        }
        
        selectedChartAssetsView?.delegate = self
        selectedChartAssetsView?.alpha = 0.0
        selectedChartAssetsView?.translatesAutoresizingMaskIntoConstraints = false
        
        selectedChartAssetsView?.configure(configurationHandler: { [weak self] tableView in
            tableView.separatorStyle = .none
            tableView.registerNibs(for: viewModel.cellModelsForRegistration)
            
            if let selectedChartAssetsDelegateManager = self?.viewModel.selectedChartAssetsDelegateManager {
                selectedChartAssetsDelegateManager.tableView = tableView
                tableView.delegate = selectedChartAssetsDelegateManager
                tableView.dataSource = selectedChartAssetsDelegateManager
                tableView.reloadData()
            }
        })
    }

    func hideInRequestStackView(_ value: Bool) {
        let inRequestHeight: CGFloat = inRequestsButton.isHidden ? 0.0 : 82.0
        if let height = selectedChartAssetsView?.frame.height, height > 58, let heightConstraint = self.selectedChartAssetsView?.heightAnchor.constraint(greaterThanOrEqualToConstant: height + inRequestHeight) {
            heightConstraint.priority = UILayoutPriority(rawValue: 900)
            heightConstraint.isActive = true
        }
        
        if let topConstraint = self.selectedChartAssetsView?.topAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 0.0) {
            topConstraint.priority = UILayoutPriority(rawValue: 999)
            topConstraint.isActive = true
        }

        if let programRequests = viewModel.programRequests, let requests = programRequests.requests, requests.count == 0, inRequestsStackView.isHidden { return }
        
        self.inRequestsButton.isHidden = value
        self.inRequestsStackView.isHidden = value
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func deselectChart() {
        if let highlighted = chartView?.highlighted, highlighted.count > 0 {
            tapGesture?.isEnabled = false
            hideSelectedChartAssetsView()
            circleView.isHidden = true
            hideInRequestStackView(false)
            chartView.highlightValues([])
            updateUI()
        }
    }
    
    private func selectChart(_ entry: ChartDataEntry) {
        tapGesture?.isEnabled = true

        let date = Date(timeIntervalSince1970: entry.x)
        
        let results = viewModel.selectChart(date)
        
        if let valueChartBar = results.0, valueChartBar.topAssets != nil {
            showSelectedChartAssetsView()
        } else {
            hideSelectedChartAssetsView()
        }
        
        if let chartSimple = results.1, let selectedValue = chartSimple.value {
            if let firstChartSimple = viewModel.dashboardChartValue?.balanceChart?.first, let firstValue = firstChartSimple.value, let rate = viewModel.dashboardChartValue?.rate {
                
                let selectedValueInCurrency = selectedValue * rate
                let changeValue = selectedValue - firstValue
                let changeValueCurrency = changeValue * rate
                
                amountValueLabel.text = selectedValue.rounded(with: .gvt).toString() + " " + Constants.gvtString
                
                let currency = getSelectedCurrency()
                if let selectedCurrency = CurrencyType(rawValue: currency) {
                    amountCurrencyLabel.text = selectedValueInCurrency.rounded(with: selectedCurrency).toString() + " \(currency)"
                    
                    changeCurrencyLabel.text = changeValueCurrency.rounded(with: selectedCurrency).toString() + " \(currency)"
                }
                
                changePercentLabel.text = getChangePercent(oldValue: firstValue, newValue: selectedValue)

                changeValueLabel.text = changeValue.rounded(with: .gvt).toString() + " " + Constants.gvtString
            }
        } else {
            
        }
    }
    
    @objc private func hideSelectedChartAssetsView() {
        guard let tabBarController = viewModel.getTabBar() else { return }
        
        tabBarController.tabBar.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.selectedChartAssetsView?.alpha = 0.0
            tabBarController.tabBar.alpha = 1.0
        }
    }
    
    private func showSelectedChartAssetsView() {
        circleView.isHidden = false
        hideInRequestStackView(true)
        
        guard let tabBarController = viewModel.getTabBar() else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.selectedChartAssetsView?.alpha = 1.0
            tabBarController.tabBar.alpha = 0.0
        })  { (result) in
            tabBarController.tabBar.isHidden = true
        }
        
        if let date = self.viewModel.selectedValueChartBar?.date {
            selectedChartAssetsView?.dateLabel.text = date.dateAndTimeFormatString
        }
    }
    
    // MARK: - Actions
    @IBAction func inRequestsButtonAction(_ sender: UIButton) {
        viewModel.showRequests()
    }
}

extension PortfolioViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        circleView.isHidden = false
        circleView.center = CGPoint(x: highlight.xPx, y: highlight.yPx)
        
        selectChart(entry)
        
        self.chartView.animationEnable = false
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        hideSelectedChartAssetsView()
        circleView.isHidden = true
        hideInRequestStackView(false)
        updateUI()
    }
}

extension PortfolioViewController: BottomSheetControllerProtocol {
    func didHide() {
        deselectChart()
    }
}

extension PortfolioViewController: SelectedChartAssetsViewProtocol {
    func assetViewDidClose() {
        deselectChart()
    }
}
