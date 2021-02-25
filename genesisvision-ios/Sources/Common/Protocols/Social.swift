//
//  Social.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 20.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol SocialPostActionsMenuPresenable: class {
    func showPostMenu(actions: [SocialPostAction], postId: UUID, postLink: String)
    func actionSelected(action: SocialPostAction)
}

extension SocialPostActionsMenuPresenable where Self: BaseViewController {
    func showPostMenu(actions: [SocialPostAction], postId: UUID, postLink: String) {
        
        let minimumHeight = CGFloat(60)
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = CGFloat(40*actions.count) < minimumHeight ? minimumHeight : CGFloat(40*actions.count)
        
        let actionsStrings = actions.map { (action) -> String in
            switch action {
            
            case .edit(postId: _):
                return "Edit"
            case .share(postLink: _):
                return "Share"
            case .copyLink(postLink: _):
                return "Copy link"
            case .delete(postId: _):
                return "Delete"
            case .report(postId: _):
                return "Report"
            }
        }
        
        bottomSheetController.addDefaultTableViewWithCell(viewModels: actionsStrings) { [weak self] (actionString) in
            self?.bottomSheetController.dismiss(animated: true, completion: {
                switch actionString {
                case "Edit":
                    self?.actionSelected(action: .edit(postId: postId))
                case "Share":
                    self?.actionSelected(action: .share(postLink: postLink))
                case "Copy link":
                    self?.actionSelected(action: .copyLink(postLink: postLink))
                case "Delete":
                    self?.actionSelected(action: .delete(postId: postId))
                case "Report":
                    self?.actionSelected(action: .report(postId: postId))
                default:
                    break
                }
            })
        }
        
        bottomSheetController.present()
    }
}
