//
//  GXMessagesBaseCellProtocol.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/23.
//

import Foundation

public protocol GXMessagesBaseCellDelegate: NSObjectProtocol {
    
    /// 点击Cell头像
    /// - Parameters:
    ///   - cell: 消息cell
    ///   - item: 数据
    func messagesCell(_ cell: GXMessagesBaseCell, didAvatarTapAt item: GXMessagesItemData?)
    
    /// 长按cell
    /// - Parameters:
    ///   - cell: 消息cell
    ///   - item: 数据
    func messagesCell(_ cell: GXMessagesBaseCell, didLongPressAt item: GXMessagesItemData?)
    
    /// 点击cell内容（播放按钮/回复引用内容）
    /// - Parameters:
    ///   - cell: 消息cell
    ///   - item: 数据
    func messagesCell(_ cell: GXMessagesBaseCell, didContentTapAt item: GXMessagesItemData?)
    
    /// 侧滑cell
    /// - Parameters:
    ///   - cell: 消息cell
    ///   - item: 数据
    func messagesCell(_ cell: GXMessagesBaseCell, didSwipeAt item: GXMessagesItemData?)
    
    /// 点击高亮文本
    /// - Parameters:
    ///   - cell: 消息cell
    ///   - item: 数据
    ///   - type: 高亮类型
    ///   - value: 高亮值
    func messagesCell(_ cell: GXMessagesBaseCell, didTapAt item: GXMessagesItemData?, type: GXRichManager.HighlightType, value: String)

}
