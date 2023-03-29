//
//  GXMessagesAtContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

class GXMessagesAtContent: GXMessagesContentProtocol {
    // MARK: - GXMessagesContentData
    
    /// 媒体视图
    public var mediaView: UIView?
    /// 媒体占位视图
    public var mediaPlaceholderView: UIView?
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    
}
