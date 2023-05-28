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
    
    public override func updateLayout(data: GXMessagesDataDelegate) {
        guard let content = data.gx_messagesContent as? GXMessagesAudioContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        var maxContainerWidth = SCREEN_MIN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        maxContainerWidth -= (GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right)
        
        let count = content.tracks?.count ?? 0
        let width = CGFloat(count) * (GXCHATC.audioSpacing + GXCHATC.audioItemWidth)
        let audioSize = CGSize(width: width, height: 30)
        
        let contentWidth = width + 10 + GXCHATC.audioPlaySize.width
        content.displaySize = CGSize(width: contentWidth, height: GXCHATC.audioPlaySize.height)
        
        let contentPoint = data.gx_contentPoint
        self.playButtonRect = CGRect(origin: contentPoint, size: GXCHATC.audioPlaySize)
        let audioTrackTop = self.playButtonRect.minY + (self.playButtonRect.height - audioSize.height)/2
        self.audioTrackRect = CGRect(origin: CGPoint(x: self.playButtonRect.maxX + 10.0, y: audioTrackTop), size: audioSize)

        var containerHeight = content.displaySize.height + GXCHATC.timeFont.lineHeight
        containerHeight += (GXCHATC.bubbleLeadingInsets.top + GXCHATC.bubbleLeadingInsets.bottom)
        if data.gx_isShowNickname {
            containerHeight += (GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing)
        }
        let containerWidth = contentWidth + GXCHATC.bubbleLeadingInsets.left + GXCHATC.bubbleLeadingInsets.right
        self.updateBaseLayout(data: data, containerSize: CGSizeMake(containerWidth, containerHeight))
        
        let audioTimeSize = CGSize(width: 28.0, height: GXCHATC.timeFont.lineHeight)
        let audioTimeTop = self.timeRect.minY + (self.timeRect.height - GXCHATC.timeFont.lineHeight)/2
        let audioTimePoint = CGPoint(x:self.playButtonRect.maxX + 10.0, y: audioTimeTop)
        self.audioTimeRect = CGRect(origin: audioTimePoint, size: audioTimeSize)
    }
}
