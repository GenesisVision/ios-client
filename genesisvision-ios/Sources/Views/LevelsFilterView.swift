//
//  LevelsFilterView.swift
//  genesisvision-ios
//
//  Created by George on 06/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import TTRangeSlider

enum LevelFilterType {
    case slider, buttons
}

protocol LevelsFilterViewProtocol: class {
    func applyButtonDidPress()
}

class LevelsFilterView: UIView {
    // MARK: - Variables
    
    let levelFilterType: LevelFilterType = .slider
    
    weak var delegate: LevelsFilterViewProtocol?
    
    private var minLevel: Int = 1
    private var maxLevel: Int = 7
    
    private var selectedLevels: [Int] = [0]
    
    var bottomSheetController: BottomSheetController?
    
    // MARK: - IBOutlets
    @IBOutlet var rangeSlider: TTRangeSlider!
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
        case .slider:
            break
        }
    }
    
    // MARK: - Private methods
    private func setup() {
        switch levelFilterType {
        case .buttons:
            setupButtons()
        case .slider:
            setupSlider()
        }
    }
    
    private func setupSlider() {
        rangeSlider.delegate = self
        rangeSlider.enableStep = true
        rangeSlider.step = 1
        rangeSlider.minDistance = 1

        rangeSlider.minValue = 1
        rangeSlider.maxValue = 7

        rangeSlider.selectedMinimum = Float(minLevel)
        rangeSlider.selectedMaximum = Float(maxLevel)

        rangeSlider.lineHeight = 2.0
        
        rangeSlider.tintColor = UIColor.Cell.subtitle
        
        rangeSlider.tintColorBetweenHandles = UIColor.Cell.title
        rangeSlider.handleColor = UIColor.Cell.title
        rangeSlider.minLabelColour = UIColor.Cell.title
        rangeSlider.maxLabelColour = UIColor.Cell.title

        rangeSlider.minLabelFont = UIFont.getFont(.regular, size: 14.0)
        rangeSlider.maxLabelFont = UIFont.getFont(.regular, size: 14.0)
        
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
        case .slider:
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
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        bottomSheetController?.dismiss()
        delegate?.applyButtonDidPress()
    }
}

extension LevelsFilterView: BottomSheetControllerProtocol {
    func didHide() {
        
    }
}

extension LevelsFilterView: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        minLevel = Int(selectedMinimum)
        maxLevel = Int(selectedMaximum)
    }
}
