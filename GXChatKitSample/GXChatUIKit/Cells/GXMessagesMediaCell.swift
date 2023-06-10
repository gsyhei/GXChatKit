//
//  GXMessagesMediaCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/12.
//

import UIKit

public class GXMessagesMediaCell: GXMessagesBaseCell {
    
    /// 媒体图片
    public lazy var mediaImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear

        return imageView
    }()
    
    /// 播放按钮
    public lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.setBackgroundImage(.gx_videoPlayImage, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = .zero
        button.isHidden = true
        button.addTarget(self, action: #selector(playButtonClicked(_:)), for: .touchUpInside)

        return button
    }()
    
    /// highlighted效果
    public lazy var highlightedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.isHidden = true
        
        return view
    }()

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.playButton.isHidden = true
        self.mediaImageView.image = nil
        self.highlightedView.isHidden = true
    }
    
    public override func createSubviews() {
        super.createSubviews()
        
        self.messageBubbleImageView.addSubview(self.mediaImageView)
        self.messageBubbleContainerView.addSubview(self.playButton)
        self.highlightedView.frame = self.mediaImageView.bounds
        self.highlightedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mediaImageView.addSubview(self.highlightedView)
        
        self.messageBubbleNameLabel.layer.shadowOpacity = 1.0
        self.messageBubbleNameLabel.layer.shadowRadius = 2.0
        self.messageBubbleNameLabel.layer.shadowColor = UIColor.black.cgColor
        self.messageBubbleNameLabel.layer.shadowOffset = .zero
        self.messageBubbleTimeLabel.layer.shadowOpacity = 1.0
        self.messageBubbleTimeLabel.layer.shadowRadius = 2.0
        self.messageBubbleTimeLabel.layer.shadowColor = UIColor.black.cgColor
        self.messageBubbleTimeLabel.layer.shadowOffset = .zero
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)

        if item.data.gx_isShowNickname {
            self.messageBubbleNameLabel.textColor = .white
            self.messageBubbleNameLabel.frame = item.layout.nicknameRect
        }
        self.messageBubbleTimeLabel.textColor = .white
        self.messageBubbleTimeLabel.frame = item.layout.timeRect

        if let content = item.data.gx_messagesContent as? GXMessagesPhotoContent {
            guard let layout = item.layout as? GXMessagesPhotoLayout else { return }

            self.mediaImageView.frame = layout.imageRect
            self.mediaImageView.image = content.thumbnailImage
            self.mediaImageView.setMaskImage(self.messageBubbleImageView.image, dx: 1.0, dy: 1.0)
        }
        else if let content = item.data.gx_messagesContent as? GXMessagesVideoContent {
            guard let layout = item.layout as? GXMessagesVideoLayout else { return }

            self.mediaImageView.frame = layout.imageRect
            self.mediaImageView.image = content.thumbnailImage
            self.mediaImageView.setMaskImage(self.messageBubbleImageView.image, dx: 1.0, dy: 1.0)
            
            self.playButton.isHidden = false
            self.playButton.center = self.messageBubbleImageView.center
        }
    }
    
    public override func setBubbleHighlighted(_ checked: Bool) {
        super.setBubbleHighlighted(checked)
        self.highlightedView.isHidden = !checked
    }

}

extension GXMessagesMediaCell {
    //MARK: - UIButton Clicked
    
    @objc func playButtonClicked(_ sender: Any?) {
        guard !self.isEditing else { return }

        self.delegate?.messagesCell(self, didContentTapAt: self.item)
    }
}
