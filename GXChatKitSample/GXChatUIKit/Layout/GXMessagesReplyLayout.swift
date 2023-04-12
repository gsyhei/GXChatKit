//
//  GXMessagesReplyLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/12.
//

import UIKit

public class GXMessagesReplyLayout: GXMessagesBaseLayout {
    public var replyContentRect: CGRect = .zero
    public var replyVLineRect: CGRect = .zero
    public var replyIconRect: CGRect = .zero
    public var replyFileExtRect: CGRect = .zero
    public var replyNameRect: CGRect = .zero
    public var replyTextRect: CGRect = .zero
    public var textRect: CGRect = .zero
    
    public override func updateLayout(data: GXMessagesDataProtocol) {
        guard let content = data.gx_messagesContent as? GXMessagesReplyContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let maxContainerWidth = SCREEN_WIDTH - data.gx_avatarContentWidth - hookWidth
        let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        
        let contentPoint = data.gx_contentPoint
        self.replyVLineRect = CGRect(origin: contentPoint, size: CGSizeMake(GXCHATC.replyVLineWidth, GXCHATC.replyIconSize.height))
        
        var contentLeft = self.replyVLineRect.width + 5.0
        if content.isShowIcon {
            self.replyIconRect = CGRect(origin: CGPoint(x: contentPoint.x + contentLeft, y: contentPoint.y), size: GXCHATC.replyIconSize)
            self.replyFileExtRect = self.replyIconRect.inset(by: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0))
            contentLeft += (GXCHATC.replyIconSize.width + 5.0)
        }
        
        let replyNameWidth = content.replyData.gx_senderDisplayName.width(font: GXCHATC.nicknameFont)
        var contentWidth = min(maxContentWidth, replyNameWidth + contentLeft)

        let replyContentTextWidth = content.replyContentText.width(font: GXCHATC.replyContentFont)
        contentWidth = max(contentWidth, min(maxContentWidth, replyContentTextWidth + contentLeft))

        let attributedText = NSMutableAttributedString(attributedString: content.attributedText)
        attributedText.append(NSAttributedString(string: data.gx_messageTime))
        let maxTextSize = CGSizeMake(maxContentWidth, 10000)
        let displaySize = attributedText.boundingRect(with: maxTextSize, options: .usesLineFragmentOrigin, context: nil).size
        contentWidth = max(contentWidth, min(maxContentWidth, displaySize.width))
        
        if data.gx_isShowNickname {
            let nickNameWidth = data.gx_senderDisplayName.width(font: GXCHATC.nicknameFont)
            contentWidth = max(contentWidth, min(maxContentWidth, nickNameWidth))
        }
        content.displaySize = CGSize(width: max(contentWidth, displaySize.width), height: displaySize.height)
        
        let replyNameTop = contentPoint.y + GXCHATC.replyIconSize.height/2 - GXCHATC.nicknameFont.lineHeight - 1.0
        self.replyNameRect = CGRect(x: contentPoint.x + contentLeft, y: replyNameTop, width: contentWidth - contentLeft, height: GXCHATC.nicknameFont.lineHeight)
        let replyTextTop =  contentPoint.y + GXCHATC.replyIconSize.height/2 + 1.0
        self.replyTextRect = CGRect(x: contentPoint.x + contentLeft, y: replyTextTop, width: contentWidth - contentLeft, height: GXCHATC.replyContentFont.lineHeight)
        self.replyContentRect = CGRect(origin: contentPoint, size: CGSize(width: contentWidth, height: GXCHATC.replyIconSize.height))
        self.textRect = CGRect(origin: CGPoint(x: contentPoint.x, y: self.replyContentRect.maxY + 6.0), size: content.displaySize)
        
        let containerHeight = self.textRect.maxY + GXCHATC.bubbleLeadingInsets.bottom
        let containerWidth = contentWidth + GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right
        self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
    }
    
}
