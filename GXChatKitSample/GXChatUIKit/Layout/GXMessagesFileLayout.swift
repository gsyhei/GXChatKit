//
//  GXMessagesFileLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/7.
//

import UIKit

public class GXMessagesFileLayout: GXMessagesBaseLayout {
    
    public var fileIconRect: CGRect = .zero
    public var fileNameRect: CGRect = .zero
    public var fileExtRect: CGRect = .zero
    public var fileLineRect: CGRect = .zero

    public override func updateLayout(data: GXMessagesDataDelegate) {
        guard let content = data.gx_messagesContent as? GXMessagesFileContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let maxContainerWidth = SCREEN_MIN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let contentWidth = maxContentWidth * GXCHATC.fileMaxWidthScale
        let contentHeight = GXCHATC.fileIconSize.height
        content.displaySize = CGSize(width: contentWidth, height: contentHeight)
        
        let contentPoint = data.gx_contentPoint
        self.fileIconRect = CGRect(origin: contentPoint, size: GXCHATC.fileIconSize)
        self.fileExtRect = self.fileIconRect.inset(by: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0))
        let fileNamePoint = CGPoint(x: self.fileIconRect.maxX + 10, y: contentPoint.y)
        let fileNameSize = CGSize(width: contentWidth - GXCHATC.fileIconSize.width - 10, height: GXCHATC.fileIconSize.height)
        self.fileNameRect = CGRect(origin: fileNamePoint, size: fileNameSize)
        
        var containerHeight = content.displaySize.height + GXCHATC.timeFont.lineHeight + 10
        containerHeight += (GXCHATC.bubbleLeadingInsets.top + GXCHATC.bubbleLeadingInsets.bottom)
        if data.gx_isShowNickname {
            containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
        }
        let lineTop = containerHeight - GXCHATC.timeFont.lineHeight - 15
        self.fileLineRect = CGRect(origin: CGPoint(x: contentPoint.x, y: lineTop), size: CGSize(width: contentWidth, height: 0.5))
        
        let containerWidth = contentWidth + GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right
        self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
    }
    
}

