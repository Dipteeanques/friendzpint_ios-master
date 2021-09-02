//
//  MenuViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 13/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import DKPhotoGallery
import DKImagePickerController
import SJSegmentedScrollView

class MenuViewController: UIViewController {
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblMenu: UITableView!
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
    @IBOutlet weak var img_logo: UIImageView!
    
    //MARK: - Variable
    var arrMenulist = [["img":#imageLiteral(resourceName: "MoreShape"),"name":"Liked pages"],["img":#imageLiteral(resourceName: "groupred"),"name":"Joined groups"],["img":#imageLiteral(resourceName: "groupred"),"name":"Joined pages"],["img":#imageLiteral(resourceName: "MoreGreenfeed"),"name":"My pages"],["img":#imageLiteral(resourceName: "groupBlue"),"name":"My groups"],["img":#imageLiteral(resourceName: "FriendPurpal"),"name":"Followers"],["img":#imageLiteral(resourceName: "FriendPurpal"),"name":"Following"],["img":#imageLiteral(resourceName: "Browse"),"name":"Browse"],["img":#imageLiteral(resourceName: "Event"),"name":"Event"],["img":#imageLiteral(resourceName: "changepwd"),"name":"Change Password"],["img":#imageLiteral(resourceName: "MoreSetting"),"name":"Settings"],["img":#imageLiteral(resourceName: "policy"),"name":"Privacy Policy"],["img":#imageLiteral(resourceName: "terms"),"name":"Terms and condition"],["img":#imageLiteral(resourceName: "RoundShap"),"name":"Help & Support"],["img":#imageLiteral(resourceName: "BusinessProfile"),"name":"Business Profile"],["img":#imageLiteral(resourceName: "wallet"),"name":"Tellzme Wallet"],["img":#imageLiteral(resourceName: "Logout"),"name":"Logout"]]//["img":#imageLiteral(resourceName: "BusinessProfile"),"name":"Business Profile"],["img":#imageLiteral(resourceName: "wallet"),"name":"Tellzme Wallet"],["img":#imageLiteral(resourceName: "cart"),"name":"Ad Manager"],
    
    //,["img":#imageLiteral(resourceName: "wallet"),"name":"Tellzme Wallet"],
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var strCurruntPwd = String()
    var strNewPwd = String()
    var wc = Webservice.init()
    var url: URL?
    var assets: [DKAsset]?
    
    //MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseReels"), object: nil)
        setDefault()
//        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.ProfileImageChange), name: NSNotification.Name(rawValue: "ProfileImage"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.Menu), name: NSNotification.Name(rawValue: "Menu"), object: nil)
    }
    
    @objc func ProfileImageChange(_ notification: NSNotification) {
        let profile = loggdenUser.value(forKey: PROFILE)as! String
        url = URL(string: profile)
        imgProfile.sd_setImage(with: url, completed: nil)
    }
    
    @objc func Menu(_ notification: NSNotification) {
        let profile = loggdenUser.value(forKey: PROFILE)as! String
        url = URL(string: profile)
        imgProfile.sd_setImage(with: url, completed: nil)
    }
    
    
    func setDefault() {
        lblName.text = loggdenUser.value(forKey: NAMELOgin)as? String
        let profile = loggdenUser.value(forKey: PROFILE)as! String
        url = URL(string: profile)
        imgProfile.sd_setImage(with: url, completed: nil)
        imgProfile.layer.cornerRadius = 25
        imgProfile.clipsToBounds = true
        btnEdit.layer.cornerRadius = 5
        btnEdit.clipsToBounds = true
        
        self.navigationController?.navigationBar.isHidden = true
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
        gridentView.addSubview(img_logo)
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
            self.lblbadge.badge(text: String(count))
        }
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
//            if count == 0{
//                currentTabBar!.setBadgeText(nil, atIndex: 3)
//            }
//            else{
//                currentTabBar!.setBadgeText(String(count), atIndex: 3)
//            }
        }
        
