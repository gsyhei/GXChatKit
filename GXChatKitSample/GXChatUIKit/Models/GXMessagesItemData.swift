//
//  GXMessageMideaItem.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/15.
//

import UIKit
import GXMessagesTableView

public class GXMessagesItemData: Equatable {
    public var data: GXMessagesDataProtocol
    
    public var avatar: GXMessagesAvatar?
    public var bubble: GXMessagesBubble?
    
    public var containerRect: CGRect = .zero
    public var contentRect: CGRect = .zero
    public var avatarRect: CGRect = .zero
    public var nicknameRect: CGRect = .zero
    public var timeRect: CGRect = .zero
    public var cellHeight: CGFloat = 0
    
    public static func == (lhs: GXMessagesItemData, rhs: GXMessagesItemData) -> Bool {
        if lhs.data.gx_chatType == .group {
            return lhs.data.gx_chatType == rhs.data.gx_chatType
            && lhs.data.gx_groupId == rhs.data.gx_groupId
            && lhs.data.gx_senderId == rhs.data.gx_senderId
            && lhs.data.gx_messageId == rhs.data.gx_messageId
        }
        else {
            return lhs.data.gx_chatType == rhs.data.gx_chatType
            && lhs.data.gx_senderId == rhs.data.gx_senderId
            && lhs.data.gx_messageId == rhs.data.gx_messageId
        }
    }
    
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
            self.updateAudioLayout()
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
    
