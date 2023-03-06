//
//  GXMessagesTableViewCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/6.
//

import UIKit
import Reusable

open class GXMessagesTableViewCell: UITableViewCell, Reusable {
    
    public var messageContinuousStatus: GXChatConfiguration.MessageContinuousStatus = .begin
    
    public lazy var avatar: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .red
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCell()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    func setupCell() {
        let size: CGFloat = 60.0
        let rect = CGRect(x: self.contentView.left, y: self.contentView.height - size, width: size, height: size)
        self.avatar.frame = rect
        self.avatar.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
//        self.contentView.addSubview(self.avatar)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }

}
