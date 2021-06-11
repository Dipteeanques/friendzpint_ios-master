//
//  ArticleWebViewVC.swift
//  FriendzPoint
//
//  Created by Anques on 27/05/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import WebKit
import ProgressHUD

class ArticleWebViewVC: UIViewController {
    
    var strURl = String()
    var strTitle = String()
    @IBOutlet weak var Webview: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
//    {
//        didSet{
//            let image = UIImage(named: "Backarrow")?.withRenderingMode(.alwaysTemplate)
//            btnBack.setImage(image, for: .normal)
//            btnBack.tintColor = UIColor.white
//        }
//    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        self.lblTitle.text = strTitle
        
        let formattedString1 = strTitle
                                .htmlAttributedString()
                                .with(font:UIFont(name: "SFUIText-Semibold", size: 20)!)
        self.lblTitle.attributedText = formattedString1//data.title
        self.lblTitle.adjustsFontSizeToFitWidth = false
        self.lblTitle.lineBreakMode = .byTruncatingTail
        ProgressHUD.show()
        currentTabBar?.setBar(hidden: true, animated: false)
        displayWebView()
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        //self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    func displayWebView() {
        //self.ViewCustomeUrl.backgroundColor = .clear
        //self.imgUrl.isHidden = false
        if let webView = self.createWebView(withFrame: self.Webview.bounds) {
            webView.layer.cornerRadius = 15.0
            webView.clipsToBounds = true
            Webview.backgroundColor = .clear
           
           
            //           self.WebView.addSubview(imgUrl)
            self.Webview.addSubview(webView)
            //           self.ViewCustomeUrl.addSubview(btnReadMore)
        }
    }
    
    func createWebView(withFrame frame: CGRect) -> WKWebView? {
        let webView = WKWebView(frame: frame)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let resourceUrl = URL(string: strURl) {
            let request = URLRequest(url: resourceUrl)
            webView.load(request)
            //self.imgUrl.isHidden = true
            ProgressHUD.dismiss()
            return webView
        }
       
        return nil
    }
    
}
