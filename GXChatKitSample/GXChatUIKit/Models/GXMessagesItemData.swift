//
//  GXMessageMideaItem.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/15.
//

import UIKit
import GXMessagesTableView

public class GXMessagesItemData {
    public var data: GXMessagesDataProtocol
    
    public var avatar: GXMessagesAvatar?
    public var bubble: GXMessagesBubble?

    public var containerRect: CGRect = .zero
    public var contentRect: CGRect = .zero
    public var avatarRect: CGRect = .zero
    public var nicknameRect: CGRect = .zero
    public var timeRect: CGRect = .zero
    public var cellHeight: CGFloat = 0
    
    public required init(data: GXMessagesDataProtocol) {
        self.data = data
        self.avatar = GXMessagesAvatarFactory.messagesAvatar(text: data.gx_senderDisplayName)
        self.bubble = GXMessagesBubbleFactory.messagesBubble(status: data.gx_messageStatus)
        self.updateLayout()
    }
    
    public func updateLayout() {
        switch self.data.gx_messageType {
        case .text:
            self.updateTextLayout()
        case .phote:
            self.updatePhotoLayout()
        case .video:
            self.updateVideoLayout()
        case .audio:
            NSLog("GXMessagesAudioContent init task end update data")
            self.updateAudioLayout()
        default: break
        }
    }

    public func updateMessagesAvatar(image: UIImage?) {
        if let avatarImage = image {
            self.avatar?.avatarImage = GXMessagesAvatarFactory.circularAvatarImage(image: avatarImage)
            self.avatar?.avatarHighlightedImage = GXMessagesAvatarFactory.circularAvatarHighlightedImage(image: avatarImage)
        }
    }
}
 
private extension GXMessagesItemData {
    
    func updateBaseLayout(containerWidth: CGFloat, containerHeight: CGFloat) {
        let containerLeft = self.gx_containerLeft(container: containerWidth)
        switch self.data.gx_messageContinuousStatus {
        case .begin:
            self.containerRect = CGRect(x: containerLeft, y: 5.0, width: containerWidth, height: containerHeight)
            self.cellHeight = self.containerRect.maxY + 1.0
        case .ongoing:
            self.containerRect = CGRect(x: containerLeft, y: 1.0, width: containerWidth, height: containerHeight)
            self.cellHeight = self.containerRect.maxY + 1.0
        case .end:
            self.containerRect = CGRect(x: containerLeft, y: 1.0, width: containerWidth, height: containerHeight)
            self.cellHeight = self.containerRect.maxY + 5.0
        case .beginAndEnd:
            self.containerRect = CGRect(x: containerLeft, y: 5.0, width: containerWidth, height: containerHeight)
            self.cellHeight = self.containerRect.maxY + 5.0
        }
        
        if self.data.gx_messageStatus == .sending {
            if self.gx_isShowAvatar {
                let avatarTop = self.cellHeight - GXCHATC.avatarSize.height - 2
                self.avatarRect = CGRect(origin: CGPoint(x: self.containerRect.maxX + 5.0, y: avatarTop), size: GXCHATC.avatarSize)
            }
            if self.gx_isShowNickname {
                let left = GXCHATC.bubbleTrailingInset.left, top =  GXCHATC.bubbleTrailingInset.top
                let maxWidth = self.containerRect.width - GXCHATC.bubbleTrailingInset.left - GXCHATC.bubbleTrailingInset.right
                let maxHeight = GXCHATC.nicknameFont.lineHeight
                let nameSize = self.data.gx_senderDisplayName.size(size: CGSize(width: maxWidth, height: maxHeight), font: GXCHATC.nicknameFont)
                self.nicknameRect = CGRect(x: left, y: top, width: nameSize.width, height: nameSize.height)
            }
            let timeSize = self.data.gx_messageTime.size(size: self.containerRect.size, font: GXCHATC.timeFont)
            let top = self.containerRect.height - GXCHATC.bubbleTrailingInset.bottom - timeSize.height
            let left = self.containerRect.width - GXCHATC.bubbleTrailingInset.right - timeSize.width
            self.timeRect = CGRect(x: left, y: top, width: timeSize.width, height: timeSize.height)
        }
        else {
            if self.gx_isShowAvatar {
                let avatarTop = self.cellHeight - GXCHATC.avatarSize.height - 2
                self.avatarRect = CGRect(origin: CGPoint(x: 5.0, y: avatarTop), size: GXChatConfiguration.shared.avatarSize)
            }
            if self.gx_isShowNickname {
                let left = GXCHATC.bubbleLeadingInset.left, top =  GXCHATC.bubbleLeadingInset.top
                let maxWidth = self.containerRect.width - GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
                let maxHeight = GXCHATC.nicknameFont.lineHeight
                let nameSize = self.data.gx_senderDisplayName.size(size: CGSize(width: maxWidth, height: maxHeight), font: GXCHATC.nicknameFont)
                self.nicknameRect = CGRect(x: left, y: top, width: nameSize.width, height: nameSize.height)
            }
            let timeSize = self.data.gx_messageTime.size(size: self.containerRect.size, font: GXCHATC.timeFont)
            let top = self.containerRect.height - GXCHATC.bubbleLeadingInset.bottom - timeSize.height
            let left = self.containerRect.width - GXCHATC.bubbleLeadingInset.right - timeSize.width
            self.timeRect = CGRect(x: left, y: top, width: timeSize.width, height: timeSize.height)
        }
    }
    
