//
//  GXMessagesBubble.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/15.
//

import UIKit

public class GXMessagesBubble: NSObject {
    /// 消息开始气泡图
    public var messageBeginBubbleImage: UIImage?
    /// 消息开始高亮气泡图
    public var messageBeginBubbleHighlightedImage: UIImage?
    /// 消息持续中气泡图
    public var messageOngoingBubbleImage: UIImage?
    /// 消息持续中高亮气泡图
    public var messageOngoingBubbleHighlightedImage: UIImage?
    /// 消息结束气泡图
    public var messageEndBubbleImage: UIImage?
    /// 消息结束高亮气泡图
    public var messageEndBubbleHighlightedImage: UIImage?
}
