//
//  ProfileViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 13/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import MXSegmentedPager
import Photos
import DKPhotoGallery
import DKImagePickerController
import Alamofire

class openNewuserGroupController: MXSegmentedPagerController {
    
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var viewOnlySettings: UIView!
    @IBOutlet weak var ViewJoin: UIView!
    @IBOutlet weak var btnjoin: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnJoined: UIButton!
    @IBOutlet weak var viewFriendButton: UIView!
    @IBOutlet weak var coverActivity: UIActivityIndicatorView!
    @IBOutlet weak var viewCoverActivity: UIView!
    @IBOutlet weak var viewActivityProfile: UIView!
    @IBOutlet weak var ProActivity: UIActivityIndicatorView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var viewCoverCamera: UIView!
    @IBOutlet weak var btnProfileCamero: UIButton!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var viewImgRound: UIView!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var viewHeght: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblbadge: BadgeLabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var iconSearch: UIImageView!
    @IBOutlet weak var btnCameraleading: NSLayoutConstraint!
    @IBOutlet weak var btnnotitrailing: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var gridentView: UIView!
    @IBOutlet weak var btncamera: UIButton!{
        didSet{
            let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
            btncamera.setImage(image, for: .normal)
            btncamera.tintColor = UIColor.white
        }
    }
    
