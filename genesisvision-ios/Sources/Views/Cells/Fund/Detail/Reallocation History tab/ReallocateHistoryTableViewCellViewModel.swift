//
//  ReallocateHistoryTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 21/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

struct ReallocateHistoryTableViewCellViewModel {
    let index: Int
    let model: ReallocationModel
    
    var delegate: ReallocateHistoryTableViewCellProtocol?
}

extension ReallocateHistoryTableViewCellViewModel: CellViewModel {
    func setup(on cell: ReallocateHistoryTableViewCell) {
        cell.index = index
        cell.delegate = delegate
        
        if let date = model.date {
            cell.dateLabel.text = date.dateAndTimeToString()
        }
        
        if let parts = model.parts, !parts.isEmpty {
            parts.prefix(4).forEach { (part) in
                let assetsStackView = UIStackView(frame: .zero)
                assetsStackView.axis = .horizontal
                assetsStackView.spacing = 0.0
                assetsStackView.distribution = .fill
                assetsStackView.alignment = .center
                
                //icon
                let iconImageView = UIImageView()
                iconImageView.backgroundColor = .clear
                iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
                iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                if let logo = part.icon, let fileUrl = getFileURL(fileName: logo) {
                    iconImageView.kf.indicatorType = .activity
                    iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.fundPlaceholder)
                }
                //percent
                let label = UILabel()
                if let percent = part.percent {
                    label.text = percent.rounded(withType: .undefined).toString() + "%"
                }
                label.textColor = UIColor.Common.white
                label.font = UIFont.getFont(.regular, size: 16.0)
                label.textAlignment = .center
                
                assetsStackView.addArrangedSubview(iconImageView)
                assetsStackView.addArrangedSubview(label)
                
                let view = RoundedBackgroundView()
                view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                view.translatesAutoresizingMaskIntoConstraints = false
                assetsStackView.insertSubview(view, at: 0)
                
                view.pin(to: assetsStackView)
            
                cell.stackView.addArrangedSubview(assetsStackView)
            }
            
            if parts.count > 4 {
                cell.seeAllButton.isHidden = false
                cell.seeAllButton.setTitle("+\(parts.count - 4)", for: .normal)
            }
        }
    }
}


public extension UIView {
    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -8.0),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8.0),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
