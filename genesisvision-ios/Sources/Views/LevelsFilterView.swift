//
//  LevelsFilterView.swift
//  genesisvision-ios
//
//  Created by George on 06/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol LevelsFilterViewProtocol: class {
    func applyButtonDidPress(with levels: [Int])
}

class LevelsFilterView: UIView {
    // MARK: - Variables
    weak var delegate: LevelsFilterViewProtocol?
    
    var selectedLevels: [Int] = [0]
    
    // MARK: - IBOutlets
    @IBOutlet var levelButtons: [LevelFilterButton]!
    
    @IBOutlet var applyButton: ActionButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        levelButtons[0].setTitle("All", for: .normal)
        levelButtons[0].tag = 0
        
        for idx in 1...7 {
            levelButtons[idx].setTitle("\(idx)", for: .normal)
            levelButtons[idx].tag = idx
        }
        
        updateLevelButtons()
    }
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        updateLevelButtons()
    }
    
    // MARK: - Private methods
    private func updateLevelButtons() {
        for button in levelButtons {
            button.isSelected = false
        }
        
        for selectedLevel in selectedLevels {
            levelButtons[selectedLevel].isSelected = true
        }
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
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        delegate?.applyButtonDidPress(with: selectedLevels)
    }
}

extension LevelsFilterView: BottomSheetControllerProtocol {
    func didHide() {
        
    }
}
