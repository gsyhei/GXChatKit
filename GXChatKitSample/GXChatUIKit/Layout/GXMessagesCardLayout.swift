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

    public override func updateLayout(data: GXMessagesDataDelegate) {
        guard let content = data.gx_messagesContent as? GXMessagesCardContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let maxContainerWidth = SCREEN_MIN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let contentWidth = maxContentWidth * GXCHATC.cardMaxWidthScale
        let contentHeight = GXCHATC.avatarSize.height
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
        
        let cardTypeWidth = content.cardTypeName.size(size: CGSizeMake(1000, GXCHATC.textFont.lineHeight), font: GXCHATC.textFont).width
        let cardTypePoint = CGPoint(x:contentPoint.x, y: self.timeRect.minY)
        let cardTypeSize = CGSize(width: cardTypeWidth, height: GXCHATC.timeFont.lineHeight)
        self.cardTypeRect = CGRect(origin: cardTypePoint, size: cardTypeSize)
    }
    
}
