//
//  GXMessagesRedPacketCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/8.
//

import UIKit

public class GXMessagesRedPacketCell: GXMessagesBaseCell {
    /// 红包icon
    public lazy var rpIconIView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.gx_bundleAssetImage(name: "redEnvelope")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = GXCHATC.redPacketIconColor

        return imageView
    }()
    /// 红包文本Label
    public lazy var rpTextLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = GXCHATC.redPacketTextFont
        label.textColor = GXCHATC.redPacketTextColor

        return label
    }()
    /// 红包状态Label
    public lazy var rpStatusLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = GXCHATC.redPacketStatusFont
        label.textColor = GXCHATC.redPacketStatusColor
        
        return label
    }()
    /// 红包名称Label
    public lazy var rpNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = GXCHATC.timeFont

        return label
    }()
    /// 线条
    public lazy var rpLineView: UIView = {
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
        
        self.rpTextLabel.text = nil
        self.rpStatusLabel.text = nil
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.messageBubbleContainerView.addSubview(self.rpIconIView)
        self.messageBubbleContainerView.addSubview(self.rpTextLabel)
        self.messageBubbleContainerView.addSubview(self.rpStatusLabel)
        self.messageBubbleContainerView.addSubview(self.rpNameLabel)
        self.messageBubbleContainerView.addSubview(self.rpLineView)
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        self.messageBubbleNameLabel.textColor = .white
        self.messageBubbleTimeLabel.textColor = .white
        self.rpNameLabel.textColor = .white
        self.rpLineView.backgroundColor = .white
        
        guard let layout = item.layout as? GXMessagesRedPacketLayout else { return }
        self.rpIconIView.frame = layout.rpIconRect
        self.rpTextLabel.frame = layout.rpTextRect
        self.rpStatusLabel.frame = layout.rpStatusRect
        self.rpNameLabel.frame = layout.rpNameRect
        self.rpLineView.frame = layout.rpLineRect

        guard let content = item.data.gx_messagesContent as? GXMessagesRedPacketContent else { return }
        self.rpTextLabel.text = content.text
        self.rpStatusLabel.text = content.statusName
        self.rpNameLabel.text = content.name
    }
}
