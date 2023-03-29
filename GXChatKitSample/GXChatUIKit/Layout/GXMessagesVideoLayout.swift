//
//  GXMessagesVideoLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

class GXMessagesVideoLayout: GXMessagesBaseLayout {

    public var imageRect: CGRect = .zero

    public override func updateLayout(item: GXMessagesItemLayoutData) {
        guard let content = item.data.gx_messagesContentData as? GXMessagesVideoContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
        let maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let contentSize = item.gx_imageResize(size: content.displaySize, maxSize: CGSize(width: maxContainerWidth, height: SCREEN_HEIGHT/2))
        self.imageRect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        self.updateBaseLayout(item: item, containerSize: contentSize)
    }
    
}
