//
//  GXMessagesCellPreviewController.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/5/1.
//

import UIKit
import Reusable

public class GXMessagesCellPreviewController: UIViewController {
    private let lineSpacing: CGFloat = 6.0
    private let headerHeight: CGFloat = 8.0
    private let tableWidth: CGFloat = SCREEN_WIDTH/2
    private let itemHeight: CGFloat = 44.0
    
    public var messageData: GXMessagesDataDelegate
    public var preview: UIView
    public var originalRect: CGRect
    
    public var currentRect: CGRect = .zero
    public var itemTypes: [[GXChatConfiguration.MessageMenuType]] = []
    public var tableRect: CGRect = .zero
    
    public var actionBlock: ((GXMessagesDataDelegate, GXChatConfiguration.MessageMenuType) -> Void)?
    
    public lazy var animationDelegate: GXMessagesMenuAnimationDelegate = {
        let animationDelegate = GXMessagesMenuAnimationDelegate()
        
        return animationDelegate
    }()
    
    public lazy var backgroudView: UIVisualEffectView = {
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
        tv.separatorColor = UIColor(hex: 0xB1B1B1)
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor(white: 0.5, alpha: 0.3).cgColor
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 16.0
        tv.configuration(separatorLeft: true)
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
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
        
        self.setupTypes()
        self.setupLayout()
        self.setupViewController()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let viewPoint = touch.location(in: self.view)
        guard self.tableRect.contains(viewPoint) else { return }
        
        let point = self.view.convert(viewPoint, to: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: point) else { return }
        
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let viewPoint = touch.location(in: self.view)
        
        if self.tableRect.contains(viewPoint) {
            let point = self.view.convert(viewPoint, to: self.tableView)
            guard let indexPath = self.tableView.indexPathForRow(at: point) else { return }
            if let oldIndexPath = self.tableView.indexPathForSelectedRow {
                if oldIndexPath != indexPath {
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            }
            else {
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        else {
            guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            self.tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        let type = self.itemTypes[indexPath.section][indexPath.row]
        self.actionBlock?(self.messageData, type)
        self.dismiss(animated: true)
    }
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.deselectAll(animated: false)
    }
}

extension GXMessagesCellPreviewController: UIGestureRecognizerDelegate {
    
    func setupTypes() {
        //self.itemTypes = [[.repply, .copy, .forward, .edit, .save, .collect, .revoke, .report, .delete], [.select]]
        var types: [GXChatConfiguration.MessageMenuType] = []
        if self.messageData.gx_messageSendStatus == .failure {
            types.append(.resend)
            types.append(.delete)
        }
        else if self.messageData.gx_messageSendStatus == .sending {
            if self.messageData.gx_messageType == .text || self.messageData.gx_messageType == .atText {
                types.append(.copy)
            }
            types.append(.delete)
        }
        else {
            types.append(.repply)
            types.append(.forward)
            types.append(.collect)
            if self.messageData.gx_messageType == .text || self.messageData.gx_messageType == .atText {
                types.append(.copy)
                if self.messageData.gx_messageStatus == .send {
                    types.append(.edit)
                }
            }
            if self.messageData.gx_messageType == .phote || self.messageData.gx_messageType == .video {
                types.append(.save)
                types.append(.report)
            }
            if self.messageData.gx_messageStatus == .send {
                types.append(.revoke)
            }
            types.append(.delete)
        }
        self.itemTypes = [types, [.select]]
    }
    
    func setupLayout() {
        var tableHeight: CGFloat = CGFloat(self.itemTypes.count - 1) * self.headerHeight
        for types in self.itemTypes {
            tableHeight += self.itemHeight * CGFloat(types.count)
        }
        let bottomHeight = tableHeight + self.lineSpacing * 2
        let safeAreaInsets = self.view.currentWindow()?.safeAreaInsets ?? .zero
        let bottomTop = self.view.frame.height - bottomHeight - safeAreaInsets.bottom
        let allHeight = bottomHeight + self.originalRect.height
        let viewHeight = self.view.frame.height - safeAreaInsets.top - safeAreaInsets.bottom

        var tableTop: CGFloat = 0
        if allHeight < viewHeight {
            self.currentRect = self.originalRect
            if self.originalRect.minY < safeAreaInsets.top {
                self.currentRect.origin.y = safeAreaInsets.top
            }
            else if self.originalRect.maxY > bottomTop {
                self.currentRect.origin.y = bottomTop - self.originalRect.height
            }
            tableTop = self.currentRect.maxY + self.lineSpacing
        }
        else {
            self.currentRect = self.originalRect
            if viewHeight > self.originalRect.height {
                self.currentRect.origin.y = safeAreaInsets.top
            }
            else {
                self.currentRect.origin.y = self.view.frame.height - self.originalRect.height - safeAreaInsets.bottom
            }
            tableTop = bottomTop
        }
        
        let hookWidth = GXCHATC.bubbleLeadingInsets.left - GXCHATC.bubbleLeadingInsets.right
        if self.messageData.gx_messageStatus == .send {
            let left = self.originalRect.maxX - self.tableWidth - hookWidth
            self.tableRect = CGRect(x: left, y: tableTop, width: self.tableWidth, height: tableHeight)
        }
        else {
            let left = self.originalRect.origin.x + hookWidth
            self.tableRect = CGRect(x: left, y: tableTop, width: self.tableWidth, height: tableHeight)
        }
    }
    
    func setupViewController() {
        self.view.backgroundColor = .clear
        self.preview.isUserInteractionEnabled = false
        
        self.view.addSubview(self.backgroudView)
        self.preview.frame = self.currentRect
        self.view.addSubview(self.preview)
        self.tableView.frame = self.tableRect
        self.view.addSubview(self.tableView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureRecognizer(_:)))
        tap.delegate = self
        self.backgroudView.addGestureRecognizer(tap)
    }
        
    @objc func tapGestureRecognizer(_ tap: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: self.view)
        return !self.tableRect.contains(point)
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
    
    private lazy var generator: UIImpactFeedbackGenerator = {
        return UIImpactFeedbackGenerator(style: .light)
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
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        let oldSelected = self.isSelected
        super.setSelected(selected, animated: animated)
        if selected && oldSelected != selected {
            self.generator.impactOccurred()
        }
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
