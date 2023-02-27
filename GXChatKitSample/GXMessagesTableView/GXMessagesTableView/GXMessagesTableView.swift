//
//  GXMessagesTableView.swift
//  GXMessagesTableView
//
//  Created by Gin on 2023/2/21.
//

import UIKit
import Reusable
import GXRefresh

@MainActor public protocol GXMessagesTableViewDataSource: NSObjectProtocol {
    /// 中间tableView的header
    func gx_tableView(inCenter tableView: UITableView, viewForHeaderInSection section: Int, data: GXMessagesCenterSection) -> UIView?
    /// 中间tableView的cell
    func gx_tableView(inCenter tableView: UITableView, cellForRowAt indexPath: IndexPath, data: any GXMessagesCenterOperation) -> UITableViewCell
    /// 两边tableView的具体内容视图
    func gx_tableView(inMargin tableView: UITableView, viewForHeaderFooterInSection section: Int, data: GXMessagesMarginSection) -> UIView?
}

@MainActor public protocol GXMessagesTableViewDelegate: NSObjectProtocol {

}

@MainActor public class GXMessagesTableView: UIView {
    
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
    
    public var marginItemHeight: CGFloat = 50.0
    
    public var marginPosition: MarginPosition = .bottom
    
    public var centerHeaderHeight: CGFloat = 30.0

    public var marginDataSections: [GXMessagesMarginSection] = []
    
