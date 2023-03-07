//
//  GXMessagesTableView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/6.
//

import UIKit

public protocol GXMessagesTableViewDatalist: NSObjectProtocol {
    func tableView(_ tableView: UITableView, avatarIdForRowAt indexPath: IndexPath) -> String
}

public class GXMessagesTableView: GXMessagesLoadTableView {
    public weak var datalist: GXMessagesTableViewDatalist?
    private var hoverAvatars: [String: UIView] = [:]
    private var preEndAvatarIndexPath: IndexPath?
    
    
}

public extension GXMessagesTableView {
    
    func gx_scrollViewChangeContentOffset(_ offset: CGPoint) {
        guard let dataDelegate = self.datalist else { return }
        let lastCell = self.visibleCells.last(where: {$0.isKind(of: GXMessagesTableViewCell.self)})
        guard let lastAvatarCell = lastCell as? GXMessagesTableViewCell else { return }
        guard let lastAvatarIndexPath = self.indexPath(for: lastAvatarCell) else { return }
        guard let preIndexPath = self.indexPathsForVisibleRows?.last(where: {$0 < lastAvatarIndexPath}) else { return }
        
        let lastAvatarID = dataDelegate.tableView(self, avatarIdForRowAt: lastAvatarIndexPath)
        if !self.hoverAvatars.keys.contains(lastAvatarID) {
            self.gx_resetPreEndAvatar()
            
            let avatar = GXMessagesTableViewCell.getAvatar()
            let avatarOrigin = CGPoint(x: lastAvatarCell.left, y: lastAvatarCell.bottom - lastAvatarCell.avatar.height)
            avatar.frame = CGRect(origin: avatarOrigin, size: lastAvatarCell.avatar.size)
            self.addSubview(avatar)
            self.hoverAvatars.updateValue(avatar, forKey: lastAvatarID)
        }
        else {
            if self.cellForRow(at: preIndexPath) is GXMessagesTableViewCell {
                if lastAvatarCell.messageContinuousStatus == .end || lastAvatarCell.messageContinuousStatus == .beginAndEnd {
                    lastAvatarCell.avatar.isHidden = true
                    self.preEndAvatarIndexPath = lastAvatarIndexPath
                }
            }
            else {
                self.gx_resetPreEndAvatar()
                
                let avatar = GXMessagesTableViewCell.getAvatar()
                let avatarOrigin = CGPoint(x: lastAvatarCell.left, y: lastAvatarCell.bottom - lastAvatarCell.avatar.height)
                avatar.frame = CGRect(origin: avatarOrigin, size: lastAvatarCell.avatar.size)
                self.addSubview(avatar)
                self.hoverAvatars.updateValue(avatar, forKey: lastAvatarID)
            }
        }
    
        let cellRect = self.rectForRow(at: lastAvatarIndexPath)
        let cellTop = cellRect.minY - self.contentOffset.y
        let cellBottom = cellRect.maxY - self.contentOffset.y
        let tvBottom = self.height - self.adjustedContentInset.bottom
        let tDifference = tvBottom - cellTop
        let bDifference = tvBottom - cellBottom

        if tDifference >= lastAvatarCell.avatar.height {
            if bDifference <= 0 {
                self.hoverAvatars.values.forEach {
                    $0.top = tvBottom - $0.height + self.contentOffset.y
                }
            }
            else {
                self.hoverAvatars.values.forEach {
                    $0.top = cellRect.maxY - $0.height
                }
            }
        }
        else {
            if let preCell = self.cellForRow(at: preIndexPath) as? GXMessagesTableViewCell,
               preCell.messageContinuousStatus != .end && preCell.messageContinuousStatus != .beginAndEnd,
               lastAvatarIndexPath.section == preIndexPath.section
            {
                self.hoverAvatars.values.forEach {
                    $0.top = tvBottom - $0.height + self.contentOffset.y
                }
            }
            else {
                self.hoverAvatars.values.forEach {
                    $0.top = cellRect.minY
                }
            }
        }
        
    }
    
    func gx_resetPreEndAvatar() {
        self.hoverAvatars.values.forEach {
            $0.removeFromSuperview()
        }
        self.hoverAvatars.removeAll()
        if let preEndIndexPath = self.preEndAvatarIndexPath {
            if let preEndCell = self.cellForRow(at: preEndIndexPath) as? GXMessagesTableViewCell {
                if preEndCell.messageContinuousStatus == .end || preEndCell.messageContinuousStatus == .beginAndEnd {
                    preEndCell.avatar.isHidden = false
                }
            }
        }
    }
    
}
