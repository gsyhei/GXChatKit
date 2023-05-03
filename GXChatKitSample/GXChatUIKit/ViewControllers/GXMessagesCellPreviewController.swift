//
//  GXMessagesCellPreviewController.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/5/1.
//

import UIKit

public class GXMessagesCellPreviewController: UIViewController {
    private let lineSpacing: CGFloat = 10.0
    private let headerHeight: CGFloat = 12.0
    private let tableWidth: CGFloat = 200.0
    private let itemHeight: CGFloat = 44.0
    
    public var messageData: GXMessagesDataDelegate
    public var preview: UIView
    public var originalRect: CGRect
    
    public var currentRect: CGRect = .zero
    public var itemTypes: [[GXChatConfiguration.MessageMenuType]] = []
    public var tableRect: CGRect = .zero
    
    private lazy var backgroudView: UIVisualEffectView = {
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = self.view.bounds
        
        return view
    }()
    
    public lazy var tableView: UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .grouped)
//        tv.dataSource = self
//        tv.delegate = self
        tv.backgroundColor = UIColor(hex: 0xEFEFEF)
        tv.separatorInset = .zero
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 20.0
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        
        return tv
    }()

    public init(data: GXMessagesDataDelegate, preview: UIView, originalRect: CGRect) {
        self.messageData = data
        self.preview = preview
        self.originalRect = originalRect
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.setupViewController()
    }
    
}

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
        let tableTop = self.currentRect.maxY + self.lineSpacing - 4.0
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        if self.messageData.gx_messageStatus == .receiving {
            let left = self.originalRect.origin.x + hookWidth
            self.tableRect = CGRect(x: left, y: tableTop, width: self.tableWidth, height: tableHeight)
        }
        else {
            let left = self.originalRect.maxX - self.tableWidth - hookWidth
            self.tableRect = CGRect(x: left, y: tableTop, width: self.tableWidth, height: tableHeight)
        }
    }
    
    func setupViewController() {
        self.view.backgroundColor = .clear
        
        self.view.addSubview(self.backgroudView)
        self.preview.frame = self.currentRect
        self.view.addSubview(self.preview)
        self.tableView.frame = self.tableRect
        self.view.addSubview(self.tableView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureRecognizer(_:)))
        self.backgroudView.addGestureRecognizer(tap)
    }
    
    @objc func tapGestureRecognizer(_ tap: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
}
