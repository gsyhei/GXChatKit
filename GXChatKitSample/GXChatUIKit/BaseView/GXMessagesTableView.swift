//
//  GXMessagesTableView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/6.
//

import UIKit

public protocol GXMessagesTableViewDatalist: NSObjectProtocol {
    func gx_tableView(_ tableView: UITableView, avatarIdForRowAt indexPath: IndexPath) -> String
    func gx_tableView(_ tableView: UITableView, changeForRowAt indexPath: IndexPath, avatar: UIView)
}

public class GXMessagesTableView: GXMessagesLoadTableView {
    public weak var datalist: GXMessagesTableViewDatalist?
    private var hoverAvatar: UIView?
    private var hoverAvatarId: String?
    private var hoverMessageStatus: GXChatConfiguration.MessageStatus?
    private var lastHiddenIndexPath: IndexPath?
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super .init(frame: frame, style: style)
        self.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            if let offset = change?[NSKeyValueChangeKey.newKey] as? CGPoint {
                DispatchQueue.main.async {
                    self.gx_changeContentOffset(offset)
                }
            }
        }
    }
}

private extension GXMessagesTableView {
    
    func gx_changeContentOffset(_ offset: CGPoint) {
        guard let dataDelegate = self.datalist else { return }
        let lastCell = self.visibleCells.last(where: {$0 is GXMessagesAvatarDataSource})
        guard let lastAvatarCell = lastCell as? GXMessagesAvatarDataSource else { return }
        guard let lastAvatarIndexPath = self.indexPath(for: lastAvatarCell) else { return }
        let previousIndexPath = self.indexPathsForVisibleRows?.last(where: {$0 < lastAvatarIndexPath})

        let lastAvatarID = dataDelegate.gx_tableView(self, avatarIdForRowAt: lastAvatarIndexPath)
        if self.hoverAvatarId != lastAvatarID || (self.hoverMessageStatus == lastAvatarCell.messageStatus && self.hoverMessageStatus == .sending) {
            self.gx_resetPreEndAvatar()
            
            let avatar = lastAvatarCell.createAvatarView()
            dataDelegate.gx_tableView(self, changeForRowAt: lastAvatarIndexPath, avatar: avatar)
            let avatarOrigin = CGPoint(x: lastAvatarCell.avatar.left, y: lastAvatarCell.bottom - lastAvatarCell.avatar.height)
            avatar.frame = CGRect(origin: avatarOrigin, size: lastAvatarCell.avatar.size)
            self.addSubview(avatar)
            self.hoverAvatarId = lastAvatarID
            self.hoverMessageStatus = lastAvatarCell.messageStatus
            self.hoverAvatar = avatar
        }
        else {
            guard let preIndexPath = previousIndexPath else { return }
            if self.cellForRow(at: preIndexPath) is GXMessagesAvatarDataSource {
                if lastAvatarCell.messageContinuousStatus == .end || lastAvatarCell.messageContinuousStatus == .beginAndEnd {
                    lastAvatarCell.avatar.isHidden = true
                    self.lastHiddenIndexPath = lastAvatarIndexPath
                }
            }
            else {
                self.gx_resetPreEndAvatar()
                
                let avatar = lastAvatarCell.createAvatarView()
                dataDelegate.gx_tableView(self, changeForRowAt: lastAvatarIndexPath, avatar: avatar)
                let avatarOrigin = CGPoint(x: lastAvatarCell.avatar.left, y: lastAvatarCell.bottom - lastAvatarCell.avatar.height)
                avatar.frame = CGRect(origin: avatarOrigin, size: lastAvatarCell.avatar.size)
                self.addSubview(avatar)
                self.hoverAvatarId = lastAvatarID
                self.hoverMessageStatus = lastAvatarCell.messageStatus
                self.hoverAvatar = avatar
            }
        }
    
        let cellRect = self.rectForRow(at: lastAvatarIndexPath)
        let cellTop = cellRect.minY - self.contentOffset.y
        let cellBottom = cellRect.maxY - self.contentOffset.y
        let tDifference = self.height - cellTop
        let bDifference = self.height - cellBottom

        guard let avatar = self.hoverAvatar else { return }
        if tDifference >= lastAvatarCell.avatar.height {
            if bDifference <= 0 {
                avatar.top = self.height - avatar.height + self.contentOffset.y
            }
            else {
                avatar.top = cellRect.maxY - avatar.height
            }
        }
        else {
            guard let preIndexPath = previousIndexPath else { return }
            if let preCell = self.cellForRow(at: preIndexPath) as? GXMessagesAvatarDataSource,
               preCell.messageContinuousStatus != .end && preCell.messageContinuousStatus != .beginAndEnd,
               lastAvatarIndexPath.section == preIndexPath.section {
                avatar.top = self.height - avatar.height + self.contentOffset.y
            }
            else {
                avatar.top = cellRect.minY
            }
        }
    }
    
    func gx_resetPreEndAvatar() {
        self.hoverAvatar?.removeFromSuperview()
        if let preEndIndexPath = self.lastHiddenIndexPath,
           let preEndCell = self.cellForRow(at: preEndIndexPath) as? GXMessagesAvatarDataSource,
           preEndCell.messageContinuousStatus == .end || preEndCell.messageContinuousStatus == .beginAndEnd {
            preEndCell.avatar.isHidden = false
        }
    }
    
}
