//
//  GXMessagesItemLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

public class GXMessagesBaseLayout: NSObject {
    
    public var containerRect: CGRect = .zero
    public var avatarRect: CGRect = .zero
    public var nicknameRect: CGRect = .zero
    public var timeRect: CGRect = .zero
    public var cellHeight: CGFloat = 0
    
    public required init(item: GXMessagesItemLayoutData) {
        super.init()
        self.updateLayout(item: item)
    }
    
    public func updateLayout(item: GXMessagesItemLayoutData) {
        
    }
    
    public func updateBaseLayout(item: GXMessagesItemLayoutData, containerSize: CGSize) {
        let containerLeft = item.gx_containerLeft(container: containerSize.width)
        switch item.data.gx_messageContinuousStatus {
        case .begin:
            self.containerRect = CGRect(origin: CGPoint(x: containerLeft, y: GXCHATC.cellMaxLineSpacing), size: containerSize)
            self.cellHeight = self.containerRect.maxY + GXCHATC.cellMinLineSpacing
        case .ongoing:
            self.containerRect = CGRect(origin: CGPoint(x: containerLeft, y: GXCHATC.cellMinLineSpacing), size: containerSize)
            self.cellHeight = self.containerRect.maxY + GXCHATC.cellMinLineSpacing
        case .end:
            self.containerRect = CGRect(origin: CGPoint(x: containerLeft, y: GXCHATC.cellMinLineSpacing), size: containerSize)
            self.cellHeight = self.containerRect.maxY + GXCHATC.cellMaxLineSpacing
        case .beginAndEnd:
            self.containerRect = CGRect(origin: CGPoint(x: containerLeft, y: GXCHATC.cellMaxLineSpacing), size: containerSize)
            self.cellHeight = self.containerRect.maxY + GXCHATC.cellMaxLineSpacing
        }
        
        if item.data.gx_messageStatus == .sending {
            if item.gx_isShowAvatar {
                let avatarTop = self.cellHeight - GXCHATC.avatarSize.height - 2.0
                self.avatarRect = CGRect(origin: CGPoint(x: self.containerRect.maxX + GXCHATC.avatarMargin, y: avatarTop), size: GXCHATC.avatarSize)
            }
            if item.gx_isShowNickname {
                let top = GXCHATC.bubbleTrailingInset.top
                let maxWidth = self.containerRect.width - GXCHATC.bubbleTrailingInset.left - GXCHATC.bubbleTrailingInset.right
                let maxHeight = GXCHATC.nicknameFont.lineHeight
                let nameSize = item.data.gx_senderDisplayName.size(size: CGSize(width: maxWidth, height: maxHeight), font: GXCHATC.nicknameFont)
                let left = self.containerRect.width - GXCHATC.bubbleTrailingInset.right - nameSize.width
                self.nicknameRect = CGRect(x: left, y: top, width: nameSize.width, height: nameSize.height)
            }
            let timeSize = item.data.gx_messageTime.size(size: self.containerRect.size, font: GXCHATC.timeFont)
            let top = self.containerRect.height - GXCHATC.bubbleTrailingInset.bottom - timeSize.height
            let left = self.containerRect.width - GXCHATC.bubbleTrailingInset.right - timeSize.width
            self.timeRect = CGRect(x: left, y: top, width: timeSize.width, height: timeSize.height)
        }
        else {
            if item.gx_isShowAvatar {
                let avatarTop = self.cellHeight - GXCHATC.avatarSize.height - 2.0
                self.avatarRect = CGRect(origin: CGPoint(x: GXCHATC.avatarMargin, y: avatarTop), size: GXCHATC.avatarSize)
            }
            if item.gx_isShowNickname {
                let left = GXCHATC.bubbleLeadingInset.left, top =  GXCHATC.bubbleLeadingInset.top
                let maxWidth = self.containerRect.width - GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
                let maxHeight = GXCHATC.nicknameFont.lineHeight
                let nameSize = item.data.gx_senderDisplayName.size(size: CGSize(width: maxWidth, height: maxHeight), font: GXCHATC.nicknameFont)
                self.nicknameRect = CGRect(x: left, y: top, width: nameSize.width, height: nameSize.height)
            }
            let timeSize = item.data.gx_messageTime.size(size: self.containerRect.size, font: GXCHATC.timeFont)
            let top = self.containerRect.height - GXCHATC.bubbleLeadingInset.bottom - timeSize.height
            let left = self.containerRect.width - GXCHATC.bubbleLeadingInset.right - timeSize.width
            self.timeRect = CGRect(x: left, y: top, width: timeSize.width, height: timeSize.height)
        }
    }
}
