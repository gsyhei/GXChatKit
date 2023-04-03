//
//  GXMessagesSystemCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/3.
//

import UIKit
import Reusable

public class GXMessagesSystemCell: UITableViewCell, Reusable {
    
    /// 内容的容器
    public lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = GXCHATC.systemBackgroudColor
        view.layer.masksToBounds = true
        let maxLineHeight = GXCHATC.systemTextFont.lineHeight + GXCHATC.systemTextInserts.top + GXCHATC.systemTextInserts.bottom
        view.layer.cornerRadius = maxLineHeight/2
        
        return view
    }()
    
    /// 内容文本Label
    public lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = GXCHATC.systemTextFont
        label.textColor = GXCHATC.systemTextColor
        
        return label
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.contentLabel.text = nil
    }
    
    public func createSubviews() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.contentLabel)
    }
    
    public func bindCell(item: GXMessagesItemData) {
        guard let content = item.data.gx_messagesContent as? GXMessagesSystemContent else { return }
        self.contentLabel.text = content.text
        
        guard let layout = item.layout as? GXMessagesSystemLayout else { return }
        self.containerView.frame = layout.containerRect
        self.contentLabel.frame = layout.textRect
    }
}
