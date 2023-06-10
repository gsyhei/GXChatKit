//
//  GXMessagesReplyCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/13.
//

import UIKit
import YYText

public class GXMessagesReplyCell: GXMessagesBaseCell {
    /// 回复内容的容器
    public lazy var replyContentView: UIControl = {
        let button = UIControl()
        button.backgroundColor = GXCHATC.replyBackgroundColor
        button.addTarget(self, action: #selector(replyContentClicked(_:)), for: .touchUpInside)

        return button
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
    public lazy var contentTextView: YYLabel = {
        let textView = YYLabel()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        
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
        self.contentTextView.attributedText = nil
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
        
        self.contentTextView.highlightTapAction = {[weak self] containerView, text, range, rect in
            guard let `self` = self else { return }
            guard !self.isEditing else { return }

            let attributed = text.attributedSubstring(from: range)
            if let textHighlight = attributed.yy_attributes?[YYTextHighlightAttributeName] as? YYTextHighlight {
                guard let type = textHighlight.userInfo?[GXRichManager.highlightKey] as? GXRichManager.HighlightType else { return }
                
                if type == .user, let userId = textHighlight.userInfo?[GXRichManager.userIdKey] as? String {
                    self.delegate?.messagesCell(self, didTapAt: self.item, type: type, value: userId)
                }
                else {
                    self.delegate?.messagesCell(self, didTapAt: self.item, type: type, value: attributed.string)
                }
            }
        }
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        self.replyVLineView.backgroundColor = self.messageBubbleNameLabel.textColor
        self.replyNameLabel.textColor = self.messageBubbleNameLabel.textColor
                
        guard let layout = item.layout as? GXMessagesReplyLayout else { return }
        self.contentTextView.textLayout = layout.textLayout
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
    
    public override func setBubbleHighlighted(_ checked: Bool) {
        super.setBubbleHighlighted(checked)
        let color: UIColor = checked ? .clear : GXCHATC.replyBackgroundColor
        self.replyContentView.backgroundColor = color
    }
}

extension GXMessagesReplyCell {
    //MARK: - UIButton Clicked
    
    @objc func replyContentClicked(_ sender: Any?) {
        guard !self.isEditing else { return }

        self.delegate?.messagesCell(self, didContentTapAt: self.item)
    }
}
