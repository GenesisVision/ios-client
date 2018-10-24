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
    
    private var bottomAssetsView: UIView?
    
    // MARK: - Outlets
    @IBOutlet weak var amountTitleLabel: SubtitleLabel!
    @IBOutlet weak var amountValueLabel: TitleLabel!
    @IBOutlet weak var amountCurrencyLabel: MediumLabel!
    
    @IBOutlet weak var changeTitleLabel: SubtitleLabel!
    @IBOutlet weak var changePercentLabel: TitleLabel! {
        didSet {
            changePercentLabel.textColor = UIColor.Cell.greenTitle
            changePercentLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    @IBOutlet weak var changeValueLabel: TitleLabel!
    @IBOutlet weak var changeCurrencyLabel: MediumLabel!
    
    @IBOutlet weak var inRequestsStackView: UIStackView!
    @IBOutlet weak var inRequestsButton: UIButton!
    @IBOutlet weak var inRequestsTitleLabel: SubtitleLabel!
    @IBOutlet weak var inRequestsValueLabel: TitleLabel!
    @IBOutlet weak var inRequestsCurrencyLabel: MediumLabel!
    
    @IBOutlet weak var chartView: ChartView! {
        didSet {
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
        }
    }
    @IBOutlet weak var inRequeststViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideBottomAssetsView()
    }

    // MARK: - Public methods
    func updateUI() {
        setupUI()
    }
    
    func updateViewConstraints(_ yOffset: CGFloat) {
        
    }
    
    func hideChart(_ value: Bool) {
        chartViewHeightConstraint.constant = value ? 0.0 : 150.0
    }
    
    // MARK: - Private methods
    private func setup() {
        
        //Selected Chart Assets Bottom Sheet View
        setupSelectedChartAssetsBottomSheetView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideBottomAssetsView))
        tapGesture.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        chartView.addSubview(circleView)
    }
    
    private func setupUI() {
        if let dashboardChartValue = viewModel.dashboardChartValue {
            if let lineChartData = dashboardChartValue.balanceChart, let barChartData = dashboardChartValue.investedProgramsInfo {
                chartView.setup(lineChartData: lineChartData, barChartData: barChartData)
            }
            
            amountTitleLabel.text = "Amount"
            if let value = dashboardChartValue.value {
                amountValueLabel.text = value.rounded(withType: .gvt).toString() + " " + Constants.gvtString
            }
            if let valueCurrency = dashboardChartValue.valueCurrency, let selectedCurrency = CurrencyType(rawValue: getSelectedCurrency()) {
                amountCurrencyLabel.text = valueCurrency.rounded(withType: selectedCurrency).toString() + " \(getSelectedCurrency())"
            }
            
            changeTitleLabel.text = "Change"
            if let changePercent = dashboardChartValue.changePercent {
                changePercentLabel.text = changePercent.rounded(toPlaces: 2).toString() + " %"
            }
            if let changeValue = dashboardChartValue.changeValue {
                changeValueLabel.text = changeValue.rounded(withType: .gvt).toString() + " " + Constants.gvtString
            }
            if let changeValueCurrency = dashboardChartValue.changeValueCurrency, let selectedCurrency = CurrencyType(rawValue: getSelectedCurrency()) {
                changeCurrencyLabel.text = changeValueCurrency.rounded(withType: selectedCurrency).toString() + " \(getSelectedCurrency())"
            }
        
            if let programRequests = viewModel.programRequests {
                inRequestsTitleLabel.text = "In Requests"
                if let totalValue = programRequests.totalValue {
                    inRequestsValueLabel.text = totalValue.rounded(withType: .gvt).toString() + " " + Constants.gvtString
                }
                
                if let totalValue = programRequests.totalValue, let rate = dashboardChartValue.rate, let selectedCurrency = CurrencyType(rawValue: getSelectedCurrency()) {
                    let inRequestsCurrency = totalValue * rate
                    inRequestsCurrencyLabel.text = inRequestsCurrency.rounded(withType: selectedCurrency).toString() + " \(getSelectedCurrency())"
                }
                
                if let requests = programRequests.requests {
                    self.inRequestsButton.isHidden = requests.count == 0
                }
            }
        }
    }
    
    private func setupSelectedChartAssetsBottomSheetView() {
        bottomSheetController.bottomSheetControllerProtocol = self
        bottomSheetController.addNavigationBar("Assets")
        bottomSheetController.lineViewIsHidden = true
        
        bottomSheetController.addTableView(isScrollEnabledInSheet: true) { [weak self] tableView in
            tableView.separatorStyle = .none
            tableView.registerNibs(for: viewModel.cellModelsForRegistration)
            
            if let selectedChartAssetsDelegateManager = self?.viewModel.selectedChartAssetsDelegateManager {
                selectedChartAssetsDelegateManager.tableView = tableView
                tableView.delegate = selectedChartAssetsDelegateManager
                tableView.dataSource = selectedChartAssetsDelegateManager
            }
        }
    }
    
    private func configureConstraints(containerView: UIView, view: UIView) {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.transform = CGAffineTransform.identity
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 10.0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func hideInRequestStackView(_ value: Bool) {
        circleView.isHidden = !value
        
        UIView.animate(withDuration: 0.3) {
            self.inRequestsButton.isHidden = value
            self.inRequestsStackView.isHidden = value
            self.view.layoutIfNeeded()
        }
    }
    
    private func selectChart(_ entry: ChartDataEntry) {
        let date = Date(timeIntervalSince1970: entry.x)
        
        if let valueChartBar = viewModel.selectChart(date) {
            if let topAssets = valueChartBar.topAssets {
                print(topAssets)
                showBottomAssetsView()
            }
            
            
        }
    }
    
    @objc private func hideBottomAssetsView() {
        guard bottomAssetsView != nil else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomAssetsView?.alpha = 0.0
        }) { (result) in
            self.bottomAssetsView?.removeFromSuperview()
            self.bottomAssetsView = nil
        }
        
        hideInRequestStackView(false)
    }
    
    private func showBottomAssetsView() {
        if self.bottomAssetsView == nil {
            hideInRequestStackView(true)
        }

        let window = UIApplication.shared.windows[0] as UIWindow
        if let vc = window.rootViewController, self.bottomAssetsView == nil {
            self.bottomAssetsView = bottomSheetController.containerView
            self.bottomAssetsView?.alpha = 0.0
        
            guard self.bottomAssetsView != nil else { return }
            vc.view.addSubview(self.bottomAssetsView!)
        
            self.bottomAssetsView?.transform = CGAffineTransform.identity
            self.bottomAssetsView?.clipsToBounds = true
        
            self.configureConstraints(containerView: self.bottomAssetsView!, view: vc.view)
            self.bottomAssetsView?.layoutIfNeeded()
            self.bottomSheetController.initializeHeight = self.bottomAssetsView?.frame.size.height ?? 300.0
            self.bottomSheetController.viewDidLayoutSubviews()
        
            UIView.animate(withDuration: 0.3) {
                self.bottomAssetsView?.alpha = 1.0
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func inRequestsButtonAction(_ sender: UISwitch) {
        viewModel.showRequests()
    }
}

extension PortfolioViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        circleView.center = CGPoint(x: highlight.xPx, y: highlight.yPx)
        
        selectChart(entry)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        hideBottomAssetsView()
    }
}

extension PortfolioViewController: BottomSheetControllerProtocol {
    func didHide() {
        hideInRequestStackView(false)
        chartView.highlightValues([])
    }
}