    @IBOutlet weak var imgwidth: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    var strUserName = String()
    var strUserType = String()
    var url : URL?
    var ustCover : URL?
    var wc = Webservice.init()
    var strGroup_type = String()
    var groupTimeline_id = Int()
    var menuBool = true
    var group = String()
    var onlyPost = String()
    var onlyInvaite = String()
    var passBackvala = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        setDefault()
    }
    
    func setDefault() {
        NotificationCenter.default.addObserver(self, selector: #selector(openNewuserGroupController.GetCreatedGroup), name: NSNotification.Name(rawValue: "GroupCreat"), object: nil)
        getGroupDetails()
        self.navigationController?.navigationBar.isHidden = true
        segmentedPager.backgroundColor = .white
        
        // Parallax Header
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 180
        segmentedPager.parallaxHeader.minimumHeight = 0
        
        // Segmented Control customization
        segmentedPager.segmentedControl.indicator.linePosition = .bottom
        segmentedPager.segmentedControl.backgroundColor = .white
        //segmentedPager.segmentedControl.
        segmentedPager.segmentedControl.textColor = UIColor(red: 73/255, green: 100/255, blue: 134/255, alpha: 1)
        segmentedPager.segmentedControl.font = UIFont.systemFont(ofSize: 14)
        segmentedPager.segmentedControl.selectedTextColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            // segmentedPager.segmentedControl.animation = .
        segmentedPager.segmentedControl.indicatorColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
        segmentedPager.segmentedControl.indicatorHeight = 1.5
        
        viewImgRound.layer.cornerRadius = 60
        viewImgRound.clipsToBounds = true
        imgProfile.layer.cornerRadius = 55
        imgProfile.clipsToBounds = true
        btnProfileCamero.layer.cornerRadius = 15
        btnProfileCamero.clipsToBounds = true
        viewCamera.layer.cornerRadius = 17.5
        viewCamera.clipsToBounds = true
        viewCoverCamera.layer.cornerRadius = 15
        viewCoverCamera.clipsToBounds = true
        viewActivityProfile.layer.cornerRadius = 60
        viewActivityProfile.clipsToBounds = true
        btnJoined.layer.cornerRadius = 5
        btnJoined.clipsToBounds = true
        btnSettings.layer.cornerRadius = 5
        btnSettings.clipsToBounds = true
        btnjoin.layer.cornerRadius = 5
        btnjoin.clipsToBounds = true
        viewOnlySettings.layer.cornerRadius = 5
        viewOnlySettings.clipsToBounds = true
        ViewJoin.layer.cornerRadius = 5
        ViewJoin.clipsToBounds = true
        
        
//        let gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = self.gridentView.bounds
//
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        gridentView.layer.addSublayer(gradientLayer)
//        gridentView.addSubview(btncamera)
//        gridentView.addSubview(btnNotification)
//        gridentView.addSubview(lineView)
//        gridentView.addSubview(iconSearch)
//        gridentView.addSubview(lblSearch)
//        gridentView.addSubview(btnSearch)
//        gridentView.addSubview(lblbadge)
//
//        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
//            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
//            self.lblbadge.badge(text: String(count))
//        }
        
//        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
//            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
//            if count == 0{
//                currentTabBar!.setBadgeText(nil, atIndex: 3)
//            }
//            else{
//                currentTabBar!.setBadgeText(String(count), atIndex: 3)
//            }
//        }
        imgwidth.constant = UIScreen.main.bounds.width
//        gridentView.backgroundColor = .white
        
        if UIScreen.main.bounds.width == 320 {
            viewHeght.constant = 66
            segmentedPager.parallaxHeader.height = 370
            segmentedPager.parallaxHeader.minimumHeight = 66
//            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: 66)
        }
        else {
            segmentedPager.parallaxHeader.height = 400
            segmentedPager.parallaxHeader.minimumHeight = 90
//            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: gridentView.bounds.size.height)
        }
        
        if passBackvala == "passBackvala" {
            self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        }
        else {
            self.navigationController?.interactivePopGestureRecognizer!.isEnabled = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.BadgeCleare), name: NSNotification.Name(rawValue: "BadgeCleare"), object: nil)
    }
    
    @objc func BadgeCleare(_ notification: NSNotification) {
        self.lblbadge.badge(text: nil)
    }
    
    @objc func GetCreatedGroup(_ notification: NSNotification) {
        getGroupDetails()
    }
    
    func getGroupDetails() {
        let parameters = ["username":strUserName]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: MYGROUPDETAILS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: MygroupDetailsResponseModel?) in
            if sucess {
                let res = response?.data
                let Name = res?.name
                let strAvatar = res?.avatar
                self.url = URL(string: strAvatar!)
                self.imgProfile.sd_setImage(with: self.url, completed: nil)
                let strCover = res?.cover
                self.ustCover = URL(string: strCover!)
                self.imgCover.sd_setImage(with: self.ustCover, completed: nil)
                self.strUserType = res!.type
                self.lblName.text = Name!
                self.lblTitle.text = Name!
                self.groupTimeline_id = res!.timeline_id
                let groupId = res?.id
                self.group = res!.group_request
                loggdenUser.set(groupId, forKey: GROUPID)
                loggdenUser.set(self.strUserName, forKey: GROUPUSERNAME)
                 let object: [String: Any] = ["id": self.groupTimeline_id, "Gusername": self.strUserName,"onlyPost":self.onlyPost,"onlyInvaite":self.onlyInvaite,"group_request": self.group]
                NotificationCenter.default.post(name: Notification.Name("GroupprofileTimeline"),
                                                object: object)
                
                if self.group == "MyGroup"{
                    if self.strUserType == "open" {
                        self.viewFriendButton.isHidden = false
                        self.ViewJoin.isHidden = true
                        self.viewOnlySettings.isHidden = true
                        self.btnMenu.isHidden = true
                        self.viewCamera.isHidden = false
                        self.viewCoverCamera.isHidden = false
                    }
                    else {
                        self.viewFriendButton.isHidden = true
                        self.ViewJoin.isHidden = true
                        self.viewOnlySettings.isHidden = false
                        self.btnMenu.isHidden = true
                        self.viewCamera.isHidden = false
                        self.viewCoverCamera.isHidden = false
                    }
                }
                else if self.group == "join" {
                    if self.strUserType == "open" {
                        self.viewFriendButton.isHidden = true
                        self.ViewJoin.isHidden = false
                        self.ViewJoin.layer.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.2).cgColor
                        self.btnjoin.setTitle("+ Join", for: .normal)
                        self.btnjoin.setTitleColor(.darkGray, for: .normal)
                        self.viewOnlySettings.isHidden = true
                        self.btnMenu.isHidden = false
                        self.viewCamera.isHidden = true
                        self.viewCoverCamera.isHidden = true
                    }
                    else {
                        self.viewFriendButton.isHidden = true
                        self.ViewJoin.isHidden = true
                        self.viewOnlySettings.isHidden = true
                        self.btnMenu.isHidden = false
                        self.viewCamera.isHidden = true
                        self.viewCoverCamera.isHidden = true
                    }
                }
                else {
                    if self.strUserType == "open" {
                        self.viewFriendButton.isHidden = true
                        self.ViewJoin.isHidden = false
                        self.btnjoin.layer.backgroundColor = UIColor(red: 21/255, green: 120/255, blue: 246/255, alpha: 1).cgColor
                        self.btnjoin.setTitle("Joined", for: .normal)
                        self.btnjoin.setTitleColor(.white, for: .normal)
                        self.viewOnlySettings.isHidden = true
                        self.btnMenu.isHidden = false
                        self.viewCamera.isHidden = true
                        self.viewCoverCamera.isHidden = true
                    }
                    else {
                        self.viewFriendButton.isHidden = true
                        self.ViewJoin.isHidden = true
                        self.viewOnlySettings.isHidden = true
                        self.btnMenu.isHidden = false
                        self.viewCamera.isHidden = true
                        self.viewCoverCamera.isHidden = true
                    }
                }
            }
        }
    }
    
    //MARK: - Btn Action
    
    @IBAction func btnJoinOpenGroup(_ sender: UIButton) {
        let parameters = ["timeline_id":self.groupTimeline_id]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        self.wc.callSimplewebservice(url: JOINGROUPREMOVE, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: joinedgroupRemoveReponseModel?) in
            if sucess {
                let joined = response?.joined
                if joined! {
                    self.ViewJoin.isHidden = false
                    self.ViewJoin.layer.backgroundColor = UIColor(red: 21/255, green: 120/255, blue: 246/255, alpha: 1).cgColor
                    self.btnjoin.setTitle("Joined", for: .normal)
                    self.btnjoin.setTitleColor(.white, for: .normal)
                }
                else {
                    self.ViewJoin.isHidden = false
                    self.ViewJoin.layer.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.2).cgColor
                    self.btnjoin.setTitle("+ Join", for: .normal)
                    self.btnjoin.setTitleColor(.darkGray, for: .normal)
                }
            }
        }
    }
    @IBAction func btnSecretSetting(_ sender: UIButton) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController")as! CreateGroupViewController
        obj.username = strUserName
        //self.navigationController?.pushViewController(obj, animated: true)
        obj.strbackcheck = "3"
        obj.modalPresentationStyle = .fullScreen
        self.present(obj, animated: false, completion: nil)
        
        
    }
    @IBAction func btnMenuAction(_ sender: UIButton) {
        if menuBool == true {
            viewReport.isHidden = false
            menuBool = false
        }
        else {
            viewReport.isHidden = true
            menuBool = true
        }
    }
    @IBAction func btnReportAction(_ sender: UIButton) {
        viewReport.isHidden = true
        let parameters = ["timeline_id":self.groupTimeline_id] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept":ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: PAGE_REPORT, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: GroupreportResponsModel?) in
            if sucess {
                let report = response?.reported
                if report! {
                    print("Success")
                }
            }
        }
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController")as! SearchViewController
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    @IBAction func btnProfileCameraAction(_ sender: UIButton) {
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            let asset = assets[0]
            asset.fetchOriginalImage(completeBlock: { (image, info) in
                self.imgProfile.image = image
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let parameters = ["timeline_id":self.groupTimeline_id,
                                  "timeline_type": "group"] as [String : Any]
                
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept":ACCEPT,
                                            "Authorization":BEARERTOKEN]
                
                self.viewActivityProfile.isHidden = true
                self.ProActivity.stopAnimating()
                
                AF.upload(
                    multipartFormData: { multiPart in
                        for (key, value) in parameters {
                            if let temp = value as? String {
                                multiPart.append(temp.data(using: .utf8)!, withName: key)
                            }
                            if let temp = value as? Int {
                                multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                            }
                            if let temp = value as? NSArray {
                                temp.forEach({ element in
                                    let keyObj = key + "[]"
                                    if let string = element as? String {
                                        multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                    } else
                                        if let num = element as? Int {
                                            let value = "\(num)"
                                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                    }
                                })
                            }
                        }
                        let image = self.imgProfile.image!.resizeWithWidth(width: 700)!
                        let imagedata = image.jpegData(compressionQuality: 1)
                        multiPart.append(imagedata!, withName: "change_avatar", fileName: "image.png", mimeType: "image/png")
                },
                    usingThreshold: UInt64.init(),to: CHANGEAVATAR, method: .post , headers: headers)
                    .responseJSON(completionHandler: { (response) in
                        let dic = response.value as! NSDictionary
                        let profile = dic.value(forKey: "data")as! [String]
                        let ProfileImage = profile[0]
                        print(ProfileImage)
                        loggdenUser.set(ProfileImage, forKey: PROFILE)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProfileImage"), object: nil)
                    })
            })
        }
        pickerController.showsCancelButton = true
        pickerController.singleSelect = true
        self.present(pickerController, animated: true) {
            self.viewActivityProfile.isHidden = false
            self.ProActivity.startAnimating()
        }
    }
    
    @IBAction func btnCameraCoverAction(_ sender: UIButton) {
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            let asset = assets[0]
            asset.fetchOriginalImage(completeBlock: { (image, info) in
                self.imgCover.image = image
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let parameters = ["timeline_id":self.groupTimeline_id,
                                  "timeline_type": "group"] as [String : Any]
                
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept":ACCEPT,
                                            "Authorization":BEARERTOKEN]
                
                self.viewCoverActivity.isHidden = true
                self.coverActivity.stopAnimating()
                
                AF.upload(
                    multipartFormData: { multiPart in
                        for (key, value) in parameters {
                            if let temp = value as? String {
                                multiPart.append(temp.data(using: .utf8)!, withName: key)
                            }
                            if let temp = value as? Int {
                                multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                            }
                            if let temp = value as? NSArray {
                                temp.forEach({ element in
                                    let keyObj = key + "[]"
                                    if let string = element as? String {
                                        multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                    } else
                                        if let num = element as? Int {
                                            let value = "\(num)"
                                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                    }
                                })
                            }
                        }
                        let image = self.imgCover.image!.resizeWithWidth(width: 700)!
                        let imagedata = image.jpegData(compressionQuality: 1)
                        multiPart.append(imagedata!, withName: "change_cover", fileName: "image.png", mimeType: "image/png")
                },
                    usingThreshold: UInt64.init(),to: CHANGECOVER, method: .post , headers: headers)
                    .responseJSON(completionHandler: { (response) in
                        print(response)
                    })
            })
        }
        pickerController.showsCancelButton = true
        pickerController.singleSelect = true
        
        self.present(pickerController, animated: true) {
            self.viewCoverActivity.isHidden = false
            self.coverActivity.startAnimating()
        }
    }
    
    @IBAction func btnCameraAction(_ sender: UIButton) {
        if passBackvala == "passBackvala" {
            self.backTwo()
        }
        else {
//            self.navigationController?.popViewController(animated: true)
        }
        
        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btnNotificationAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController")as! NotificationController
        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        self.present(naviget, animated: true, completion: nil)
    }
    
    func backTwo() {
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["Timeline","Members"][index]//,"Admins"
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("progress \(parallaxHeader.progress)")
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelect view: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewAt index: Int) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        if index == 0 {
             let object: [String: Any] = ["id": self.groupTimeline_id, "Gusername": self.strUserName,"onlyPost":self.onlyPost,"onlyInvaite":self.onlyInvaite,"group_request": self.group]
            NotificationCenter.default.post(name: Notification.Name("GroupprofileTimeline"),
                                            object: object)
        }
        else if index == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Members"), object: nil)
        }
//        else if index == 2 {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Admins"), object: nil)
//        }
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
