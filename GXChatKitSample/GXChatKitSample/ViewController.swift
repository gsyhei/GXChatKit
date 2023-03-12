//

import UIKit
import Reusable
import GXMessagesTableView
import GXChatUIKit

class ViewController: UIViewController {
    
    private var list: [[GXMessageItem]] = []
    
    private lazy var tableView: GXMessagesTableView = {
        let tv = GXMessagesTableView(frame: self.view.bounds, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.datalist = self
        tv.backgroundColor = UIColor(hexString: "#333333")
        tv.rowHeight = 100.0
        tv.separatorStyle = .none

        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.tableView)
        self.tableView.register(cellType: GXMessagesTextCell.self)
        self.tableView.register(cellType: GXMessagesMediaCell.self)
        
        self.tableView.sectionHeaderHeight = 30.0
        self.tableView.addMessagesHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 2.0) {
                self?.updateDatas()
                self?.tableView.endHeaderLoading()
            }
        }
        
        self.updateDatas()
        self.tableView.reloadData()
    }
    
    public func updateDatas() {
        var array: [GXMessageItem] = []

        for index in 0..<40 {
            let column = index / 4
            let cuindex = index % 4
            
            if cuindex == 2 {
                var data = GXTestTextData()
                data.text = "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。"
                if cuindex == 0 {
                    data.messageContinuousStatus = .begin
                } else if cuindex == 3 {
                    data.messageContinuousStatus = .end
                } else {
                    data.messageContinuousStatus = .ongoing
                }
                data.messageStatus = (column%4 > 1) ? .sending : .receiving
                if data.messageStatus == .sending {
                    data.avatarID = "111111111111"
                    data.avatarText = "发送"
                }
                else {
                    data.avatarID = "\(column)"
                    data.avatarText = "收\(column)"
                }

                let item = GXMessageItem(data: data)
                array.append(item)
            }
            else {
                var data = GXTestPhotoData()
                if cuindex == 0 {
                    data.messageContinuousStatus = .begin
                } else if cuindex == 3 {
                    data.messageContinuousStatus = .end
                } else {
                    data.messageContinuousStatus = .ongoing
                }
                data.messageStatus = (column%4 > 1) ? .sending : .receiving
                if data.messageStatus == .sending {
                    data.avatarID = "111111111111"
                    data.avatarText = "发送"
                }
                else {
                    data.avatarID = "\(column)"
                    data.avatarText = "收\(column)"
                }

                let item = GXMessageItem(data: data)
                array.append(item)
            }
        }
        self.list.append(array)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        let rect = self.view.bounds.insetBy(dx: 0, dy: self.view.safeAreaInsets.bottom)
        self.tableView.frame = rect
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate, GXMessagesTableViewDatalist {
    
    func gx_tableView(_ tableView: UITableView, avatarDataForRowAt indexPath: IndexPath) -> GXMessagesAvatarDataProtocol {        
        return self.list[indexPath.section][indexPath.row].data
    }
    
    func gx_tableView(_ tableView: UITableView, changeForRowAt indexPath: IndexPath, avatar: UIView) {
        if let avatarButton = avatar as? UIButton {
            let item = self.list[indexPath.section][indexPath.row]
            if item.gx_isShowAvatar {
                GXMessagesBaseCell.updateAvatar(item: item, avatarButton: avatarButton)
            }
            else {
                avatarButton.isHidden = true
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.list[indexPath.section][indexPath.row]
        switch item.data.gx_messageType {
        case .text:
            let cell: GXMessagesTextCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item)
            
            return cell
        case .phote:
            let cell: GXMessagesMediaCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item)
            
            return cell
            
        default: break
        }
        return UITableViewCell ()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.list[indexPath.section][indexPath.row]

        return item.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewID = "ViewID"
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "viewID")
        if header == nil {
            header = UITableViewHeaderFooterView(reuseIdentifier: viewID)
        }
        header?.textLabel?.text = "Section: \(section)"
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
