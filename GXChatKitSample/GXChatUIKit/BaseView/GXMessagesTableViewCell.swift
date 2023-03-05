//
//  GXMessagesTableViewCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/6.
//

import UIKit

class GXMessagesTableViewCell: UITableViewCell {
    
    public lazy var avatar: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .red
        
        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }

}
