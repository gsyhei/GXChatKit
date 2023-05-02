//
//  GXMessagesCallLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

public class GXMessagesCallLayout: GXMessagesBaseLayout {

    public var textRect: CGRect = .zero
    public var iconRect: CGRect = .zero
    
    public override func updateLayout(data: GXMessagesDataDelegate) {
        guard let content = data.gx_messagesContent as? GXMessagesCallContent else { return }
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let maxTitleSize = CGSize(width: maxContainerWidth, height: 100)
        let text = content.text + data.gx_messageTime
        let maxTextSize = text.size(size: maxTitleSize, font: GXCHATC.textFont)
        let textSize = content.text.size(size: maxTitleSize, font: GXCHATC.textFont)
        let iconSize = CGSize(width: GXCHATC.textFont.lineHeight * 1.5, height: GXCHATC.textFont.lineHeight)
        content.displaySize = CGSize(width: maxTextSize.width + 10.0 + iconSize.width, height: maxTextSize.height)

        let contentPoint = data.gx_contentPoint
        if data.gx_messageStatus == .sending {
            self.textRect = CGRect(origin: contentPoint, size: textSize)
            self.iconRect = CGRect(origin: CGPoint(x: self.textRect.maxX + 10.0, y: contentPoint.y), size: iconSize)
        }
        else {
            self.iconRect = CGRect(origin: contentPoint, size: iconSize)
            self.textRect = CGRect(origin: CGPoint(x: self.iconRect.maxX + 10.0, y: contentPoint.y), size: textSize)
        }
        
        var containerHeight = content.displaySize.height + GXCHATC.bubbleLeadingInsets.top + GXCHATC.bubbleLeadingInsets.bottom
        if data.gx_isShowNickname {
            containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
        }
        let containerWidth = content.displaySize.width + GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right
        self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
    }
    
}
