//
//  GXMessagesBubbleFactory.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/16.
//

import UIKit

public class GXMessagesBubbleFactory {
    
    /// 得到GXMessagesBubble消息气泡对象
    /// - Parameters:
    ///   - color: 颜色
    ///   - status: 消息状态
    /// - Returns: GXMessagesBubble消息气泡对象
    public class func messagesBubble(status: GXChatConfiguration.MessageStatus) -> GXMessagesBubble {
        return self.gx_messagesBubbleImage(status: status)
    }
    
    /// 得到GXMessagesBubble红包消息气泡对象
    /// - Parameters:
    ///   - color: 颜色
    ///   - status: 消息状态
    /// - Returns: GXMessagesBubble消息气泡对象
    public class func messagesRedPacketBubble(status: GXChatConfiguration.MessageStatus) -> GXMessagesBubble {
        return self.gx_messagesRedPacketBubbleImage(status: status)
    }
    
}

private extension GXMessagesBubbleFactory {
    
    class func gx_messagesBubbleImage(status: GXChatConfiguration.MessageStatus) -> GXMessagesBubble {
        let messagesBubble = GXMessagesBubble()
        if status == .send {
            let color = GXCHATC.sendingBubbleMaskColor
            if let beginBubbleImage = GXCHATC.bubbleBeginImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: beginBubbleImage.size)
                if let maskImage = beginBubbleImage.gx_imageMasked(color: color) {
                    messagesBubble.messageBeginBubbleImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = beginBubbleImage.gx_imageMasked(color: darkeningkColor) {
                        messagesBubble.messageBeginBubbleHighlightedImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                    }
                }
            }
            if let bubbleOngoingImage = GXCHATC.bubbleOngoingImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: bubbleOngoingImage.size)
                if let maskImage = bubbleOngoingImage.gx_imageMasked(color: color) {
                    messagesBubble.messageOngoingBubbleImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = bubbleOngoingImage.gx_imageMasked(color: darkeningkColor) {
                        messagesBubble.messageOngoingBubbleHighlightedImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                    }
                }
            }
            if let bubbleEndImage = GXCHATC.bubbleEndImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: bubbleEndImage.size)
                if let maskImage = bubbleEndImage.gx_imageMasked(color: color) {
                    messagesBubble.messageEndBubbleImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = bubbleEndImage.gx_imageMasked(color: darkeningkColor) {
                        messagesBubble.messageEndBubbleHighlightedImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                    }
                }
            }
        }
        else {
            let color = GXCHATC.receivingBubbleMaskColor
            if let beginBubbleImage = GXCHATC.bubbleBeginImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: beginBubbleImage.size)
                if let maskImage = beginBubbleImage.gx_imageMasked(color: color) {
                    if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                        messagesBubble.messageBeginBubbleImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                    }
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = beginBubbleImage.gx_imageMasked(color: darkeningkColor) {
                        if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                            messagesBubble.messageBeginBubbleHighlightedImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                        }
                    }
                }
            }
            if let bubbleOngoingImage = GXCHATC.bubbleOngoingImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: bubbleOngoingImage.size)
                if let maskImage = bubbleOngoingImage.gx_imageMasked(color: color) {
                    if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                        messagesBubble.messageOngoingBubbleImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                    }
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = bubbleOngoingImage.gx_imageMasked(color: darkeningkColor) {
                        if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                            messagesBubble.messageOngoingBubbleHighlightedImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                        }
                    }
                }
            }
            if let bubbleEndImage = GXCHATC.bubbleEndImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: bubbleEndImage.size)
                if let maskImage = bubbleEndImage.gx_imageMasked(color: color) {
                    if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                        messagesBubble.messageEndBubbleImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                    }
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = bubbleEndImage.gx_imageMasked(color: darkeningkColor) {
                        if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                            messagesBubble.messageEndBubbleHighlightedImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                        }
                    }
                }
            }
        }
        return messagesBubble
    }
    
    class func gx_messagesRedPacketBubbleImage(status: GXChatConfiguration.MessageStatus) -> GXMessagesBubble {
        let messagesBubble = GXMessagesBubble()
        let color = GXCHATC.redPacketBubbleMaskColor
        if status == .send {
            if let beginBubbleImage = GXCHATC.bubbleBeginImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: beginBubbleImage.size)
                if let maskImage = beginBubbleImage.gx_imageMasked(color: color) {
                    messagesBubble.messageBeginBubbleImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = beginBubbleImage.gx_imageMasked(color: darkeningkColor) {
                        messagesBubble.messageBeginBubbleHighlightedImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                    }
                }
            }
            if let bubbleOngoingImage = GXCHATC.bubbleOngoingImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: bubbleOngoingImage.size)
                if let maskImage = bubbleOngoingImage.gx_imageMasked(color: color) {
                    messagesBubble.messageOngoingBubbleImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = bubbleOngoingImage.gx_imageMasked(color: darkeningkColor) {
                        messagesBubble.messageOngoingBubbleHighlightedImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                    }
                }
            }
            if let bubbleEndImage = GXCHATC.bubbleEndImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: bubbleEndImage.size)
                if let maskImage = bubbleEndImage.gx_imageMasked(color: color) {
                    messagesBubble.messageEndBubbleImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = bubbleEndImage.gx_imageMasked(color: darkeningkColor) {
                        messagesBubble.messageEndBubbleHighlightedImage = self.gx_stretchableImage(image: maskImage, capInsets: capInsets)
                    }
                }
            }
        }
        else {
            if let beginBubbleImage = GXCHATC.bubbleBeginImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: beginBubbleImage.size)
                if let maskImage = beginBubbleImage.gx_imageMasked(color: color) {
                    if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                        messagesBubble.messageBeginBubbleImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                    }
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = beginBubbleImage.gx_imageMasked(color: darkeningkColor) {
                        if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                            messagesBubble.messageBeginBubbleHighlightedImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                        }
                    }
                }
            }
            if let bubbleOngoingImage = GXCHATC.bubbleOngoingImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: bubbleOngoingImage.size)
                if let maskImage = bubbleOngoingImage.gx_imageMasked(color: color) {
                    if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                        messagesBubble.messageOngoingBubbleImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                    }
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = bubbleOngoingImage.gx_imageMasked(color: darkeningkColor) {
                        if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                            messagesBubble.messageOngoingBubbleHighlightedImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                        }
                    }
                }
            }
            if let bubbleEndImage = GXCHATC.bubbleEndImage {
                let capInsets: UIEdgeInsets = self.gx_centerEdgeInsets(bubbleSize: bubbleEndImage.size)
                if let maskImage = bubbleEndImage.gx_imageMasked(color: color) {
                    if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                        messagesBubble.messageEndBubbleImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                    }
                }
                if let darkeningkColor = color.gx_colorByDarkeningColor(value: 0.2) {
                    if let maskImage = bubbleEndImage.gx_imageMasked(color: darkeningkColor) {
                        if let flippedImage = self.gx_horizontallyFlippedImage(image: maskImage) {
                            messagesBubble.messageEndBubbleHighlightedImage = self.gx_stretchableImage(image: flippedImage, capInsets: capInsets)
                        }
                    }
                }
            }
        }
        return messagesBubble
    }
    
    class func gx_centerEdgeInsets(bubbleSize: CGSize) -> UIEdgeInsets {
        let center = CGPoint(x: bubbleSize.width / 2, y: bubbleSize.height / 2)
        
        return UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)
    }
    
    class func gx_horizontallyFlippedImage(image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: .upMirrored)
    }
    
    class func gx_stretchableImage(image: UIImage, capInsets: UIEdgeInsets) -> UIImage {
        return image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
}

