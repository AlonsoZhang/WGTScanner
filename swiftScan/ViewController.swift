//
//  ViewController.swift
//  swiftScan
//
//  Created by xialibing on 15/11/25.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = QQScanViewController()
        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        vc.scanStyle = style
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
