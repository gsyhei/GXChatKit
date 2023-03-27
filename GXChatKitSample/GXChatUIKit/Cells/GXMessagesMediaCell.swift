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
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
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
        if !self.playButton.isHidden {
            self.playButton.isHighlighted = highlighted
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.playButton.isHidden = true
        self.mediaView?.removeFromSuperview()
    }
    
    public override func createSubviews() {
        super.createSubviews()
        
        self.messageBubbleContainerView.addSubview(self.playButton)
        self.messageBubbleNameLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.messageBubbleTimeLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.messageBubbleNameLabel.layer.masksToBounds = true
        self.messageBubbleTimeLabel.layer.masksToBounds = true
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        
        if item.gx_isShowNickname {
            self.messageBubbleNameLabel.textAlignment = .center
            self.messageBubbleNameLabel.textColor = .white
            self.messageBubbleNameLabel.layer.cornerRadius = item.nicknameRect.height/2 + 2
            self.messageBubbleNameLabel.frame = item.nicknameRect.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -4, right: -item.nicknameRect.height))
        }
        self.messageBubbleTimeLabel.textAlignment = .center
        self.messageBubbleTimeLabel.textColor = .white
        self.messageBubbleTimeLabel.layer.cornerRadius = item.timeRect.height/2 + 2
        self.messageBubbleTimeLabel.frame = item.timeRect.inset(by: UIEdgeInsets(top: -4, left: -item.timeRect.height, bottom: 0, right: 0))

        if let content = item.data.gx_messagesContentData as? GXMessagesPhotoContent {
            if let itemMediaView = content.mediaView {
                itemMediaView.frame = item.contentRect
                self.messageBubbleImageView.addSubview(itemMediaView)
                self.mediaView = itemMediaView
            }
            else {
                let itemMediaView = UIImageView(frame: item.contentRect)
                itemMediaView.image = content.thumbnailImage
                itemMediaView.setMaskImage(self.messageBubbleImageView.image, dx: 1.0, dy: 1.0)
                self.messageBubbleImageView.addSubview(itemMediaView)
                self.mediaView = itemMediaView
                content.mediaView = itemMediaView
            }
        }
        else if let content = item.data.gx_messagesContentData as? GXMessagesVideoContent {
            if let itemMediaView = content.mediaView {
                itemMediaView.frame = item.contentRect
                self.messageBubbleImageView.addSubview(itemMediaView)
                self.mediaView = itemMediaView
            }
            else {
                let itemMediaView = UIImageView(frame: item.contentRect)
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
