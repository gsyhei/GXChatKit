//
//  GXMessagesBaseCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/3.
//

import UIKit
import Reusable
import GXMessagesTableView

open class GXMessagesBaseCell: GXMessagesAvatarCellProtocol, Reusable {
    
    /// 消息数据
    public weak var item: GXMessagesItemData?
    
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

        return button
    }()
    
    //MARK: - GXMessagesAvatarCellProtocol
    
    public var avatar: UIView {
        return self.messageAvatarButton
    }
    
    public func createAvatarView() -> UIView {
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
//        self.setChecked(highlighted)
        self.updateHighlighted(highlighted, animated: animated)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.messageAvatarButton.isHidden = true
        self.messageAvatarButton.setImage(nil, for: .normal)
        self.messageAvatarButton.setImage(nil, for: .highlighted)
        self.messageBubbleNameLabel.isHidden = true
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
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognizer(_:)))
        longPress.minimumPressDuration = 1.0
        self.messageBubbleContainerView.addGestureRecognizer(longPress)
    }
    
    public func bindCell(item: GXMessagesItemData) {
        self.item = item
        switch item.data.gx_messageContinuousStatus {
        case .begin:
            self.messageBubbleImageView.image = item.bubble?.messageBeginBubbleImage
            self.messageBubbleImageView.highlightedImage = item.bubble?.messageBeginBubbleHighlightedImage
        case .ongoing:
            self.messageBubbleImageView.image = item.bubble?.messageOngoingBubbleImage
            self.messageBubbleImageView.highlightedImage = item.bubble?.messageOngoingBubbleHighlightedImage
        case .end, .beginAndEnd:
            self.messageBubbleImageView.image = item.bubble?.messageEndBubbleImage
            self.messageBubbleImageView.highlightedImage = item.bubble?.messageEndBubbleHighlightedImage
        }
        self.messageBubbleContainerView.frame = item.layout.containerRect
        
        if item.data.gx_isShowAvatar {
            self.messageAvatarButton.isHidden = false
            self.messageAvatarButton.frame = item.layout.avatarRect
            if item.avatar?.avatarImage == nil {
                self.messageAvatarButton.setImage(item.avatar?.avatarPlaceholderImage, for: .normal)
            }
            else {
                self.messageAvatarButton.setImage(item.avatar?.avatarImage, for: .normal)
                self.messageAvatarButton.setImage(item.avatar?.avatarHighlightedImage, for: .highlighted)
            }
            self.messageAvatarButton.isHidden = (item.data.gx_messageContinuousStatus != .end && item.data.gx_messageContinuousStatus != .beginAndEnd)
        }
        if item.data.gx_isShowNickname {
            self.messageBubbleNameLabel.isHidden = false
            self.messageBubbleNameLabel.frame = item.layout.nicknameRect
            self.messageBubbleNameLabel.text = item.data.gx_senderDisplayName
        }
        self.messageBubbleTimeLabel.frame = item.layout.timeRect
        self.messageBubbleTimeLabel.textAlignment = .right
        self.messageBubbleTimeLabel.text = item.data.gx_messageTime
        
        if item.data.gx_messageStatus == .sending {
            self.messageBubbleNameLabel.textAlignment = .right
            self.messageBubbleNameLabel.textColor = GXCHATC.sendingNicknameColor
            self.messageBubbleTimeLabel.textColor = GXCHATC.sendingTimeColor
        }
        else {
            self.messageBubbleNameLabel.textAlignment = .left
            self.messageBubbleNameLabel.textColor = GXCHATC.receivingNicknameColor
            self.messageBubbleTimeLabel.textColor = GXCHATC.receivingTimeColor
        }
    }

    public func setChecked(_ checked: Bool) {
        self.messageBubbleImageView.isHighlighted = checked
    }
}

extension GXMessagesBaseCell {
    
    private func updateHighlighted(_ highlighted: Bool, animated: Bool) {
        let transform: CGAffineTransform = highlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
        UIView.animate(withDuration: 0.25) {
            self.messageBubbleContainerView.transform = transform
        }
    }
    
    @objc func longPressGestureRecognizer(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            NSLog("longPressGestureRecognizer began")
        }
    }
}
