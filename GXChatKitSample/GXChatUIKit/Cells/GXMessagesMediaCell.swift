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
        button.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20.0
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = .white
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
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        
        self.messageBubbleNameLabel.textColor = .white
        self.messageBubbleTimeLabel.textColor = .white
        self.messageBubbleNameLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.messageBubbleTimeLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.messageBubbleNameLabel.textAlignment = .center
        self.messageBubbleTimeLabel.textAlignment = .center
        self.messageBubbleNameLabel.layer.masksToBounds = true
        self.messageBubbleTimeLabel.layer.masksToBounds = true
        self.messageBubbleNameLabel.layer.cornerRadius = item.nicknameRect.height/2 + 2
        self.messageBubbleTimeLabel.layer.cornerRadius = item.timeRect.height/2 + 2
        self.messageBubbleNameLabel.frame = item.nicknameRect.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -4, right: -item.nicknameRect.height))
        self.messageBubbleTimeLabel.frame = item.timeRect.inset(by: UIEdgeInsets(top: -4, left: -item.timeRect.height, bottom: 0, right: 0))

        if let content = item.data.gx_messagesContentData as? GXMessagesPhotoContent {
            if let itemMediaView = content.mediaView {
                self.messageBubbleImageView.addSubview(itemMediaView)
                itemMediaView.frame = item.contentRect
                self.mediaView = itemMediaView
            }
            else {
                let itemMediaView = UIImageView(frame: item.contentRect)
                itemMediaView.image = content.thumbnailImage
                itemMediaView.setMaskImage(self.messageBubbleImageView.image, dx: 1.0, dy: 1.0)
                self.mediaView = itemMediaView
                self.messageBubbleImageView.addSubview(itemMediaView)
            }
        }
        else if let content = item.data.gx_messagesContentData as? GXMessagesVideoContent {
            if let itemMediaView = content.mediaView {
                self.messageBubbleImageView.addSubview(itemMediaView)
                itemMediaView.frame = item.contentRect
                self.mediaView = itemMediaView
            }
            else {
                let itemMediaView = UIImageView(frame: item.contentRect)
                itemMediaView.image = content.thumbnailImage
                itemMediaView.setMaskImage(self.messageBubbleImageView.image, dx: 1.0, dy: 1.0)
                self.mediaView = itemMediaView
                self.messageBubbleImageView.addSubview(itemMediaView)
            }
            self.playButton.isHidden = false
            self.playButton.center = self.messageBubbleImageView.center
        }
    }

}
