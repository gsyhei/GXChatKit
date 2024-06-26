//

import UIKit
import Reusable
import GXMessagesHoverAvatarTableView
import GXChatUIKit
import AVFoundation
import CoreLocation
import FPSLabel

class ViewController: UIViewController {
    
    private var list: [GXMessagesSectionData] = []
    private var currentReplyIndexPath: IndexPath?
    
    private lazy var animationDelegate: GXMessagesMenuAnimationDelegate = {
        let animationDelegate = GXMessagesMenuAnimationDelegate()
        animationDelegate.configureTransition(self, interacted: false)
        
        return animationDelegate
    }()
    
    private lazy var tableView: GXMessagesHoverAvatarTableView = {
        let tv = GXMessagesHoverAvatarTableView(frame: self.view.bounds, style: .plain)
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
        
        FPSLabel.install(on: self.view.currentWindow())

        self.view.addSubview(self.tableView)
        self.tableView.backgroundImage = UIImage(named: "background")
        self.tableView.register(cellType: GXMessagesTextCell.self)
        self.tableView.register(cellType: GXMessagesMediaCell.self)
        self.tableView.register(cellType: GXMessagesAudioCell.self)
        self.tableView.register(cellType: GXMessagesLocationCell.self)
        self.tableView.register(cellType: GXMessagesCallCell.self)
        self.tableView.register(cellType: GXMessagesSystemCell.self)
        self.tableView.register(cellType: GXMessagesCardCell.self)
        self.tableView.register(cellType: GXMessagesFileCell.self)
        self.tableView.register(cellType: GXMessagesRedPacketCell.self)
        self.tableView.register(cellType: GXMessagesReplyCell.self)
        
        self.tableView.register(headerFooterViewType: GXMessagesSectionHeader.self)
        //        self.tableView.addMessagesHeader {[weak self] in
        //            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 2.0) {
        //                self?.updateDatas()
        //                self?.tableView.endHeaderLoading()
        //            }
        //        }

        self.updateDatas()
        self.tableView.reloadData()
        
        
        let right = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editItemTapped))
        self.navigationItem.rightBarButtonItem = right
    }
    
    @objc func editItemTapped() {
        if self.tableView.gx_isEditing {
            self.tableView.gx_setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        else {
            self.tableView.gx_setEditing(true, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Cancel"
        }
    }
    
    public func updateDatas() {
        var data1 = GXMessagesTestData()
        data1.date = Date().dateByAdding(days: -2)!
        data1.showName = "发疯了吧"
        data1.avatarID = "11"
        data1.messageID = "110"
        data1.gx_continuousBegin = true
        data1.messageStatus = .send
        data1.messageSendStatus = .sending
        data1.messageType = .text
        let text = "[鬼脸]也不知道说什么！7867868765765765656556565656测试网址https://www.baidu.com，" +
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
        data2.showName = "发疯了吧"
        data2.avatarID = "11"
        data2.messageID = "111"
        data2.messageStatus = .send
        data2.messageSendStatus = .unread
        data2.messageType = .text
        data2.messagesContentData = GXMessagesTextContent(text: "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。")
        
        let item2 = GXMessagesItemData(data: data2)
//        item2.updateMessagesAvatar(image: UIImage(named: "avatar1"))
        sectionData.append(item: item2)
        
        var data02 = GXMessagesTestData()
        data02.date = Date().dateByAdding(days: -2)!
        data02.showName = "发疯了吧"
        data02.avatarID = "11"
        data02.messageID = "112"
        data02.messageStatus = .send
        data02.messageSendStatus = .failure
        data02.messageType = .text
        data02.messagesContentData = GXMessagesTextContent(text: "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。")
        
        let item02 = GXMessagesItemData(data: data02)
        sectionData.append(item: item02)
        
        var data3 = GXMessagesTestData()
        data3.date = Date().dateByAdding(days: -2)!
        data3.showName = "发疯了吧"
        data3.avatarID = "11"
        data3.messageID = "113"
        data3.gx_continuousEnd = true
        data3.messageStatus = .send
        data3.messageSendStatus = .read
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
        data11.gx_continuousBegin = true
        data11.messageStatus = .receive
        data11.messageType = .text
        data11.messagesContentData = GXMessagesTextContent(text: "什么东东啊")
        
        let item11 = GXMessagesItemData(data: data11)
        item11.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        
        let sectionData1 = GXMessagesSectionData(date: data11.date)
        sectionData1.append(item: item11)
        
        var data22 = GXMessagesTestData()
        data22.date = Date().dateByAdding(days: -1)!
        data22.showName = "你算什么男人"
        data22.avatarID = "22"
        data22.messageID = "115"
        data22.messageStatus = .receive
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
        data33.gx_continuousEnd = true
        data33.messageStatus = .receive
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
        data13.gx_continuousBegin = true
        data13.messageStatus = .receive
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
        data23.messageStatus = .receive
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
        data34.gx_continuousEnd = true
        data34.messageStatus = .receive
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
        data24.gx_continuousBegin = true
        data24.gx_continuousEnd = true
        data24.messageStatus = .receive
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
        data44.gx_continuousBegin = true
        data44.messageStatus = .receive
        data44.messageType = .audio
        let urlString = Bundle.main.path(forResource: "voicexinwen", ofType: "mp3")!
//        let urlString = Bundle.main.path(forResource: "redpacket_sound_open", ofType: "wav")!
        let url = URL(fileURLWithPath: urlString)
//        let tracks = [120, 30, 50, 60, 80, 120, 200, 255, 230, 180, 150, 90, 0, 30, 50, 60, 80, 120, 200, 255, 230, 180, 150, 90, 255]
        data44.messagesContentData = GXMessagesAudioContent(fileURL: url, duration: 12)
//        data44.messagesContentData = GXMessagesAudioContent(fileURL: url, duration: 1)

        let item44 = GXMessagesItemData(data: data44)
        item44.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        
        let sectionData4 = GXMessagesSectionData(date: data44.date)
        sectionData4.append(item: item44)
        
        var data35 = GXMessagesTestData()
        data35.date = Date().dateByAdding(days: 1)!
        data35.showName = "你算什么男人"
        data35.avatarID = "22"
        data35.messageID = "122"
        data35.gx_continuousEnd = true
        data35.messageStatus = .receive
        data35.messageType = .location
        let locationTitle = "广东省深圳市南山区南山村正街正三坊168号6栋618"
        data35.messagesContentData = GXMessagesLocationContent(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), locationTitle: locationTitle, locationImage: UIImage(named: "location"))

        let item35 = GXMessagesItemData(data: data35)
        item35.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        sectionData4.append(item: item35)

        self.list.append(sectionData4)
        
        
        var data36 = GXMessagesTestData()
        data36.date = Date().dateByAdding(days: 1)!
        data36.showName = "你算什么男人"
        data36.avatarID = "22"
        data36.messageID = "123"
        data36.gx_continuousBegin = true
        data36.gx_continuousEnd = true
        data36.messageStatus = .receive
        data36.messageType = .videoCall
        data36.messagesContentData = GXMessagesCallContent(duration: 100, status: .interrupt, messagesStatus: data36.messageStatus)
        
        let item36 = GXMessagesItemData(data: data36)
        item36.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        
        let sectionData5 = GXMessagesSectionData(date: data36.date)
        sectionData5.append(item: item36)
        self.list.append(sectionData5)
        
        
        var user1 = GXTestUser()
        user1.userId = "11"
        user1.userName = "发疯了吧"
        var user2 = GXTestUser()
        user2.userId = "22"
        user2.userName = "你算什么男人"
        var user3 = GXTestUser()
        user3.userId = "33"
        user3.userName = "这样也好"
        let users = [user1, user2, user3]
        
        var data37 = GXMessagesTestData()
        data37.date = Date().dateByAdding(days: 1)!
        data37.showName = "你算什么男人"
        data37.avatarID = "22"
        data37.messageID = "124"
        data37.gx_continuousBegin = true
        data37.gx_continuousEnd = true
        data37.messageStatus = .receive
        data37.messageType = .atText
        data37.messagesContentData = GXMessagesAtContent(text: text, users: users)

        let item37 = GXMessagesItemData(data: data37)
        item37.updateMessagesAvatar(image: UIImage(named: "avatar2"))

        let sectionData6 = GXMessagesSectionData(date: data37.date)
        sectionData6.append(item: item37)
        self.list.append(sectionData6)
        
        var data38 = GXMessagesTestData()
        data38.date = Date().dateByAdding(days: 1)!
        data38.showName = "你算什么男人"
        data38.avatarID = "22"
        data38.messageID = "124"
        data38.gx_continuousBegin = true
        data38.gx_continuousEnd = true
        data38.messageStatus = .receive
        data38.messageType = .forward
        data38.messagesContentData = GXMessagesForwardContent(text: text, user: user3)

        let item38 = GXMessagesItemData(data: data38)
        item38.updateMessagesAvatar(image: UIImage(named: "avatar2"))

        let sectionData7 = GXMessagesSectionData(date: data38.date)
        sectionData7.append(item: item38)
        self.list.append(sectionData7)
        
        var data39 = GXMessagesTestData()
        data39.date = Date().dateByAdding(days: 1)!
        data39.showName = "你算什么男人"
        data39.avatarID = "22"
        data39.messageID = "125"
        data39.gx_continuousBegin = true
        data39.gx_continuousEnd = true
        data39.messageStatus = .receive
        data39.messageType = .system
//        let systemText = "'这样也好'邀请了'抬头45度仰望天空'加入群聊，请注意'抬头45度仰望天空'与群里其他人都不是好友关系。"
        data39.messagesContentData = GXMessagesSystemContent(text: "'这样也好'邀请了'抬头45度仰望天空'加入群聊。")
        
        let item39 = GXMessagesItemData(data: data39)
        
        let sectionData8 = GXMessagesSectionData(date: data39.date)
        sectionData8.append(item: item39)
        self.list.append(sectionData8)
        
        var data40 = GXMessagesTestData()
        data40.date = Date().dateByAdding(days: 1)!
        data40.showName = "你算什么男人"
        data40.avatarID = "22"
        data40.messageID = "126"
        data40.gx_continuousBegin = true
        data40.gx_continuousEnd = true
        data40.messageStatus = .send
        data40.messageType = .bCard

        let cardAvatar = GXMessagesAvatarFactory.messagesAvatar(name: user1.gx_displayName)
        cardAvatar.avatarImage = GXMessagesAvatarFactory.circularAvatarImage(image: UIImage(named: "avatar1"))

        data40.messagesContentData = GXMessagesCardContent(contact: user1, avatar: cardAvatar)

        let item40 = GXMessagesItemData(data: data40)
        item40.updateMessagesAvatar(image: UIImage(named: "avatar2"))

        let sectionData9 = GXMessagesSectionData(date: data40.date)
        sectionData9.append(item: item40)
        self.list.append(sectionData9)
        
        var data41 = GXMessagesTestData()
        data41.date = Date().dateByAdding(days: 1)!
        data41.showName = "你算什么男人"
        data41.avatarID = "22"
        data41.messageID = "127"
        data41.gx_continuousBegin = true
        data41.gx_continuousEnd = true
        data41.messageStatus = .send
        data41.messageType = .file
//        let fileUrl = Bundle.main.path(forResource: "voicexinwen", ofType: "mp3")!
        let bundle = Bundle.gx_messagesAssetBundle
        let fileUrl: String = (bundle?.path(forResource: "file", ofType: "png", inDirectory: "images"))!
        if #available(iOS 16.0, *) {
            data41.messagesContentData = GXMessagesFileContent(fileUrl: URL(filePath: fileUrl))
        } else {
            data41.messagesContentData = GXMessagesFileContent(fileUrl: URL(fileURLWithPath: fileUrl))
        }

        let item41 = GXMessagesItemData(data: data41)
        item41.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        
        let sectionData10 = GXMessagesSectionData(date: data41.date)
        sectionData10.append(item: item41)
        self.list.append(sectionData10)
        
        var data42 = GXMessagesTestData()
        data42.date = Date().dateByAdding(days: 1)!
        data42.showName = "你算什么男人"
        data42.avatarID = "22"
        data42.messageID = "128"
        data42.gx_continuousBegin = true
        data42.gx_continuousEnd = true
        data42.messageStatus = .receive
        data42.messageType = .redPacket

        data42.messagesContentData = GXMessagesRedPacketContent(text: "恭喜发财，大吉大利", status: .none)
        let item42 = GXMessagesItemData(data: data42)
        item42.updateMessagesAvatar(image: UIImage(named: "avatar2"))

        let sectionData11 = GXMessagesSectionData(date: data42.date)
        sectionData11.append(item: item42)
        self.list.append(sectionData11)
        
        var data43 = GXMessagesTestData()
        data43.date = Date().dateByAdding(days: 1)!
        data43.showName = "你算什么男人"
        data43.avatarID = "22"
        data43.messageID = "129"
        data43.gx_continuousBegin = true
        data43.gx_continuousEnd = true
        data43.messageStatus = .receive
        data43.messageType = .reply

        data43.messagesContentData = GXMessagesReplyContent(text: text, users: [user1, user2], replyData: data44)
        let item43 = GXMessagesItemData(data: data43)
        item43.updateMessagesAvatar(image: UIImage(named: "avatar2"))

        let sectionData12 = GXMessagesSectionData(date: data43.date)
        sectionData12.append(item: item43)
        self.list.append(sectionData12)
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, GXMessagesHoverAvatarTableViewDatalist {
    
    func gx_tableView(_ tableView: UITableView, avatarDataForRowAt indexPath: IndexPath) -> GXMessagesAvatarDataProtocol {
        return self.list[indexPath.section].items[indexPath.row].data
    }
    
    func gx_tableView(_ tableView: UITableView, changeForRowAt indexPath: IndexPath, avatar: UIView) {
        if let avatarButton = avatar as? UIButton {
            let item = self.list[indexPath.section].items[indexPath.row]
            if item.data.gx_isShowAvatar {
                avatarButton.removeTarget(nil, action: nil, for: .allEvents)
                avatarButton.setImage(item.avatar?.avatarImage, for: .normal)
                avatarButton.setImage(item.avatar?.avatarHighlightedImage, for: .highlighted)
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
        case .text, .atText, .forward:
            let cell: GXMessagesTextCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item, delegate: self)
            
            return cell
        case .phote, .video:
            let cell: GXMessagesMediaCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item, delegate: self)

            return cell
        case .audio:
            let cell: GXMessagesAudioCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item, delegate: self)

            return cell
        case .location:
            let cell: GXMessagesLocationCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item, delegate: self)

            return cell
        case .voiceCall, .videoCall:
            let cell: GXMessagesCallCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item, delegate: self)

            return cell
        case .system:
            let cell: GXMessagesSystemCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item)

            return cell
        case .bCard:
            let cell: GXMessagesCardCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item, delegate: self)

            return cell
        case .file:
            let cell: GXMessagesFileCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item, delegate: self)

            return cell
        case .redPacket:
            let cell: GXMessagesRedPacketCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item, delegate: self)

            return cell
        case .reply:
            let cell: GXMessagesReplyCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bindCell(item: item, delegate: self)

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.list[indexPath.section].items[indexPath.row]
        
        return item.layout.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return GXCHATC.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: GXMessagesSectionHeader? = tableView.dequeueReusableHeaderFooterView()
        let sectionData = self.list[section]
        header?.bindHeader(data: sectionData)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("cell didSelectRowAt \(indexPath.description)")
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        NSLog("cell willBeginEditingRowAt \(indexPath.description)")
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        NSLog("cell didEndEditingRowAt \(indexPath?.description ?? "")")
    }
    
}

