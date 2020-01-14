//
//  DashboardInvestingTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 20.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct DashboardInvestingCellViewModel<ViewModelType: CellViewModelWithCollection> {
    var viewModel: ViewModelType
    var dataSource: CollectionViewDataSource<ViewModelType>!
    let data: InvestingHeaderData?
    
    weak var delegate: BaseTableViewProtocol?
    init(_ viewModel: ViewModelType, data: InvestingHeaderData?, delegate: BaseTableViewProtocol?) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.data = data
        
        dataSource = CollectionViewDataSource(viewModel)
    }
}
extension DashboardInvestingCellViewModel: CellViewModel {
    func setup(on cell: DashboardInvestingTableViewCell) {
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

class DashboardInvestingTableViewCell: CellWithCollectionView {
    @IBOutlet weak var emptyView: DashboardInvestingEmptyView! {
        didSet {
            emptyView.isHidden = true
        }
    }
    @IBOutlet weak var labelsView: DashboardInvestingLabelsView!
}

class InvestingCollectionViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true
    var details: DashboardInvestingDetails?
    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioEventCollectionViewCellViewModel.self]
    }
    
    weak var delegate: BaseTableViewProtocol?
    init(_ details: DashboardInvestingDetails?, delegate: BaseTableViewProtocol?) {
        self.details = details
        self.delegate = delegate
        self.title = "Investments"
        self.type = .dashboardInvesting
        
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
    
    func hideLoader() -> Bool {
        return details?.equity != nil && details?.profits != nil
    }
    
    // MARK: - Actions
    @IBAction func showAllButtonAction(_ sender: UIButton) {
        delegate?.action(type, actionType: .showAll)
    }
}

extension InvestingCollectionViewModel {
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
