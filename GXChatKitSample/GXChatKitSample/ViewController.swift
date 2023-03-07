//

import UIKit
import Reusable
import GXChatUIKit

class ViewController: UIViewController {
    
    private var rowCount = 20
    
    private lazy var tableView: GXMessagesTableView = {
        let tv = GXMessagesTableView(frame: self.view.bounds, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.datalist = self
        tv.backgroundColor = .white
        tv.rowHeight = 100.0
        
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.tableView)
        self.tableView.register(cellType: GXMessagesTableViewCell.self)
        
        self.tableView.addMessagesHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 2.0) {
                self?.rowCount += 10
                self?.tableView.endHeaderLoading()
            }
        }
        
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now()) {
//            self.tableView.gx_changeContentOffset(self.tableView.contentOffset)
        }
    }

}

extension  ViewController: UITableViewDataSource, UITableViewDelegate, GXMessagesTableViewDatalist {
    
    func gx_tableView(_ tableView: UITableView, avatarIdForRowAt indexPath: IndexPath) -> String {
        let index = indexPath.row / 4
        return "index\(index)"
    }
    
    func gx_tableView(_ tableView: UITableView, changeForRowAt indexPath: IndexPath, avatar: UIButton) {
        let index = indexPath.row / 4
        avatar.setTitle("头\(index)", for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GXMessagesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let index = indexPath.row / 4
        let text = "index\(index)"
        cell.textLabel?.text = "section: \(indexPath.section), row: \(indexPath.row), id: \(text)"
        cell.avatar.setTitle("头\(index)", for: .normal)
        
        let cuindex = indexPath.row % 4
        if cuindex == 0 {
            cell.messageContinuousStatus = .begin
        }
        else if cuindex == 3 {
            cell.messageContinuousStatus = .end
        }
        else {
            cell.messageContinuousStatus = .ongoing
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
