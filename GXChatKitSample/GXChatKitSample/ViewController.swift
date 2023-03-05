//
//  ViewController.swift
//  GXChatKitSample
//
//  Created by Gin on 2022/12/24.
//

import UIKit
import GXMessagesTableView

class GXTestMessageData: NSObject, GXMessagesCenterOperation {
    var date: Date = Date()
    
    var marginSection: Int = 0
    var centerIndexPath: IndexPath = IndexPath()
    var marginIdentifier: String {
        return self.senderId
    }
    var senderId: String = ""
    var identifier: String = ""
    var height: CGFloat = 60.0
    var text = "测试文本，阿萨德交换空间啊还是打卡机啊三打哈"
    
    static func == (lhs: GXTestMessageData, rhs: GXTestMessageData) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

fileprivate let GX_USERID: String = "333"

class ViewController: UIViewController {
    
    
//    public required init(frame: CGRect,
//                         style: UITableView.Style = .plain,
//                         marginStyle: UITableView.Style = .plain,
//                         marginPosition: MarginPosition = .bottom,
//                         leftWidth: Double = 0.0,
//                         rightWidth: Double = 0.0,
//                         contentHeight: Double = 0.0)
    
    private lazy var tableView: GXMessagesTableView = {
        let rect = CGRect(x: 0, y: 64, width: self.view.width, height: self.view.height - 64)
        let tv = GXMessagesTableView(frame: rect, leftWidth: 50.0, rightWidth: 50.0)
        tv.backgroundColor = .white
        tv.dataSource = self
        tv.delegate = self
        
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GXMessagesTableView"
        
        self.view.addSubview(self.tableView)
        self.tableView.marginPosition = .bottom
        self.tableView.marginItemHeight = 50.0
        self.tableView.centerHeaderHeight = 30.0
        self.tableView.myUserID = GX_USERID
        self.loadData()
        
        self.tableView.addMessagesHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 2.0) {
                
                
                var indexPats: [IndexPath] = []
                indexPats.append(IndexPath(row: 0, section: 1))
                indexPats.append(IndexPath(row: 1, section: 1))

                indexPats.append(IndexPath(row: 0, section: 3))
                indexPats.append(IndexPath(row: 1, section: 3))
                indexPats.append(IndexPath(row: 2, section: 3))
                indexPats.append(IndexPath(row: 3, section: 3))

                indexPats.append(IndexPath(row: 1, section: 2))
                indexPats.append(IndexPath(row: 2, section: 2))

//                self?.tableView.deleteRows(at: indexPats, with: .fade)

//                self?.loadData()
//                self?.tableView.reloadData()
                self?.tableView.endHeaderLoading(isReload: false)
                
            }
        }
    }
    
    func loadData() {
        var list: [GXTestMessageData] = []
        
        let date = Date().dateByAdding(days: -1)
        for _ in 0..<3 {
            let data = GXTestMessageData()
            data.date = date ?? Date()
            data.senderId = "111"
            list.append(data)
        }
        
        let date1 = Date().dateByAdding(days: -2)
        for _ in 0..<3 {
            let data = GXTestMessageData()
            data.date = date1 ?? Date()
            data.senderId = "333"
            list.append(data)
        }
        
        let date2 = Date().dateByAdding(days: -3)
        for _ in 0..<3 {
            let data = GXTestMessageData()
            data.date = date2 ?? Date()
            data.senderId = "222"
            list.append(data)
        }
        
        self.tableView.reloadDataByAppend(datas: list)
    }

}

extension  ViewController: GXMessagesTableViewDataSource, GXMessagesTableViewDelegate {
    
    
    /// 中间tableView的header
    func gx_tableView(inCenter tableView: UITableView, viewForHeaderInSection section: Int, data: GXMessagesCenterSection) -> UIView? {
        let view = UITableViewHeaderFooterView(reuseIdentifier: "H")
        view.textLabel?.text = "H(\(section)"
        view.backgroundView = UIView()
        view.backgroundView?.backgroundColor = .clear
        
        return view
    }
    /// 中间tableView的cell
    func gx_tableView(inCenter tableView: UITableView, cellForRowAt indexPath: IndexPath, data: any GXMessagesCenterOperation) -> UITableViewCell {
        let cellID = "CellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = "asdkjaksldaskldjkl, asjdkhkajshdkjas hdkajsdhajksdhakjsdhaksjdh"

        return cell!
    }
    
    func gx_tableView(inMargin tableView: UITableView, directionInSection section: Int, data: GXMessagesMarginSection) -> GXMessagesTableView.MarginDirection {
        if data.marginIdentifier == nil {
            return .none
        }
        else if data.marginIdentifier == GX_USERID {
            return .right
        }
        else  {
            return .left
        }
    }
    
    /// 两边tableView的具体内容视图
    func gx_tableView(inMargin tableView: UITableView, viewForHeaderFooterInSection section: Int, data: GXMessagesMarginSection) -> UIView? {
        let view = UITableViewHeaderFooterView(reuseIdentifier: "H")
        view.textLabel?.text = "H"
        view.backgroundView = UIView()
        view.backgroundView?.backgroundColor = .red
        
        return view
    }
    
    // MARK: GXMessagesTableViewDelegate

}

