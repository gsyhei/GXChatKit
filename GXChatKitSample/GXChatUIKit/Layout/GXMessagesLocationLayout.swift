//
//  GXMessagesLocationLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

class GXMessagesLocationLayout: GXMessagesBaseLayout {
    
    public var imageRect: CGRect = .zero
    public var locationContentRect: CGRect = .zero
    public var locationTitleRect: CGRect = .zero

    public override func updateLayout(item: GXMessagesItemLayoutData) {
        guard let content = item.data.gx_messagesContentData as? GXMessagesLocationContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
        let maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let contentSize = item.gx_imageResize(size: content.displaySize, maxSize: CGSize(width: maxContainerWidth, height: SCREEN_HEIGHT/2))
        self.imageRect = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        
        let maxContentWidth = maxContainerWidth - hookWidth
        let text = content.locationTitle + item.data.gx_messageTime
        let maxTitleSize = CGSize(width: maxContentWidth - 16.0, height: contentSize.height)
        let titleHeight = text.size(size: maxTitleSize, font: GXCHATC.locationTextFont).height
        let locationContentSize = CGSize(width: contentSize.width, height: titleHeight + 10.0 + GXCHATC.bubbleTrailingInset.bottom)
        let locationContentTop = contentSize.height - locationContentSize.height
        self.locationContentRect = CGRect(origin: CGPoint(x: 0, y: locationContentTop), size: locationContentSize)
        if item.data.gx_messageStatus == .sending {
            let left = GXCHATC.bubbleTrailingInset.left
            let width = self.locationContentRect.width - left - GXCHATC.bubbleTrailingInset.right
            let height = self.locationContentRect.height + GXCHATC.bubbleTrailingInset.bottom
            self.locationTitleRect = CGRect(x: left, y: 0, width: width, height: height)
        }
        else {
            let left = GXCHATC.bubbleLeadingInset.left
            let width = self.locationContentRect.width - left - GXCHATC.bubbleLeadingInset.right
            let height = self.locationContentRect.height + GXCHATC.bubbleLeadingInset.bottom
            self.locationTitleRect = CGRect(x: left, y: 0, width: width, height: height)
        }
        self.updateBaseLayout(item: item, containerSize: contentSize)
    }
    
}
