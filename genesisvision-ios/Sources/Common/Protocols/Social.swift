//
//  Social.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 20.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

fileprivate struct PostActionsStrings {
    static let edit = "Edit"
    static let share = "Share"
    static let copy = "Copy link"
    static let delete = "Delete"
    static let report = "Report"
    static let pin = "Pin"
    static let unpin = "Unpin"
}

protocol SocialPostActionsMenuPresenable: class {
    func showPostMenu(actions: [SocialPostAction], postId: UUID, postLink: String)
    func actionSelected(action: SocialPostAction)
}

extension SocialPostActionsMenuPresenable where Self: BaseViewController {
    func showPostMenu(actions: [SocialPostAction], postId: UUID, postLink: String) {
        
        let minimumHeight = CGFloat(60)
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = CGFloat(40*actions.count) < minimumHeight ? minimumHeight : CGFloat(40*actions.count)
        
        bottomSheetController.addDefaultTableViewWithCell(viewModels: actions.map({ return $0.string })) { [weak self] (actionString) in
            self?.bottomSheetController.dismiss(animated: true, completion: {
                switch actionString {
                case PostActionsStrings.edit:
                    self?.actionSelected(action: .edit(postId: postId))
                case PostActionsStrings.share:
                    self?.actionSelected(action: .share(postLink: postLink))
                case PostActionsStrings.copy:
                    self?.actionSelected(action: .copyLink(postLink: postLink))
                case PostActionsStrings.delete:
                    self?.actionSelected(action: .delete(postId: postId))
                case PostActionsStrings.report:
                    self?.actionSelected(action: .report(postId: postId))
                case PostActionsStrings.pin:
                    self?.actionSelected(action: .pin(postId: postId))
                case PostActionsStrings.unpin:
                    self?.actionSelected(action: .unpin(postId: postId))
                default:
                    break
                }
            })
        }
        
        bottomSheetController.present()
    }
}