    func updateBaseLayout(containerSize: CGSize) {
        let containerLeft = self.gx_containerLeft(container: containerSize.width)
        switch self.data.gx_messageContinuousStatus {
        case .begin:
            self.containerRect = CGRect(origin: CGPoint(x: containerLeft, y: GXCHATC.cellMaxLineSpacing), size: containerSize)
            self.cellHeight = self.containerRect.maxY + GXCHATC.cellMinLineSpacing
        case .ongoing:
            self.containerRect = CGRect(origin: CGPoint(x: containerLeft, y: GXCHATC.cellMinLineSpacing), size: containerSize)
            self.cellHeight = self.containerRect.maxY + GXCHATC.cellMinLineSpacing
        case .end:
            self.containerRect = CGRect(origin: CGPoint(x: containerLeft, y: GXCHATC.cellMinLineSpacing), size: containerSize)
            self.cellHeight = self.containerRect.maxY + GXCHATC.cellMaxLineSpacing
        case .beginAndEnd:
            self.containerRect = CGRect(origin: CGPoint(x: containerLeft, y: GXCHATC.cellMaxLineSpacing), size: containerSize)
            self.cellHeight = self.containerRect.maxY + GXCHATC.cellMaxLineSpacing
        }
        
        if self.data.gx_messageStatus == .sending {
            if self.gx_isShowAvatar {
                let avatarTop = self.cellHeight - GXCHATC.avatarSize.height - 2.0
                self.avatarRect = CGRect(origin: CGPoint(x: self.containerRect.maxX + GXCHATC.avatarMargin, y: avatarTop), size: GXCHATC.avatarSize)
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
                let avatarTop = self.cellHeight - GXCHATC.avatarSize.height - 2.0
                self.avatarRect = CGRect(origin: CGPoint(x: GXCHATC.avatarMargin, y: avatarTop), size: GXCHATC.avatarSize)
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
        
        let hookWidth = GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
        let maxContainerWidth = SCREEN_WIDTH - self.gx_avatarContentWidth - hookWidth
        let maxContentWidth = maxContainerWidth - GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
        let attributedText = NSMutableAttributedString(attributedString: content.attributedText)
        attributedText.append(NSAttributedString(string: self.data.gx_messageTime))        
        let maxTextSize = CGSizeMake(maxContentWidth, 10000)
        content.displaySize = attributedText.boundingRect(with: maxTextSize, options: .usesLineFragmentOrigin, context: nil).size
        var contentHeight = content.displaySize.height
        if self.gx_isShowNickname {
            contentHeight += GXCHATC.nicknameFont.lineHeight
            if self.data.gx_messageStatus == .sending {
                let top = GXCHATC.bubbleTrailingInset.top + GXCHATC.nicknameFont.lineHeight
                let left = GXCHATC.bubbleTrailingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: content.displaySize)
            }
            else {
                let top = GXCHATC.bubbleLeadingInset.top + GXCHATC.nicknameFont.lineHeight
                let left = GXCHATC.bubbleLeadingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: content.displaySize)
            }
        }
        else {
            if self.data.gx_messageStatus == .sending {
                let top = GXCHATC.bubbleTrailingInset.top
                let left = GXCHATC.bubbleTrailingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: content.displaySize)
            }
            else {
                let top = GXCHATC.bubbleLeadingInset.top
                let left = GXCHATC.bubbleLeadingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: content.displaySize)
            }
        }
        let containerWidth = content.displaySize.width + GXCHATC.bubbleLeadingInset.left + GXCHATC.bubbleLeadingInset.right
        let containerHeight = contentHeight + GXCHATC.bubbleLeadingInset.top + GXCHATC.bubbleLeadingInset.bottom
        self.updateBaseLayout(containerSize: CGSizeMake(containerWidth, containerHeight))
    }
    
    func updatePhotoLayout() {
        guard let content = self.data.gx_messagesContentData as? GXMessagesPhotoContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
        let maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let displaySize = self.gx_resize(size: content.displaySize, maxSize: CGSize(width: maxContainerWidth, height: SCREEN_HEIGHT/2))
        self.contentRect = CGRect(x: 0, y: 0, width: displaySize.width, height: displaySize.height)
        self.updateBaseLayout(containerSize: displaySize)
    }
    
    func updateVideoLayout() {
        guard let content = self.data.gx_messagesContentData as? GXMessagesVideoContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
        let maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        let displaySize = self.gx_resize(size: content.displaySize, maxSize: CGSize(width: maxContainerWidth, height: SCREEN_HEIGHT/2))
        self.contentRect = CGRect(x: 0, y: 0, width: displaySize.width, height: displaySize.height)
        self.updateBaseLayout(containerSize: displaySize)
    }
    
    func updateAudioLayout() {
        guard let content = self.data.gx_messagesContentData as? GXMessagesAudioContent else { return }
        
        let hookWidth = GXCHATC.bubbleLeadingInset.left - GXCHATC.bubbleLeadingInset.right
        var maxContainerWidth = SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) * 2 - hookWidth
        maxContainerWidth -= (GXCHATC.bubbleLeadingInset.left + GXCHATC.bubbleLeadingInset.right)
        maxContainerWidth -= GXCHATC.audioPlaySize.width
        
        let count = content.tracks?.count ?? 0
        content.animateDuration = content.duration / Double(count)
        let width = CGFloat(count) * (GXCHATC.audioSpacing + GXCHATC.audioItemWidth)
        content.audioSize = CGSize(width: width, height: GXCHATC.audioPlaySize.height/2 - 10)
        
        let contentWidth = width + 10 + GXCHATC.audioPlaySize.width
        content.displaySize = CGSize(width: contentWidth, height: GXCHATC.audioPlaySize.height)
        var contentHeight = content.displaySize.height + GXCHATC.timeFont.lineHeight
        if self.gx_isShowNickname {
            contentHeight += GXCHATC.nicknameFont.lineHeight
            if self.data.gx_messageStatus == .sending {
                let top = GXCHATC.bubbleTrailingInset.top + GXCHATC.nicknameFont.lineHeight
                let left = GXCHATC.bubbleTrailingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: content.displaySize)
            }
            else {
                let top = GXCHATC.bubbleLeadingInset.top + GXCHATC.nicknameFont.lineHeight
                let left = GXCHATC.bubbleLeadingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: content.displaySize)
            }
        }
        else {
            if self.data.gx_messageStatus == .sending {
                let top = GXCHATC.bubbleTrailingInset.top
                let left = GXCHATC.bubbleTrailingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: content.displaySize)
            }
            else {
                let top = GXCHATC.bubbleLeadingInset.top
                let left = GXCHATC.bubbleLeadingInset.left
                self.contentRect = CGRect(origin: CGPoint(x: left, y: top), size: content.displaySize)
            }
        }
        let containerWidth = contentWidth + GXCHATC.bubbleLeadingInset.left + GXCHATC.bubbleLeadingInset.right
        let containerHeight = contentHeight + GXCHATC.bubbleLeadingInset.top + GXCHATC.bubbleLeadingInset.bottom
        self.updateBaseLayout(containerSize: CGSizeMake(containerWidth, containerHeight))
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
        var avatarContentWidth: CGFloat = GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2
        if self.data.gx_messageStatus == .sending && GXCHATC.singleChatSendingShowAvatar {
            avatarContentWidth += GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2
        }
        else if self.data.gx_messageStatus == .receiving && GXCHATC.singleChatReceivingShowAvatar {
            avatarContentWidth += GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2
        }
        else {
            avatarContentWidth += GXCHATC.avatarMargin*2
        }
        return avatarContentWidth
    }
    
    /// 内容视图的left
    func gx_containerLeft(container width: CGFloat) -> CGFloat {
        if self.data.gx_messageStatus == .sending {
            if self.data.gx_chatType == .single {
                if GXCHATC.singleChatSendingShowAvatar {
                    return SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) - width
                }
                else {
                    return SCREEN_WIDTH - GXCHATC.avatarMargin*2 - width
                }
            }
            else {
                if GXCHATC.groupChatSendingShowAvatar {
                    return SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) - width
                }
                else {
                    return SCREEN_WIDTH - GXCHATC.avatarMargin*2 - width
                }
            }
        }
        else {
            if self.data.gx_chatType == .single {
                if GXCHATC.singleChatReceivingShowAvatar {
                    return GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2
                }
                else {
                    return GXCHATC.avatarMargin*2
                }
            }
            else {
                if GXCHATC.groupChatReceivingShowAvatar {
                    return GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2
                }
                else {
                    return GXCHATC.avatarMargin*2
                }
            }
        }
    }
    
    func gx_resize(size: CGSize, maxSize: CGSize) -> CGSize {
        if size.width < maxSize.width && size.height < maxSize.height {
            return size
        }
        let scaleW = maxSize.width/size.width, scaleH = maxSize.height/size.height
        let resizeScale = min(scaleW, scaleH)
        
        return CGSize(width: size.width * resizeScale, height: size.height * resizeScale)
    }
    
}
