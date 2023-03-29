//
//  GXMessageMideaItem.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/15.
//

import UIKit
import GXMessagesTableView

public class GXMessagesItemLayoutData: Equatable {
    public var data: GXMessagesItemDataProtocol
    public var layout: GXMessagesBaseLayout!

    public var avatar: GXMessagesAvatar?
    public var bubble: GXMessagesBubble?

    public static func == (lhs: GXMessagesItemLayoutData, rhs: GXMessagesItemLayoutData) -> Bool {
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
    
    public required init(data: GXMessagesItemDataProtocol) {
        self.data = data
        self.avatar = GXMessagesAvatarFactory.messagesAvatar(text: data.gx_senderDisplayName)
        self.bubble = GXMessagesBubbleFactory.messagesBubble(status: data.gx_messageStatus)
        
        self.updateLayout()
    }
    
    public func updateLayout() {
        switch self.data.gx_messageType {
        case .text:
            self.layout = GXMessagesTextLayout(item: self)
        case .phote:
            self.layout = GXMessagesPhotoLayout(item: self)
        case .video:
            self.layout = GXMessagesVideoLayout(item: self)
        case .audio:
            self.layout = GXMessagesAudioLayout(item: self)
        case .location:
            self.layout = GXMessagesLocationLayout(item: self)
        case .voiceCall, .videoCall:
            self.layout = GXMessagesCallLayout(item: self)
            
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

public extension GXMessagesItemLayoutData {
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
    
    var gx_contentPoint: CGPoint {
        if self.gx_isShowNickname {
            if data.gx_messageStatus == .sending {
                let top = GXCHATC.bubbleTrailingInset.top + GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing
                return CGPoint(x: GXCHATC.bubbleTrailingInset.left, y: top)
            }
            else {
                let top = GXCHATC.bubbleLeadingInset.top + GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing
                return CGPoint(x: GXCHATC.bubbleLeadingInset.left, y: top)
            }
        }
        else {
            if data.gx_messageStatus == .sending {
                return CGPoint(x: GXCHATC.bubbleTrailingInset.left, y: GXCHATC.bubbleTrailingInset.top)
            }
            else {
                return CGPoint(x: GXCHATC.bubbleLeadingInset.left, y: GXCHATC.bubbleLeadingInset.top)
            }
        }
    }
    
    func gx_imageResize(size: CGSize, maxSize: CGSize) -> CGSize {
        if size.width < maxSize.width && size.height < maxSize.height {
            return size
        }
        let scaleW = maxSize.width/size.width, scaleH = maxSize.height/size.height
        let resizeScale = min(min(scaleW, scaleH), 1.0)
        let resize = CGSize(width: size.width * resizeScale, height: size.height * resizeScale)
        if resize.width < 40.0 { // 最小宽度40.0
            var height = (40.0 / maxSize.width) * size.height
            height = min(height, maxSize.height)
            
            return CGSize(width: 40.0, height: height)
        }
        
        return resize
    }
    
}
