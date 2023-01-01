//
//  GXMessageTableView.swift
//  GXChatUIKit
//
//  Created by Gin on 2022/12/24.
//

import UIKit
import GXCategories
import GXRefresh

public class GXMessageTableView: UITableView {
    
    public var headerHeight: CGFloat = 40.0
    
    public var headerMargin: CGFloat = 5.0
    
    private var isHeaderLoading: Bool = false
    
    public var backgroundImage: UIImage? {
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
    
    private lazy var indicatorView = {
        let aiView = UIActivityIndicatorView(style: .white)
        let size: CGFloat  = headerHeight - headerMargin * 2;
        aiView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        aiView.color = .gray
        return aiView
    }()
    
    private lazy var headerView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight))
        view.backgroundColor = .clear
        view.addSubview(self.indicatorView)
        self.indicatorView.center = CGPoint(x: view.center.x, y: view.center.y)
        
        return view
    }()
    
    open override var contentSize: CGSize {
        willSet {
            guard self.dataSource != nil else {
                return
            }
            guard contentSize != .zero else {
                return
            }
            guard newValue.height > contentSize.height else {
                return
            }
            var offset = super.contentOffset
            if (self.isHeaderLoading) {
                offset.y = newValue.height - contentSize.height - contentInset.top
                self.contentOffset = offset
                self.isHeaderLoading = false
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
        self.backgroundColor = .init(hex: 0x333333)
        self.keyboardDismissMode = .none
        self.alwaysBounceVertical = true
        self.alwaysBounceHorizontal = false
        self.isHeaderLoading = true
    }
}

public extension GXMessageTableView {
    
    func addMessagesHeader() {
        
        
        
    }
    
}
