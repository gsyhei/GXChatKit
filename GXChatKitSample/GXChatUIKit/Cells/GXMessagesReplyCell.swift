//
//  GXMessagesReplyCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/13.
//

import UIKit

public class GXMessagesReplyCell: GXMessagesBaseCell {
    /// 回复内容的容器
    public lazy var replyContentView: UIView = {
        let view = UIView()
        view.backgroundColor = GXCHATC.replyBackgroundColor
        
        return view
    }()
    
    /// 回复垂直线条
    public lazy var replyVLineView: UIView = {
        let view = UIView(frame: .zero)

        return view
    }()
    
    ///回复icon
    public lazy var replyIconIView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.isHidden = true
        
        return imageView
    }()
    
    /// 回复文件扩展名Label
    public lazy var replyFileExtLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = GXCHATC.fileExtFont
        label.textColor = GXCHATC.fileExtColor
        label.isHidden = true
        
        return label
    }()
    
    /// 回复对象名Label
    public lazy var replyNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = GXCHATC.nicknameFont

        return label
    }()
    
    /// 回复对象文本Label
    public lazy var replyTextLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = GXCHATC.replyContentFont

        return label
    }()
    
    /// 文本Label
    public lazy var contentTextView: GXMessagesTextView = {
        let textView = GXMessagesTextView()
        textView.backgroundColor = .clear
        textView.font = GXCHATC.textFont
        textView.textColor = GXCHATC.textColor
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        
        return textView
    }()

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.replyIconIView.image = nil
        self.replyFileExtLabel.text = nil
        self.replyNameLabel.text = nil
        self.replyTextLabel.text = nil
        self.contentTextView.text = nil
        self.replyIconIView.isHidden = true
        self.replyFileExtLabel.isHidden = true
        self.replyIconIView.tintColor = nil
    }
    
    public override func createSubviews() {
        super.createSubviews()
        
        self.messageBubbleContainerView.addSubview(self.replyContentView)
        self.messageBubbleContainerView.addSubview(self.replyVLineView)
        self.messageBubbleContainerView.addSubview(self.replyIconIView)
        self.messageBubbleContainerView.addSubview(self.replyFileExtLabel)
        self.messageBubbleContainerView.addSubview(self.replyNameLabel)
        self.messageBubbleContainerView.addSubview(self.replyTextLabel)
        self.messageBubbleContainerView.addSubview(self.contentTextView)
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        self.replyVLineView.backgroundColor = self.messageBubbleNameLabel.textColor
        self.replyNameLabel.textColor = self.messageBubbleNameLabel.textColor
                
        guard let layout = item.layout as? GXMessagesReplyLayout else { return }
        self.replyContentView.frame = layout.replyContentRect
        self.replyVLineView.frame = layout.replyVLineRect
        self.replyIconIView.frame = layout.replyIconRect
        self.replyFileExtLabel.frame = layout.replyFileExtRect
        self.replyNameLabel.frame = layout.replyNameRect
        self.replyTextLabel.frame = layout.replyTextRect
        self.contentTextView.frame = layout.textRect

        guard let content = item.data.gx_messagesContent as? GXMessagesReplyContent else { return }
        self.replyNameLabel.text = content.replyData.gx_senderDisplayName
        self.replyTextLabel.text = content.replyContentText
        self.contentTextView.attributedText = content.attributedText
        
        switch content.replyData.gx_messageType {
        case .phote, .video, .audio, .voiceCall, .videoCall:
            self.replyTextLabel.textColor = GXCHATC.replyTypeNameColor
        default:
            self.replyTextLabel.textColor = GXCHATC.replyContentColor
        }
        
        self.replyIconIView.isHidden = !content.isShowIcon
        self.replyFileExtLabel.isHidden = (content.replyData.gx_messageType != .file)
        
        if let replyContent = content.replyData.gx_messagesContent as? GXMessagesPhotoContent {
            self.replyIconIView.image = replyContent.thumbnailImage
        }
        else if let replyContent = content.replyData.gx_messagesContent as? GXMessagesVideoContent {
            self.replyIconIView.image = replyContent.thumbnailImage
        }
        else if let replyContent = content.replyData.gx_messagesContent as? GXMessagesLocationContent {
            self.replyIconIView.image = replyContent.locationImage
        }
        else if let replyContent = content.replyData.gx_messagesContent as? GXMessagesCardContent {
            self.replyIconIView.image = replyContent.cardAvatar.avatarImage
        }
        else if let replyContent = content.replyData.gx_messagesContent as? GXMessagesFileContent {
            self.replyIconIView.image = .gx_fileIconImage?.withRenderingMode(.alwaysTemplate)
            self.replyIconIView.tintColor = GXCHATC.fileIconColor
            self.replyFileExtLabel.text = replyContent.fileExt
        }
        else if content.replyData.gx_messagesContent is GXMessagesRedPacketContent {
            self.replyIconIView.image = .gx_redPacketIconImage?.withRenderingMode(.alwaysTemplate)
            self.replyIconIView.tintColor = GXCHATC.redPacketIconColor
        }
    }
    
    public override func setChecked(_ checked: Bool) {
        super.setChecked(checked)
        let color: UIColor = checked ? .clear : GXCHATC.replyBackgroundColor
        self.replyContentView.backgroundColor = color
    }
}

extension GXMessagesReplyCell: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString .hasPrefix(GXCHAT_LINK_PREFIX) && interaction == .invokeDefaultAction {
            let userId = URL.absoluteString.substring(from: GXCHAT_LINK_PREFIX.count)
            NSLog("UITextView shouldInteractWith: userId = \(userId)")
            
            return false
        }
        return true
    }
    
}
