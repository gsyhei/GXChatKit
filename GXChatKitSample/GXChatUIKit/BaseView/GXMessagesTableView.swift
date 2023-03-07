//
//  GXMessagesTableView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/6.
//

import UIKit

public struct GXAvatarData {
    public var avatar: UIView
    public var indexPath: IndexPath
    
    init(avatar: UIView, indexPath: IndexPath) {
        self.avatar = avatar
        self.indexPath = indexPath
    }
}

public protocol GXMessagesTableViewDatalist: NSObjectProtocol {
    func tableView(_ tableView: UITableView, avatarIdForRowAt indexPath: IndexPath) -> String
}

public class GXMessagesTableView: GXMessagesLoadTableView {
    public weak var datalist: GXMessagesTableViewDatalist?
    private var hoverAvatars: [String: GXAvatarData] = [:]
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
            let avatarData = GXAvatarData(avatar: avatar, indexPath: lastAvatarIndexPath)
            self.hoverAvatars.updateValue(avatarData, forKey: lastAvatarID)
        }
        else {
            if self.cellForRow(at: preIndexPath) is GXMessagesTableViewCell {
                if lastAvatarCell.messageContinuousStatus == .end {
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
                let avatarData = GXAvatarData(avatar: avatar, indexPath: lastAvatarIndexPath)
                self.hoverAvatars.updateValue(avatarData, forKey: lastAvatarID)
            }
        }
    }
    
    func gx_resetPreEndAvatar() {
        self.hoverAvatars.values.forEach {
            $0.avatar.removeFromSuperview()
        }
        self.hoverAvatars.removeAll()
        if let preEndIndexPath = self.preEndAvatarIndexPath {
            if let preEndCell = self.cellForRow(at: preEndIndexPath) as? GXMessagesTableViewCell {
                if preEndCell.messageContinuousStatus == .end {
                    preEndCell.avatar.isHidden = false
                }
            }
        }
    }
    
}
