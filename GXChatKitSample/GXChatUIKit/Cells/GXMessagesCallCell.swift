//
//  GXMessagesCallCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/28.
//

import UIKit

public class GXMessagesCallCell: GXMessagesBaseCell {
    
    /// icon图
    public lazy var iconIView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = GXCHATC.textColor

        return imageView
    }()
    
    /// 文本Label
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = GXCHATC.textFont
        label.textColor = GXCHATC.textColor

        return label
    }()

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = nil
        self.iconIView.image = nil
    }
    
    public override func createSubviews() {
        super.createSubviews()
        
        self.messageBubbleContainerView.addSubview(self.iconIView)
        self.messageBubbleContainerView.addSubview(self.titleLabel)
    }

    public override func bindCell(item: GXMessagesItemLayoutData) {
        super.bindCell(item: item)
        
        guard let content = item.data.gx_messagesContentData as? GXMessagesCallContent else { return }
        guard let layout = item.layout as? GXMessagesCallLayout else { return }

        self.titleLabel.text = content.text
        self.titleLabel.frame = layout.textRect
        
        self.iconIView.frame = layout.iconRect
        if item.data.gx_messageType == .voiceCall {
            self.iconIView.image = UIImage(systemName: "phone.down")
        }
        else if item.data.gx_messageType == .videoCall {
            self.iconIView.image = UIImage(systemName: "video")
        }
        if item.data.gx_messageStatus == .sending {
            self.iconIView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
    
}
