//
//  GXMessagesLocationCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/27.
//

import UIKit

public class GXMessagesLocationCell: GXMessagesBaseCell {
    
    /// 气泡imageView
    public var mediaView: UIView?
    
    /// 文本容器
    public lazy var locationContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)

        return view
    }()

    /// 文本Label
    public lazy var locationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = GXCHATC.locationTextFont
        textView.textColor = .white

        return textView
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
        self.mediaView?.removeFromSuperview()
    }
    
    public override func createSubviews() {
        super.createSubviews()
        
        self.messageBubbleNameLabel.layer.shadowOpacity = 1.0
        self.messageBubbleNameLabel.layer.shadowRadius = 2.0
        self.messageBubbleNameLabel.layer.shadowColor = UIColor.black.cgColor
        self.messageBubbleNameLabel.layer.shadowOffset = .zero
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        
        if item.gx_isShowNickname {
            self.messageBubbleNameLabel.textColor = .white
            self.messageBubbleNameLabel.frame = item.nicknameRect
        }
        self.messageBubbleTimeLabel.textColor = .white

        guard let content = item.data.gx_messagesContentData as? GXMessagesLocationContent else { return }
        if let itemMediaView = content.mediaView {
            itemMediaView.frame = item.contentRect
            self.messageBubbleImageView.addSubview(itemMediaView)
            self.mediaView = itemMediaView
        }
        else {
            self.locationTextView.text = content.locationTitle
            self.locationTextView.frame = content.locationTitleRect
            self.locationContentView.frame = content.locationContentRect
            self.locationContentView.addSubview(self.locationTextView)
            let itemMediaView = UIImageView(frame: item.contentRect)
            itemMediaView.addSubview(self.locationContentView)
            itemMediaView.image = content.locationImage
            itemMediaView.setMaskImage(self.messageBubbleImageView.image, dx: 1.0, dy: 1.0)
            self.messageBubbleImageView.addSubview(itemMediaView)
            self.mediaView = itemMediaView
            content.mediaView = itemMediaView
        }
    }

}
