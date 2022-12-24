//
//  GXMessageTableView.swift
//  GXChatUIKit
//
//  Created by Gin on 2022/12/24.
//

import UIKit

public class GXMessageTableView: UITableView {
    
    public var isHeaderLoading: Bool = false
    
    private lazy var indicatorView = {
        let view = UIActivityIndicatorView(style: .white)
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        return view
    }()
}
