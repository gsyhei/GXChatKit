//
//  GXMessagesBaseCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/3.
//

import UIKit
import Reusable
import GXMessagesHoverAvatarTableView

open class GXMessagesBaseCell: GXMessagesAvatarCellProtocol, Reusable, NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let cell = type(of: self).init(frame: self.frame)
        if let nonullItem = self.item {
            cell.bindCell(item: nonullItem)
        }
        return cell
    }
    
    /// 代理
    public weak var delegate: GXMessagesBaseCellDelegate?
    
    /// 消息数据
    public weak var item: GXMessagesItemData?
    
    /// 气泡对象
    public var bubble: GXMessagesBubble?
    
    /// 气泡上边的Label（群昵称）
    public lazy var messageBubbleNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = GXCHATC.nicknameFont
        
        return label
    }()
    /// 气泡内容的容器
    public lazy var messageBubbleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    /// 气泡imageView
    public lazy var messageBubbleImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear

        return imageView
    }()
    /// 右边的时间
    public lazy var messageBubbleTimeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .right
        label.font = GXCHATC.timeFont

        return label
    }()
    /// 头像按钮
    public lazy var messageAvatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.messageAvatarButtonClicked(_:)), for: .touchUpInside)
        
        return button
    }()
    
    /// 回复侧滑标志
    public lazy var replyIndicatorView: GXMessagesReplyIndicatorView = {
        let frame = CGRect(origin: .zero, size: GXCHATC.replyIndicatorSize)
        let view = GXMessagesReplyIndicatorView(frame: frame)
        view.actionBlock = {[weak self] in
            self?.generator.impactOccurred(intensity: 1.0)
        }
        return view
    }()
    
    /// 发送动画视图
    public lazy var clockView: GXMessagesClockView = {
        let view = GXMessagesClockView(frame: .zero)
        return view
    }()
    
    /// 震动对象
    private lazy var generator: UIImpactFeedbackGenerator = {
        return UIImpactFeedbackGenerator(style: .rigid)
    }()
    
    /// Pan手势锁
    private var isPanLock: Bool = false
    /// 悬浮头像
    private var hoverAvatar: UIView?
    private var hoverAvatarRect: CGRect = .zero

    //MARK: - GXMessagesAvatarCellProtocol
    
    public var gx_avatar: UIView {
        return self.messageAvatarButton
    }
    
    public func gx_createAvatarView() -> UIView {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear

        return button
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.updateHighlighted(highlighted, animated: animated)
    }

    open override func gx_setEditing(_ editing: Bool, animated: Bool) {
        super.gx_setEditing(editing, animated: animated)
        self.contentView.isUserInteractionEnabled = !editing
        guard self.item?.data.gx_messageStatus == .receive else { return }
        
        var avatarViewFrame = self.item?.layout.avatarRect ?? CGRectZero
        var contentViewFrame = self.item?.layout.containerRect ?? CGRectZero
        if editing {
            avatarViewFrame.origin.x += GXMessagesHoverAvatarTableView.GXEditViewWidth
            contentViewFrame.origin.x += GXMessagesHoverAvatarTableView.GXEditViewWidth
        }
        if animated {
            UIView.animate(withDuration: GXMessagesHoverAvatarTableView.GXEditAnimateDuration) {
                self.messageAvatarButton.frame = avatarViewFrame
                self.messageBubbleContainerView.frame = contentViewFrame
            }
        }
        else {
            self.messageAvatarButton.frame = avatarViewFrame
            self.messageBubbleContainerView.frame = contentViewFrame
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.clockView.removeFromSuperview()
        self.messageAvatarButton.isHidden = true
        self.messageAvatarButton.setImage(nil, for: .normal)
        self.messageAvatarButton.setImage(nil, for: .highlighted)
        self.messageBubbleNameLabel.isHidden = true
        self.hoverAvatar = nil
        self.isPanLock = false
    }
    
    public func createSubviews() {
        self.selectionStyle = .none
        self.backgroundColor = .clear

        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.messageAvatarButton)
        self.contentView.addSubview(self.messageBubbleContainerView)
        self.messageBubbleImageView.frame = self.messageBubbleContainerView.bounds
        self.messageBubbleImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.messageBubbleContainerView.addSubview(self.messageBubbleImageView)
        self.messageBubbleContainerView.addSubview(self.messageBubbleNameLabel)
        self.messageBubbleContainerView.addSubview(self.messageBubbleTimeLabel)
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognizer(_:)))
        longPressGR.minimumPressDuration = 0.6
        self.messageBubbleContainerView.addGestureRecognizer(longPressGR)
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizer(_:)))
        panGR.delegate = self
        self.contentView.addGestureRecognizer(panGR)
    }
    
    public func bindCell(item: GXMessagesItemData, delegate: GXMessagesBaseCellDelegate?) {
        self.delegate = delegate
        self.bindCell(item: item)
    }
    
    public func bindCell(item: GXMessagesItemData) {
        self.item = item
        
        var avatarViewFrame = item.layout.avatarRect
        var contentViewFrame = item.layout.containerRect
        if self.gx_isEditing && self.item?.data.gx_messageStatus == .receive {
            avatarViewFrame.origin.x += GXMessagesHoverAvatarTableView.GXEditViewWidth
            contentViewFrame.origin.x += GXMessagesHoverAvatarTableView.GXEditViewWidth
        }
        if item.data.gx_messageType == .redPacket {
            self.bubble = GXMessagesBubbleFactory.messagesRedPacketBubble(status: item.data.gx_messageStatus)
        }
        else {
            self.bubble = GXMessagesBubbleFactory.messagesBubble(status: item.data.gx_messageStatus)
        }
        if item.data.gx_continuousEnd {
            self.messageBubbleImageView.image = self.bubble?.messageEndBubbleImage
            self.messageBubbleImageView.highlightedImage = self.bubble?.messageEndBubbleHighlightedImage
        }
        else if item.data.gx_continuousBegin {
            self.messageBubbleImageView.image = self.bubble?.messageBeginBubbleImage
            self.messageBubbleImageView.highlightedImage = self.bubble?.messageBeginBubbleHighlightedImage
        }
        else {
            self.messageBubbleImageView.image = self.bubble?.messageOngoingBubbleImage
            self.messageBubbleImageView.highlightedImage = self.bubble?.messageOngoingBubbleHighlightedImage
        }
        self.messageBubbleContainerView.frame = contentViewFrame
        
        if item.data.gx_isShowAvatar {
            self.messageAvatarButton.isHidden = false
            self.messageAvatarButton.frame = avatarViewFrame
            if item.avatar?.avatarImage == nil {
                self.messageAvatarButton.setImage(item.avatar?.avatarPlaceholderImage, for: .normal)
            }
            else {
                self.messageAvatarButton.setImage(item.avatar?.avatarImage, for: .normal)
                self.messageAvatarButton.setImage(item.avatar?.avatarHighlightedImage, for: .highlighted)
            }
            self.messageAvatarButton.isHidden = !item.data.gx_continuousEnd
        }
        if item.data.gx_isShowNickname {
            self.messageBubbleNameLabel.isHidden = false
            self.messageBubbleNameLabel.frame = item.layout.nicknameRect
            self.messageBubbleNameLabel.text = item.data.gx_senderDisplayName
        }
        self.messageBubbleTimeLabel.frame = item.layout.timeRect
        self.messageBubbleTimeLabel.textAlignment = .right
        self.messageBubbleTimeLabel.attributedText = item.data.gx_timeAttributedText
        
        if item.data.gx_messageStatus == .send {
            self.messageBubbleNameLabel.textAlignment = .right
            if let hexString = item.dispalyNameHexString {
                self.messageBubbleNameLabel.textColor = UIColor(hexString: hexString)
            } else {
                self.messageBubbleNameLabel.textColor = GXCHATC.sendingNicknameColor
            }
            self.messageBubbleTimeLabel.textColor = GXCHATC.sendingTimeColor
            if item.data.gx_messageSendStatus == .sending {
                self.clockView.frame = item.layout.clockRect
                self.messageBubbleContainerView.addSubview(self.clockView)
            }
        }
        else {
            self.messageBubbleNameLabel.textAlignment = .left
            if let hexString = item.dispalyNameHexString {
                self.messageBubbleNameLabel.textColor = UIColor(hexString: hexString)
            } else {
                self.messageBubbleNameLabel.textColor = GXCHATC.receivingNicknameColor
            }
            self.messageBubbleTimeLabel.textColor = GXCHATC.receivingTimeColor
        }
    }

    @objc public func setBubbleHighlighted(_ checked: Bool) {
        self.messageBubbleImageView.isHighlighted = checked
    }
    
    public func showAutoHighlighted() {
        self.setBubbleHighlighted(true)
        self.perform(#selector(setBubbleHighlighted(_:)), with: false, afterDelay: 1.0)
    }
    
}

