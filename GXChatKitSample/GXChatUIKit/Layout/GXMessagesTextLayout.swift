//
//  GXMessagesTextLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

public class GXMessagesTextLayout: GXMessagesBaseLayout {
    
    public var textRect: CGRect = .zero

    public override func updateLayout(data: GXMessagesDataProtocol) {
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let maxContainerWidth = SCREEN_WIDTH - data.gx_avatarContentWidth - hookWidth
        let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        
        if let content = data.gx_messagesContent as? GXMessagesTextContent {
            let attributedText = NSMutableAttributedString(attributedString: content.attributedText)
            attributedText.append(NSAttributedString(string: data.gx_messageTime))
            let maxTextSize = CGSizeMake(maxContentWidth, 10000)
            let displaySize = attributedText.boundingRect(with: maxTextSize, options: .usesLineFragmentOrigin, context: nil).size
            if data.gx_isShowNickname {
                var nickNameWidth = data.gx_senderDisplayName.height(width: maxContentWidth, font: GXCHATC.nicknameFont)
                nickNameWidth = min(nickNameWidth, maxContentWidth)
                content.displaySize = CGSize(width: max(nickNameWidth, displaySize.width), height: displaySize.height)
            }
            else {
                content.displaySize = displaySize
            }
            
            let contentPoint = data.gx_contentPoint
            self.textRect = CGRect(origin: contentPoint, size: content.displaySize)

            var containerHeight = content.displaySize.height + GXCHATC.bubbleLeadingInsets.top + GXCHATC.bubbleLeadingInsets.bottom
            if data.gx_isShowNickname {
                containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
            }
            let containerWidth = content.displaySize.width + GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right
            self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
        }
        else if let content = data.gx_messagesContent as? GXMessagesAtContent {
            let attributedText = NSMutableAttributedString(attributedString: content.attributedText)
            attributedText.append(NSAttributedString(string: data.gx_messageTime))
            let maxTextSize = CGSizeMake(maxContentWidth, 10000)
            let displaySize = attributedText.boundingRect(with: maxTextSize, options: .usesLineFragmentOrigin, context: nil).size
            if data.gx_isShowNickname {
                var nickNameWidth = data.gx_senderDisplayName.height(width: maxContentWidth, font: GXCHATC.nicknameFont)
                nickNameWidth = min(nickNameWidth, maxContentWidth)
                content.displaySize = CGSize(width: max(nickNameWidth, displaySize.width), height: displaySize.height)
            }
            else {
                content.displaySize = displaySize
            }
            
            let contentPoint = data.gx_contentPoint
            self.textRect = CGRect(origin: contentPoint, size: content.displaySize)

            var containerHeight = content.displaySize.height + GXCHATC.bubbleLeadingInsets.top + GXCHATC.bubbleLeadingInsets.bottom
            if data.gx_isShowNickname {
                containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
            }
            let containerWidth = content.displaySize.width + GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right
            self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
        }
        else if let content = data.gx_messagesContent as? GXMessagesForwardContent {
            let attributedText = NSMutableAttributedString(attributedString: content.attributedText)
            attributedText.append(NSAttributedString(string: data.gx_messageTime))
            let maxTextSize = CGSizeMake(maxContentWidth, 10000)
            let displaySize = attributedText.boundingRect(with: maxTextSize, options: .usesLineFragmentOrigin, context: nil).size
            if data.gx_isShowNickname {
                var nickNameWidth = data.gx_senderDisplayName.height(width: maxContentWidth, font: GXCHATC.nicknameFont)
                nickNameWidth = min(nickNameWidth, maxContentWidth)
                content.displaySize = CGSize(width: max(nickNameWidth, displaySize.width), height: displaySize.height)
            }
            else {
                content.displaySize = displaySize
            }
            
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
    
}
