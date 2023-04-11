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
    public var replyNameRect: CGRect = .zero
    public var replyTextRect: CGRect = .zero
    public var textRect: CGRect = .zero
    
    public override func updateLayout(data: GXMessagesDataProtocol) {
        guard let content = data.gx_messagesContent as? GXMessagesReplyContent else { return }
        
        switch content.replyData.gx_messageType {
        case .text:
            self.updateTextLayout(content: content, data: data)
            
        default: break
        }
    }
    
}

private extension GXMessagesReplyLayout {
    
    func updateTextLayout(content: GXMessagesReplyContent, data: GXMessagesDataProtocol) {
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let maxContainerWidth = SCREEN_WIDTH - data.gx_avatarContentWidth - hookWidth
        let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        
        
        
        
        let attributedText = NSMutableAttributedString(attributedString: content.attributedText)
        attributedText.append(NSAttributedString(string: data.gx_messageTime))
        let maxTextSize = CGSizeMake(maxContentWidth, 10000)
        content.displaySize = attributedText.boundingRect(with: maxTextSize, options: .usesLineFragmentOrigin, context: nil).size
        
        let contentPoint = data.gx_contentPoint
        self.textRect = CGRect(origin: contentPoint, size: content.displaySize)

        var containerHeight = content.displaySize.height + GXCHATC.bubbleLeadingInsets.top + GXCHATC.bubbleLeadingInsets.bottom
        if data.gx_isShowNickname {
            containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
        }
        let containerWidth = content.displaySize.width + GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right
        self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
        
    }
    
}
