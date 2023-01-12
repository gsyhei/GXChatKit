//
//  GXMessagesBaseCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/3.
//

import UIKit

open class GXMessagesBaseCell: UITableViewCell {
    
    
    
//    /** 气泡上边的Label（群昵称）*/
//    @property (weak, nonatomic, readonly) UILabel            *messageBubbleTopLabel;
//    /** 气泡内容的容器 */
//    @property (weak, nonatomic, readonly) UIView             *messageBubbleContainerView;
//    /** 气泡imageView */
//    @property (weak, nonatomic, readonly) UIImageView        *messageBubbleImageView;
//    /** 头像按钮 */
//    @property (weak, nonatomic, readonly) UIButton           *messageAvatarButton;
//    /** cell右边的时间 */
//    @property (weak, nonatomic, readonly) UILabel            *messageRightTimeLabel;

    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
