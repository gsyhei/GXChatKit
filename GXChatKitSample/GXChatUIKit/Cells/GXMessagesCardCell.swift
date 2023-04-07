//
//  GXMessagesCardCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/5.
//

import UIKit

public class GXMessagesCardCell: GXMessagesBaseCell {
    /// 名片头像
    public lazy var cardAvatarIView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear

        return imageView
    }()
    /// 名片名称Label
    public lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = GXCHATC.textFont
        label.textColor = GXCHATC.textColor

        return label
    }()
    /// 名片类型Label
    public lazy var cardTypeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = GXCHATC.timeFont
        
        return label
    }()
    /// 线条
    public lazy var cardLineView: UIView = {
        let view = UIView(frame: .zero)
        view.alpha = 0.3
        
        return view
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cardAvatarIView.image = nil
        self.cardTypeLabel.text = nil
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.messageBubbleContainerView.addSubview(self.cardAvatarIView)
        self.messageBubbleContainerView.addSubview(self.cardNameLabel)
        self.messageBubbleContainerView.addSubview(self.cardTypeLabel)
        self.messageBubbleContainerView.addSubview(self.cardLineView)
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        self.cardTypeLabel.textColor = self.messageBubbleTimeLabel.textColor
        self.cardLineView.backgroundColor = self.messageBubbleTimeLabel.textColor
        
        guard let layout = item.layout as? GXMessagesCardLayout else { return }
        self.cardAvatarIView.frame = layout.cardAvatarRect
        self.cardNameLabel.frame = layout.cardNameRect
        self.cardTypeLabel.frame = layout.cardTypeRect
        self.cardLineView.frame = layout.cardLineRect
        
        guard let content = item.data.gx_messagesContent as? GXMessagesCardContent else { return }
        if content.cardAvatar.avatarImage == nil {
            self.cardAvatarIView.image = content.cardAvatar.avatarPlaceholderImage
        }
        else {
            self.cardAvatarIView.image = content.cardAvatar.avatarImage
        }
        self.cardTypeLabel.text = content.cardTypeName
        self.cardNameLabel.text = content.contact.gx_displayName
    }
}
