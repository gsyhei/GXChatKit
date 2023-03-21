//
//  GXMessagesTextCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/2.
//

import UIKit

public class GXMessagesTextCell: GXMessagesBaseCell {
    
    /// 文本Label
    public lazy var contentTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = GXCHATC.textFont
        label.textColor = GXCHATC.textColor

        return label
    }()

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.messageBubbleContainerView.addSubview(self.contentTextLabel)
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        
        if item.data.gx_messageStatus == .sending {
            self.contentTextLabel.backgroundColor = GXChatConfiguration.shared.sendingBubbleMaskColor
        } else {
            self.contentTextLabel.backgroundColor = GXChatConfiguration.shared.receivingBubbleMaskColor
        }
        guard let content = item.data.gx_messagesContentData as? GXMessagesTextContent else { return }
        self.contentTextLabel.text = content.text
        self.contentTextLabel.frame = item.contentRect
    }
    
}