        if UIScreen.main.bounds.width == 320 {
            
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: gridentView.bounds.size.height)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.BadgeCleare), name: NSNotification.Name(rawValue: "BadgeCleare"), object: nil)
    }
    
    @objc func BadgeCleare(_ notification: NSNotification) {
        self.lblbadge.badge(text: nil)
    }
    
    //MARK: - Action Method

    @IBAction func btnEditAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "GeneralSettingsViewController")as! GeneralSettingsViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    //MARK: - Btn Action
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseAllButton"), object: nil)
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController")as! SearchViewController
        self.navigationController?.pushViewController(obj, animated: false)
        
    }
    
    @IBAction func btnCameraAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseAllButton"), object: nil)
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            self.updateAssets(assets: assets)
        }
        pickerController.showsCancelButton = true
        pickerController.allowMultipleTypes = false
        pickerController.maxSelectableCount = 10
        self.present(pickerController, animated: true) {}
    }
    
    func updateAssets(assets: [DKAsset]) {
        print(assets)
        self.assets = assets
        if assets.count == 0 {
            print("null")
        }
        else if assets.count == 1 {
            let obj = storyboard?.instantiateViewController(withIdentifier: "PostViewController")as! PostViewController
            obj.assets = assets
            obj.postSelected = "postSelected"
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
            self.present(naviget, animated: true, completion: nil)
        } else {
            let obj = storyboard?.instantiateViewController(withIdentifier: "PostViewController")as! PostViewController
            obj.assets = assets
            obj.postSelected = "postSelected"
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
            self.present(naviget, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnNotificationAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseAllButton"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController")as! NotificationController
        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        self.present(naviget, animated: true, completion: nil)
    }
    @IBAction func btnProfileViewAction(_ sender: UIButton) {
         currentTabBar?.setIndex(4)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
//            self.navigationController?.pushViewController(obj, animated: true)
        obj.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(obj, animated: true)
        self.present(obj, animated: false, completion: nil)
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

//MARK: - Tableview Method

extension MenuViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenulist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMenu.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(101)as! UIImageView
        let lblName = cell.viewWithTag(102)as! UILabel
        img.image = (self.arrMenulist[indexPath.row]as AnyObject).value(forKey: "img") as? UIImage
        lblName.text = (self.arrMenulist[indexPath.row]as AnyObject).value(forKey: "name") as? String
        if (self.arrMenulist[indexPath.row]as AnyObject).value(forKey: "name") as? String == "Business Profile"{
            img.image = img.image?.withRenderingMode(.alwaysTemplate)
            img.tintColor = UIColor.blue
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikedPageviewController")as! LikedPageviewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 1 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "JoinedMeGroupViewController")as! JoinedMeGroupViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 2 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PagejoinedlistController")as! PagejoinedlistController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 3 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MypagesViewController")as! MypagesViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 4 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MygroupsViewControllerList")as! MygroupsViewControllerList
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 5 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController")as! FollowersViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 6 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyfriendsController")as! MyfriendsController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 7 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowseallpostController")as! BrowseallpostController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 8 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "EventlistControllerview")as! EventlistControllerview
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 9 {
            let alertController = UIAlertController(title: "FriendzPoint", message: "Change Password", preferredStyle: .alert)
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter current password"
                textField.isSecureTextEntry = true
                let firstTextField = alertController.textFields![0] as UITextField
                let heightConstraint = NSLayoutConstraint(item: firstTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
                firstTextField.addConstraint(heightConstraint)
            }
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter new password"
                textField.isSecureTextEntry = true
                let secondTextField = alertController.textFields![1] as UITextField
                let heightConstraint = NSLayoutConstraint(item: secondTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
                secondTextField.addConstraint(heightConstraint)
                let margins = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
                secondTextField.layoutMargins = margins
            }
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter confirm password"
                textField.isSecureTextEntry = true
                let ThirdTextField = alertController.textFields![2] as UITextField
                let heightConstraint = NSLayoutConstraint(item: ThirdTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
                ThirdTextField.addConstraint(heightConstraint)
                let margins = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
                ThirdTextField.layoutMargins = margins
            }
            
            
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let currunt = alertController.textFields![0]
                let new = alertController.textFields![1]
                let confirm = alertController.textFields![2]
                
                if currunt.text!.isEmpty || new.text!.isEmpty {
                    let uiAlert = UIAlertController(title: "FriendzPoint", message: "Please enter all textFields", preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                }
                else {
                    if new == confirm {
                        let parameters = ["current_password":currunt.text!,
                                          "new_password" : new.text!] as [String : Any]
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization": BEARERTOKEN]
                        
                        self.wc.callSimplewebservice(url: CHANGE_PASSWORD, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: PasswordChangeResponseModel?) in
                            if sucess {
                                let suc = response?.success
                                let message = response?.message
                                if suc! {
                                    let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                                    self.present(uiAlert, animated: true, completion: nil)
                                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                        self.dismiss(animated: true, completion: nil)
                                    }))
                                }
                                else {
                                    let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                                    self.present(uiAlert, animated: true, completion: nil)
                                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                        self.dismiss(animated: true, completion: nil)
                                    }))
                                }
                            }
                        }
                    }
                    else {
                        let uiAlert = UIAlertController(title: "FriendzPoint", message: "Password dose not match.", preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                        }))
                    }
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
            })
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else if indexPath.row == 10 {
            
            // create an actionSheet
            let actionSheetController: UIAlertController = UIAlertController(title: "FriendzPoint", message: nil, preferredStyle: .actionSheet)
            
            // create an action
            let firstAction: UIAlertAction = UIAlertAction(title: "General Settings", style: .default) { action -> Void in
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "GeneralSettingsViewController")as! GeneralSettingsViewController
                self.navigationController?.pushViewController(obj, animated: true)
            }
            
            let secondAction: UIAlertAction = UIAlertAction(title: "Privacy Settings", style: .default) { action -> Void in
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivacySettingController")as! PrivacySettingController
                self.navigationController?.pushViewController(obj, animated: true)
            }
            
