//
//  GXMessagesOperation.swift
//  GXMessagesTableView
//
//  Created by Gin on 2023/2/27.
//

import Foundation

public protocol GXMessagesCenterOperation: NSObject, Equatable {
    /// 高度
    var height: CGFloat { set get }
}

public protocol GXMessagesMarginSection {
    /// 高度
    var height: CGFloat { set get }
    /// 方向
    var direction: GXMessagesTableView.MarginDirection { set get }
    /// 内容
    var list: [any GXMessagesCenterOperation] { set get }
}

public protocol GXMessagesCenterSection {
    /// 内容
    var list: [any GXMessagesCenterOperation] { set get }
}