extension GXMessagesBaseCell {
    
    // MARK: - UIGestureRecognizerDelegate
    open override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is UIPanGestureRecognizer {
            return !self.isPanLock
        }
        return true
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            if self.isEditing { return true }
            guard self.item?.data.gx_messageSendStatus != .failure else { return false }
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

private extension GXMessagesBaseCell {
    
    @objc func messageAvatarButtonClicked(_ sender: Any) {
        guard !self.isEditing else { return }

        self.delegate?.messagesCell(self, didAvatarTapAt: self.item)
    }
    
    @objc func longPressGestureRecognizer(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard !self.isEditing else { return }
        guard self.isHighlighted else { return }
        
        if gestureRecognizer.state == .began {
            self.generator.impactOccurred()
            self.delegate?.messagesCell(self, didLongPressAt: self.item)
        }
    }
    
    @objc func panGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard !self.isEditing else { return }
        if let table = self.superview as? GXMessagesHoverAvatarTableView {
            if table.isDecelerating || table.isDecelerating || table.isDragging {
                return
            }
        }
        
        switch gestureRecognizer.state {
        case .began:
            self.panStateBegan()
        case .cancelled, .failed:
            self.panStateEndAnimation()
        case .ended:
            self.panStateEndAnimation()
            break
        case .changed:
            let movePoint = gestureRecognizer.translation(in: gestureRecognizer.view)
            self.updateSafeCurrentPoint(movePoint)
            gestureRecognizer.setTranslation(.zero, in: gestureRecognizer.view)
        default: break
        }
    }
    
