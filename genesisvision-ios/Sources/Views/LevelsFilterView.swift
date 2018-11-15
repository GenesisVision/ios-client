//
//  LevelsFilterView.swift
//  genesisvision-ios
//
//  Created by George on 06/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

enum LevelFilterType {
    case fields, buttons
}

protocol LevelsFilterViewProtocol: class {
    func applyButtonDidPress()
    func showPickerMinPicker(min minLevel: Int, max maxLevel: Int)
    func showPickerMaxPicker(min minLevel: Int, max maxLevel: Int)
}

class LevelsFilterView: UIView {
    // MARK: - Variables
    
    let levelFilterType: LevelFilterType = .fields
    
    weak var delegate: LevelsFilterViewProtocol?
    
    var minLevel: Int = 1
    var maxLevel: Int = 7
    
    private var selectedLevels: [Int] = [0]
    
    var bottomSheetController: BottomSheetController?
    
    // MARK: - IBOutlets
    @IBOutlet var minTitleLabel: UILabel!
    @IBOutlet var maxTitleLabel: UILabel!
    
    @IBOutlet var minTextField: DesignableUITextField! {
        didSet {
            minTextField.addPadding()
            minTextField.backgroundColor = UIColor.DateRangeView.textfieldBg
        }
    }
    @IBOutlet var maxTextField: DesignableUITextField! {
        didSet {
            maxTextField.addPadding()
            maxTextField.backgroundColor = UIColor.DateRangeView.textfieldBg
        }
    }
    
    @IBOutlet var levelButtons: [LevelFilterButton]!
    
    @IBOutlet var applyButton: ActionButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        switch levelFilterType {
        case .buttons:
            updateLevelButtons()
        case .fields:
            updateFileds()
        }
    }
    
    // MARK: - Private methods
    private func setup() {
        switch levelFilterType {
        case .buttons:
            setupButtons()
        case .fields:
            setupFields()
        }
    }
    
    private func setupFields() {
        updateFileds()
        
    }
    private func setupButtons() {
        levelButtons[0].setTitle("All", for: .normal)
        levelButtons[0].tag = 0
        
        for idx in 1...7 {
            levelButtons[idx].setTitle("\(idx)", for: .normal)
            levelButtons[idx].tag = idx
        }
        
        updateLevelButtons()
    }
    
    private func updateLevelButtons() {
        for button in levelButtons {
            button.isSelected = false
        }
        
        for selectedLevel in selectedLevels {
            levelButtons[selectedLevel].isSelected = true
        }
    }
    
    private func updateFileds() {
        minTextField.text = "\(minLevel)"
        maxTextField.text = "\(maxLevel)"
    }
    
    // MARK: - Public methods
    func getSelectedLevels() -> String {
        switch levelFilterType {
        case .buttons:
            if selectedLevels.count == 1, selectedLevels[0] == 0 {
                return "All"
            } else {
                let levels = selectedLevels.sorted()
                return levels.map { String($0) }.joined(separator: ", ")
            }
        case .fields:
            return "\(minLevel)-\(maxLevel)"
        }
    }
    
    func reset() {
        selectedLevels = [0]
    }
    // MARK: - Actions
    @IBAction func changeSelectedLevelButtonAction(_ sender: UIButton) {
        if sender.tag == 0, !sender.isSelected {
            selectedLevels.removeAll()
            for button in levelButtons {
                button.isSelected = false
                
                UIView.transition(with: button,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: { button.isSelected = false },
                                  completion: nil)
            }
            
            selectedLevels.append(sender.tag)
            sender.isSelected = true
            sender.isUserInteractionEnabled = false
            
            return
        } else if levelButtons[0].isSelected {
            UIView.transition(with: levelButtons[0],
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { self.levelButtons[0].isSelected = false },
                              completion: nil)
            
            levelButtons[0].isUserInteractionEnabled = true
            
            selectedLevels = selectedLevels.filter { $0 != 0 }
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            selectedLevels.append(sender.tag)
        } else {
            selectedLevels = selectedLevels.filter { $0 != sender.tag }
        }
        
        if selectedLevels.count == 0 {
            selectedLevels.append(levelButtons[0].tag)
            
            UIView.transition(with: levelButtons[0],
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { self.levelButtons[0].isSelected = true },
                              completion: nil)
            
            levelButtons[0].isUserInteractionEnabled = false
        } else if selectedLevels.count == 7 && !selectedLevels.contains(0) {
            selectedLevels.removeAll()
            for button in levelButtons {
                UIView.transition(with: button,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: { button.isSelected = false },
                                  completion: nil)
            }
            
            selectedLevels.append(levelButtons[0].tag)
            UIView.transition(with: levelButtons[0],
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { self.levelButtons[0].isSelected = true },
                              completion: nil)
            
            levelButtons[0].isUserInteractionEnabled = false
        }
    }
    
    @IBAction func textFieldEditing(sender: UITextField) {
        sender.resignFirstResponder()
        
        if sender == minTextField {
            delegate?.showPickerMinPicker(min: minLevel, max: maxLevel)
        } else {
            delegate?.showPickerMaxPicker(min: minLevel, max: maxLevel)
        }
    }
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        bottomSheetController?.dismiss()
        
        if let text = minTextField.text, let value = Int(text) {
            minLevel = value
        }
        
        if let text = maxTextField.text, let value = Int(text) {
            maxLevel = value
        }
        
        delegate?.applyButtonDidPress()
    }
}

extension LevelsFilterView: BottomSheetControllerProtocol {
    func didHide() {
        
    }
}
