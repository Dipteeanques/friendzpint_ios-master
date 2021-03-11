//
//  BrowserCallViewcontroller.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 20/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import WebKit

class BrowserCallViewcontroller: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var web: WKWebView!
    var strPassLink = String()
    var privacy = String()
    var terms = String()
    var strtitle = String()
    
    @IBOutlet weak var lblTitle: UILabel!
    // var webView = WKWebView()
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = strtitle
        currentTabBar?.setBar(hidden: true, animated: false)
        loaderView.isHidden = false
        activity.startAnimating()
//
//        guard let url = URL(string: strPassLink) else { return }
//        webView.frame = view.bounds
//        webView.navigationDelegate = self
//        webView.load(URLRequest(url: url))
//        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        view.addSubview(webView)
//        webView = WKWebView()
 //       web.navigationDelegate = self
//        view = webView
        
        setDefault()
    }
    
    func setDefault() {
//        let gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = self.headerView.bounds
//
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        headerView.layer.addSublayer(gradientLayer)
//        headerView.addSubview(btnBack)
//
//       if UIScreen.main.bounds.width == 414 {
//            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
//        }
        
        if privacy == "privacy" {
            web.navigationDelegate = self
            let url = URL(string: Privacy)!
            web.load(URLRequest(url: url))
            web.allowsBackForwardNavigationGestures = true
        }
        else if terms == "terms" {
            web.navigationDelegate = self
            let url = URL(string: TermsOfservice)!
            web.load(URLRequest(url: url))
            web.allowsBackForwardNavigationGestures = true
        }
        else {
            web.navigationDelegate = self
            let url = URL(string: helpSuport)!
            web.load(URLRequest(url: url))
            web.allowsBackForwardNavigationGestures = true
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish loading video")
        loaderView.isHidden = true
        activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host, !host.hasPrefix("www.google.com"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
