//

import UIKit
import Reusable
import GXMessagesTableView
import GXChatUIKit
import AVFoundation
import CoreLocation

class ViewController: UIViewController {
    
    private var list: [GXMessagesSectionData] = []
    
    private lazy var tableView: GXMessagesTableView = {
        let tv = GXMessagesTableView(frame: self.view.bounds, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.datalist = self
        tv.backgroundColor = UIColor(hex: 0xEFEFEF)
        tv.separatorStyle = .none
        
        return tv
    }()
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        let frame = self.view.bounds.inset(by: self.view.safeAreaInsets)
        self.tableView.frame = frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.tableView)
        self.tableView.backgroundImage = UIImage(named: "background")
        self.tableView.register(cellType: GXMessagesTextCell.self)
        self.tableView.register(cellType: GXMessagesMediaCell.self)
        self.tableView.register(cellType: GXMessagesAudioCell.self)
        self.tableView.register(cellType: GXMessagesLocationCell.self)

        
        self.tableView.register(headerFooterViewType: GXMessagesSectionHeader.self)
        self.tableView.sectionHeaderHeight = 30.0
        //        self.tableView.addMessagesHeader {[weak self] in
        //            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 2.0) {
        //                self?.updateDatas()
        //                self?.tableView.endHeaderLoading()
        //            }
        //        }

