//
//  GXMessagesTableViewCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/6.
//

import UIKit
import Reusable

open class GXMessagesTableViewCell: UITableViewCell, Reusable {
    
    public var messageContinuousStatus: GXChatConfiguration.MessageContinuousStatus = .begin {
        didSet {
            self.avatar.isHidden = (messageContinuousStatus != .end && messageContinuousStatus != .beginAndEnd)
        }
    }
    
    public func getAvatar() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .red

        return button
    }
    
    public lazy var avatar: UIButton = {
        let button = self.getAvatar()

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
    
    open override func prepareForReuse() {
        var rect = self.avatar.frame
        rect.origin.y = self.contentView.height - self.avatar.frame.height
        self.avatar.frame = rect
    }
    
    func setupCell() {
        let size: CGFloat = 60.0
        let rect = CGRect(x: 0, y: self.contentView.height - size, width: size, height: size)
        self.avatar.frame = rect
        self.avatar.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
        self.contentView.addSubview(self.avatar)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }

}
