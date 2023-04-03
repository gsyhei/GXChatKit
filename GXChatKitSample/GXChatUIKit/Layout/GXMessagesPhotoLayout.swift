//
//  GXMessagesPhotoLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

public class GXMessagesPhotoLayout: GXMessagesBaseLayout {
    
    public var imageRect: CGRect = .zero

    public override func updateLayout(data: GXMessagesDataProtocol) {
        guard let content = data.gx_messagesContent as? GXMessagesPhotoContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let contentSize = GXUtilManager.gx_imageResize(size: content.displaySize, maxSize: CGSize(width: maxContainerWidth, height: SCREEN_HEIGHT/2))
        self.imageRect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        self.updateBaseLayout(data: data, containerSize: contentSize)
    }
    
}
