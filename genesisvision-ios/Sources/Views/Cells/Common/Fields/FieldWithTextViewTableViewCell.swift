//
//  FieldWithTextViewTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 12/07/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FieldWithTextViewTableViewCell: PlateTableViewCell {

    var valueChanged: ((String) -> Void)?
    
    // MARK: - Views
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var accessoryImageView: UIImageView!
    
    @IBOutlet var textView: UITextView! {
        didSet {
            textView.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryImageView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
}

extension FieldWithTextViewTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        valueChanged?(textView.text)
    }
}
