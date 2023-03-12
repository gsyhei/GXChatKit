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

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public override func createSubviews() {
        super.createSubviews()
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

        if let photoContent = item.data.gx_messagesContentData as? GXMessagesPhotoContent {
            if mediaView != nil {
                self.mediaView?.removeFromSuperview()
            }
            if let itemMediaView = photoContent.mediaView {
                self.messageBubbleImageView.addSubview(itemMediaView)
                itemMediaView.frame = item.contentRect
                self.mediaView = itemMediaView
            }
            else {
                let itemMediaView = UIImageView(frame: item.contentRect)
                itemMediaView.image = photoContent.thumbnailImage
                itemMediaView.setMaskImage(self.messageBubbleImageView.image, dx: 1.0, dy: 1.0)
                self.mediaView = itemMediaView
                self.messageBubbleImageView.addSubview(itemMediaView)
            }
        }
        else if let videoContent = item.data.gx_messagesContentData as? GXMessagesVideoContent {
            if mediaView != nil {
                self.mediaView?.removeFromSuperview()
            }
            if let itemMediaView = videoContent.mediaView {
                self.messageBubbleImageView.addSubview(itemMediaView)
                itemMediaView.frame = item.contentRect
                self.mediaView = itemMediaView
            }
            else {
                let itemMediaView = UIImageView(frame: item.contentRect)
                itemMediaView.image = videoContent.thumbnailImage
                itemMediaView.setMaskImage(self.messageBubbleImageView.image, dx: 1.0, dy: 1.0)
                self.mediaView = itemMediaView
                self.messageBubbleImageView.addSubview(itemMediaView)
            }
        }
    }

}
