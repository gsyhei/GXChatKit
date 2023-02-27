//
//  ViewController.swift
//  GXChatKitSample
//
//  Created by Gin on 2022/12/24.
//

import UIKit
import GXMessagesTableView

class GXTestAvatarsData: GXMessagesMarginSection {
    var height: CGFloat = 0.0
    var direction: GXMessagesTableView.MarginDirection = .none
    var list: [any GXMessagesCenterOperation] = []
    var text = "头"
}

class GXTestGroupsMessageData: GXMessagesCenterSection {
    var list: [any GXMessagesCenterOperation] = []
    var headerText = "header text"
}

class GXTestMessageData: NSObject, GXMessagesCenterOperation {
    var identifier: String = ""
    var height: CGFloat = 60.0
    var text = "测试文本，阿萨德交换空间啊还是打卡机啊三打哈"
    
    static func == (lhs: GXTestMessageData, rhs: GXTestMessageData) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class ViewController: UIViewController {
    
    private var messageGroups: [GXTestGroupsMessageData] = []
    private var messageAvatars: [GXTestAvatarsData] = []
    
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
        self.loadData()
        self.tableView.reloadData()
        
        self.tableView.addMessagesHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 2.0) {
                self?.loadData()
                self?.tableView.reloadData()
                self?.tableView.endHeaderLoading(isReload: false)
            }
        }
    }
    
    func loadData() {
        let groupCount = self.messageGroups.count
        for groupIndex in (0..<5) {
            let group = GXTestGroupsMessageData()
            group.headerText +=  ": \(groupIndex + groupCount)"
            var avatars: [GXTestAvatarsData] = []
            
            var avatar = GXTestAvatarsData()
            avatar.height = 30.0
            avatar.direction = .none
            avatars.append(avatar)
            
            avatar = GXTestAvatarsData()
            avatar.direction = .left
            for _ in 0..<2 {
                let message = GXTestMessageData()
                message.identifier = "\(groupIndex + groupCount)_\(group.list.count)"
                avatar.height += message.height
                avatar.list.append(message)
                group.list.append(message)
            }
            avatars.append(avatar)

            avatar = GXTestAvatarsData()
            avatar.direction = .right
            for _ in 0..<2 {
                let message = GXTestMessageData()
                message.identifier = "\(groupIndex + groupCount)_\(group.list.count)"

                avatar.height += message.height
                avatar.list.append(message)
                group.list.append(message)
            }
            avatars.append(avatar)

            
            self.messageAvatars.insert(contentsOf: avatars, at: 0)
            self.messageGroups.insert(group, at: 0)
        }
        
        self.tableView.centerDataSections = self.messageGroups
        self.tableView.marginDataSections = self.messageAvatars
    }

}

extension  ViewController: GXMessagesTableViewDataSource, GXMessagesTableViewDelegate {
    
    /// 中间tableView的header
    func gx_tableView(inCenter tableView: UITableView, viewForHeaderInSection section: Int, data: GXMessagesCenterSection) -> UIView? {
        let view = UITableViewHeaderFooterView(reuseIdentifier: "H")
        view.textLabel?.text = self.messageGroups[section].headerText
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
    /// 两边tableView的具体内容视图
    func gx_tableView(inMargin tableView: UITableView, viewForHeaderFooterInSection section: Int, data: GXMessagesMarginSection) -> UIView? {
        let view = UITableViewHeaderFooterView(reuseIdentifier: "H")
        view.textLabel?.text = self.messageAvatars[section].text
        view.backgroundView = UIView()
        view.backgroundView?.backgroundColor = .red
        
        return view
    }
    
    // MARK: GXMessagesTableViewDelegate

}

