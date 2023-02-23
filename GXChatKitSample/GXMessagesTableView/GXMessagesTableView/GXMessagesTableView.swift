//
//  GXMessagesTableView.swift
//  GXMessagesTableView
//
//  Created by Gin on 2023/2/21.
//

import UIKit
import Reusable
import GXRefresh

@MainActor @objc public protocol GXMessagesTableViewDataSource: NSObjectProtocol {
    /// 两边tableView的sections
    func gx_numberOfSections(inMargin tableView: UITableView) -> Int
    /// 中间tableView的sections
    func gx_numberOfSections(inCenter tableView: UITableView) -> Int
    /// 中间tableView的sections
    func gx_tableView(inCenter tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    /// 中间tableView的header
    func gx_tableView(inCenter tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    /// 中间tableView的cell
    func gx_tableView(inCenter tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    /// 两边tableView内容具体显示在哪边
    func gx_tableView(inMargin tableView: UITableView, directionInSection section: Int) -> GXMessagesTableView.MarginDirection
    /// 两边tableView的具体内容视图
    func gx_tableView(inMargin tableView: UITableView, viewForContentInSection section: Int) -> UIView?
}

@MainActor public protocol GXMessagesTableViewDelegate: NSObjectProtocol {
    /// 两边tableView的总体高度
    func gx_tableView(inMargin tableView: UITableView, heightForAllInSection section: Int) -> CGFloat
    /// 中间tableView的header高度
    func gx_tableView(inCenter tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    /// 中间tableView的cell高度
    func gx_tableView(inCenter tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}

@MainActor public class GXMessagesTableView: UIView {

    private var marginItemHeight: CGFloat = 0.0

    @objc public enum MarginPosition: Int, @unchecked Sendable {
        case top    = 0
        case bottom = 1
    }
    
    @objc public enum MarginDirection: Int, @unchecked Sendable {
        case none  = 0
        case left  = 1
        case right = 2
    }
    
    weak public var dataSource: GXMessagesTableViewDataSource?
    
    weak public var delegate: GXMessagesTableViewDelegate?
    
    private var marginPosition: MarginPosition!
    
    private var centerTableView: GXMessagesLoadTableView!
    private var leftTableView: GXMessagesLoadTableView?
    private var rightTableView: GXMessagesLoadTableView?

    public var tableBackgroundColor: UIColor? {
        didSet {
            self.centerTableView.backgroundColor = self.tableBackgroundColor
            self.leftTableView?.backgroundColor = self.tableBackgroundColor
            self.rightTableView?.backgroundColor = self.tableBackgroundColor
        }
    }
    
    public required init(frame: CGRect,
                         style: UITableView.Style = .plain,
                         marginStyle: UITableView.Style = .plain,
                         marginPosition: MarginPosition = .bottom,
                         marginItemHeight: Double = 0.0,
                         leftWidth: Double = 0.0,
                         rightWidth: Double = 0.0)
    {
        super.init(frame: frame)
        self.marginPosition = marginPosition
        self.marginItemHeight = marginItemHeight
        let centerRect = CGRect(x: leftWidth, y: frame.origin.y + 100, width: frame.width - leftWidth - rightWidth, height: frame.height)
        self.centerTableView = GXMessagesLoadTableView(frame: centerRect, style: style)
        self.centerTableView.separatorStyle = .none
        self.centerTableView.contentInsetAdjustmentBehavior = .never
        self.centerTableView.allowsSelection = false
        self.centerTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.centerTableView.dataSource = self
        self.centerTableView.delegate = self
        self.addSubview(self.centerTableView)
        if leftWidth > 0 {
            let rect = CGRect(x: frame.origin.x, y: centerRect.origin.y, width: leftWidth, height: frame.height)
            self.leftTableView = GXMessagesLoadTableView(frame: rect, style: marginStyle)
            self.leftTableView?.separatorStyle = .none
            self.leftTableView?.contentInsetAdjustmentBehavior = .never
            self.leftTableView?.allowsSelection = false
            self.leftTableView?.showsVerticalScrollIndicator = false
            self.leftTableView?.showsHorizontalScrollIndicator = false
            self.leftTableView?.autoresizingMask = [.flexibleRightMargin, .flexibleHeight]
            self.leftTableView?.dataSource = self
            self.leftTableView?.delegate = self
            self.addSubview(self.leftTableView!)
        }
        if rightWidth > 0 {
            let rect = CGRect(x: frame.width - rightWidth, y: centerRect.origin.y, width: rightWidth, height: frame.height)
            self.rightTableView = GXMessagesLoadTableView(frame: rect, style: marginStyle)
            self.rightTableView?.separatorStyle = .none
            self.rightTableView?.contentInsetAdjustmentBehavior = .never
            self.rightTableView?.allowsSelection = false
            self.rightTableView?.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
            self.rightTableView?.dataSource = self
            self.rightTableView?.delegate = self
            self.addSubview(self.rightTableView!)
            self.centerTableView.showsVerticalScrollIndicator = false
            self.centerTableView.showsHorizontalScrollIndicator = false
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GXMessagesTableView: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.centerTableView {
            return self.dataSource?.gx_numberOfSections(inCenter: tableView) ?? 0
        }
        else {
            return self.dataSource?.gx_numberOfSections(inMargin: tableView) ?? 0
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.centerTableView {
            return self.dataSource?.gx_tableView(inCenter: tableView, numberOfRowsInSection: section) ?? 0
        }
        else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.centerTableView {
            return (self.dataSource?.gx_tableView(inCenter: tableView, cellForRowAt: indexPath))!
        }
        else {
            let cellID = "SpaceCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
                cell?.backgroundColor = .clear
                cell?.contentView.backgroundColor = .clear
            }
            return cell!
        }
    }
    
    // MARK: UITableViewDelegate

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.leftTableView {
            let direction = self.dataSource?.gx_tableView(inMargin: tableView, directionInSection: indexPath.section) ?? .none
            let allHeight = self.delegate?.gx_tableView(inMargin: tableView, heightForAllInSection: indexPath.section) ?? 0
            if direction == .left {
                return allHeight - self.marginItemHeight
            }
            else {
                return allHeight
            }
        }
        else if tableView == self.rightTableView {
            let direction = self.dataSource?.gx_tableView(inMargin: tableView, directionInSection: indexPath.section) ?? .none
            let allHeight = self.delegate?.gx_tableView(inMargin: tableView, heightForAllInSection: indexPath.section) ?? 0
            if direction == .right {
                return allHeight - self.marginItemHeight
            }
            else {
                return allHeight
            }
        }
        else {
            return self.delegate?.gx_tableView(inCenter: tableView, heightForRowAt: indexPath) ?? 0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.centerTableView {
            return self.delegate?.gx_tableView(inCenter: tableView, heightForHeaderInSection: section) ?? 0
        }
        
        guard marginPosition == .top else { return CGFloat.leastNormalMagnitude }
        let direction = self.dataSource?.gx_tableView(inMargin: tableView, directionInSection: section) ?? .none
        if tableView == self.leftTableView {
            if direction == .left {
                return self.marginItemHeight
            }
        }
        else if tableView == self.rightTableView {
            if direction == .right {
                return self.marginItemHeight
            }
        }
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard marginPosition == .bottom else { return CGFloat.leastNormalMagnitude }
        
        let direction = self.dataSource?.gx_tableView(inMargin: tableView, directionInSection: section) ?? .none
        if tableView == self.leftTableView {
            if direction == .left {
                return self.marginItemHeight
            }
        }
        else if tableView == self.rightTableView {
            if direction == .right {
                return self.marginItemHeight
            }
        }
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.centerTableView {
            return self.dataSource?.gx_tableView(inCenter: tableView, viewForHeaderInSection: section)
        }
        
        guard marginPosition == .top else { return nil }
        let direction = self.dataSource?.gx_tableView(inMargin: tableView, directionInSection: section) ?? .none
        if tableView == self.leftTableView {
            if direction == .left {
                return self.dataSource?.gx_tableView(inMargin: tableView, viewForContentInSection: section)
            }
        }
        else if tableView == self.rightTableView {
            if direction == .right {
                return self.dataSource?.gx_tableView(inMargin: tableView, viewForContentInSection: section)
            }
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard marginPosition == .bottom else { return nil }
        
        let direction = self.dataSource?.gx_tableView(inMargin: tableView, directionInSection: section) ?? .none
        if tableView == self.leftTableView {
            if direction == .left {
                return self.dataSource?.gx_tableView(inMargin: tableView, viewForContentInSection: section)
            }
        }
        else if tableView == self.rightTableView {
            if direction == .right {
                return self.dataSource?.gx_tableView(inMargin: tableView, viewForContentInSection: section)
            }
        }
        return nil
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.centerTableView {
            self.leftTableView?.contentOffset = scrollView.contentOffset
            self.rightTableView?.contentOffset = scrollView.contentOffset
        }
        else if scrollView == self.leftTableView {
            self.rightTableView?.contentOffset = scrollView.contentOffset
            self.centerTableView.contentOffset = scrollView.contentOffset
        }
        else if scrollView == self.rightTableView {
            self.leftTableView?.contentOffset = scrollView.contentOffset
            self.centerTableView.contentOffset = scrollView.contentOffset
        }
    }
}

public extension GXMessagesTableView {
    
    func reloadData() {
        self.leftTableView?.reloadData()
        self.rightTableView?.reloadData()
        self.centerTableView.reloadData()
    }
    
    func addMessagesHeader(callback: @escaping GXRefreshComponent.GXRefreshCallBack) {
        let leftWidth = self.leftTableView?.frame.width ?? 0
        let rightWidth = self.rightTableView?.frame.width ?? 0
        let offsetWidth = leftWidth - rightWidth
        self.centerTableView.addMessagesHeader(callback: callback, offsetWidth: offsetWidth)
        self.leftTableView?.addMessagesHeader(callback: {})
        self.rightTableView?.addMessagesHeader(callback: {})
    }
    
    func endHeaderLoading(isReload: Bool = true, isNoMore: Bool = false) {
        self.centerTableView.endHeaderLoading(isReload: isReload, isNoMore: isNoMore)
        self.leftTableView?.isScrollEnabled = true
    }
}
