//
//  GXMessagesCellPreviewController.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/5/1.
//

import UIKit
import Reusable

public class GXMessagesCellPreviewController: UIViewController {
    private let lineSpacing: CGFloat = 10.0
    private let headerHeight: CGFloat = 8.0
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
        let tv = UITableView(frame: self.view.bounds, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .clear
        tv.separatorColor = UIColor(hex: 0xD1D1D1)
        tv.layer.borderWidth = 1.0
        tv.layer.borderColor = UIColor(white: 0.8, alpha: 0.3).cgColor
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 16.0
        tv.configuration(separatorLeft: true)
        tv.isScrollEnabled = false
        tv.register(cellType: GXMessagesCellPreviewCell.self)
        
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
    
//    enum MessageMenuType: Int {
//        /// 回复
//        case repply  = 0
//        /// 复制
//        case copy    = 1
//        /// 转发
//        case forward = 2
//        /// 编辑
//        case edit    = 3
//        /// 保存
//        case save    = 4
//        /// 收藏
//        case collect = 5
//        /// 撤回
//        case revoke  = 6
//        /// 删除
//        case delete  = 7
//        /// 举报
//        case report  = 8
//        /// 选择
//        case select  = 9
//    }
    func setupLayout() {
        self.itemTypes = [[.repply, .copy, .forward, .edit, .save, .collect, .revoke, .report, .delete], [.select]]
        
        var tableHeight: CGFloat = CGFloat(self.itemTypes.count - 1) * self.headerHeight
        for types in self.itemTypes {
            tableHeight += self.itemHeight * CGFloat(types.count)
        }
        let bottomHeight = tableHeight + self.lineSpacing * 2
        let safeBottom = self.view.currentWindow()?.safeAreaInsets.bottom ?? 0
        let bottomTop = self.view.frame.height - bottomHeight - safeBottom
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

extension GXMessagesCellPreviewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.itemTypes.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemTypes[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GXMessagesCellPreviewCell = tableView.dequeueReusableCell(for: indexPath)
        let type = self.itemTypes[indexPath.section][indexPath.row]
        cell.bindCell(type: type)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.itemHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return CGFloat.leastNonzeroMagnitude }
        
        return self.headerHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
}

public class GXMessagesCellPreviewCell: UITableViewCell, Reusable {
    
    public lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = GXCHATC.textFont
        
        return label
    }()
    
    public lazy var iconIView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        self.contentView.addSubview(self.typeLabel)
        self.contentView.addSubview(self.iconIView)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard self.frame != .zero else { return }
        
        let margin: CGFloat = 16.0, iconSize: CGFloat = 20.0
        let iconTop = (self.frame.height - iconSize)/2
        let iconLeft = self.frame.width - iconSize - margin
        self.iconIView.frame = CGRect(x: iconLeft, y: iconTop, width: iconSize, height: iconSize)
        
        let labelTop = (self.frame.height - GXCHATC.textFont.lineHeight)/2
        let labelWidth = self.frame.width - (self.frame.width - self.iconIView.frame.minX) - margin * 2
        self.typeLabel.frame = CGRect(x: margin, y: labelTop, width: labelWidth, height: GXCHATC.textFont.lineHeight)
    }
    
    public func bindCell(type: GXChatConfiguration.MessageMenuType) {
        self.typeLabel.text = GXCHATC.chatText.gx_menuTypeString(type: type)
        self.iconIView.image = UIImage.gx_cellPreviewIconImage(type: type)
        
        if type == .delete {
            self.iconIView.tintColor = .systemRed
            self.typeLabel.textColor = .systemRed
        }
        else {
            self.iconIView.tintColor = .black
            self.typeLabel.textColor = .black
        }
    }
    
}