        self.updateDatas()
        self.tableView.reloadData()
        
    }
    
    public func updateDatas() {
        var data1 = GXMessagesTestData()
        data1.date = Date().dateByAdding(days: -2)!
        data1.showName = "抬头45度仰望天空"
        data1.avatarID = "11"
        data1.messageID = "111"
        data1.messageContinuousStatus = .begin
        data1.messageStatus = .sending
        data1.messageType = .text
        let text = "也不知道说什么！7867868765765765656556565656测试网址https://www.baidu.com，" +
        "测试电话0755-89776672，测试手机号18826763432，" +
        "测试表情[微笑][厌恶][鬼脸]。" +
        "邮箱：22872347834@qq.com"
        data1.messagesContentData = GXMessagesTextContent(text: text)
        
        let item1 = GXMessagesItemData(data: data1)
        item1.updateMessagesAvatar(image: UIImage(named: "avatar1"))
        let sectionData = GXMessagesSectionData(date: data1.date)
        sectionData.append(item: item1)
        
        var data2 = GXMessagesTestData()
        data2.date = Date().dateByAdding(days: -2)!
        data2.showName = "抬头45度仰望天空"
        data2.avatarID = "11"
        data2.messageID = "112"
        data2.messageContinuousStatus = .ongoing
        data2.messageStatus = .sending
        data2.messageType = .text
        data2.messagesContentData = GXMessagesTextContent(text: "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。")
        
        let item2 = GXMessagesItemData(data: data2)
        item2.updateMessagesAvatar(image: UIImage(named: "avatar1"))
        sectionData.append(item: item2)
        
        var data3 = GXMessagesTestData()
        data3.date = Date().dateByAdding(days: -2)!
        data3.showName = "抬头45度仰望天空"
        data3.avatarID = "11"
        data3.messageID = "113"
        data3.messageContinuousStatus = .end
        data3.messageStatus = .sending
        data3.messageType = .phote
        data3.messagesContentData = GXMessagesPhotoContent(thumbnailImage: UIImage(named: "testphoto"))
        
        let item3 = GXMessagesItemData(data: data3)
        item3.updateMessagesAvatar(image: UIImage(named: "avatar1"))
        sectionData.append(item: item3)
        
        self.list.append(sectionData)
        
        
        var data11 = GXMessagesTestData()
        data11.date = Date().dateByAdding(days: -1)!
        data11.showName = "你算什么男人"
        data11.avatarID = "22"
        data11.messageID = "114"
        data11.messageContinuousStatus = .begin
        data11.messageStatus = .receiving
        data11.messageType = .text
        data11.messagesContentData = GXMessagesTextContent(text: "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。")
        
        let item11 = GXMessagesItemData(data: data11)
        item11.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        
        let sectionData1 = GXMessagesSectionData(date: data11.date)
        sectionData1.append(item: item11)
        
        var data22 = GXMessagesTestData()
        data22.date = Date().dateByAdding(days: -1)!
        data22.showName = "你算什么男人"
        data22.avatarID = "22"
        data22.messageID = "115"
        data22.messageContinuousStatus = .ongoing
        data22.messageStatus = .receiving
        data22.messageType = .text
        data22.messagesContentData = GXMessagesTextContent(text: "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。")
        
        let item22 = GXMessagesItemData(data: data22)
        item22.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        sectionData1.append(item: item22)
        
        var data33 = GXMessagesTestData()
        data33.date = Date().dateByAdding(days: -1)!
        data33.showName = "你算什么男人"
        data33.avatarID = "22"
        data33.messageID = "116"
        data33.messageContinuousStatus = .end
        data33.messageStatus = .receiving
        data33.messageType = .video
        data33.messagesContentData = GXMessagesVideoContent(thumbnailImage: UIImage(named: "testphoto"))
        
        let item33 = GXMessagesItemData(data: data33)
        item33.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        sectionData1.append(item: item33)
        
        self.list.append(sectionData1)
        
        
        var data13 = GXMessagesTestData()
        data13.date = Date()
        data13.showName = "你算什么男人"
        data13.avatarID = "22"
        data13.messageID = "117"
        data13.messageContinuousStatus = .begin
        data13.messageStatus = .receiving
        data13.messageType = .text
        data13.messagesContentData = GXMessagesTextContent(text: "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。")
        
        let item13 = GXMessagesItemData(data: data13)
        item13.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        
        let sectionData2 = GXMessagesSectionData(date: data13.date)
        sectionData2.append(item: item13)
        
        var data23 = GXMessagesTestData()
        data23.date = Date()
        data23.showName = "你算什么男人"
        data23.avatarID = "22"
        data23.messageID = "118"
        data23.messageContinuousStatus = .ongoing
        data23.messageStatus = .receiving
        data23.messageType = .text
        data23.messagesContentData = GXMessagesTextContent(text: "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。")
        
        let item23 = GXMessagesItemData(data: data23)
        item23.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        sectionData2.append(item: item23)
        
        var data34 = GXMessagesTestData()
        data34.date = Date()
        data34.showName = "你算什么男人"
        data34.avatarID = "22"
        data34.messageID = "119"
        data34.messageContinuousStatus = .end
        data34.messageStatus = .receiving
        data34.messageType = .video
        data34.messagesContentData = GXMessagesVideoContent(thumbnailImage: UIImage(named: "testphoto"))
        
        let item34 = GXMessagesItemData(data: data34)
        item34.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        sectionData2.append(item: item34)
        
        var data24 = GXMessagesTestData()
        data24.date = Date()
        data24.showName = "这样也好"
        data24.avatarID = "33"
        data24.messageID = "120"
        data24.messageContinuousStatus = .beginAndEnd
        data24.messageStatus = .receiving
        data24.messageType = .text
        data24.messagesContentData = GXMessagesTextContent(text: "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。")
        
        let item24 = GXMessagesItemData(data: data24)
        item24.updateMessagesAvatar(image: UIImage(named: "avatar3"))
        sectionData2.append(item: item24)
        
        self.list.append(sectionData2)
        
        
        var data44 = GXMessagesTestData()
        data44.date = Date().dateByAdding(days: 1)!
        data44.showName = "你算什么男人"
        data44.avatarID = "22"
        data44.messageID = "121"
        data44.messageContinuousStatus = .begin
        data44.messageStatus = .receiving
        data44.messageType = .audio
        let urlString = Bundle.main.path(forResource: "voicexinwen", ofType: "mp3")!
        let url = URL(fileURLWithPath: urlString)
        let tracks = [120, 30, 50, 60, 80, 120, 200, 255, 230, 180, 150, 90, 0, 30, 50, 60, 80, 120, 200, 255, 230, 180, 150, 90, 255]
        data44.messagesContentData = GXMessagesAudioContent(fileURL: url, duration: 12, tracks: tracks)

        let item44 = GXMessagesItemData(data: data44)
        item44.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        
        let sectionData4 = GXMessagesSectionData(date: data44.date)
        sectionData4.append(item: item44)
        
        
        var data35 = GXMessagesTestData()
        data35.date = Date().dateByAdding(days: 1)!
        data35.showName = "你算什么男人"
        data35.avatarID = "22"
        data35.messageID = "122"
        data35.messageContinuousStatus = .end
        data35.messageStatus = .receiving
        data35.messageType = .location
        let locationTitle = "广东省深圳市南山区南山村正街正三坊168号6栋618"
        data35.messagesContentData = GXMessagesLocationContent(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), locationTitle: locationTitle, locationImage: UIImage(named: "testphoto"))
        
        let item35 = GXMessagesItemData(data: data35)
        item35.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        sectionData4.append(item: item35)

        self.list.append(sectionData4)
        
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, GXMessagesTableViewDatalist {
    
    func gx_tableView(_ tableView: UITableView, avatarDataForRowAt indexPath: IndexPath) -> GXMessagesAvatarDataProtocol {
        return self.list[indexPath.section].items[indexPath.row].data
    }
    
    func gx_tableView(_ tableView: UITableView, changeForRowAt indexPath: IndexPath, avatar: UIView) {
        if let avatarButton = avatar as? UIButton {
            let item = self.list[indexPath.section].items[indexPath.row]
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
        return self.list[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.list[indexPath.section].items[indexPath.row]
        switch item.data.gx_messageType {
        case .text:
            let cell: GXMessagesTextCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item)
            
            return cell
        case .phote, .video:
            let cell: GXMessagesMediaCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item)
            
            return cell
        case .audio:
            let cell: GXMessagesAudioCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item)
            
            return cell
        case .location:
            let cell: GXMessagesLocationCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item)
            
            return cell

        default: break
        }
        return UITableViewCell ()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.list[indexPath.section].items[indexPath.row]
        
        return item.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: GXMessagesSectionHeader? = tableView.dequeueReusableHeaderFooterView()
        let sectionData = self.list[section]
        header?.bindHeader(data: sectionData)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ViewController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableView.gx_scrollBeginDragging()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.tableView.gx_scrollEndDragging()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.tableView.gx_scrollEndDragging()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.tableView.gx_scrollEndDragging()
    }
}
