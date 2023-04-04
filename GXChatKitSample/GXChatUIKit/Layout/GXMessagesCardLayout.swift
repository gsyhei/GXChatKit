//
//  GXMessagesCardLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/5.
//

import UIKit

public class GXMessagesCardLayout: GXMessagesBaseLayout {
    
    public var cardAvatarRect: CGRect = .zero
    public var cardNameRect: CGRect = .zero
    public var cardTypeRect: CGRect = .zero
    public var cardLineRect: CGRect = .zero

    public override func updateLayout(data: GXMessagesDataProtocol) {
        guard let content = data.gx_messagesContent as? GXMessagesCardContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let maxNameWidth = maxContentWidth - GXCHATC.avatarSize.width - 10
        let maxNameSize = CGSizeMake(10000, 10000)
        let lineNameWidth = content.contact.gx_displayName.size(size: maxNameSize, font: GXCHATC.textFont).width
        let nameWidth = min(lineNameWidth, maxNameWidth)
        
        var contentWidth = nameWidth + GXCHATC.avatarSize.width + 10
        var contentHeight = GXCHATC.avatarSize.height
        let bottomText = content.cardTypeName + data.gx_messageTime
        let bottomTextWidth = bottomText.size(size: maxNameSize, font: GXCHATC.textFont).width + 10
        if bottomTextWidth > maxContentWidth {
            contentHeight += GXCHATC.timeFont.lineHeight
        }
        else if bottomTextWidth > contentWidth {
            contentWidth = bottomTextWidth
        }
        content.displaySize = CGSize(width: contentWidth, height: contentHeight)
        
        let contentPoint = data.gx_contentPoint
        self.cardAvatarRect = CGRect(origin: contentPoint, size: GXCHATC.avatarSize)
        let cardNamePoint = CGPoint(x: self.cardAvatarRect.maxX + 10, y: contentPoint.y)
        let cardNameSize = CGSize(width: contentWidth - GXCHATC.avatarSize.width - 10, height: GXCHATC.avatarSize.height)
        self.cardNameRect = CGRect(origin: cardNamePoint, size: cardNameSize)
        
        var containerHeight = content.displaySize.height + GXCHATC.timeFont.lineHeight + 10
        containerHeight += (GXCHATC.bubbleLeadingInsets.top + GXCHATC.bubbleLeadingInsets.bottom)
        if data.gx_isShowNickname {
            containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
        }
        let lineTop = containerHeight - GXCHATC.timeFont.lineHeight - 15
        self.cardLineRect = CGRect(origin: CGPoint(x: contentPoint.x, y: lineTop), size: CGSize(width: contentWidth, height: 0.5))

        let containerWidth = contentWidth + GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right
        self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
        
        let cardTypePoint = CGPoint(x:contentPoint.x, y: self.timeRect.minY)
        let cardTypeSize = CGSize(width: bottomTextWidth - self.timeRect.width, height: GXCHATC.timeFont.lineHeight)
        self.cardTypeRect = CGRect(origin: cardTypePoint, size: cardTypeSize)
    }
    
}
