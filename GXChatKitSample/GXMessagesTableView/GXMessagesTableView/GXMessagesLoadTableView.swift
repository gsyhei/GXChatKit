//
//  GXMessagesTableView.swift
//  GXChatUIKit
//
//  Created by Gin on 2022/12/24.
//

import UIKit
import GXCategories
import GXRefresh

@MainActor open class GXMessagesLoadTableView: UITableView {
    
    public var loadingCompletion: (() -> Void)? = nil
    
    private var isHeaderLoading: Bool = false

    open var headerHeight: CGFloat = 40.0
        
    open var backgroundImage: UIImage? {
        didSet {
            guard let image = backgroundImage else { return }
            let imageView = UIImageView(frame: self.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
            imageView.clipsToBounds = true
            if #available(iOS 13.0, *) {
                imageView.contentScaleFactor =  self.window?.windowScene?.screen.scale ?? 2.0
            } else {
                imageView.contentScaleFactor =  UIScreen.main.scale
            }
            self.backgroundView = imageView
            self.backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    open override var contentSize: CGSize {
        didSet {
            guard self.dataSource != nil else {
                return
            }
            guard contentSize != .zero else {
                return
            }
            guard contentSize.height > oldValue.height else {
                return
            }
            var offset = super.contentOffset
            if (self.isHeaderLoading) {
                offset.y = contentSize.height - oldValue.height - self.adjustedContentInset.top
                self.contentOffset = offset
                self.isHeaderLoading = false
                self.loadingCompletion?()
            }
            else {
                self.setContentOffset(offset, animated: true)
            }
        }
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.configuration()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.configuration()
    }
    
    private func configuration() {
        self.configuration(mode: .onDrag, separatorLeft: false, footerZero: false)
    }
}

public extension GXMessagesLoadTableView {
    
    func addMessagesHeader(callback: @escaping GXRefreshComponent.GXRefreshCallBack, offsetWidth: CGFloat? = nil) {
        let header = GXMessagesLoadHeader(completion: {
            callback()
        }, offsetWidth: offsetWidth)
        header.isTextHidden = true
        header.gx_height = headerHeight;
        header.beginRefreshingAction = {[weak self] in
            self?.isHeaderLoading = true
        }
        self.gx_header = header;
    }
    
    func endHeaderLoading(isReload: Bool = true, isNoMore: Bool = false) {
        if isReload {
            self.reloadData()
        }
        self.gx_header?.endRefreshing()
        if isNoMore {
            self.gx_header = nil;
        }
    }
    
}
