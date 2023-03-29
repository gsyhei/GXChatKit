//
//  GXMessagesMediaCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/12.
//

import UIKit

public class GXMessagesMediaCell: GXMessagesBaseCell {
    
    /// 气泡imageView
    public var mediaView: UIView?
    
    /// 播放按钮
    public lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "play.circle")
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = .white
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = .zero
        button.isUserInteractionEnabled = false
        button.isHidden = true
        
        return button
    }()

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.playButton.isHidden = true
        self.mediaView?.removeFromSuperview()
    }
    
    public override func createSubviews() {
        super.createSubviews()
        
        self.messageBubbleContainerView.addSubview(self.playButton)
        self.messageBubbleNameLabel.layer.shadowOpacity = 1.0
        self.messageBubbleNameLabel.layer.shadowRadius = 2.0
        self.messageBubbleNameLabel.layer.shadowColor = UIColor.black.cgColor
        self.messageBubbleNameLabel.layer.shadowOffset = .zero
        self.messageBubbleTimeLabel.layer.shadowOpacity = 1.0
        self.messageBubbleTimeLabel.layer.shadowRadius = 2.0
        self.messageBubbleTimeLabel.layer.shadowColor = UIColor.black.cgColor
        self.messageBubbleTimeLabel.layer.shadowOffset = .zero
    }

    public override func bindCell(item: GXMessagesItemLayoutData) {
        super.bindCell(item: item)

        if item.gx_isShowNickname {
            self.messageBubbleNameLabel.textColor = .white
            self.messageBubbleNameLabel.frame = item.layout.nicknameRect
        }
        self.messageBubbleTimeLabel.textColor = .white
        self.messageBubbleTimeLabel.frame = item.layout.timeRect

        if let content = item.data.gx_messagesContentData as? GXMessagesPhotoContent {
            guard let layout = item.layout as? GXMessagesPhotoLayout else { return }

            if let itemMediaView = content.mediaView {
                self.messageBubbleImageView.addSubview(itemMediaView)
                self.mediaView = itemMediaView
            }
            else {
                let itemMediaView = UIImageView(frame: layout.imageRect)
                itemMediaView.image = content.thumbnailImage
                itemMediaView.setMaskImage(self.messageBubbleImageView.image, dx: 1.0, dy: 1.0)
                self.messageBubbleImageView.addSubview(itemMediaView)
                self.mediaView = itemMediaView
                content.mediaView = itemMediaView
            }
        }
        else if let content = item.data.gx_messagesContentData as? GXMessagesVideoContent {
            guard let layout = item.layout as? GXMessagesVideoLayout else { return }

            if let itemMediaView = content.mediaView {
                self.messageBubbleImageView.addSubview(itemMediaView)
                self.mediaView = itemMediaView
            }
            else {
                let itemMediaView = UIImageView(frame: layout.imageRect)
                itemMediaView.image = content.thumbnailImage
                itemMediaView.setMaskImage(self.messageBubbleImageView.image, dx: 1.0, dy: 1.0)
                self.messageBubbleImageView.addSubview(itemMediaView)
                self.mediaView = itemMediaView
                content.mediaView = itemMediaView
            }
            self.playButton.isHidden = false
            self.playButton.center = self.messageBubbleImageView.center
        }
    }

}
