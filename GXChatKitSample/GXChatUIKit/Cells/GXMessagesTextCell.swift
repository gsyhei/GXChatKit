//
//  GXMessagesTextCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/2.
//

import UIKit

public class GXMessagesTextCell: GXMessagesBaseCell {
    
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
        
        self.contentTextView.text = nil
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.messageBubbleContainerView.addSubview(self.contentTextView)
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        
        guard let content = item.data.gx_messagesContentData as? GXMessagesTextContent else { return }
        self.contentTextView.attributedText = content.attributedText
        self.contentTextView.frame = item.contentRect
    }
    
}
