//
//  SearchHeaderView.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 19.08.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

protocol SearchHeaderTextChangedProtocol: AnyObject {
    func textChanged(text: String)
}


class SearchHeaderView: UIView {
    
    private let searchField: DesignableUITextField = {
        let textField = DesignableUITextField(frame: .zero)
        textField.placeholder = "Search"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "img_search_icon").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.Common.primary
        return imageView
    }()
    
    var searchFieldDelegate: SearchHeaderTextChangedProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        overlayFirstLayer()
        addBottomLine()
    }
    
    private func overlayFirstLayer() {
        addSubview(searchField)
        addSubview(rightImageView)
        
        rightImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, size: CGSize(width: 20, height: 20))
        rightImageView.anchorCenter(centerY: searchField.centerYAnchor, centerX: nil)
        searchField.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: rightImageView.leadingAnchor)
        searchField.anchorSize(size: CGSize(width: UIScreen.main.bounds.width - 20, height: 0))
    }
    
    private func addBottomLine() {
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.Common.darkCell
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLineView)
        
        bottomLineView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: CGSize(width: 0, height: 1))
    }
    
    @objc private func textFieldDidChange() {
        guard let text = searchField.text else { return }
        searchFieldDelegate?.textChanged(text: text)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
