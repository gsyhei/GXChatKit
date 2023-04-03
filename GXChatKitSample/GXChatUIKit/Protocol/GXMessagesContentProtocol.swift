//
//  GXMessagesContentData.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/16.
//

import UIKit

public protocol GXMessagesContentProtocol {
    /// 显示区域尺寸
    var displaySize: CGSize { get }
}

public protocol GXMessagesMediaContentProtocol: GXMessagesContentProtocol {
    /// 媒体视图
    var mediaView: UIView? { get }
    /// 媒体占位视图
    var mediaPlaceholderView: UIView? { get }
}
