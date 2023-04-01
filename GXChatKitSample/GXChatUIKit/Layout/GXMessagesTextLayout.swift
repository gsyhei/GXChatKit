//
//  GXMessagesTextLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

class GXMessagesTextLayout: GXMessagesBaseLayout {
    
    public var textRect: CGRect = .zero

    public override func updateLayout(data: GXMessagesDataProtocol) {
        if let content = data.gx_messagesContentData as? GXMessagesTextContent {
            let hookWidth = GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
            let maxContainerWidth = SCREEN_WIDTH - data.gx_avatarContentWidth - hookWidth
            let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
            let attributedText = NSMutableAttributedString(attributedString: content.attributedText)
            attributedText.append(NSAttributedString(string: data.gx_messageTime))
            let maxTextSize = CGSizeMake(maxContentWidth, 10000)
            content.displaySize = attributedText.boundingRect(with: maxTextSize, options: .usesLineFragmentOrigin, context: nil).size
            
            let contentPoint = data.gx_contentPoint
            self.textRect = CGRect(origin: contentPoint, size: content.displaySize)

            var containerHeight = content.displaySize.height + GXCHATC.bubbleLeadingInset.top + GXCHATC.bubbleLeadingInset.bottom
            if data.gx_isShowNickname {
                containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
            }
            let containerWidth = content.displaySize.width + GXCHATC.bubbleLeadingInset.left + GXCHATC.bubbleLeadingInset.right
            self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
        }
        else if let content = data.gx_messagesContentData as? GXMessagesAtContent {
            let hookWidth = GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
            let maxContainerWidth = SCREEN_WIDTH - data.gx_avatarContentWidth - hookWidth
            let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
            let attributedText = NSMutableAttributedString(attributedString: content.attributedText)
            attributedText.append(NSAttributedString(string: data.gx_messageTime))
            let maxTextSize = CGSizeMake(maxContentWidth, 10000)
            content.displaySize = attributedText.boundingRect(with: maxTextSize, options: .usesLineFragmentOrigin, context: nil).size
            
            let contentPoint = data.gx_contentPoint
            self.textRect = CGRect(origin: contentPoint, size: content.displaySize)

            var containerHeight = content.displaySize.height + GXCHATC.bubbleLeadingInset.top + GXCHATC.bubbleLeadingInset.bottom
            if data.gx_isShowNickname {
                containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
            }
            let containerWidth = content.displaySize.width + GXCHATC.bubbleLeadingInset.left + GXCHATC.bubbleLeadingInset.right
            self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
        }
        else if let content = data.gx_messagesContentData as? GXMessagesForwardContent {
            let hookWidth = GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
            let maxContainerWidth = SCREEN_WIDTH - data.gx_avatarContentWidth - hookWidth
            let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
            let attributedText = NSMutableAttributedString(attributedString: content.attributedText)
            attributedText.append(NSAttributedString(string: data.gx_messageTime))
            let maxTextSize = CGSizeMake(maxContentWidth, 10000)
            content.displaySize = attributedText.boundingRect(with: maxTextSize, options: .usesLineFragmentOrigin, context: nil).size
            
            let contentPoint = data.gx_contentPoint
            self.textRect = CGRect(origin: contentPoint, size: content.displaySize)

            var containerHeight = content.displaySize.height + GXCHATC.bubbleLeadingInset.top + GXCHATC.bubbleLeadingInset.bottom
            if data.gx_isShowNickname {
                containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
            }
            let containerWidth = content.displaySize.width + GXCHATC.bubbleLeadingInset.left + GXCHATC.bubbleLeadingInset.right
            self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
        }
    }
    
}
