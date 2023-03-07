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
    private var hoverAvatars: [UIView] = []
}

public extension GXMessagesTableView {
    
    /// 控制头像的隐藏与显示
    func gx_willDisplay(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let wdCell = cell as? GXMessagesTableViewCell else { return }
        guard let lastIndexPath = self.indexPathsForVisibleRows?.last else { return }
        guard let firstIndexPath = self.indexPathsForVisibleRows?.first else { return }
        guard let dataDelegate = self.datalist else { return }
        
        NSLog("gx_willDisplay: indexPath = \(indexPath.description)")
        // 首加载
        if indexPath <= lastIndexPath && indexPath >= firstIndexPath {
            if let letLastIP = self.indexPathsForVisibleRows?.last(where: {$0 < indexPath}) {
                let wdAvatarID = dataDelegate.tableView(self, avatarIdForRowAt: indexPath)
                let lsAvatarID = dataDelegate.tableView(self, avatarIdForRowAt: letLastIP)

                if indexPath.section != letLastIP.section || wdAvatarID != lsAvatarID {
                    let avatarOrigin = CGPoint(x: wdCell.left, y: wdCell.bottom - wdCell.avatar.height)
                    wdCell.avatar.frame = CGRect(origin: avatarOrigin, size: wdCell.avatar.size)
                    self.addSubview(wdCell.avatar)
                    self.hoverAvatars.append(wdCell.avatar)
                }
            }
            else {
                if indexPath == firstIndexPath && self.hoverAvatars.count > 0 {
                    
                }
                else {
                    let avatarOrigin = CGPoint(x: wdCell.left, y: wdCell.bottom - wdCell.avatar.height)
                    wdCell.avatar.frame = CGRect(origin: avatarOrigin, size: wdCell.avatar.size)
                    self.addSubview(wdCell.avatar)
                    self.hoverAvatars.append(wdCell.avatar)
                }
            }
        }
        // 上拉
        else if indexPath > lastIndexPath {
            let wdAvatarID = dataDelegate.tableView(self, avatarIdForRowAt: indexPath)
            let lsAvatarID = dataDelegate.tableView(self, avatarIdForRowAt: lastIndexPath)

            if indexPath.section != lastIndexPath.section || wdAvatarID != lsAvatarID {
                let avatarOrigin = CGPoint(x: wdCell.left, y: wdCell.bottom - wdCell.avatar.height)
                wdCell.avatar.frame = CGRect(origin: avatarOrigin, size: wdCell.avatar.size)
                self.addSubview(wdCell.avatar)
                self.hoverAvatars.append(wdCell.avatar)
            }
        }
        // 下拉
        else {
            let wdAvatarID = dataDelegate.tableView(self, avatarIdForRowAt: indexPath)
            let fsAvatarID = dataDelegate.tableView(self, avatarIdForRowAt: firstIndexPath)
            
            if indexPath.section != firstIndexPath.section || wdAvatarID != fsAvatarID {
                let avatarOrigin = CGPoint(x: wdCell.left, y: wdCell.bottom - wdCell.avatar.height)
                wdCell.avatar.frame = CGRect(origin: avatarOrigin, size: wdCell.avatar.size)
                self.addSubview(wdCell.avatar)
                self.hoverAvatars.insert(wdCell.avatar, at: 0)
            }
        }
    }
    
    func gx_didEndDisplaying(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let edCell = cell as? GXMessagesTableViewCell else { return }
        guard let lastIndexPath = self.indexPathsForVisibleRows?.last else { return }
        guard let firstIndexPath = self.indexPathsForVisibleRows?.first else { return }
        guard let dataDelegate = self.datalist else { return }
        
        // 上拉
        if indexPath < lastIndexPath {
            let edAvatarID = dataDelegate.tableView(self, avatarIdForRowAt: indexPath)
            let fsAvatarID = dataDelegate.tableView(self, avatarIdForRowAt: firstIndexPath)
            
            if indexPath.section != firstIndexPath.section || edAvatarID != fsAvatarID {
                edCell.avatar.removeFromSuperview()
                self.hoverAvatars.removeFirst()
            }
        }
        // 下拉
        else {
            let edAvatarID = dataDelegate.tableView(self, avatarIdForRowAt: indexPath)
            let lsAvatarID = dataDelegate.tableView(self, avatarIdForRowAt: lastIndexPath)
            
            if indexPath.section != lastIndexPath.section || edAvatarID != lsAvatarID {
                edCell.avatar.removeFromSuperview()
                self.hoverAvatars.removeLast()
            }
        }
    }
    
    func gx_scrollViewChangeContentOffset(_ offset: CGPoint) {
//        guard var indexPaths = self.indexPathsForVisibleRows else { return }
//        var lastCell: GXMessagesTableViewCell?
//        while (lastCell == nil) {
//            guard let lastIndexPath = indexPaths.last else { return }
//            lastCell = self.cellForRow(at: lastIndexPath) as? GXMessagesTableViewCell
//            indexPaths.removeLast()
//        }
//        guard let letLastCell = lastCell else { return }
//
//        if letLastCell.messageContinuousStatus != .end {
//            let avatarOrigin = CGPoint(x: letLastCell.left, y: letLastCell.bottom - letLastCell.avatar.height)
//            letLastCell.avatar.frame = CGRect(origin: avatarOrigin, size: letLastCell.avatar.size)
//            self.addSubview(letLastCell.avatar)
//            self.hoverAvatars.append(letLastCell.avatar)
//        }
    }
    
}
