//
//  GXMessagesAtCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/30.
//

import UIKit

public class GXMessagesAtCell: GXMessagesBaseCell {
    
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
        textView.delegate = self
        
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
        
        self.contentTextView.text = nil
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.messageBubbleContainerView.addSubview(self.contentTextView)
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        
        guard let content = item.data.gx_messagesContentData as? GXMessagesAtContent else { return }
        self.contentTextView.attributedText = content.attributedText
        
        guard let layout = item.layout as? GXMessagesAtLayout else { return }
        self.contentTextView.frame = layout.textRect
    }

}

extension GXMessagesAtCell: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString .hasPrefix(GXCHAT_AT_PREFIX) && interaction == .invokeDefaultAction {
            let userId = URL.absoluteString.substring(from: GXCHAT_AT_PREFIX.count)
            NSLog("UITextView shouldInteractWith: userId = \(userId)")
            
            return false
        }
        return true
    }
    
}
