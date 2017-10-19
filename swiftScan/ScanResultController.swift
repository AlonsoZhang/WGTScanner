//
//  ScanResultController.swift
//  swiftScan
//
//  Created by xialibing on 15/12/11.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit


class ScanResultController: UIViewController {

    @IBOutlet weak var codeImg: UIImageView!
    @IBOutlet weak var codeTypeLabel: UILabel!
    @IBOutlet weak var codeStringLabel: UILabel!
    @IBOutlet weak var concreteCodeImg: UIImageView!
    @IBOutlet weak var sendbtn: UIButton!
    
    var codeResult:LBXScanResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        codeTypeLabel.text = ""
        codeStringLabel.text = ""
        sendbtn.layer.cornerRadius = 5
        sendbtn.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        sendbtn.layer.borderWidth = 5
        
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: "isAutoMode")){
            SendMsg(sendbtn)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        codeImg.image = codeResult?.imgScanned
        codeTypeLabel.text = (codeResult?.strBarCodeType)!
        codeStringLabel.text = (codeResult?.strScanned)!
        if codeImg.image != nil
        {
            var rect = LBXScanWrapper.getConcreteCodeRectFromImage(srcCodeImage: codeImg.image!, codeResult: codeResult!)
            if !rect.isEmpty
            {
                zoomRect(rect: &rect, srcImg: codeImg.image!)
                let img2 = LBXScanWrapper.getConcreteCodeImage(srcCodeImage: codeImg.image!, rect: rect)
                if (img2 != nil)
                {
                    concreteCodeImg.image = img2
                    concreteCodeImg.layer.borderWidth = 8
                    concreteCodeImg.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            }
        }
    }
    
    func zoomRect( rect:inout CGRect,srcImg:UIImage)
    {
        rect.origin.x -= 10
        rect.origin.y -= 10
        rect.size.width += 20
        rect.size.height += 20
        if rect.origin.x < 0
        {
            rect.origin.x = 0
        }
        if (rect.origin.y < 0)
        {
            rect.origin.y = 0
        }
        if (rect.origin.x + rect.size.width) > srcImg.size.width
        {
            rect.size.width = srcImg.size.width - rect.origin.x - 1
        }
        if (rect.origin.y + rect.size.height) > srcImg.size.height
        {
            rect.size.height = srcImg.size.height - rect.origin.y - 1
        }
    }
    
    @IBAction func SendMsg(_ sender: UIButton) {
        sendbtn.isEnabled = false
        DispatchQueue.global().async {
            self.synchronousPost()
        }
        //self.navigationController?.popViewController(animated: true)
    }
    
    func synchronousPost() {
        let file = Bundle.main.path(forResource:"Config", ofType: "plist")!
        let ConfigPlist = NSDictionary(contentsOfFile: file)! as! [String : Any]
        let urlStr = ConfigPlist["URL"] as! String
        let url:URL! = URL(string:urlStr)
        print(url)
        var urlRequest:URLRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 3)
        urlRequest.httpMethod = "POST"
        let defaultStand = UserDefaults.standard
        let str:String = String(format: "SN=%@&Name=%@",(codeResult?.strScanned)!,defaultStand.string(forKey: "name")!)
        print(str)
        //let str = "sn=\(String(describing: codeStringLabel.text))&name=\(String(describing: defaultStand.string(forKey: "name")))"
        let data:Data = str.data(using: .utf8, allowLossyConversion: true)!
        urlRequest.httpBody = data
        var response:URLResponse?
        do {
            let received =  try NSURLConnection.sendSynchronousRequest(urlRequest, returning: &response)
            //let dic = try JSONSerialization.jsonObject(with: received, options: JSONSerialization.ReadingOptions.allowFragments)
            //print(dic)
            if let jsonStr = String(data: received, encoding:String.Encoding.utf8){
                print(jsonStr)
                if (jsonStr.contains("Pass")){
                    DispatchQueue.main.async {
                        self.noticeTop("Pass", autoClear: true, autoClearTime: 2)
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    DispatchQueue.main.async {
                        self.noticeError("Add Fail", autoClear: true, autoClearTime: 2)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.sendbtn.isEnabled = true
                    self.noticeError("Data error", autoClear: true, autoClearTime: 3)
                }
            }
        } catch let error{
            DispatchQueue.main.async {
                self.sendbtn.isEnabled = true
                self.noticeError(error.localizedDescription, autoClear: true, autoClearTime: 3)
            }
        }
    }
    
    func showMsg(title:String?,message:String?)
    {
        let alertController = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (alertAction) in
            //self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