    func updateHighlighted(_ highlighted: Bool, animated: Bool) {
        let transform: CGAffineTransform = highlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
        UIView.animate(withDuration: 0.25) {
            self.messageBubbleContainerView.transform = transform
        }
    }
        
    func panStateBegan() {
        self.isPanLock = true
        self.replyIndicatorView.reset()
        if let data = self.item?.data, data.gx_messageStatus == .send {
            let left = self.frame.maxX + 10.0
            let point = CGPoint(x: left, y: (self.height - self.replyIndicatorView.height)/2)
            self.replyIndicatorView.origin = point
        }
        else {
            let left = self.frame.maxX
            let point = CGPoint(x: left, y: (self.height - self.replyIndicatorView.height)/2)
            self.replyIndicatorView.origin = point
        }
        self.contentView.addSubview(self.replyIndicatorView)

        if let table = self.superview as? GXMessagesHoverAvatarTableView {
            if let indexPath = table.indexPath(for: self) {
                if indexPath == table.avatarToCellIndexPath {
                    self.hoverAvatar = table.hoverToCellAvatar
                    self.hoverAvatarRect = table.hoverToCellAvatar?.frame ?? .zero
                }
            }
        }
    }
    
    func updateSafeCurrentPoint(_ movePoint: CGPoint) {
        guard abs(movePoint.x) > abs(movePoint.y) else { return }
        
        var moveMaxWidth = GXCHATC.replyIndicatorMoveMaxWidth
        if let data = self.item?.data, data.gx_messageStatus == .send {
            moveMaxWidth = GXCHATC.replyIndicatorMoveMaxWidth + 10.0
        }
        var moveX = movePoint.x
        let currentLeft = self.contentView.left
        if movePoint.x < 0 && currentLeft <= -moveMaxWidth {
            moveX = -0.1
        }
        var moveLeft = currentLeft + moveX
        if moveLeft <= -moveMaxWidth {
            self.replyIndicatorView.showAnimation()
        }
        else if moveLeft > 0 {
            moveLeft = 0
        }
        self.contentView.left = moveLeft
        var progress = abs(moveLeft) / moveMaxWidth
        progress = progress > 1.0 ? 1.0 : progress
        self.replyIndicatorView.progress = progress
        
        if let letHoverAvatar = self.hoverAvatar {
            letHoverAvatar.left = self.hoverAvatarRect.minX + moveLeft
        }
    }
    
    func panStateEndAnimation() {
        if self.replyIndicatorView.progress == 1.0 {
            self.delegate?.messagesCell(self, didSwipeAt: self.item)
        }
        self.isPanLock = false
        UIView.animate(withDuration: 0.3) {
            self.contentView.left = 0
            self.hoverAvatar?.frame = self.hoverAvatarRect
            self.replyIndicatorView.reset(end: true)
        } completion: { finish in
            self.replyIndicatorView.removeFromSuperview()
            self.hoverAvatar = nil
        }
    }
    
}
