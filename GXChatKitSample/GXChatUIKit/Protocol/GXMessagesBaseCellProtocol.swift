//
//  GXMessagesBaseCellProtocol.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/23.
//

import Foundation

public protocol GXMessagesBaseCellProtocol: NSObjectProtocol {
    
    /// 点击Cell头像
    /// - Parameters:
    ///   - cell: 消息cell
    ///   - indexPath: 索引
    func messagesCell(_ cell: GXMessagesBaseCell, didAvatarTapAt indexPath: IndexPath)
    
    /// 长按cell
    /// - Parameters:
    ///   - cell: 消息cell
    ///   - indexPath: 索引
    func messagesCell(_ cell: GXMessagesBaseCell, didLongPressAt indexPath: IndexPath)
    
    /// 点击cell内容（播放按钮/回复引用内容）
    /// - Parameters:
    ///   - cell: 消息cell
    ///   - indexPath: 索引
    func messagesCell(_ cell: GXMessagesBaseCell, didContentTapAt indexPath: IndexPath)
    
    /// 点击高亮文本
    /// - Parameters:
    ///   - cell: 消息cell
    ///   - indexPath: 索引
    ///   - type: 高亮类型
    ///   - value: 高亮值
    func messagesCell(_ cell: GXMessagesBaseCell, didTapAt indexPath: IndexPath, type: GXRichManager.HighlightType, value: String)

}