//            let thirdAction: UIAlertAction = UIAlertAction(title: "Email Notifications", style: .default) { action -> Void in
//                let obj = self.storyboard?.instantiateViewController(withIdentifier: "EmailnotificationController")as! EmailnotificationController
//                self.navigationController?.pushViewController(obj, animated: true)
//            }
//
            let fourAction: UIAlertAction = UIAlertAction(title: "Deactivate Account", style: .default) { action -> Void in
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "DeactiveController")as! DeactiveController
                self.navigationController?.pushViewController(obj, animated: true)
            }
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
            
            // add actions
            actionSheetController.addAction(firstAction)
            actionSheetController.addAction(secondAction)
          //  actionSheetController.addAction(thirdAction)
            actionSheetController.addAction(fourAction)
            actionSheetController.addAction(cancelAction)
            
            // present an actionSheet...
            present(actionSheetController, animated: true, completion: nil)
            
        }
        else if indexPath.row == 11 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowserCallViewcontroller")as! BrowserCallViewcontroller
            obj.privacy = "privacy"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 12 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowserCallViewcontroller")as! BrowserCallViewcontroller
            obj.terms = "terms"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 13 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowserCallViewcontroller")as! BrowserCallViewcontroller
            self.navigationController?.pushViewController(obj, animated: true)
        }
