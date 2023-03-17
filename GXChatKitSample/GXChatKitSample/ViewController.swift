//

import UIKit
import Reusable
import GXMessagesTableView
import GXChatUIKit

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
        
//        self.view.addSubview(self.tableView)
//        self.tableView.backgroundImage = UIImage(named: "background")
//        self.tableView.register(cellType: GXMessagesTextCell.self)
//        self.tableView.register(cellType: GXMessagesMediaCell.self)
//        self.tableView.register(headerFooterViewType: GXMessagesSectionHeader.self)
//        self.tableView.sectionHeaderHeight = 30.0
//        //        self.tableView.addMessagesHeader {[weak self] in
//        //            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 2.0) {
//        //                self?.updateDatas()
//        //                self?.tableView.endHeaderLoading()
//        //            }
//        //        }
//
//        self.updateDatas()
//        self.tableView.reloadData()
        
        if let urlString = Bundle.main.path(forResource: "redpacket_sound_open", ofType: "wav") {
            let url = URL(fileURLWithPath: urlString)
            GXAudioManager.gx_cutAudioTrackList(size: CGSize(width: 20, height: 48), url: url) { trackList in
                let count = GXMessagesAudioTrackView.GetTrackMaxCount(maxWidth: 300, time: 4)
                let width = GXMessagesAudioTrackView.GetTrackViewWidth(count: count)
                
                let rect = CGRect(x: 10, y: 100, width: width, height: 50)
                let trackView = GXMessagesAudioTrackView(frame: rect, trackList: trackList)
                self.view.addSubview(trackView)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    trackView.gx_animation(time: 3.0)
                })
            }
        }
        
    }
    
    public func updateDatas() {
        var data1 = GXTestTextData()
        data1.text = "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。"
        data1.messageContinuousStatus = .begin
        data1.messageStatus = .receiving
        data1.avatarID = "111111111111"
        data1.date = Date().dateByAdding(days: -2)!
        let item1 = GXMessagesItemData(data: data1)
        item1.updateMessagesAvatar(image: UIImage(named: "avatar1"))
        
        let sectionData = GXMessagesSectionData(date: data1.date)
        sectionData.append(item: item1)
        
        var data2 = GXTestTextData()
        data2.text = "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。"
        data2.messageContinuousStatus = .ongoing
        data2.messageStatus = .receiving
        data2.avatarID = "111111111111"
        data2.date = Date().dateByAdding(days: -2)!
        let item2 = GXMessagesItemData(data: data2)
        item2.updateMessagesAvatar(image: UIImage(named: "avatar1"))
        sectionData.append(item: item2)
        
        var data3 = GXTestPhotoData()
        data3.messageContinuousStatus = .end
        data3.messageStatus = .receiving
        data3.avatarID = "111111111111"
        data3.date = Date().dateByAdding(days: -2)!
        let item3 = GXMessagesItemData(data: data3)
        item3.updateMessagesAvatar(image: UIImage(named: "avatar1"))
        sectionData.append(item: item3)
        
        self.list.append(sectionData)
        
        
        var data11 = GXTestTextData()
        data11.text = "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。"
        data11.messageContinuousStatus = .begin
        data11.messageStatus = .receiving
        data11.avatarID = "2222222222"
        data11.date = Date().dateByAdding(days: -1)!
        let item11 = GXMessagesItemData(data: data11)
        item11.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        
        let sectionData1 = GXMessagesSectionData(date: data11.date)
        sectionData1.append(item: item11)
        
        var data22 = GXTestTextData()
        data22.text = "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。"
        data22.messageContinuousStatus = .ongoing
        data22.messageStatus = .receiving
        data22.avatarID = "2222222222"
        data22.date = Date().dateByAdding(days: -1)!
        let item22 = GXMessagesItemData(data: data22)
        item22.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        sectionData1.append(item: item22)
        
        var data33 = GXTestPhotoData()
        data33.messageContinuousStatus = .end
        data33.messageStatus = .receiving
        data33.avatarID = "2222222222"
        data33.date = Date().dateByAdding(days: -1)!
        let item33 = GXMessagesItemData(data: data33)
        item33.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        sectionData1.append(item: item33)
        
        self.list.append(sectionData1)
        
        
        var data13 = GXTestTextData()
        data13.text = "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。"
        data13.messageContinuousStatus = .begin
        data13.messageStatus = .receiving
        data13.avatarID = "2222222222"
        data13.date = Date()
        let item13 = GXMessagesItemData(data: data13)
        item13.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        
        let sectionData2 = GXMessagesSectionData(date: data13.date)
        sectionData2.append(item: item13)
        
        var data23 = GXTestTextData()
        data23.text = "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。"
        data23.messageContinuousStatus = .ongoing
        data23.messageStatus = .receiving
        data23.avatarID = "2222222222"
        data23.date = Date()
        let item23 = GXMessagesItemData(data: data23)
        item23.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        sectionData2.append(item: item23)
        
        var data34 = GXTestVideoData()
        data34.messageContinuousStatus = .end
        data34.messageStatus = .receiving
        data34.avatarID = "2222222222"
        data34.date = Date()
        let item34 = GXMessagesItemData(data: data34)
        item34.updateMessagesAvatar(image: UIImage(named: "avatar2"))
        sectionData2.append(item: item34)
        
        var data24 = GXTestTextData()
        data24.text = "啊撒大声地黄金卡山东科技哈萨打卡机阿克苏记得哈手机打开,啊时间跨度黄金卡手动滑稽卡卡手打合计。"
        data24.messageContinuousStatus = .beginAndEnd
        data24.messageStatus = .receiving
        data24.avatarID = "3333333333"
        data24.date = Date()
        let item24 = GXMessagesItemData(data: data24)
        item24.updateMessagesAvatar(image: UIImage(named: "avatar3"))
        sectionData2.append(item: item24)
        
        self.list.append(sectionData2)
        
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
