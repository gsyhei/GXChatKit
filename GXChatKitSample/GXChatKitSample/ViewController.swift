//
//  ViewController.swift
//  GXChatKitSample
//
//  Created by Gin on 2022/12/24.
//

import UIKit
import GXChatUIKit

class ViewController: UIViewController {
    
    private var rowCount = 20
    
    private lazy var tableView: GXMessageTableView = {
        let tv = GXMessageTableView(frame: self.view.bounds, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .white
        tv.rowHeight = 100.0
        
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.tableView.addMessagesHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 2.0) {
                self?.rowCount += 10
                self?.tableView.endHeaderLoading()
            }
        }
    }

}

extension  ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellID = "CellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = "asdkjaksldaskldjkl, asjdkhkajshdkjas hdkajsdhajksdhakjsdhaksjdh"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

