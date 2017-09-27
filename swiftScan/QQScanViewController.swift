//
//  QQScanViewController.swift
//  swiftScan
//
//  Created by xialibing on 15/12/10.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit

class QQScanViewController: LBXScanViewController {
    var topTitle:UILabel?
    var isOpenedFlash:Bool = false
    var isAutoMode:Bool = false
    var bottomItemsView:UIView?
    var btnPhoto:UIButton = UIButton()
    var btnFlash:UIButton = UIButton()
    var btnMode:UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedCodeImage(needCodeImg: true)
        scanStyle?.centerUpOffset += 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawBottomItems()
    }

    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        for result:LBXScanResult in arrayResult
        {
            if let str = result.strScanned {
                print(str)
            }
        }
        let result:LBXScanResult = arrayResult[0]
        let defaults = UserDefaults.standard
        defaults.set(isAutoMode, forKey: "isAutoMode")
        let vc = ScanResultController()
        vc.codeResult = result
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func drawBottomItems()
    {
        if (bottomItemsView != nil) {
            return
        }
        let yMax = self.view.frame.maxY - self.view.frame.minY
        bottomItemsView = UIView(frame:CGRect(x: 0.0, y: yMax-100,width: self.view.frame.size.width, height: 100 ))
        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        self.view .addSubview(bottomItemsView!)
        let size = CGSize(width: 65, height: 87)
        
        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/2, y: bottomItemsView!.frame.height/2)
        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        btnFlash.addTarget(self, action: #selector(QQScanViewController.openOrCloseFlash), for: UIControlEvents.touchUpInside)
        
        self.btnPhoto = UIButton()
        btnPhoto.bounds = btnFlash.bounds
        btnPhoto.center = CGPoint(x: bottomItemsView!.frame.width/4, y: bottomItemsView!.frame.height/2)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_nor"), for: UIControlState.normal)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_down"), for: UIControlState.highlighted)
        btnPhoto.addTarget(self, action: Selector(("openPhotoAlbum")), for: UIControlEvents.touchUpInside)
        
        self.btnMode = UIButton()
        btnMode.bounds = btnFlash.bounds
        btnMode.center = CGPoint(x: bottomItemsView!.frame.width * 3/4, y: bottomItemsView!.frame.height/2)
        btnMode.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"), for: UIControlState.normal)
        btnMode.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_down"), for: UIControlState.highlighted)
        btnMode.addTarget(self, action: #selector(QQScanViewController.myMode), for: UIControlEvents.touchUpInside)
        
        bottomItemsView?.addSubview(btnFlash)
        bottomItemsView?.addSubview(btnPhoto)
        bottomItemsView?.addSubview(btnMode)
        
        self.view .addSubview(bottomItemsView!)
    }
    
    func openOrCloseFlash()
    {
        scanObj?.changeTorch()
        isOpenedFlash = !isOpenedFlash
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControlState.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        }
    }
    
    func myMode()
    {
        isAutoMode = !isAutoMode
        if isAutoMode
        {
            btnMode.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_down"), for:UIControlState.normal)
        }
        else
        {
            btnMode.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"), for:UIControlState.normal)
        }
    }
}
