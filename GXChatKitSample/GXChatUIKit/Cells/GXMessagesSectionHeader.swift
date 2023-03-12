//
//  GXMessagesSectionHeader.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/12.
//

import UIKit
import Reusable

public class GXMessagesSectionHeader: UITableViewHeaderFooterView, Reusable {
    public lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = GXCHATC.headerTextFont
        label.backgroundColor = GXCHATC.headerBackgroudColor
        label.textColor = GXCHATC.headerTextColor
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .clear
        self.contentView.addSubview(self.dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bindHeader(data: GXMessagesSectionData) {
        self.dateLabel.text = data.dateString
        
        let left = (self.width - data.dateSize.width) / 2, top = (self.height - data.dateSize.height) / 2
        self.dateLabel.frame = CGRect(x: left, y: top, width: data.dateSize.width, height: data.dateSize.height)
        
        self.dateLabel.layer.masksToBounds = true
        self.dateLabel.layer.cornerRadius = data.dateSize.height/2
    }
}
