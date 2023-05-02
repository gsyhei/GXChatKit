//
//  GXMessagesLocationLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

public class GXMessagesLocationLayout: GXMessagesBaseLayout {
    
    public var imageRect: CGRect = .zero
    public var locationContentRect: CGRect = .zero
    public var locationTitleRect: CGRect = .zero

    public override func updateLayout(data: GXMessagesDataDelegate) {
        guard let content = data.gx_messagesContent as? GXMessagesLocationContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        let maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let contentSize = GXUtilManager.gx_imageResize(size: content.displaySize, maxSize: CGSize(width: maxContainerWidth, height: SCREEN_HEIGHT/2))
        self.imageRect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        
        let maxContentWidth = contentSize.width - GXCHATC.bubbleTrailingInsets.left - GXCHATC.bubbleTrailingInsets.right
        let text = content.locationTitle + data.gx_messageTime
        let maxTitleSize = CGSize(width: maxContentWidth, height: contentSize.height)
        let titleHeight = text.size(size: maxTitleSize, font: GXCHATC.locationTextFont).height
        let locationContentSize = CGSize(width: contentSize.width, height: titleHeight + 10.0 + GXCHATC.bubbleTrailingInsets.bottom)
        let locationContentTop = contentSize.height - locationContentSize.height
        self.locationContentRect = CGRect(origin: CGPoint(x: 0, y: locationContentTop), size: locationContentSize)
        if data.gx_messageStatus == .sending {
            let left = GXCHATC.bubbleTrailingInsets.left
            self.locationTitleRect = CGRect(x: left, y: 0, width: maxContentWidth, height: self.locationContentRect.height)
        }
        else {
            let left = GXCHATC.bubbleLeadingInsets.left
            self.locationTitleRect = CGRect(x: left, y: 0, width: maxContentWidth, height: self.locationContentRect.height)
        }
        self.updateBaseLayout(data: data, containerSize: contentSize)
    }
    
}
