//
//  GXMessagesTableViewCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/6.
//

import UIKit
import Reusable

open class GXMessagesTableViewCell: GXMessagesAvatarDataSource, Reusable {
    
    public var avatar: UIView {
        return self.avatarButton
    }
        
    public func createAvatarView() -> UIButton {
        return getAvatar()
    }
    
    public var messageContinuousStatus: GXChatConfiguration.MessageContinuousStatus = .begin {
        didSet {
            self.avatarButton.isHidden = (messageContinuousStatus != .end && messageContinuousStatus != .beginAndEnd)
        }
    }
    
    public var messageStatus: GXChatConfiguration.MessageStatus = .receiving {
        didSet {
            if messageStatus == .receiving {
                let size: CGFloat = 60.0
                let rect = CGRect(x: 0, y: self.contentView.height - size, width: size, height: size)
                self.avatarButton.frame = rect
                self.avatarButton.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
            }
            else {
                let size: CGFloat = 60.0
                let rect = CGRect(x: self.contentView.width - size, y: self.contentView.height - size, width: size, height: size)
                self.avatarButton.frame = rect
                self.avatarButton.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
            }
        }
    }
    
    public lazy var avatarButton: UIButton = {
        let button = self.getAvatar()

        return button
    }()
    
    private func getAvatar() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .red

        return button
    }
    
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
        let rect = CGRect(x: 0, y: self.contentView.height - size, width: size, height: size)
        self.avatarButton.frame = rect
        self.contentView.addSubview(self.avatarButton)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
