//
//  ViewController.swift
//  GXChatKitSample
//
//  Created by Gin on 2022/12/24.
//

import UIKit
import GXMessagesTableView

class GXTestAvatarsData: NSObject {
    var direction: GXMessagesTableView.MarginDirection = .none
    var height: CGFloat = 0.0
    var text = "头"
}

class GXTestGroupsMessageData: NSObject {
    var headerHeight: CGFloat = 30.0
    var allHeight: CGFloat = 0.0
    var headerText = "header text"
    var messages: [GXTestMessageData] = []
}

class GXTestMessageData: NSObject {
    var height: CGFloat = 60.0
    var text = "测试文本，阿萨德交换空间啊还是打卡机啊三打哈"
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
        let rect = self.view.frame//CGRect(x: 0, y: 100, width: self.view.width, height: self.view.height - 100)
        let tv = GXMessagesTableView(frame: rect, marginPosition: .top, marginItemHeight: 50.0, leftWidth: 50.0, rightWidth: 0.0)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .white
        
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GXMessagesTableView"
        
        self.view.addSubview(self.tableView)
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
        for index in (0..<5) {
            let group = GXTestGroupsMessageData()
            group.headerText +=  ": \(index + groupCount)"
            
            var avatar = GXTestAvatarsData()
            avatar.height = group.headerHeight
            avatar.direction = .none
            self.messageAvatars.append(avatar)
            
            avatar = GXTestAvatarsData()
            avatar.direction = .left
            for _ in 0..<2 {
                let message = GXTestMessageData()
                group.allHeight += message.height
                avatar.height += message.height
                group.messages.append(message)
            }
            self.messageAvatars.append(avatar)

            avatar = GXTestAvatarsData()
            avatar.direction = .left
            for _ in 0..<2 {
                let message = GXTestMessageData()
                group.allHeight += message.height
                avatar.height += message.height
                group.messages.append(message)
            }
            self.messageAvatars.append(avatar)
            
            self.messageGroups.insert(group, at: 0)
        }
    }

}

extension  ViewController: GXMessagesTableViewDataSource, GXMessagesTableViewDelegate {
    
    /// 两边tableView的sections
    func gx_numberOfSections(inMargin tableView: UITableView) -> Int {
        return self.messageAvatars.count
    }
    /// 中间tableView的sections
    func gx_numberOfSections(inCenter tableView: UITableView) -> Int {
        return self.messageGroups.count
    }
    /// 中间tableView的sections
    func gx_tableView(inCenter tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageGroups[section].messages.count
    }
    /// 中间tableView的header
    func gx_tableView(inCenter tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView(reuseIdentifier: "H")
        view.textLabel?.text = self.messageGroups[section].headerText
        
        return view
    }
    /// 中间tableView的cell
    func gx_tableView(inCenter tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "CellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = "asdkjaksldaskldjkl, asjdkhkajshdkjas hdkajsdhajksdhakjsdhaksjdh"

        return cell!
    }
    /// 两边tableView内容具体显示在哪边
    func gx_tableView(inMargin tableView: UITableView, directionInSection section: Int) -> GXMessagesTableView.MarginDirection {
        return self.messageAvatars[section].direction
    }
    /// 两边tableView的具体内容视图
    func gx_tableView(inMargin tableView: UITableView, viewForContentInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView(reuseIdentifier: "H")
        view.textLabel?.text = self.messageAvatars[section].text
        view.backgroundView = UIView()
        view.backgroundView?.backgroundColor = .red
        
        return view
    }
    
    // MARK: GXMessagesTableViewDelegate
    
    /// 两边tableView的总体高度
    func gx_tableView(inMargin tableView: UITableView, heightForAllInSection section: Int) -> CGFloat {
        return self.messageAvatars[section].height
    }
    /// 中间tableView的header高度
    func gx_tableView(inCenter tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.messageGroups[section].headerHeight
    }
    /// 中间tableView的cell高度
    func gx_tableView(inCenter tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.messageGroups[indexPath.section].messages[indexPath.row].height
    }
    
}