    public var centerDataSections: [GXMessagesCenterSection] = []
    
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
                         leftWidth: Double = 0.0,
                         rightWidth: Double = 0.0)
    {
        super.init(frame: frame)
        let centerRect = CGRect(x: leftWidth, y: 0.0, width: frame.width - leftWidth - rightWidth, height: frame.height)
        self.centerTableView = GXMessagesLoadTableView(frame: centerRect, style: style)
        self.centerTableView.separatorStyle = .none
        self.centerTableView.contentInsetAdjustmentBehavior = .never
        self.centerTableView.allowsMultipleSelection = true
        self.centerTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.centerTableView.dataSource = self
        self.centerTableView.delegate = self
        self.centerTableView.loadingCompletion = {[weak self] in
            DispatchQueue.main.async {
                self?.endScroll()
            }
        }
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
            return self.centerDataSections.count
        }
        else {
            return self.marginDataSections.count
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.centerTableView {
            return self.centerDataSections[section].list.count
        }
        else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.centerTableView {
            let centerData = self.centerDataSections[indexPath.section].list[indexPath.row]
            return (self.dataSource?.gx_tableView(inCenter: tableView, cellForRowAt: indexPath, data: centerData))!
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
            let marginDataSection = self.marginDataSections[indexPath.section]
            if marginDataSection.direction == .left {
                return marginDataSection.height - self.marginItemHeight
            }
            else {
                return marginDataSection.height
            }
        }
        else if tableView == self.rightTableView {
            let marginDataSection = self.marginDataSections[indexPath.section]
            if marginDataSection.direction == .right {
                return marginDataSection.height - self.marginItemHeight
            }
            else {
                return marginDataSection.height
            }
        }
        else {
            return self.centerDataSections[indexPath.section].list[indexPath.row].height
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.centerTableView {
            return self.centerHeaderHeight
        }
        
        guard marginPosition == .top else { return CGFloat.leastNormalMagnitude }
        let direction = self.marginDataSections[section].direction
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
        
        let direction = self.marginDataSections[section].direction
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
            let centerDataSection = self.centerDataSections[section]
            let header = self.dataSource?.gx_tableView(inCenter: tableView, viewForHeaderInSection: section, data: centerDataSection)
            return header
        }
        guard marginPosition == .top else { return nil }
        
        let marginDataSection = self.marginDataSections[section]
        if tableView == self.leftTableView {
            if marginDataSection.direction == .left {
                return self.dataSource?.gx_tableView(inMargin: tableView, viewForHeaderFooterInSection: section, data: marginDataSection)
            }
        }
        else if tableView == self.rightTableView {
            if marginDataSection.direction == .right {
                return self.dataSource?.gx_tableView(inMargin: tableView, viewForHeaderFooterInSection: section, data: marginDataSection)
            }
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard marginPosition == .bottom else { return nil }
        
        let marginDataSection = self.marginDataSections[section]
        if tableView == self.leftTableView {
            if marginDataSection.direction == .left {
                return self.dataSource?.gx_tableView(inMargin: tableView, viewForHeaderFooterInSection: section, data: marginDataSection)
            }
        }
        else if tableView == self.rightTableView {
            if marginDataSection.direction == .right {
                return self.dataSource?.gx_tableView(inMargin: tableView, viewForHeaderFooterInSection: section, data: marginDataSection)
            }
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isSelectMargin = self.isCenterCorrelationMargin(at: indexPath)
        
        NSLog("isCenterCorrelationMargin = \(isSelectMargin),  atIndex: \(indexPath)")
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
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.beginScroll()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.endScroll()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.endScroll()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.endScroll()
    }
      
}

private extension GXMessagesTableView {
    func beginScroll() {
        if let fristIndexPath = self.centerTableView.indexPathsForVisibleRows?.first {
            let header = self.centerTableView.headerView(forSection: fristIndexPath.section)
            self.scrollHeaderAnimate(header: header, hidden: false)
        }
    }
    func endScroll() {
        if let fristIndexPath = self.centerTableView.indexPathsForVisibleRows?.first {
            let cellRect = self.centerTableView.rectForRow(at: fristIndexPath)
            let cellTop = cellRect.origin.y - self.centerTableView.contentOffset.y
            if fristIndexPath.row > 0 || cellTop - self.centerHeaderHeight/2 < 0 {
                let header = self.centerTableView.headerView(forSection: fristIndexPath.section)
                self.scrollHeaderAnimate(header: header, hidden: true)
            }
        }
    }
    func scrollHeaderAnimate(header: UIView?, hidden: Bool) {
        if hidden {
            header?.isHidden = true
        }
        else {
            header?.isHidden = false
        }
    }
    func isCenterCorrelationMargin(at indexPath: IndexPath) -> Bool {
        let cellData = self.centerDataSections[indexPath.section].list[indexPath.row]
        var marginVisibleSections: [any GXMessagesCenterOperation]? = nil
        if let indexPathsForVisibleRows = self.leftTableView?.indexPathsForVisibleRows {
            for subIndexPath in indexPathsForVisibleRows {
                let marginDataSection = self.marginDataSections[subIndexPath.section]
                if marginDataSection.list.contains(where: {$0 == cellData}) {
                    marginVisibleSections = marginDataSection.list; break
                }
            }
        }
        if let indexPathsForVisibleRows = self.rightTableView?.indexPathsForVisibleRows {
            for subIndexPath in indexPathsForVisibleRows {
                let marginDataSection = self.marginDataSections[subIndexPath.section]
                if marginDataSection.list.contains(where: {$0 == cellData}) {
                    marginVisibleSections = marginDataSection.list; break
                }
            }
        }
        guard let marginSections = marginVisibleSections else { return false }
        
        var minItem: Int = NSNotFound, maxItem: Int = NSNotFound
        if let indexPathsForVisibleRows = self.centerTableView.indexPathsForVisibleRows {
            for subIndexPath in indexPathsForVisibleRows {
                let subCellData = self.centerDataSections[subIndexPath.section].list[subIndexPath.row]
                if marginSections.contains(where: {$0 == subCellData}) {
                    minItem = (minItem == NSNotFound) ? subIndexPath.row : min(subIndexPath.row, minItem)
                    maxItem = (maxItem == NSNotFound) ? subIndexPath.row : max(subIndexPath.row, maxItem)
                }
            }
        }
        if self.marginPosition == .top {
            if minItem == maxItem {
                return true
            }
            else if indexPath.row == minItem {
                let cellRect = self.centerTableView.rectForRow(at: indexPath)
                let cellBottom = cellRect.maxY - self.centerTableView.contentOffset.y
                return (cellBottom > self.marginItemHeight/2)
            }
            else if indexPath.row - minItem > 0 {
                let cellRect = self.centerTableView.rectForRow(at: indexPath)
                let cellTop = cellRect.origin.y - self.centerTableView.contentOffset.y
                return (cellTop < self.marginItemHeight/2)
            }
        }
        else {
            if minItem == maxItem {
                return true
            }
            else if indexPath.row == maxItem {
                let cellRect = self.centerTableView.rectForRow(at: indexPath)
                let cellTop = cellRect.origin.y - self.centerTableView.contentOffset.y
                return (self.centerTableView.height - cellTop > self.marginItemHeight/2)
            }
            else if maxItem - indexPath.row > 0 {
                let cellRect = self.centerTableView.rectForRow(at: indexPath)
                let cellBottom = cellRect.maxY - self.centerTableView.contentOffset.y
                return (self.centerTableView.height - cellBottom < self.marginItemHeight/2)
            }
        }
        return false
    }
    
}

public extension GXMessagesTableView {
    
    func register<T: UITableViewCell>(cellType: T.Type)
      where T: Reusable & NibLoadable {
          self.centerTableView.register(cellType: cellType)
    }

    func register<T: UITableViewCell>(cellType: T.Type)
      where T: Reusable {
          self.centerTableView.register(cellType: cellType)
    }
    
    func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type, isCenter: Bool)
      where T: Reusable & NibLoadable {
          if isCenter {
              self.centerTableView.register(headerFooterViewType: headerFooterViewType)
          }
          else {
              self.leftTableView?.register(headerFooterViewType: headerFooterViewType)
              self.rightTableView?.register(headerFooterViewType: headerFooterViewType)
          }
    }

    func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type, isCenter: Bool)
      where T: Reusable {
          if isCenter {
              self.centerTableView.register(headerFooterViewType: headerFooterViewType)
          }
          else {
              self.leftTableView?.register(headerFooterViewType: headerFooterViewType)
              self.rightTableView?.register(headerFooterViewType: headerFooterViewType)
          }
    }
    
    func deleteRows(at indexPaths: [IndexPath], deleteMarginSections: IndexSet, updateMarginSections: IndexSet) {
        self.centerTableView.updateWithBlock({ tableView in
            tableView?.deleteRows(at: indexPaths, with: .middle)
        })
        self.leftTableView?.updateWithBlock({ tableView in
            if deleteMarginSections.count > 0 {
                tableView?.deleteSections(deleteMarginSections, with: .middle)
            }
            if updateMarginSections.count > 0 {
                tableView?.reloadSections(updateMarginSections, with: .middle)
            }
        })
        self.rightTableView?.updateWithBlock({ tableView in
            if deleteMarginSections.count > 0 {
                tableView?.deleteSections(deleteMarginSections, with: .middle)
            }
            if updateMarginSections.count > 0 {
                tableView?.reloadSections(updateMarginSections, with: .middle)
            }
        })
    }
    
    func deleteSections(sections: IndexSet, deleteMarginSections: IndexSet, updateMarginSections: IndexSet) {
        self.centerTableView.updateWithBlock({ tableView in
            tableView?.deleteSections(sections, with: .middle)
        })
        self.leftTableView?.updateWithBlock({ tableView in
            if deleteMarginSections.count > 0 {
                tableView?.deleteSections(deleteMarginSections, with: .middle)
            }
            if updateMarginSections.count > 0 {
                tableView?.reloadSections(updateMarginSections, with: .middle)
            }
        })
        self.rightTableView?.updateWithBlock({ tableView in
            if deleteMarginSections.count > 0 {
                tableView?.deleteSections(deleteMarginSections, with: .middle)
            }
            if updateMarginSections.count > 0 {
                tableView?.reloadSections(updateMarginSections, with: .middle)
            }
        })
    }
    
    func deleteSectionsAndRows(indexPaths: [IndexPath], sections: IndexSet, deleteMarginSections: IndexSet, updateMarginSections: IndexSet) {
        self.centerTableView.updateWithBlock({ tableView in
            tableView?.deleteRows(at: indexPaths, with: .middle)
            tableView?.deleteSections(sections, with: .middle)
        })
        self.leftTableView?.updateWithBlock({ tableView in
            if deleteMarginSections.count > 0 {
                tableView?.deleteSections(deleteMarginSections, with: .middle)
            }
            if updateMarginSections.count > 0 {
                tableView?.reloadSections(updateMarginSections, with: .middle)
            }
        })
        self.rightTableView?.updateWithBlock({ tableView in
            if deleteMarginSections.count > 0 {
                tableView?.deleteSections(deleteMarginSections, with: .middle)
            }
            if updateMarginSections.count > 0 {
                tableView?.reloadSections(updateMarginSections, with: .middle)
            }
        })
    }
    
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
