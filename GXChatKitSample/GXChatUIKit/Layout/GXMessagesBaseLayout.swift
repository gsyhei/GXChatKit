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
    
    public required init(data: GXMessagesDataDelegate) {
        super.init()
        self.updateLayout(data: data)
    }
    
    public func updateLayout(data: GXMessagesDataDelegate) {
        
    }
    
    public func updateBaseLayout(data: GXMessagesDataDelegate, containerSize: CGSize) {
        let containerLeft = data.gx_containerLeft(container: containerSize.width)
        if data.gx_continuousBegin {
            self.containerRect = CGRect(origin: CGPoint(x: containerLeft, y: GXCHATC.cellMaxLineSpacing), size: containerSize)
        }
        else {
            self.containerRect = CGRect(origin: CGPoint(x: containerLeft, y: GXCHATC.cellMinLineSpacing), size: containerSize)
        }
        if data.gx_continuousEnd {
            self.cellHeight = self.containerRect.maxY + GXCHATC.cellMaxLineSpacing
        }
        else {
            self.cellHeight = self.containerRect.maxY + GXCHATC.cellMinLineSpacing
        }
        
        if data.gx_messageStatus == .send {
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
            let timeSize = data.gx_timeAttributedText?.boundingRect(with: self.containerRect.size, options: .usesLineFragmentOrigin, context: nil).size ?? .zero
            let top = self.containerRect.height - GXCHATC.bubbleTrailingInsets.bottom - timeSize.height
            let left = self.containerRect.width - GXCHATC.bubbleTrailingInsets.right - timeSize.width
            if data.gx_messageSendStatus == .none {
                self.timeRect = CGRect(x: left, y: top, width: timeSize.width, height: timeSize.height)
            } else {
                self.timeRect = CGRect(x: left, y: top+2.0, width: timeSize.width, height: timeSize.height)
            }
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
            let timeSize = data.gx_timeAttributedText?.boundingRect(with: self.containerRect.size, options: .usesLineFragmentOrigin, context: nil).size ?? .zero
            let top = self.containerRect.height - GXCHATC.bubbleLeadingInsets.bottom - timeSize.height
            let left = self.containerRect.width - GXCHATC.bubbleLeadingInsets.right - timeSize.width
            if data.gx_messageSendStatus == .none {
                self.timeRect = CGRect(x: left, y: top, width: timeSize.width, height: timeSize.height)
            } else {
                self.timeRect = CGRect(x: left, y: top+2.0, width: timeSize.width, height: timeSize.height)
            }
        }
    }
}
