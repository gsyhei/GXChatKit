//
//  GXMessagesCallLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

class GXMessagesCallLayout: GXMessagesBaseLayout {

    public var textRect: CGRect = .zero
    public var iconRect: CGRect = .zero
    
    public override func updateLayout(item: GXMessagesItemLayoutData) {
        guard let content = item.data.gx_messagesContentData as? GXMessagesCallContent else { return }
        let hookWidth = GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
        let maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let maxTitleSize = CGSize(width: maxContainerWidth, height: 100)
        let text = content.text + item.data.gx_messageTime
        let maxTextSize = text.size(size: maxTitleSize, font: GXCHATC.textFont)
        let textSize = content.text.size(size: maxTitleSize, font: GXCHATC.textFont)
        let iconSize = CGSize(width: GXCHATC.textFont.lineHeight * 1.5, height: GXCHATC.textFont.lineHeight)
        content.displaySize = CGSize(width: maxTextSize.width + 10.0 + iconSize.width, height: maxTextSize.height)

        let contentPoint = item.gx_contentPoint
        if item.data.gx_messageStatus == .sending {
            self.textRect = CGRect(origin: contentPoint, size: textSize)
            self.iconRect = CGRect(origin: CGPoint(x: self.textRect.maxX + 10.0, y: contentPoint.y), size: iconSize)
        }
        else {
            self.iconRect = CGRect(origin: contentPoint, size: iconSize)
            self.textRect = CGRect(origin: CGPoint(x: self.iconRect.maxX + 10.0, y: contentPoint.y), size: textSize)
        }
        
        var containerHeight = content.displaySize.height + GXCHATC.bubbleLeadingInset.top + GXCHATC.bubbleLeadingInset.bottom
        if item.gx_isShowNickname {
            containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
        }
        let containerWidth = content.displaySize.width + GXCHATC.bubbleLeadingInset.left + GXCHATC.bubbleLeadingInset.right
        self.updateBaseLayout(item: item, containerSize: CGSizeMake(containerWidth, containerHeight))
    }
    
}
