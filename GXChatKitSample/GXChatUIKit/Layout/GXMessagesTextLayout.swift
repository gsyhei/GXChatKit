//
//  GXMessagesTextLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

class GXMessagesTextLayout: GXMessagesBaseLayout {
    
    public var textRect: CGRect = .zero

    public override func updateLayout(item: GXMessagesItemLayoutData) {
        guard let content = item.data.gx_messagesContentData as? GXMessagesTextContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
        let maxContainerWidth = SCREEN_WIDTH - item.gx_avatarContentWidth - hookWidth
        let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
        let attributedText = NSMutableAttributedString(attributedString: content.attributedText)
        attributedText.append(NSAttributedString(string: item.data.gx_messageTime))
        let maxTextSize = CGSizeMake(maxContentWidth, 10000)
        content.displaySize = attributedText.boundingRect(with: maxTextSize, options: .usesLineFragmentOrigin, context: nil).size
        
        let contentPoint = item.gx_contentPoint
        self.textRect = CGRect(origin: contentPoint, size: content.displaySize)

        var containerHeight = content.displaySize.height + GXCHATC.bubbleLeadingInset.top + GXCHATC.bubbleLeadingInset.bottom
        if item.gx_isShowNickname {
            containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
        }
        let containerWidth = content.displaySize.width + GXCHATC.bubbleLeadingInset.left + GXCHATC.bubbleLeadingInset.right
        self.updateBaseLayout(item: item, containerSize: CGSizeMake(containerWidth, containerHeight))
    }
    
}
