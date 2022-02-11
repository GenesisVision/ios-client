//
//  AssetsTableView.swift
//  genesisvision-ios
//
//  Created by Gregory on 09.02.2022.
//  Copyright © 2022 Genesis Vision. All rights reserved.
//

import UIKit

class AssetsTableView : UIView {
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.Common.darkCell
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    var viewModels = [SocialAssetsTableViewCellViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    private func setup() {
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.fillSuperview(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        tableView.register(UINib(nibName: SocialAssetsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SocialAssetsTableViewCell.identifier)
        let backView = UIView()
        backView.backgroundColor = UIColor.Common.darkBackground
        tableView.backgroundView = backView
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension AssetsTableView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModels[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SocialAssetsTableViewCell.identifier, for: indexPath) as? SocialAssetsTableViewCell else { return UITableViewCell()}
        model.setup(on: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isHidden = true
        let model = viewModels[indexPath.row]
        guard let assetUrl = model.assetURL, let assettype = model.tagType else { return }
        let textToPost = assetUrl + " (\(assettype))"
        NotificationCenter.default.post(name: .didSelectAssetsTableView, object: nil, userInfo: ["text" : textToPost])
        viewModels.removeAll()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.Common.darkBackground
    }
}
