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

class FriendsProfileViewController: MXSegmentedPagerController {
    
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblFollower: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnFriends: UIButton!
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
    @IBOutlet weak var btncamera: UIButton!
    @IBOutlet weak var btnaddfriends: UIButton!
    
    var url : URL?
    var ustCover : URL?
    var strUserType = String()
    var strUserName = String()
    var wc = Webservice.init()
    var send_request = String()
    var message_priva = String()
    var timeVala_id = Int()
    var passBackvala = String()
    var user_id = Int()
    var strAvatar = String()
    var menuBool = true
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setDefault()
    }
    
    func setDefault() {
        getProfileDetails()
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
        btnFriends.layer.cornerRadius = 5
        btnFriends.clipsToBounds = true
        btnMessage.layer.cornerRadius = 5
        btnMessage.clipsToBounds = true
        btnaddfriends.layer.cornerRadius = 5
        btnaddfriends.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gridentView.bounds
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gridentView.layer.addSublayer(gradientLayer)
        gridentView.addSubview(btncamera)
        gridentView.addSubview(btnNotification)
        gridentView.addSubview(lineView)
        gridentView.addSubview(iconSearch)
        gridentView.addSubview(lblSearch)
        gridentView.addSubview(btnSearch)
        gridentView.addSubview(lblbadge)
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
            self.lblbadge.badge(text: String(count))
        }
        
        if UIScreen.main.bounds.width == 320 {
            viewHeght.constant = 66
            segmentedPager.parallaxHeader.height = 410
            segmentedPager.parallaxHeader.minimumHeight = 66
            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: 66)
        }
        else {
            segmentedPager.parallaxHeader.height = 440
            segmentedPager.parallaxHeader.minimumHeight = 90
            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: gridentView.bounds.size.height)
        }
        
        if passBackvala == "passBackvala" {
            self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        }
        else {
            self.navigationController?.interactivePopGestureRecognizer!.isEnabled = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.BadgeCleare), name: NSNotification.Name(rawValue: "BadgeCleare"), object: nil)
        
        btnMenu.layer.cornerRadius = 20
        btnMenu.clipsToBounds = true
    }
    
    @objc func BadgeCleare(_ notification: NSNotification) {
        self.lblbadge.badge(text: nil)
    }

    func getProfileDetails() {
        viewFriendButton.isHidden = false
        let parameters = ["username":strUserName]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: MYPROFILEDETAILS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: MyprofileResponsModel?) in
            if sucess {
                let dic = response?.data
                self.lblName.text = dic?.name
                self.user_id = dic!.id
                print(self.user_id)
                self.lblFollower.text = String(dic!.followers)
                self.lblFollowing.text = String(dic!.following)
                self.strAvatar = dic!.avatar
                self.url = URL(string: self.strAvatar)
                self.imgProfile.sd_setImage(with: self.url, completed: nil)
                let strCover = dic?.cover
                self.ustCover = URL(string: strCover!)
                self.imgCover.sd_setImage(with: self.ustCover, completed: nil)
                self.strUserType = dic!.type
                self.timeVala_id = dic!.id
                loggdenUser.set(self.strUserName, forKey: FRIENDSUSERNAME)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FriendsView"), object: self.strUserName)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FriendsprofileTimeline"), object: self.strUserName)
                self.send_request = dic!.sendRequested
                self.message_priva = dic!.messagePrivacy
                if self.send_request == "approved" {
                    self.btnFriends.setTitle("Friends", for: UIControl.State.normal)
//                    if self.message_priva == "everyone" {
//                        self.btnMessage.isHidden = false
//                    }
                    self.btnFriends.isHidden = false
                    self.btnMessage.isHidden = false
                    self.btnaddfriends.isHidden = true
//                    else if self.message_priva == "only_follow" {
//                        self.btnMessage.isHidden = false
//                    }
//                    else {
//                        self.btnMessage.isHidden = true
//                    }
                }
                else if self.send_request == "addfriend" {
                    self.btnFriends.setTitle("Add Friends", for: UIControl.State.normal)
//                    if self.message_priva == "everyone" {
//                        self.btnMessage.isHidden = false
//                    }
                    self.btnFriends.isHidden = true
                    self.btnMessage.isHidden = true
                    self.btnaddfriends.isHidden = false
//                    else if self.message_priva == "only_follow" {
//                        self.btnMessage.isHidden = false
//                    }
//                    else {
//                        self.btnMessage.isHidden = true
//                    }
                }
                else {
                    self.btnFriends.setTitle("Requested", for: UIControl.State.normal)
//                    if self.message_priva == "everyone" {
//                        self.btnMessage.isHidden = false
//                    }
                    self.btnFriends.isHidden = true
                    self.btnMessage.isHidden = true
                    self.btnaddfriends.isHidden = false
//                    else if self.message_priva == "only_follow" {
//                        self.btnMessage.isHidden = false
//                    }
//                    else {
//                        self.btnMessage.isHidden = true
//                    }
                }
            }
        }
    }
    
    func AddFriends() {
        let parameters = ["timeline_id" : timeVala_id]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: USERFOLLOWREQUEST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendsRequestSentResponsModel?) in
            if sucess {
                let suc = response?.success
                if suc! {
                    let data = response?.data
                    let follow = data?.followrequest
                    if follow! {
                        self.btnFriends.setTitle("Requested", for: .normal)
                    }
                    else {
                        self.btnFriends.setTitle("Add Friends", for: .normal)
                    }
                }
            }
        }
    }
    
    func RemoveFriends() {
        let parameters = ["timeline_id" : timeVala_id]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: REMOVEFRIENDS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: RemoveFriendsResponseModel?) in
            if sucess {
                let status = response?.status
                if status == "200" {
                    self.btnFriends.setTitle("Add Friends", for: .normal)
                }
            }
        }
    }
    
    func getThread() {
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        let url = PRIVATE_CONVERSATION + "/" + String(self.strUserName)
        
        AF.request(url, method: .post, parameters: [:], encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
               print(response)
                let dic = response.value as! NSDictionary
                let dataDic = dic.value(forKey: "data")as! NSDictionary
                let id = dataDic.value(forKey: "id")as! Int
                let user_id = dataDic.value(forKey: "user_id")as! Int
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChatConversionController")as! ChatConversionController
                obj.Id = id
                obj.user_id = user_id
                obj.receiverUsername = self.lblName.text!
                obj.avatar = self.strAvatar
                let naviget: UINavigationController = UINavigationController(rootViewController: obj)
                self.present(naviget, animated: true, completion: nil)

        }
    }
    
    //MARK: - Btn Action
    
    @IBAction func btnFollowingAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyfriendsController")as! MyfriendsController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnFollowersAction(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController")as! FollowersViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnMessageAction(_ sender: UIButton) {
       getThread()
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
                let timelin_id = loggdenUser.value(forKey: TimeLine_id)as! Int
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let parameters = ["timeline_id":timelin_id,
                                  "timeline_type": self.strUserType] as [String : Any]
                
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
                        print(response)
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
                self.viewCoverActivity.isHidden = true
                self.coverActivity.stopAnimating()
            })
        }
        pickerController.showsCancelButton = true
        pickerController.singleSelect = true
        
        self.present(pickerController, animated: true) {
            self.viewCoverActivity.isHidden = false
            self.coverActivity.startAnimating()
        }
    }
    @IBAction func btnNewAddfriendsAction(_ sender: UIButton) {
        if self.send_request == "approved" {
            RemoveFriends()
        }
        else if self.send_request == "addfriend" {
            AddFriends()
        }
        else {
        }
    }
    
    @IBAction func btnFriendAction(_ sender: UIButton) {
        if self.send_request == "approved" {
            RemoveFriends()
        }
        else if self.send_request == "addfriend" {
            AddFriends()
        }
        else {
        }
    }
    
    @IBAction func btnCameraAction(_ sender: UIButton) {
        if passBackvala == "passBackvala" {
            self.backTwo()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func btnNotificationAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController")as! NotificationController
        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        self.present(naviget, animated: true, completion: nil)
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    //MARK: - Btn Action
    
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
        
        let uiAlert = UIAlertController(title: "FriendzPoint", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)
        self.present(uiAlert, animated: true, completion: nil)
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            let loadingAlertController: UIAlertController = UIAlertController(title: "Loading", message: nil, preferredStyle: .alert)
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            loadingAlertController.view.addSubview(activityIndicator)
            
            let xConstraint: NSLayoutConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: loadingAlertController.view, attribute: .centerX, multiplier: 1, constant: 0)
            let yConstraint: NSLayoutConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: loadingAlertController.view, attribute: .centerY, multiplier: 1.4, constant: 0)
            
            NSLayoutConstraint.activate([ xConstraint, yConstraint])
            activityIndicator.isUserInteractionEnabled = false
            activityIndicator.startAnimating()
            
            let height: NSLayoutConstraint = NSLayoutConstraint(item: loadingAlertController.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 80)
            loadingAlertController.view.addConstraint(height);
            
            self.present(loadingAlertController, animated: true, completion: nil)
            self.viewReport.isHidden = true
            let parameters = ["timeline_id":self.timeVala_id] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept":ACCEPT,
                                        "Authorization":BEARERTOKEN]
            self.wc.callSimplewebservice(url: PAGE_REPORT, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: GroupreportResponsModel?) in
                if sucess {
                    let report = response?.reported
                    if report == true {
                        self.appDel.gotoDashboardController()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserBlock"), object: nil)
                    }
                }
            }
        }))
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["Bio data", "Timeline", "Liked pages","Joined groups","Gallery","Friendz"][index]//
        
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewAt index: Int) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        if index == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Biodata"), object: nil)
        }
        else if index == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FriendsprofileTimeline"), object: self.strUserName)
        }
        else if index == 2 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Likedpages"), object: nil)
        }
        else if index == 3 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Joinedgroups"), object: nil)
        }
        else if index == 4 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Photos"), object: nil)
        }
        else if index == 5 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Friends"), object: nil)
        }
//        else if index == 6 {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Guestevents"), object: nil)
//        }
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("progress \(parallaxHeader.progress)")
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelect view: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
       
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
