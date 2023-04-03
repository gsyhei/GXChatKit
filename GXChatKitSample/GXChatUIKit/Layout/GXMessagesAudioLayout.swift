//
//  GXMessagesAudioLayout.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

public class GXMessagesAudioLayout: GXMessagesBaseLayout {

    public var playButtonRect: CGRect = .zero
    public var audioTrackRect: CGRect = .zero
    public var audioTimeRect: CGRect = .zero
    
    public override func updateLayout(data: GXMessagesDataProtocol) {
        guard let content = data.gx_messagesContent as? GXMessagesAudioContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        var maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        maxContainerWidth -= (GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right)
        maxContainerWidth -= GXCHATC.audioPlaySize.width
        
        let count = content.tracks?.count ?? 0
        content.animateDuration = content.duration / Double(count)
        let width = CGFloat(count) * (GXCHATC.audioSpacing + GXCHATC.audioItemWidth)
        let audioSize = CGSize(width: width, height: GXCHATC.audioPlaySize.height/2 - 10)
        
        let contentWidth = width + 10 + GXCHATC.audioPlaySize.width
        content.displaySize = CGSize(width: contentWidth, height: GXCHATC.audioPlaySize.height)
        
        let contentPoint = data.gx_contentPoint
        self.playButtonRect = CGRect(origin: contentPoint, size: GXCHATC.audioPlaySize)
        self.audioTrackRect = CGRect(origin: CGPoint(x: self.playButtonRect.maxX + 10.0, y: contentPoint.y + 10.0), size: audioSize)
        let audioTimePoint = CGPoint(x: self.playButtonRect.maxX + 10.0, y: self.playButtonRect.midY + 5.0)
        let audioTimeSize = CGSize(width: 28.0, height: GXCHATC.timeFont.lineHeight)
        self.audioTimeRect = CGRect(origin: audioTimePoint, size: audioTimeSize)
        
        var containerHeight = content.displaySize.height + GXCHATC.timeFont.lineHeight
        containerHeight += (GXCHATC.bubbleLeadingInsets.top + GXCHATC.bubbleLeadingInsets.bottom)
        if data.gx_isShowNickname {
            containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
        }
        let containerWidth = contentWidth + GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right
        self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
    }
}
