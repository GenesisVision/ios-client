//
//  DashboardPortfolioChartTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 20.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

struct AssetData {
    let currency: CurrencyType?
    let percent: Double
    let value: String
    let color: String
}
struct DashboardPortfolioData: BaseData {
    var title: String
    var showActionsView: Bool
    var type: CellActionType
    
    let assets: [AssetData]
    
    init() {
        title = "Portfolio"
        showActionsView = false
        type = .none
        
        assets = [AssetData(currency: .btc, percent: 20.0, value: CurrencyType.btc.rawValue, color: "#fd5a18"),
                  AssetData(currency: .eth, percent: 30.0, value: CurrencyType.eth.rawValue, color: "#ffc428"),
                  AssetData(currency: .gvt, percent: 1.0, value: CurrencyType.gvt.rawValue, color: "#1b4448"),
                  AssetData(currency: nil, percent: 49.0, value: "Other", color: "#bababa")]
    }
}

struct DashboardPortfolioChartTableViewCellViewModel {
    let data: DashboardPortfolioData
    weak var delegate: BaseCellProtocol?
}
extension DashboardPortfolioChartTableViewCellViewModel: CellViewModel {
    func setup(on cell: DashboardPortfolioChartTableViewCell) {
        cell.configure(data, delegate: delegate)
    }
}

class DashboardPortfolioChartTableViewCell: BaseTableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var currenciesView: UIStackView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    // MARK: - Public methods
    func configure(_ data: DashboardPortfolioData, delegate: BaseCellProtocol?) {
        self.type = data.type
        self.delegate = delegate
        
        titleLabel.text = data.title
        actionsView.isHidden = !data.showActionsView
        
        currenciesView.removeAllArrangedSubviews()
        
        data.assets.forEach { (data) in
            let chartItem = DashboardChartItemView.viewFromNib()
            chartItem.circleView.backgroundColor = UIColor.hexColor(data.color)
            chartItem.titleLabel.text = data.value
            chartItem.valueLabel.text = data.percent.toString() + "%"
            
            currenciesView.addArrangedSubview(chartItem)
        }
        
        setDataCount(data)
    }
    
    func setDataCount(_ data: DashboardPortfolioData) {
        var entries = [PieChartDataEntry]()
        data.assets.forEach { (data) in
            entries.append(PieChartDataEntry(value: data.percent))
        }
        
        let set = PieChartDataSet(entries: entries, label: "Portfolio")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = data.assets.map({ UIColor.hexColor($0.color) })
        
        let data = PieChartData(dataSet: set)
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