//        else if indexPath.row == 16 {
////            let obj = self.storyboard?.instantiateViewController(withIdentifier: "AdmanagerViewController")as! AdmanagerViewController
////            self.navigationController?.pushViewController(obj, animated: true)
//        }
        else if indexPath.row == 14 {
            if (loggdenUser.value(forKey: USERNAME) != nil) {
                let username = loggdenUser.value(forKey: USERNAME)as! String
                let link = "https://www.friendzpoint.com/" + username + "/businessprofile"
//                print("link:",link)
                if let url = URL(string: link) {
                    UIApplication.shared.open(url)
                }
            }
        }
        else if indexPath.row == 15 {
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "TellzmeWalletVC")as! TellzmeWalletVC//TellzmeWalletViewController
//            self.navigationController?.pushViewController(obj, animated: true)

            let isLogin = loggdenUser.bool(forKey: walletLoginTellz)
            print(isLogin)


            if isLogin {
                NavigateWallet()
            }
            else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "TellzwalletupdateVC")as! TellzwalletupdateVC//TellzmeWalletViewController
                self.navigationController?.pushViewController(obj, animated: true)
            }
        }
        else if indexPath.row == 16 {
            let alert = UIAlertController(title: "Friendzpoint", message: "Are you sure to logout?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                loggdenUser.set(false, forKey: Islogin)
                loggdenUser.removeObject(forKey: NAMELOgin)
                loggdenUser.removeObject(forKey: STORETIMELINE)
                loggdenUser.removeObject(forKey: TOKEN)
                loggdenUser.removeObject(forKey: USERNAME)
                loggdenUser.removeObject(forKey: TimeLine_id)
                loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
                loggdenUser.removeObject(forKey: GROUPUSERNAME)
                loggdenUser.removeObject(forKey: PROFILE)
                loggdenUser.removeObject(forKey: COVER)
                loggdenUser.removeObject(forKey: GROUPID)
                loggdenUser.removeObject(forKey: PAGEID)
                loggdenUser.removeObject(forKey: PAGEUSERNAME)
                loggdenUser.removeObject(forKey: EVENTID)
                loggdenUser.removeObject(forKey: AD)
                loggdenUser.removeObject(forKey: POSTDETAILS)
                self.appDel.gotoLoginController()
            })
            alert.addAction(ok)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            })
            alert.addAction(cancel)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}


extension UIViewController{
    func NavigateWallet()  {
        if let storyboard = self.storyboard {

            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "HeaderViewController1")

            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "RedeemController")
            firstViewController.title = "REDEEM COINS"

            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "WithdrawController")
            secondViewController.title = "WITHDRAW HISTORY"

            let segmentController = SJSegmentedViewController()
            segmentController.headerViewController = headerViewController
            segmentController.segmentControllers = [firstViewController,
                                                    secondViewController]
            segmentController.headerViewHeight = 465
            segmentController.headerViewOffsetHeight = 31.0
            segmentController.selectedSegmentViewHeight = 1.5
            segmentController.segmentTitleColor = .lightGray
            segmentController.segmentSelectedTitleColor = UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)//.black
            segmentController.selectedSegmentViewColor = UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)
            navigationController?.pushViewController(segmentController, animated: true)
        }
    }
    
    
    
    
    func NavigateWalletMain()  {
        if let storyboard = self.storyboard {

            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "TellzmeHeaderVC")
            
    
            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "RedeemController")
            firstViewController.title = "Redeem Coins"

            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "WithdrawController")
            secondViewController.title = "Withdraw History"

            let segmentController = SJSegmentedViewController()
            segmentController.headerViewController = headerViewController
            segmentController.segmentControllers = [firstViewController,
                                                    secondViewController]
            segmentController.headerViewHeight = 435
            segmentController.headerViewOffsetHeight = 31.0
            segmentController.selectedSegmentViewHeight = 1.5
            segmentController.segmentTitleColor = .lightGray
            segmentController.segmentSelectedTitleColor = UIColor.black//UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)//.black
            segmentController.selectedSegmentViewColor = UIColor.black//UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)
            segmentController.segmentTitleFont = UIFont(name: "SFUIText-Medium", size: 15)!
