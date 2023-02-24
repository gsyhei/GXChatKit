//
//  GXMessagesLoadHeader.swift
//  GXChatUIKit
//
//  Created by Gin on 2022/12/25.
//

import UIKit
import GXRefresh

public class GXMessagesLoadHeader: GXRefreshBaseHeader {
    
    public var headerMargin: CGFloat = 5.0
    public var offsetWidth: CGFloat = 0.0
    
    private lazy var indicatorView = {
        let aiView = UIActivityIndicatorView(style: .white)
        let size: CGFloat  = self.gx_height - headerMargin * 2;
        aiView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        aiView.color = .gray
        return aiView
    }()
    
    private lazy var headerView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.gx_height))
        view.backgroundColor = .clear
        view.addSubview(self.indicatorView)
        self.indicatorView.center = CGPoint(x: view.center.x - self.offsetWidth * 1.5, y: view.center.y)
        self.indicatorView.startAnimating()
        
        return view
    }()
    
    public override var customIndicator: UIView? {
        guard self.offsetWidth > 0 else { return nil }
        
        return self.headerView
    }
    
    public required init(completion: @escaping GXRefreshCallBack, begin: GXRefreshCallBack? = nil, end: GXRefreshCallBack? = nil, offsetWidth: CGFloat) {
        self.offsetWidth = offsetWidth
        super.init(completion: completion, begin: begin, end: end)
        self.isPlayImpact = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(completion: @escaping GXRefreshComponent.GXRefreshCallBack, begin: GXRefreshComponent.GXRefreshCallBack? = nil, end: GXRefreshComponent.GXRefreshCallBack? = nil) {
        fatalError("init(completion:begin:end:) has not been implemented")
    }
    
    public override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        guard self.state == .idle else { return }
        
        if (self.svContentOffset.y + self.svAdjustedInset.top < -10) {
            self.beginRefreshing()
        }
    }

}
