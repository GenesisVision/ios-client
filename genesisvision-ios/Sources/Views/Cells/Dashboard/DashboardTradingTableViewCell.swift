//
//  DashboardTradingTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 15.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct DashboardTradingCellViewModel<ViewModelType: CellViewModelWithCollection> {
    var viewModel: ViewModelType
    let data: TradingHeaderData?
    var dataSource: CollectionViewDataSource<ViewModelType>!
    weak var delegate: BaseTableViewProtocol?
    init(_ viewModel: ViewModelType, data: TradingHeaderData?, delegate: BaseTableViewProtocol?) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.data = data
        
        dataSource = CollectionViewDataSource(viewModel)
    }
}

extension DashboardTradingCellViewModel: CellViewModel {
    func setup(on cell: DashboardTradingTableViewCell) {
        if let data = data, data.isEmpty {
            cell.emptyView.isHidden = !data.isEmpty
            cell.labelsView.isHidden = data.isEmpty
        }
        
        cell.configure(viewModel, delegate: delegate, collectionViewDelegate: dataSource, collectionViewDataSource: dataSource, cellModelsForRegistration: viewModel.cellModelsForRegistration)
        cell.labelsView.configure(data)
        cell.labelsView.changeLabelsView.dayLabel.valueLabel.isHidden = true
        cell.labelsView.changeLabelsView.weekLabel.valueLabel.isHidden = true
        cell.labelsView.changeLabelsView.monthLabel.valueLabel.isHidden = true
    }
}

class DashboardTradingTableViewCell: CellWithCollectionView {
    @IBOutlet weak var emptyView: DashboardTradingEmptyView! {
       didSet {
           emptyView.isHidden = true
       }
    }
    @IBOutlet weak var labelsView: DashboardTradingLabelsView!
}

class TradingCollectionViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType

    var viewModels = [CellViewAnyModel]()

    var canPullToRefresh: Bool = true
    var details: DashboardTradingDetails?
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioEventCollectionViewCellViewModel.self]
    }

    weak var delegate: BaseTableViewProtocol?
    init(_ details: DashboardTradingDetails?, delegate: BaseTableViewProtocol?) {
        self.details = details
        self.delegate = delegate
        self.title = "Trading"
        self.type = .dashboardTrading
        
        details?.events?.items?.forEach({ (viewModel) in
            let viewModel = PortfolioEventCollectionViewCellViewModel(reloadDataProtocol: nil, event: viewModel)
            viewModels.append(viewModel)
        })
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(type, cellViewModel: model(for: indexPath))
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return self.details?.events?.items?.count ?? 0 > 0 ? 150 : 0
    }
    
    func makeLayout() -> UICollectionViewLayout {
        return CustomLayout.defaultLayout(1, pagging: false, vCount: 1)
    }
    
    func hideLoader() -> Bool {
        return details?.equity != nil && details?.aum != nil
    }
    
    // MARK: - Actions
    @IBAction func showAllButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .showAll)
    }
}

extension TradingCollectionViewModel {
    func getRightButtons() -> [UIButton] {
        let showAllButton = UIButton(type: .system)
        showAllButton.setTitle("details", for: .normal)
        showAllButton.setImage(#imageLiteral(resourceName: "img_arrow_right_icon"), for: .normal)
        showAllButton.imageEdgeInsets.left = 8.0
        showAllButton.semanticContentAttribute = .forceRightToLeft
        showAllButton.tintColor = UIColor.primary
        showAllButton.addTarget(self, action: #selector(showAllButtonAction(_:)), for: .touchUpInside)
        return [showAllButton]
    }
}
