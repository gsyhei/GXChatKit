//
//  GXMessagesTableView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/6.
//

import UIKit

public class GXMessagesTableView: GXMessagesLoadTableView {
    private var hoverAvatars: [UIView] = []
}

public extension GXMessagesTableView {
    
    /// 控制头像的隐藏与显示
    func gx_willDisplay(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let wdCell = cell as? GXMessagesTableViewCell else { return }
        if wdCell.messageContinuousStatus == .end {
            let avatarOrigin = CGPoint(x: wdCell.left, y: wdCell.bottom - wdCell.avatar.height)
            wdCell.avatar.frame = CGRect(origin: avatarOrigin, size: wdCell.avatar.size)
            self.addSubview(wdCell.avatar)
            self.hoverAvatars.append(wdCell.avatar)
        }
    }
    
    func gx_didEndDisplaying(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let edCell = cell as? GXMessagesTableViewCell else { return }
        
        if let index = self.hoverAvatars.firstIndex(of: edCell.avatar) {
            edCell.avatar.removeFromSuperview()
            self.hoverAvatars.remove(at: index)
        }
    }
    
    func gx_scrollViewChangeContentOffset(_ offset: CGPoint) {
        guard var indexPaths = self.indexPathsForVisibleRows else { return }
        var lastCell: GXMessagesTableViewCell?
        while (lastCell == nil) {
            guard let lastIndexPath = indexPaths.last else { return }
            lastCell = self.cellForRow(at: lastIndexPath) as? GXMessagesTableViewCell
            indexPaths.removeLast()
        }
        guard let letLastCell = lastCell else { return }
        
        if letLastCell.messageContinuousStatus != .end {
            let avatarOrigin = CGPoint(x: letLastCell.left, y: letLastCell.bottom - letLastCell.avatar.height)
            letLastCell.avatar.frame = CGRect(origin: avatarOrigin, size: letLastCell.avatar.size)
            self.addSubview(letLastCell.avatar)
            self.hoverAvatars.append(letLastCell.avatar)
        }
    }
    
}
