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
    @IBOutlet weak var balanceTitleLabel: UILabel! {
        didSet {
            balanceTitleLabel.textColor = UIColor.Cell.subtitle
            balanceTitleLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var balanceValueLabel: UILabel! {
        didSet {
            balanceValueLabel.textColor = UIColor.Cell.title
            balanceValueLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var balanceCurrencyLabel: UILabel! {
        didSet {
            balanceCurrencyLabel.textColor = UIColor.Cell.subtitle
            balanceCurrencyLabel.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var changeTitleLabel: UILabel! {
        didSet {
            changeTitleLabel.textColor = UIColor.Cell.subtitle
            changeTitleLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var changePercentLabel: UILabel! {
        didSet {
            changePercentLabel.textColor = UIColor.Cell.greenTitle
            changePercentLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var changeValueLabel: UILabel! {
        didSet {
            changeValueLabel.textColor = UIColor.Cell.title
            changeValueLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var changeCurrencyLabel: UILabel! {
        didSet {
            changeCurrencyLabel.textColor = UIColor.Cell.subtitle
            changeCurrencyLabel.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var inRequestsStackView: UIStackView!
    
    @IBOutlet weak var inRequestsButton: UIButton!
    @IBOutlet weak var inRequestsTitleLabel: UILabel! {
        didSet {
            inRequestsTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    @IBOutlet weak var inRequestsValueLabel: UILabel! {
        didSet {
            inRequestsValueLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var inRequestsCurrencyLabel: UILabel! {
        didSet {
            inRequestsCurrencyLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
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

        
        let lineChartData: [TradeChart] = [TradeChart(date: Date(), profit: 31.0),
                                           TradeChart(date: Date().addDays(1), profit: 24.0),
                                           TradeChart(date: Date().addDays(2), profit: 23.0),
                                           TradeChart(date: Date().addDays(3), profit: 16.0),
                                           TradeChart(date: Date().addDays(4), profit: 20.0),
                                           TradeChart(date: Date().addDays(5), profit: 35.0)]
        
        let barChartData: [TradeChart] = [TradeChart(date: Date(), profit: 51.0),
                                          TradeChart(date: Date().addDays(1), profit: 14.0),
                                          TradeChart(date: Date().addDays(2), profit: 13.0),
                                          TradeChart(date: Date().addDays(3), profit: 26.0),
                                          TradeChart(date: Date().addDays(4), profit: 50.0),
                                          TradeChart(date: Date().addDays(5), profit: 15.0)]
        
        chartView.setup(chartType: .detail, lineChartData: lineChartData, barChartData: barChartData, name: nil, currencyValue: nil, chartDurationType: nil)
        
        chartView.addSubview(circleView)
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
    
    private func selectBar(_ entry: ChartDataEntry) {
        let date = Date(timeIntervalSince1970: entry.x)
        let dateString = date.dateAndTimeFormatString
        print(dateString)
        
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
        
        selectBar(entry)
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