extension ViewController: GXMessagesBaseCellDelegate {
    
    func messagesCell(_ cell: GXChatUIKit.GXMessagesBaseCell, didAvatarTapAt item: GXChatUIKit.GXMessagesItemData?) {
        NSLog("cell didAvatarTapAt \(String(describing: item?.data.gx_messageType))")
    }
    
    func messagesCell(_ cell: GXChatUIKit.GXMessagesBaseCell, didLongPressAt item: GXChatUIKit.GXMessagesItemData?) {
        guard let data = item?.data else { return }
        
        self.animationDelegate.bubbleView = cell.messageBubbleContainerView
        self.animationDelegate.transform = cell.messageBubbleContainerView.transform
        cell.isHighlighted = false
        guard let copyCell = cell.copy() as? GXMessagesBaseCell else { return }

        let rectForTable = cell.convert(cell.messageBubbleContainerView.frame, to: self.tableView)
        let rectForView = self.tableView.convert(rectForTable, to: self.view)
        let preview = copyCell.messageBubbleContainerView
        let vc = GXMessagesCellPreviewController(data: data, preview: preview, originalRect: rectForView)
        vc.actionBlock = { (messageData, type) in
            NSLog("GXMessagesCellPreviewController actionBlock type: \(type)")
        }
        vc.transitioningDelegate = self.animationDelegate
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
        
        NSLog("cell didLongPressAt \(String(describing: item?.data.gx_messageType))")
    }
    
