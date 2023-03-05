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
    /// 日期
    var date: Date { set get }
    /// margin分组识别id（比如发送者ID）
    var marginIdentifier: String { get }
    /// margin对应section
    var marginSection: Int { set get }
    /// center对应indexPath
    var centerIndexPath: IndexPath { set get }
}

open class GXMessagesMarginSection {
    /// margin分组识别id
    open var marginIdentifier: String?
    /// 高度
    open var height: CGFloat
    /// 内容
    open var list: [any GXMessagesCenterOperation]
    
    public init(marginIdentifier: String?,
         height: CGFloat = 0.0,
         list: [any GXMessagesCenterOperation] = [])
    {
        self.marginIdentifier = marginIdentifier
        self.height = height
        self.list = list
    }
}

open class GXMessagesCenterSection {
    /// 日期
    open var date: Date
    /// 内容
    open var list: [any GXMessagesCenterOperation]
    
    required public init(date: Date, list: [any GXMessagesCenterOperation] = []) {
        self.date = date
        self.list = list
    }
}
