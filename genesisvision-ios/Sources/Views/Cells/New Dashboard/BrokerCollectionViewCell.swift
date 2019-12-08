//
//  BrokerCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by George on 04.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct BrokerModel {
    var tags: [String]?
    var logo: String?
}

struct BrokerCollectionViewCellViewModel {
    let brokerModel: BrokerModel?
    let isSelected: Bool
    weak var delegate: BaseCellProtocol?
    let index: Int?
}

extension BrokerCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: BrokerCollectionViewCell) {
        cell.configure(brokerModel, delegate: delegate, isSelected: isSelected, index: index)
    }
}

class BrokerCollectionViewCell: BaseCollectionViewCell {
    
    var index: Int?
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var tagsView: UIStackView!
    
    weak var delegate: BaseCellProtocol?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ brokerModel: BrokerModel?, delegate: BaseCellProtocol?, isSelected: Bool, index: Int?) {
        self.index = index
        self.delegate = delegate
        
        logoImageView.image = #imageLiteral(resourceName: "img_facet_favorites_bg")
        
        if let logo = brokerModel?.logo, let fileUrl = getFileURL(fileName: logo) {
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: fileUrl)
        }
        
        tagsView.removeAllArrangedSubviews()
        if let tags = brokerModel?.tags {
            tags.forEach { (text) in
                let tag = RoundedLabel()
                tag.translatesAutoresizingMaskIntoConstraints = false
                tag.heightAnchor.constraint(equalToConstant: 28).isActive = true
                tag.text = text
                tagsView.addArrangedSubview(tag)
            }
        }
        
        roundCorners(with: Constants.SystemSizes.cornerSize, borderWidth: isSelected ? 2.0 : 0.0, borderColor: .primary)
    }
    
    @IBAction func detailButtonAction(_ sender: UIButton) {
        guard let index = index else { return }
        
        delegate?.didSelect(.showBrokerDetails, index: index)
    }
}