//            self.modalPresentationStyle = .fullScreen
            present(segmentController, animated: false, completion: nil)//pushViewController(segmentController, animated: true)
        }
    }
    
    func NavigatePages()  {
        if let storyboard = self.storyboard {

            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "HeaderVC")

            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "LikedPageviewController")
            firstViewController.title = "Liked Pages"

            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "PagejoinedlistController")
            secondViewController.title = "Joined Pages"
            
            let thirdViewController = storyboard
                .instantiateViewController(withIdentifier: "MypagesViewController")
            thirdViewController.title = "My Pages"

            let segmentController = SJSegmentedViewController()
            segmentController.headerViewController = headerViewController
            segmentController.segmentControllers = [firstViewController,
                                                    secondViewController,thirdViewController]
            segmentController.headerViewHeight = 55
            segmentController.headerViewOffsetHeight = 31.0
            segmentController.selectedSegmentViewHeight = 1.5
            segmentController.segmentTitleColor = .lightGray
            segmentController.segmentSelectedTitleColor = UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)//.black
            segmentController.selectedSegmentViewColor = UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)
            navigationController?.pushViewController(segmentController, animated: true)
        }
    }
    
    
    func NavigateEvents()  {
        if let storyboard = self.storyboard {

            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "HeaderVC")

            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "DiscoverEventVC")
            firstViewController.title = "Discover Event"

            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "EventlistControllerview")
            secondViewController.title = "My Event"

            let segmentController = SJSegmentedViewController()
            segmentController.headerViewController = headerViewController
            segmentController.segmentControllers = [firstViewController,
                                                    secondViewController]
            segmentController.headerViewHeight = 55
            segmentController.headerViewOffsetHeight = 31.0
            segmentController.selectedSegmentViewHeight = 1.5
            segmentController.segmentTitleColor = .lightGray
            segmentController.segmentSelectedTitleColor = UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)//.black
            segmentController.selectedSegmentViewColor = UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)
            navigationController?.pushViewController(segmentController, animated: true)
        }
    }
    
    func NavigateGroups()  {
        if let storyboard = self.storyboard {

            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "HeaderVC")

            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "JoinedMeGroupViewController")
            firstViewController.title = "Joined Groups"

            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "MygroupsViewControllerList")
            secondViewController.title = "My Groups"

            let segmentController = SJSegmentedViewController()
            segmentController.headerViewController = headerViewController
            segmentController.segmentControllers = [firstViewController,
                                                    secondViewController]
            segmentController.headerViewHeight = 55
            segmentController.headerViewOffsetHeight = 31.0
            segmentController.selectedSegmentViewHeight = 1.5
            segmentController.segmentTitleColor = .lightGray
            segmentController.segmentSelectedTitleColor = UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)//.black
            segmentController.selectedSegmentViewColor = UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)
            navigationController?.pushViewController(segmentController, animated: true)
        }
    }
    
    func NavigateReels()  {
        if let storyboard = self.storyboard {

            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "ReelsProfileVC")
            
    
            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "FeelitVideosVC")
            firstViewController.title = "About"

            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "FeelitVideosVC")
            secondViewController.title = "Feelit"

            let segmentController = SJSegmentedViewController()
            segmentController.headerViewController = headerViewController
            segmentController.segmentControllers = [firstViewController,
                                                    secondViewController]
            segmentController.headerViewHeight = 450
            segmentController.headerViewOffsetHeight = 31.0
            segmentController.selectedSegmentViewHeight = 1.5
            segmentController.segmentTitleColor = .lightGray
            segmentController.segmentSelectedTitleColor = UIColor.black//UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)//.black
            segmentController.selectedSegmentViewColor = UIColor.black//UIColor(red: 0.00, green: 0.37, blue: 1.00, alpha: 1.00)
            segmentController.segmentTitleFont = UIFont(name: "SFUIText-Medium", size: 15)!
            segmentController.modalPresentationStyle = .fullScreen
            present(segmentController, animated: false, completion: nil)//pushViewController(segmentController, animated: true)
        }
    }
}