    func updateTextLayout() {
        guard let content = self.data.gx_messagesContentData as? GXMessagesTextContent else { return }
        
        let maxContainerWidth = SCREEN_WIDTH - self.gx_avatarContentWidth
        let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
        
        let text = content.text + self.data.gx_messageTime
        let maxTextSize = CGSizeMake(maxContentWidth, 10000)
        let displaySize = text.size(size: maxTextSize, font: GXCHATC.textFont)
        content.displaySize = displaySize
        var contentHeight = displaySize.height
        if self.gx_isShowNickname {
            contentHeight += GXCHATC.nicknameFont.lineHeight
            if self.data.gx_messageStatus == .sending {
                let top = GXCHATC.bubbleTrailingInset.top + GXCHATC.nicknameFont.lineHeight
                let left = GXCHATC.bubbleTrailingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: displaySize)
            }
            else {
                let top = GXCHATC.bubbleLeadingInset.top + GXCHATC.nicknameFont.lineHeight
                let left = GXCHATC.bubbleLeadingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: displaySize)
            }
        }
        else {
            if self.data.gx_messageStatus == .sending {
                let top = GXCHATC.bubbleTrailingInset.top
                let left = GXCHATC.bubbleTrailingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: displaySize)
            }
            else {
                let top = GXCHATC.bubbleLeadingInset.top
                let left = GXCHATC.bubbleLeadingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: displaySize)
            }
        }
        let containerWidth = displaySize.width + GXCHATC.bubbleLeadingInset.left + GXCHATC.bubbleLeadingInset.right
        let containerHeight = contentHeight + GXCHATC.bubbleLeadingInset.top + GXCHATC.bubbleLeadingInset.bottom
        self.updateBaseLayout(containerWidth: containerWidth, containerHeight: containerHeight)
    }
    
    func updatePhotoLayout() {
        guard let content = self.data.gx_messagesContentData as? GXMessagesPhotoContent else { return }
        
        let maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + 10.0)*2
        let displaySize = self.gx_resize(size: content.displaySize, maxSize: CGSize(width: maxContainerWidth, height: SCREEN_HEIGHT/2))
        self.contentRect = CGRect(x: 0, y: 0, width: displaySize.width, height: displaySize.height)
        self.updateBaseLayout(containerWidth: displaySize.width, containerHeight: displaySize.height)
    }
    
    func updateVideoLayout() {
        guard let content = self.data.gx_messagesContentData as? GXMessagesVideoContent else { return }
        
        let maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + 10.0)*2
        let displaySize = self.gx_resize(size: content.displaySize, maxSize: CGSize(width: maxContainerWidth, height: SCREEN_HEIGHT/2))
        self.contentRect = CGRect(x: 0, y: 0, width: displaySize.width, height: displaySize.height)
        self.updateBaseLayout(containerWidth: displaySize.width, containerHeight: displaySize.height)
    }
    
    func updateAudioLayout() {
        guard let content = self.data.gx_messagesContentData as? GXMessagesAudioContent else { return }
        
        var maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + 10.0) * 2
        maxContainerWidth -= (GXCHATC.bubbleLeadingInset.left + GXCHATC.bubbleLeadingInset.right)
        maxContainerWidth -= GXChatConfiguration.shared.audioPlaySize.width
        let count = GXMessagesAudioTrackView.GetTrackMaxCount(maxWidth: maxContainerWidth, time: content.duration)
        let width = GXMessagesAudioTrackView.GetTrackViewWidth(count: count)
        content.displaySize = CGSize(width: width, height: GXChatConfiguration.shared.audioPlaySize.height/2)
        
        let contentWidth = width + 10.0 + GXChatConfiguration.shared.audioPlaySize.width
        var contentHeight = GXChatConfiguration.shared.audioPlaySize.height + GXChatConfiguration.shared.timeFont.lineHeight
        if self.gx_isShowNickname {
            contentHeight += GXCHATC.nicknameFont.lineHeight
            if self.data.gx_messageStatus == .sending {
                let top = GXCHATC.bubbleTrailingInset.top + GXCHATC.nicknameFont.lineHeight
                let left = GXCHATC.bubbleTrailingInset.left
                self.contentRect = CGRect(x: left, y: top, width: contentWidth, height: contentHeight)
            }
            else {
                let top = GXCHATC.bubbleLeadingInset.top + GXCHATC.nicknameFont.lineHeight
                let left = GXCHATC.bubbleLeadingInset.left
                self.contentRect = CGRect(x: left, y: top, width: contentWidth, height: contentHeight)
            }
        }
        else {
            if self.data.gx_messageStatus == .sending {
                let top = GXCHATC.bubbleTrailingInset.top
                let left = GXCHATC.bubbleTrailingInset.left
                self.contentRect = CGRect(x: left, y: top, width: contentWidth, height: contentHeight)
            }
            else {
                let top = GXCHATC.bubbleLeadingInset.top
                let left = GXCHATC.bubbleLeadingInset.left
                self.contentRect = CGRect(x: left, y: top, width: contentWidth, height: contentHeight)
            }
        }
        let containerWidth = contentWidth + GXCHATC.bubbleLeadingInset.left + GXCHATC.bubbleLeadingInset.right
        let containerHeight = contentHeight + GXCHATC.bubbleLeadingInset.top + GXCHATC.bubbleLeadingInset.bottom
        self.updateBaseLayout(containerWidth: containerWidth, containerHeight: containerHeight)
    }
}

