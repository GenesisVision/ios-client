//
//  BrokerCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by George on 04.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

protocol BrokerCollectionViewCellViewModelProtocol: class {
    func isSelected(_ broker: Broker) -> Bool
    func showDetails(_ broker: Broker)
}

struct BrokerCollectionViewCellViewModel {
    let brokerModel: Broker?
    weak var delegate: BrokerCollectionViewCellViewModelProtocol?
}

extension BrokerCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: BrokerCollectionViewCell) {
        cell.configure(brokerModel, delegate: delegate)
    }
}

class BrokerCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var tagsView: UIStackView!
    
    var broker: Broker?
    
    weak var delegate: BrokerCollectionViewCellViewModelProtocol?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ broker: Broker?, delegate: BrokerCollectionViewCellViewModelProtocol?) {
        self.delegate = delegate
        self.broker = broker
        
        if let logo = broker?.logo, let fileUrl = getFileURL(fileName: logo) {
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: fileUrl)
        }
        
        tagsView.removeAllArrangedSubviews()
        if let tags = broker?.tags {
            tags.forEach { (item) in
                let tag = RoundedLabel()
                if let color = item.color {
                    tag.textColor = UIColor.hexColor(color)
                    tag.backgroundColor = UIColor.hexColor(color).withAlphaComponent(0.1)
                }
                tag.translatesAutoresizingMaskIntoConstraints = false
                tag.heightAnchor.constraint(equalToConstant: 28).isActive = true
                tag.text = item.name
                tagsView.addArrangedSubview(tag)
            }
        }
        
        if let broker = broker, let isSelected = delegate?.isSelected(broker) {
            roundCorners(with: Constants.SystemSizes.cornerSize, borderWidth: isSelected ? 2.0 : 0.0, borderColor: .primary)
        }
    }
    
    @IBAction func detailButtonAction(_ sender: UIButton) {
        guard let broker = broker else { return }
        delegate?.showDetails(broker)
    }
}
