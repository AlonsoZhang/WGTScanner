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
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        btn.layer.borderWidth = 5
    }
    
    @IBAction func startScan(_ sender: UIButton) {
        if textfield.text != "" {
            let defaults = UserDefaults.standard
            defaults.set(textfield.text, forKey: "name")
            let vc = QQScanViewController()
            var style = LBXScanViewStyle()
            style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
            vc.scanStyle = style
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.noticeError("请输入姓名", autoClear: true, autoClearTime: 1)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textfield.resignFirstResponder()
    }
}