public extension GXMessagesItemData {
    /// 头像是否显示
    var gx_isShowAvatar: Bool {
        if self.data.gx_messageStatus == .sending {
            if self.data.gx_chatType == .single {
                return GXCHATC.singleChatSendingShowAvatar
            }
            else {
                return GXCHATC.groupChatSendingShowAvatar
            }
        }
        else {
            if self.data.gx_chatType == .single {
                return GXCHATC.singleChatReceivingShowAvatar
            }
            else {
                return GXCHATC.groupChatReceivingShowAvatar
            }
        }
    }
    
    /// 昵称是否显示
    var gx_isShowNickname: Bool {
        if self.data.gx_messageStatus == .sending {
            if self.data.gx_chatType == .single {
                return GXCHATC.singleChatSendingShowNickname
            }
            else {
                return GXCHATC.groupChatSendingShowNickname
            }
        }
        else {
            if self.data.gx_chatType == .single {
                return GXCHATC.singleChatReceivingShowNickname
            }
            else {
                return GXCHATC.groupChatReceivingShowNickname
            }
        }
    }
    
    /// 头像占用的width
    var gx_avatarContentWidth: CGFloat {
        var avatarContentWidth: CGFloat = GXCHATC.avatarSize.width + 10.0
        if self.data.gx_messageStatus == .sending && GXCHATC.singleChatSendingShowAvatar {
            avatarContentWidth += GXCHATC.avatarSize.width + 10.0
        }
        else if self.data.gx_messageStatus == .receiving && GXCHATC.singleChatReceivingShowAvatar {
            avatarContentWidth += GXCHATC.avatarSize.width + 10.0
        }
        else {
            avatarContentWidth += 10.0
        }
        return avatarContentWidth
    }

    /// 内容视图的left
    func gx_containerLeft(container width: CGFloat) -> CGFloat {
        if self.data.gx_messageStatus == .sending {
            if self.data.gx_chatType == .single {
                if GXCHATC.singleChatSendingShowAvatar {
                    return SCREEN_WIDTH - (GXCHATC.avatarSize.width + 10.0) - width
                }
                else {
                    return SCREEN_WIDTH - 10.0 - width
                }
            }
            else {
                if GXCHATC.groupChatSendingShowAvatar {
                    return SCREEN_WIDTH - (GXCHATC.avatarSize.width + 10.0) - width
                }
                else {
                    return SCREEN_WIDTH - 10.0 - width
                }
            }
        }
        else {
            if self.data.gx_chatType == .single {
                if GXCHATC.singleChatReceivingShowAvatar {
                    return GXCHATC.avatarSize.width + 10.0
                }
                else {
                    return 10.0
                }
            }
            else {
                if GXCHATC.groupChatReceivingShowAvatar {
                    return GXCHATC.avatarSize.width + 10.0
                }
                else {
                    return 10.0
                }
            }
        }
    }
    
    func gx_resize(size: CGSize, maxSize: CGSize) -> CGSize {
        if size.width < maxSize.width && size.height < maxSize.height {
            return size
        }
        let scaleW = size.width / maxSize.width, scaleH = size.height / maxSize.height
        let resizeScale = max(scaleW, scaleH)
        
        return CGSize(width: size.width / resizeScale, height: size.height / resizeScale)
    }
    
}
