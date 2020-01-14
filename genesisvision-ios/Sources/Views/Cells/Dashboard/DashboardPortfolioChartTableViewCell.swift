//
//  DashboardPortfolioChartTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 20.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

struct MoneyLocationData {
    var color: String
    var name: String
    var percent: Double
    
    init(_ model: MoneyLocation) {
        self.color = model.color ?? ""
        self.name = model.name?.rawValue ?? ""
        self.percent = model.percent ?? 0.0
    }
    
    init(_ color: String, name: String, percent: Double) {
        self.color = color
        self.name = name
        self.percent = percent
    }
}

struct DashboardPortfolioData: BaseData {
    var title: String
    var type: CellActionType
    
    var items = [MoneyLocationData]()
    
    init(_ portfolio: DashboardPortfolio?) {
        title = "Portfolio"
        type = .none

        portfolio?.distribution?.forEach({ (model) in
            items.append(MoneyLocationData(model))
        })
    }
}

struct DashboardPortfolioChartTableViewCellViewModel {
    let data: DashboardPortfolioData?
    weak var delegate: BaseTableViewProtocol?
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
    func configure(_ data: DashboardPortfolioData?, delegate: BaseTableViewProtocol?) {
        guard let data = data else { return }
        loaderView.stopAnimating()
        loaderView.isHidden = true
        
        self.type = data.type
        self.delegate = delegate
        
        titleLabel.text = data.title
        
        currenciesView.removeAllArrangedSubviews()
        
        data.items.forEach { (data) in
            let chartItem = DashboardChartItemView.viewFromNib()
            chartItem.circleView.backgroundColor = UIColor.hexColor(data.color)
            chartItem.titleLabel.text = data.name
            chartItem.valueLabel.text = data.percent.toString() + "%"
            
            currenciesView.addArrangedSubview(chartItem)
        }
        
        setDataCount(data)
    }
    
    func setDataCount(_ data: DashboardPortfolioData) {
        var entries = [PieChartDataEntry]()
        data.items.forEach { (data) in
            entries.append(PieChartDataEntry(value: data.percent))
        }
        let set = PieChartDataSet(entries: entries, label: "Portfolio")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = data.items.map({ UIColor.hexColor($0.color) })
        
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
