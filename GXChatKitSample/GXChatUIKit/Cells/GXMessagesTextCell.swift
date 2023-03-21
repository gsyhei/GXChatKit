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
        label.backgroundColor = .clear
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
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentTextLabel.text = nil
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.messageBubbleContainerView.addSubview(self.contentTextLabel)
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        
        guard let content = item.data.gx_messagesContentData as? GXMessagesTextContent else { return }
        self.contentTextLabel.text = content.text
        self.contentTextLabel.frame = item.contentRect
    }
    
}
