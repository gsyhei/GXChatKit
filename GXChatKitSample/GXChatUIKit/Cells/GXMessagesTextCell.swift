//
//  GXMessagesTextCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/2.
//

import UIKit
import YYText

public class GXMessagesTextCell: GXMessagesBaseCell {
    
    /// 文本Label
    public lazy var contentTextView: YYLabel = {
        let textView = YYLabel()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        
        return textView
    }()

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentTextView.attributedText = nil
    }
    
    public override func createSubviews() {
        super.createSubviews()
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
                
        guard let layout = item.layout as? GXMessagesTextLayout else { return }
        self.contentTextView.textLayout = layout.textLayout
        self.contentTextView.frame = layout.textRect
        
        if let content = item.data.gx_messagesContent as? GXMessagesTextContent {
            self.contentTextView.attributedText = content.attributedText
        }
        else if let content = item.data.gx_messagesContent as? GXMessagesAtContent {
            self.contentTextView.attributedText = content.attributedText
        }
        else if let content = item.data.gx_messagesContent as? GXMessagesForwardContent {
            self.contentTextView.attributedText = content.attributedText
        }
    }
    
}