    func messagesCell(_ cell: GXChatUIKit.GXMessagesBaseCell, didContentTapAt item: GXChatUIKit.GXMessagesItemData?) {
        guard let data = item?.data else { return }
        if data.gx_messageType == .audio {
            guard let content = data.gx_messagesContent as? GXMessagesAudioContent else { return }
            guard let audioCell = cell as? GXMessagesAudioCell else { return }
            if let filePath = content.fileURL?.relativePath {
                if FileManager.default.fileExists(atPath: filePath) {
                    audioCell.gx_playAudio(isPlay: !content.isPlaying)
                }
            }
        }
        else if data.gx_messageType == .video {
            
        }
        else if data.gx_messageType == .reply {
            guard let content = data.gx_messagesContent as? GXMessagesReplyContent else { return }
            for section in 0..<self.list.count {
                let sectionData = self.list[section]
                for row in 0..<sectionData.items.count {
                    let rowItem = sectionData.items[row]
                    if rowItem.data.gx_messageId == content.replyData.gx_messageId {
                        self.currentReplyIndexPath = IndexPath(row: row, section: section); break
                    }
                }
            }
            if let currentIndexPath = self.currentReplyIndexPath {
                self.tableView.scrollToRow(at: currentIndexPath, at: .middle, animated: true)
                let cell = self.tableView.cellForRow(at: currentIndexPath) as? GXMessagesBaseCell
                if let letCell = cell {
                    self.currentReplyIndexPath = nil
                    letCell.showAutoHighlighted()
                }
            }
        }
        NSLog("cell didContentTapAt \(String(describing: item?.data.gx_messageType))")
    }
    
    func messagesCell(_ cell: GXChatUIKit.GXMessagesBaseCell, didSwipeAt item: GXChatUIKit.GXMessagesItemData?) {
        NSLog("cell didSwipeAt \(String(describing: item?.data.gx_messageType))")
    }
    
    func messagesCell(_ cell: GXChatUIKit.GXMessagesBaseCell, didTapAt item: GXChatUIKit.GXMessagesItemData?, type: GXChatUIKit.GXRichManager.HighlightType, value: String) {
        NSLog("cell didTapAt \(String(describing: item?.data.gx_messageType)), type: \(type), value: \(value)")
    }
    
}

extension ViewController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableView.gx_scrollBeginDragging()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.tableView.gx_scrollEndDragging()
        
        if let currentIndexPath = self.currentReplyIndexPath {
            self.currentReplyIndexPath = nil
            let cell = self.tableView.cellForRow(at: currentIndexPath) as? GXMessagesBaseCell
            cell?.showAutoHighlighted()
        }
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
