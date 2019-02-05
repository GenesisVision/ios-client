//
//  ProfitViewController.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

class ProfitViewController: BaseViewController {
    // MARK: - View Model
    var viewModel: ProfitViewModel!
    
    var vc: UIViewController!
    private var bottomAssetsView: UIView?
    
    // MARK: - Outlets
    @IBOutlet weak var amountTitleLabel: SubtitleLabel!
    @IBOutlet weak var amountValueLabel: TitleLabel!
    @IBOutlet weak var amountCurrencyLabel: SubtitleLabel!
    @IBOutlet weak var changeTitleLabel: SubtitleLabel!
    @IBOutlet weak var changePercentLabel: TitleLabel! {
        didSet {
            changePercentLabel.textColor = UIColor.Cell.greenTitle
            changePercentLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    @IBOutlet weak var changeValueLabel: TitleLabel!
    @IBOutlet weak var changeCurrencyLabel: SubtitleLabel!
    
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var tradersFilterButton: UIButton!
    @IBOutlet weak var assetsFilterButton: UIButton!
    
    @IBOutlet weak var chartView: ChartView! {
        didSet {
            chartView.backgroundColor = UIColor.BaseView.bg
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
    
    @IBOutlet weak var chartViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filtersViewHeightConstraint: NSLayoutConstraint!
    
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
                chartView.setup(lineChartData: lineChartData, barChartData: barChartData, dateRangeModel: dateRangeModel)
            }
            
            amountTitleLabel.text = "Amount"
            if let value = dashboardChartValue.value {
                amountValueLabel.text = value.rounded(withType: .gvt).toString() + " " + Constants.gvtString
            }
            if let valueCurrency = dashboardChartValue.valueCurrency {
                amountCurrencyLabel.text = valueCurrency.toString() + " \(getSelectedCurrency())"
            }
            
            changeTitleLabel.text = "Change"
            if let changePercent = dashboardChartValue.changePercent {
                changePercentLabel.text = changePercent.toString() + "%"
            }
            if let changeValue = dashboardChartValue.changeValue {
                changeValueLabel.text = changeValue.rounded(withType: .gvt).toString() + " " + Constants.gvtString
            }
            if let changeValueCurrency = dashboardChartValue.changeValueCurrency {
                changeCurrencyLabel.text = changeValueCurrency.toString() + " \(getSelectedCurrency())"
            }
        }
    }
    
    private func setupSelectedChartAssetsBottomSheetView() {
        bottomSheetController.bottomSheetControllerProtocol = self
        bottomSheetController.addNavigationBar("Assets")
        
        bottomSheetController.addTableView(isScrollEnabledInSheet: true) { [weak self] tableView in
            tableView.registerNibs(for: viewModel.cellModelsForRegistration)
            tableView.delegate = self?.viewModel.selectedChartAssetsDelegateManager
            tableView.dataSource = self?.viewModel.selectedChartAssetsDelegateManager
        }
    }
    
    private func configureConstraints(containerView: UIView, view: UIView) {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 10.0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func selectBar(_ entry: ChartDataEntry) {
        showBottomAssetsView()
    }
    
    @objc private func hideBottomAssetsView() {
        guard bottomAssetsView != nil else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomAssetsView?.alpha = 0.0
        }) { (result) in
            self.bottomAssetsView?.removeFromSuperview()
            self.bottomAssetsView = nil
        }
    }
    
    private func showBottomAssetsView() {
        
    }
    
    // MARK: - Actions
    @IBAction func tradersFilterButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func assetsFilterButtonAction(_ sender: UIButton) {
        
    }
}


extension ProfitViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        circleView.center = CGPoint(x: highlight.xPx, y: highlight.yPx)
        
        selectBar(entry)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        hideBottomAssetsView()
    }
}

extension ProfitViewController: BottomSheetControllerProtocol {
    func didHide() {
        chartView.highlightValues([])
    }
}
