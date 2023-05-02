//
//  GXMessagesCellPreviewController.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/5/1.
//

import UIKit

public class GXMessagesCellPreviewController: UIViewController {
    private let lineSpacing: CGFloat = 12.0
    private let headerHeight: CGFloat = 12.0
    private let tableWidth: CGFloat = 200.0
    private let itemHeight: CGFloat = 44.0
    
    public var messageData: GXMessagesDataProtocol
    public var preview: UIView
    public var originalRect: CGRect
    public var currentRect: CGRect!
    private var itemTypes: [[GXChatConfiguration.MessageMenuType]]!
    private var tableRect: CGRect = .zero

    public init(data: GXMessagesDataProtocol, preview: UIView, originalRect: CGRect) {
        self.messageData = data
        self.preview = preview
        self.originalRect = originalRect
        super.init(nibName: nil, bundle: nil)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewController()
    }
    
}

/// 消息菜单
//enum MessageMenuType: Int {
//    /// 回复
//    case repply  = 0
//    /// 复制
//    case copy    = 1
//    /// 转发
//    case forward = 2
//    /// 编辑
//    case edit    = 3
//    /// 保存
//    case save    = 4
//    /// 收藏
//    case collect = 5
//    /// 撤回
//    case revoke  = 6
//    /// 删除
//    case delete  = 7
//    /// 举报
//    case report  = 8
//    /// 选择
//    case select  = 9
//}

private extension GXMessagesCellPreviewController {
    func setupLayout() {
        self.itemTypes = [[.repply, .forward, .collect, .report, .delete], [.select]]
        var tableHeight: CGFloat = CGFloat(self.itemTypes.count - 1) * self.headerHeight
        for types in self.itemTypes {
            tableHeight += self.itemHeight * CGFloat(types.count)
        }
        let bottomHeight = tableHeight + self.lineSpacing * 2
        let bottomTop = self.view.frame.height - bottomHeight
        if self.originalRect.maxY > bottomTop {
            self.currentRect = self.originalRect
            self.currentRect.origin.y = bottomTop - self.originalRect.height
        }
        else {
            self.currentRect = self.originalRect
        }
        let tableTop = self.currentRect.maxY + self.lineSpacing
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        if self.messageData.gx_messageSendStatus == .sending {
            let left = self.originalRect.origin.x
            self.tableRect = CGRect(x: left, y: 0, width: self.tableWidth, height: tableHeight)
        }
        else {
            let left = self.originalRect.origin.x + hookWidth
            self.tableRect = CGRect(x: left, y: 0, width: self.tableWidth, height: tableHeight)
        }
    }
    
    func setupViewController() {
        
    }
    
}
