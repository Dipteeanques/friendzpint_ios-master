//
//  PrivacySettingController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 31/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class PrivacySettingController: UIViewController {

    @IBOutlet weak var ViewLoader: LoaderView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var message: SWComboxView!
    @IBOutlet weak var yourpost: SWComboxView!
    @IBOutlet weak var timline: SWComboxView!
    @IBOutlet weak var followYou: SWComboxView!
    @IBOutlet weak var post: SWComboxView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var follow_privacy = String()
    var comment_privacy = String()
    var timeline_post_privacy = String()
    var post_privacy = String()
    var message_privacy = String()
    var wc = Webservice.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTabBar?.setBar(hidden: true, animated: false)
        setDeafult()
    }
    
    func setDeafult() {
        getPrivacySetting()
        self.activity.isHidden = true
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.headerView.bounds
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        headerView.layer.addSublayer(gradientLayer)
//        headerView.addSubview(btnBack)
//        headerView.addSubview(lblTitle)
//        if UIScreen.main.bounds.width == 414 {
//            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
//        }
        btnsave.layer.cornerRadius = 5
        btnsave.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // setupCombox()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCombox() {
        followYou.dataSource = self
        followYou.delegate = self
        
        post.dataSource = self
        post.delegate = self
        
        timline.dataSource = self
        timline.delegate = self
        
        yourpost.dataSource = self
        yourpost.delegate = self
        
        message.dataSource = self
        message.delegate = self
    }
    
    func getPrivacySetting(){
        ViewLoader.isHidden = false
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
         wc.callGETSimplewebservice(url: GETUSERPRIVACY, parameters: [:], headers: headers, fromView: self.view, isLoading: false) { (sucess, response: UserPrivacyResponseModel?) in
            if sucess {
                let sucess = response?.success
                if sucess! {
                    let dic = response?.data
                    self.follow_privacy = dic!.follow_privacy
                    if self.follow_privacy == "everyone" {
                        self.followYou.defaultSelectedIndex = 0
                    }
                    else {
                        self.followYou.defaultSelectedIndex = 1
                    }
                    self.comment_privacy = dic!.comment_privacy
                    if self.comment_privacy == "everyone" {
                        self.post.defaultSelectedIndex = 0
                    }
                    else {
                        self.post.defaultSelectedIndex = 1
                    }
                    self.timeline_post_privacy = dic!.timeline_post_privacy
                    if self.timeline_post_privacy == "everyone" {
                        self.timline.defaultSelectedIndex = 0
                    }
                    else if self.timeline_post_privacy == "only_follow" {
                        self.timline.defaultSelectedIndex = 1
                    }
                    else {
                        self.timline.defaultSelectedIndex = 2
                    }
                    self.post_privacy = dic!.post_privacy
                    if self.post_privacy == "everyone" {
                        self.yourpost.defaultSelectedIndex = 0
                    }
                    else {
                        self.yourpost.defaultSelectedIndex = 1
                    }
                    self.message_privacy = dic!.message_privacy
                    if self.message_privacy == "everyone" {
                        self.message.defaultSelectedIndex = 0
                    }
                    else {
                        self.message.defaultSelectedIndex = 1
                    }
                    self.setupCombox()
                    self.ViewLoader.isHidden = true
                }
            }
        }
    }
    
    func updatePrivacy() {
        btnsave.isHidden = true
        self.activity.isHidden = false
        activity.startAnimating()
        let parameters = ["follow_privacy":follow_privacy,
                          "comment_privacy":comment_privacy,
                          "timeline_post_privacy":timeline_post_privacy,
                          "post_privacy":post_privacy,
                          "message_privacy":message_privacy]as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        self.wc.callSimplewebservice(url: SAVEUSERPRIVACY, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: UserPrivacyResponseModel?) in
            if sucess {
                self.getPrivacySetting()
                let strMSG = response?.message
                let uiAlert = UIAlertController(title: "FriendzPoint", message: strMSG, preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.btnsave.isHidden = false
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                    self.dismiss(animated: true, completion: nil)
                }))
            }
        }
    }
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        updatePrivacy()
    }
    
    //MARK: - Btn Action
    @IBAction func btnBackAction(_ sender: UIButton) {
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

//MARK: - Drop Down
extension PrivacySettingController: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        if combox == followYou {
            return ["Everyone","Friends of Friends"]
        }
        else if combox == post {
            return ["Everyone","Friends"]
        }
        else if combox == timline {
            return ["Everyone","Friends","No one"]
        }
        else if combox == yourpost {
            return ["Everyone","Friends"]
        }
        else {
            return ["Everyone","Friends"]
        }
    }
    
    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
        return SWComboxTextSelection()
        
    }
    
    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
}

extension PrivacySettingController : SWComboxViewDelegate {
    //MARK: delegate
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
        print("index - \(index) selected - \(object)")
        
        if withCombox == followYou {
            if index == 0 {
                follow_privacy = "everyone"
            }
            else {
                follow_privacy = "only_follow"
            }
        }
        else if withCombox == post {
            if index == 0 {
                comment_privacy = "everyone"
            }
            else {
                comment_privacy = "only_follow"
            }
        }
        else if withCombox == timline {
            if index == 0 {
                timeline_post_privacy = "everyone"
            }
            else if index == 1 {
                timeline_post_privacy = "only_follow"
            }
            else {
                timeline_post_privacy = "nobody"
            }
        }
        else if withCombox == yourpost {
            if index == 0 {
                post_privacy = "everyone"
            }
            else {
                post_privacy = "only_follow"
            }
        }
        else {
            if index == 0 {
                message_privacy = "everyone"
            }
            else {
                message_privacy = "only_follow"
            }
        }
    }
    
    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
        if isOpen {
            if combox == followYou && post.isOpen && timline.isOpen && yourpost.isOpen && message.isOpen {
                post.onAndOffSelection()
            }
            
            if combox == followYou && post.isOpen && timline.isOpen && yourpost.isOpen && message.isOpen {
                followYou.onAndOffSelection()
            }
            
            if combox == followYou && post.isOpen && timline.isOpen && yourpost.isOpen && message.isOpen {
                timline.onAndOffSelection()
            }
            
            if combox == followYou && post.isOpen && timline.isOpen && yourpost.isOpen && message.isOpen {
                yourpost.onAndOffSelection()
            }
            
            if combox == followYou && post.isOpen && timline.isOpen && yourpost.isOpen && message.isOpen {
                message.onAndOffSelection()
            }
        }
    }
}

