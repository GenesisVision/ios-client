//
//  DetailChartTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Charts

protocol DetailChartTableViewCellProtocol: class {
    func showFullChartDidPressed()
    func scrollEnable(_ isScrollEnable: Bool)
    func updateChart(with type: ChartDurationType)
}

class DetailChartTableViewCell: PlateTableViewCell {

    // MARK: - Variables
    weak var delegate: DetailChartTableViewCellProtocol?
    var chartDurationType: ChartDurationType = .all
    
    // MARK: - Views
    let markerView = MarkerView()
    let circleView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.SystemSizes.chartCircleHeight, height: Constants.SystemSizes.chartCircleHeight))
    
    @IBOutlet var viewForChartView: UIView!
    
    @IBOutlet var segmentedControl: ScrollableSegmentedControl! {
        didSet {
            segmentedControl.segmentStyle = .textOnly
            segmentedControl.insertSegment(withTitle: "1D", at: 0)
            segmentedControl.insertSegment(withTitle: "1W", at: 1)
            segmentedControl.insertSegment(withTitle: "1M", at: 2)
            segmentedControl.insertSegment(withTitle: "3M", at: 3)
            segmentedControl.insertSegment(withTitle: "6M", at: 4)
            segmentedControl.insertSegment(withTitle: "1Y", at: 5)
            segmentedControl.insertSegment(withTitle: "All", at: 6)
            segmentedControl.selectedSegmentIndex = 6
            segmentedControl.underlineSelected = true
            segmentedControl.height = 21
            
            let textAttributes = [NSAttributedStringKey.font: UIFont.getFont(.regular, size: 16), NSAttributedStringKey.foregroundColor: UIColor.Font.light]
            let textHighlightAttributes = [NSAttributedStringKey.font: UIFont.getFont(.regular, size: 16), NSAttributedStringKey.foregroundColor: UIColor.primary]
            let textSelectAttributes = [NSAttributedStringKey.font: UIFont.getFont(.regular, size: 16), NSAttributedStringKey.foregroundColor: UIColor.primary]

            segmentedControl.setTitleTextAttributes(textAttributes, for: .normal)
            segmentedControl.setTitleTextAttributes(textHighlightAttributes, for: .highlighted)
            segmentedControl.setTitleTextAttributes(textSelectAttributes, for: .selected)
            
            segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        }
    }
    
    @IBOutlet var chartView: ChartView! {
        didSet {
            chartView.delegate = self
            chartView.chartViewProtocol = self
            chartView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet var chartTooltip: TooltipButton! {
        didSet {
            chartTooltip.tooltipText = String.Tooltitps.chart
        }
    }
   
    // MARK: - Labels
    @IBOutlet var noDataLabel: UILabel! {
        didSet {
            noDataLabel.textColor = UIColor.Font.dark
        }
    }
    
    @IBOutlet var changesLabel: UILabel! {
        didSet {
            changesLabel.textColor = UIColor.Font.green
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        
        circleView.backgroundColor = UIColor.ChartMarker.text
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        circleView.layer.borderColor = UIColor.ChartMarker.bg.cgColor
        circleView.layer.borderWidth = 0.5
        circleView.clipsToBounds = true
        chartView.addSubview(circleView)
        
        markerView.layer.cornerRadius = Constants.SystemSizes.cornerSize
        addSubview(markerView)
        
        hideMarker()
        hideHUD()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    // MARK: - Private methods
    private func hideMarker(value: Bool = true) {
        markerView.isHidden = value
        circleView.isHidden = value
        
        if value {
            chartView.highlightValues(nil)
        }
    }
    
    @IBAction func showFullChart(_ sender: UIButton) {
        delegate?.showFullChartDidPressed()
    }
    
    @objc func segmentSelected(sender: ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")

        hideMarker()
        showProgressHUD()
        if let type = ChartDurationType(rawValue: sender.selectedSegmentIndex) {
            delegate?.updateChart(with: type)
        }
    }
}

extension DetailChartTableViewCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let date = Date(timeIntervalSince1970: entry.x)
        let type: ChartDurationType = ChartDurationType(rawValue: segmentedControl.selectedSegmentIndex) ?? .all
        let dateString = Date.getFormatStringForChart(for: date, chartDurationType: type)
        let x = highlight.xPx - 40 < 0
            ? 0
            : highlight.xPx - 40 > chartView.frame.width - 90
            ? chartView.frame.width - 90
            : highlight.xPx - 40
        
        markerView.frame = CGRect(x: x, y: 12, width: 90, height: 36)
        
        markerView.valueLabel.text = entry.y.rounded(withType: .gvt).toString() + " %"
        markerView.dateLabel.text = dateString
        
        circleView.center = CGPoint(x: highlight.xPx, y: highlight.yPx)

        hideMarker(value: false)
    }
}

extension DetailChartTableViewCell: ChartViewProtocol {
    func didChangeMarker() {
        delegate?.scrollEnable(false)
    }
    
    func didHideMarker() {
        hideMarker()
        delegate?.scrollEnable(true)
    }
}

