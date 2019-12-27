//
//  DashboardAssetsChartTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 20.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

struct AssetData {
    var currency: CurrencyType?
    var percent: Double
    var name: String
    var color: String
    
    init(_ currency: CurrencyType, model: DashboardAsset) {
        self.color = model.color ?? ""
        self.name = model.name ?? ""
        self.percent = model.percent ?? 0.0
        self.currency = currency
    }
    
    init(_ currency: CurrencyType?, percent: Double, name: String, color: String) {
        self.color = color
        self.name = name
        self.percent = percent
        self.currency = currency
    }
}

struct DashboardAssetsData: BaseData {
    var title: String
    var type: CellActionType
    
    var items = [AssetData]()
    
    init(_ assets: DashboardAssets?, currency: CurrencyType) {
        self.title = "Assets"
        self.type = .none
        
        assets?.assets?.forEach({ (model) in
            items.append(AssetData(currency, model: model))
        })
    }
}

struct DashboardAssetsChartTableViewCellViewModel {
    let data: DashboardAssetsData?
    weak var delegate: BaseTableViewProtocol?
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
    func configure(_ data: DashboardAssetsData?, delegate: BaseTableViewProtocol?) {
        guard let data = data else { return }
        loaderView.stopAnimating()
        loaderView.isHidden = true
        
        self.type = data.type
        self.delegate = delegate
        
        titleLabel.text = data.title
        
        labelsView.removeAllArrangedSubviews()
        
        data.items.forEach { (data) in
            let chartItem = DashboardChartItemView.viewFromNib()
            chartItem.circleView.backgroundColor = UIColor.hexColor(data.color)
            chartItem.titleLabel.text = data.name
            chartItem.valueLabel.text = data.percent.toString() + "%"
            
            labelsView.addArrangedSubview(chartItem)
        }
        
        setDataCount(data)
    }
    
    func setDataCount(_ data: DashboardAssetsData) {
        var entries = [PieChartDataEntry]()
        data.items.forEach { (data) in
            entries.append(PieChartDataEntry(value: data.percent))
        }
        let set = PieChartDataSet(entries: entries, label: "Assets")
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
