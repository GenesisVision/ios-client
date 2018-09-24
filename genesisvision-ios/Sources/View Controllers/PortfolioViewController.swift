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
    
    @IBOutlet weak var balanceTitleLabel: UILabel! {
        didSet {
            balanceTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    @IBOutlet weak var balanceValueLabel: UILabel! {
        didSet {
            balanceValueLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var balanceCurrencyLabel: UILabel! {
        didSet {
            balanceCurrencyLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet weak var changeTitleLabel: UILabel! {
        didSet {
            changeTitleLabel.textColor = UIColor.Cell.subtitle
        }
    }
    @IBOutlet weak var changePercentLabel: UILabel! {
        didSet {
            changePercentLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    @IBOutlet weak var changeValueLabel: UILabel! {
        didSet {
            changeValueLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var changeCurrencyLabel: UILabel! {
        didSet {
            changeCurrencyLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
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
    
    @IBOutlet weak var chartViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inRequeststViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

    // MARK: - Public methods
    func updateViewConstraints(_ yOffset: CGFloat) {
        
    }
    // MARK: - Private methods
    func configureConstraints(containerView: UIView, view: UIView, initializeHeight: CGFloat) {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.transform = CGAffineTransform.identity
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: initializeHeight).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func selectBar(_ entry: ChartDataEntry) {
        let date = Date(timeIntervalSince1970: entry.x)
        let dateString = date.dateAndTimeFormatString
        print(dateString)
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.addNavigationBar("Assets")
        
        
        
        bottomSheetController.addTableView(isScrollEnabledInSheet: false) { [weak self] tableView in
            tableView.registerNibs(for: viewModel.cellModelsForRegistration)
            tableView.delegate = self?.viewModel.selectedChartAssetsDelegateManager
            tableView.dataSource = self?.viewModel.selectedChartAssetsDelegateManager
        }
        
        let window = UIApplication.shared.windows[0] as UIWindow
        if let vc = window.rootViewController {
            let containerView = bottomSheetController.containerView
            containerView.transform = CGAffineTransform.identity
            containerView.clipsToBounds = true
            
            vc.view.addSubview(containerView)
            vc.view.bringSubview(toFront: containerView)
            configureConstraints(containerView: containerView, view: vc.view, initializeHeight: bottomSheetController.initializeHeight)
            containerView.layoutIfNeeded()
            bottomSheetController.viewDidLayoutSubviews()
        }
    }

}

extension PortfolioViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        selectBar(entry)
    }
}
