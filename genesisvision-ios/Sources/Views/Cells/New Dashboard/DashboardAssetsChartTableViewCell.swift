//
//  DashboardAssetsChartTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 20.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

struct DashboardAssetsData: BaseData {
    var title: String
    var showActionsView: Bool
    var type: CellActionType
    
    let programs: Double
    let funds: Double
    let trading: Double
    let wallet: Double
    
    init() {
        title = "Assets"
        showActionsView = false
        type = .none
        
        programs = 40.0
        funds = 10.0
        trading = 20.0
        wallet = 30.0
    }
}

struct DashboardAssetsChartTableViewCellViewModel {
    let data: DashboardAssetsData
    weak var delegate: BaseCellProtocol?
}
extension DashboardAssetsChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: DashboardAssetsChartTableViewCell) {
        cell.configure(data, delegate: delegate)
    }
}

class DashboardAssetsChartTableViewCell: BaseTableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var labelsView: UIStackView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    // MARK: - Public methods
    func configure(_ data: DashboardAssetsData, delegate: BaseCellProtocol?) {
        type = .none
        
        self.delegate = delegate
        
        titleLabel.text = data.title
        actionsView.isHidden = !data.showActionsView
        
        labelsView.removeAllArrangedSubviews()
        
        let programsItem = DashboardChartItemView.viewFromNib()
        programsItem.circleView.backgroundColor = UIColor.Common.yellow
        programsItem.titleLabel.text = "Programs"
        programsItem.valueLabel.text = data.programs.toString() + "%"
        
        labelsView.addArrangedSubview(programsItem)
        
        let fundsItem = DashboardChartItemView.viewFromNib()
        fundsItem.circleView.backgroundColor = UIColor.Common.blue
        fundsItem.titleLabel.text = "Funds"
        fundsItem.valueLabel.text = data.funds.toString() + "%"
        
        labelsView.addArrangedSubview(fundsItem)
        
        let tradingItem = DashboardChartItemView.viewFromNib()
        tradingItem.circleView.backgroundColor = UIColor.Common.primary
        tradingItem.titleLabel.text = "Trading"
        tradingItem.valueLabel.text = data.trading.toString() + "%"
        
        labelsView.addArrangedSubview(tradingItem)
        
        let walletItem = DashboardChartItemView.viewFromNib()
        walletItem.circleView.backgroundColor = UIColor.Common.red
        walletItem.titleLabel.text = "Wallet"
        walletItem.valueLabel.text = data.wallet.toString() + "%"
        
        labelsView.addArrangedSubview(walletItem)
        
        setDataCount(data)
    }
    
    func setDataCount(_ data: DashboardAssetsData) {
        let entries = [PieChartDataEntry(value: data.programs),
                       PieChartDataEntry(value: data.funds),
                       PieChartDataEntry(value: data.trading),
                       PieChartDataEntry(value: data.wallet)]
        
        let set = PieChartDataSet(entries: entries, label: "Assets")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = [UIColor.Common.yellow, UIColor.Common.blue, UIColor.Common.primary, UIColor.Common.red]
        
        let data = PieChartData(dataSet: set)
//        let pFormatter = NumberFormatter()
//        pFormatter.numberStyle = .percent
//        pFormatter.maximumFractionDigits = 1
//        pFormatter.multiplier = 1
//        pFormatter.percentSymbol = " %"
//        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
//        data.setValueFont(UIFont.getFont(.light, size: 11))
//        data.setValueTextColor(.white)
        data.highlightEnabled = false
        data.setDrawValues(false)
        pieChartView.data = data
        pieChartView.highlightValues(nil)
        
        pieChartView.holeColor = UIColor.BaseView.bg
        pieChartView.drawHoleEnabled = true
        pieChartView.drawCenterTextEnabled = false
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.drawSlicesUnderHoleEnabled = false
        pieChartView.highlightPerTapEnabled = false

        pieChartView.usePercentValuesEnabled = false
        pieChartView.rotationEnabled = false
        pieChartView.rotationWithTwoFingers = false
        
        pieChartView.legend.enabled = false
    }
}
