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
    
    public required init(data: GXMessagesDataProtocol) {
        super.init()
        self.updateLayout(data: data)
    }
    
    public func updateLayout(data: GXMessagesDataProtocol) {
        
    }
    
    public func updateBaseLayout(data: GXMessagesDataProtocol, containerSize: CGSize) {
        let containerLeft = data.gx_containerLeft(container: containerSize.width)
        switch data.gx_messageContinuousStatus {
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
        
        if data.gx_messageStatus == .sending {
            if data.gx_isShowAvatar {
                let avatarTop = self.cellHeight - GXCHATC.avatarSize.height - 2.0
                self.avatarRect = CGRect(origin: CGPoint(x: self.containerRect.maxX + GXCHATC.avatarMargin, y: avatarTop), size: GXCHATC.avatarSize)
            }
            if data.gx_isShowNickname {
                let left = GXCHATC.bubbleTrailingInsets.left, top =  GXCHATC.bubbleTrailingInsets.top
                let width = self.containerRect.width - GXCHATC.bubbleTrailingInsets.left - GXCHATC.bubbleTrailingInsets.right
                let height = GXCHATC.nicknameFont.lineHeight
                self.nicknameRect = CGRect(x: left, y: top, width: width, height: height)
            }
            let timeSize = data.gx_messageTime.size(size: self.containerRect.size, font: GXCHATC.timeFont)
            let top = self.containerRect.height - GXCHATC.bubbleTrailingInsets.bottom - timeSize.height
            let left = self.containerRect.width - GXCHATC.bubbleTrailingInsets.right - timeSize.width
            self.timeRect = CGRect(x: left, y: top, width: timeSize.width, height: timeSize.height)
        }
        else {
            if data.gx_isShowAvatar {
                let avatarTop = self.cellHeight - GXCHATC.avatarSize.height - 2.0
                self.avatarRect = CGRect(origin: CGPoint(x: GXCHATC.avatarMargin, y: avatarTop), size: GXCHATC.avatarSize)
            }
            if data.gx_isShowNickname {
                let left = GXCHATC.bubbleLeadingInsets.left, top =  GXCHATC.bubbleLeadingInsets.top
                let width = self.containerRect.width - GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
                let height = GXCHATC.nicknameFont.lineHeight
                self.nicknameRect = CGRect(x: left, y: top, width: width, height: height)
            }
            let timeSize = data.gx_messageTime.size(size: self.containerRect.size, font: GXCHATC.timeFont)
            let top = self.containerRect.height - GXCHATC.bubbleLeadingInsets.bottom - timeSize.height
            let left = self.containerRect.width - GXCHATC.bubbleLeadingInsets.right - timeSize.width
            self.timeRect = CGRect(x: left, y: top, width: timeSize.width, height: timeSize.height)
        }
    }
}
