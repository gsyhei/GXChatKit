//
//  GXMessagesRedPacketLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/8.
//

import UIKit

public class GXMessagesRedPacketLayout: GXMessagesBaseLayout {
    
    public var rpIconRect: CGRect = .zero
    public var rpTextRect: CGRect = .zero
    public var rpStatusRect: CGRect = .zero
    public var rpLineRect: CGRect = .zero
    public var rpNameRect: CGRect = .zero
    
    public override func updateLayout(data: GXMessagesDataProtocol) {
        guard let content = data.gx_messagesContent as? GXMessagesRedPacketContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let maxContainerWidth = SCREEN_MIN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let contentWidth = maxContentWidth * GXCHATC.fileMaxWidthScale
        let contentHeight = GXCHATC.redPacketIconSize.height
        content.displaySize = CGSize(width: contentWidth, height: contentHeight)
        
        let contentPoint = data.gx_contentPoint
        self.rpIconRect = CGRect(origin: contentPoint, size: GXCHATC.redPacketIconSize)
        let textPoint = CGPoint(x: self.rpIconRect.maxX + 10, y: contentPoint.y)
        let textSize = CGSize(width: contentWidth - GXCHATC.redPacketIconSize.width - 10, height: GXCHATC.redPacketIconSize.height/2)
        self.rpTextRect = CGRect(origin: textPoint, size: textSize)
        self.rpStatusRect = CGRect(origin: CGPoint(x: self.rpTextRect.origin.x, y: self.rpTextRect.maxY), size: textSize)
        
        var containerHeight = content.displaySize.height + GXCHATC.timeFont.lineHeight + 10
        containerHeight += (GXCHATC.bubbleLeadingInsets.top + GXCHATC.bubbleLeadingInsets.bottom)
        if data.gx_isShowNickname {
            containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
        }
        let lineTop = containerHeight - GXCHATC.timeFont.lineHeight - 15
        self.rpLineRect = CGRect(origin: CGPoint(x: contentPoint.x, y: lineTop), size: CGSize(width: contentWidth, height: 0.5))
        
        let containerWidth = contentWidth + GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right
        self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
        
        let nameWidth = content.name.size(size: CGSizeMake(1000, GXCHATC.textFont.lineHeight), font: GXCHATC.textFont).width
        let namePoint = CGPoint(x:contentPoint.x, y: self.timeRect.minY)
        let nameSize = CGSize(width: nameWidth, height: GXCHATC.timeFont.lineHeight)
        self.rpNameRect = CGRect(origin: namePoint, size: nameSize)
    }
    
}
