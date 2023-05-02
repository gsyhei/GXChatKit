//
//  GXMessagesSystemLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/3.
//

import UIKit

public class GXMessagesSystemLayout: GXMessagesBaseLayout {
    
    public var textRect: CGRect = .zero

    public override func updateLayout(data: GXMessagesDataDelegate) {
        guard let content = data.gx_messagesContent as? GXMessagesSystemContent else { return }
        
        let maxContainerWidth = SCREEN_WIDTH - GXCHATC.systemCellInserts.left - GXCHATC.systemCellInserts.right
        let maxContentWidth = maxContainerWidth - GXCHATC.systemTextInserts.left - GXCHATC.systemTextInserts.right
        let maxTextSize = CGSizeMake(maxContentWidth, 10000)
        content.displaySize = content.text.size(size: maxTextSize, font: GXCHATC.systemTextFont)
        
        let contentPoint = CGPoint(x: GXCHATC.systemTextInserts.left, y: GXCHATC.systemTextInserts.top)
        self.textRect = CGRect(origin: contentPoint, size: content.displaySize)
        
        let containerWidth = content.displaySize.width + GXCHATC.systemTextInserts.left + GXCHATC.systemTextInserts.right
        let containerHeight = content.displaySize.height + GXCHATC.systemTextInserts.top + GXCHATC.systemTextInserts.bottom
        let containerPoint = CGPoint(x: (SCREEN_WIDTH - containerWidth)/2, y: GXCHATC.systemCellInserts.top)
        self.containerRect = CGRect(origin: containerPoint, size: CGSize(width: containerWidth, height: containerHeight))
        
        self.cellHeight = containerHeight + GXCHATC.systemCellInserts.top + GXCHATC.systemCellInserts.bottom
    }
    
}
