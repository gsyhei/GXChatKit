//
//  GXMessagesLocationCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/27.
//

import UIKit

public class GXMessagesLocationCell: GXMessagesBaseCell {
    
    /// 媒体图片
    public lazy var mediaImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear

        return imageView
    }()
    
    /// 位置文本容器
    public lazy var locationContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)

        return view
    }()
    
    /// 位置文本Label
    public lazy var locationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = GXCHATC.locationTextFont
        textView.textColor = .white

        return textView
    }()
    
    /// highlighted效果
    public lazy var highlightedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.isHidden = true

        return view
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
    }
    
    public override func createSubviews() {
        super.createSubviews()
                
        self.messageBubbleImageView.addSubview(self.mediaImageView)
        self.mediaImageView.addSubview(self.locationContentView)
        self.locationContentView.addSubview(self.locationTextView)
        self.highlightedView.frame = self.mediaImageView.bounds
        self.highlightedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mediaImageView.addSubview(self.highlightedView)

        self.messageBubbleNameLabel.layer.shadowOpacity = 1.0
        self.messageBubbleNameLabel.layer.shadowRadius = 2.0
        self.messageBubbleNameLabel.layer.shadowColor = UIColor.black.cgColor
        self.messageBubbleNameLabel.layer.shadowOffset = .zero
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)

        if item.data.gx_isShowNickname {
            self.messageBubbleNameLabel.textColor = .white
            self.messageBubbleNameLabel.frame = item.layout.nicknameRect
        }
        self.messageBubbleTimeLabel.textColor = .white

        guard let layout = item.layout as? GXMessagesLocationLayout else { return }
        self.locationTextView.frame = layout.locationTitleRect
        self.locationContentView.frame = layout.locationContentRect
        self.mediaImageView.frame = layout.imageRect
        
        guard let content = item.data.gx_messagesContent as? GXMessagesLocationContent else { return }
        self.locationTextView.text = content.locationTitle
        self.mediaImageView.image = content.locationImage
        
        self.mediaImageView.setMaskImage(self.messageBubbleImageView.image, dx: 1.0, dy: 1.0)
    }

    public override func setChecked(_ checked: Bool) {
        super.setChecked(checked)
        self.highlightedView.isHidden = !checked
    }
    
}
