//
//  SettingVC.swift
//  FriendzPoint
//
//  Created by Anques on 22/01/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class SettingVC: UIViewController {
    
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingVC")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }

    let appDel = UIApplication.shared.delegate as! AppDelegate
    var wc = Webservice.init()
    var gradientLayer: CAGradientLayer!
    
    var colorSets = [[UIColor(red: 0.11, green: 0.75, blue: 0.92, alpha: 1.00).cgColor, UIColor(red: 0.00, green: 0.07, blue: 1.00, alpha: 1.00).cgColor], [UIColor(red: 0.02, green: 0.36, blue: 0.91, alpha: 1.00).cgColor, UIColor(red: 0.04, green: 0.78, blue: 0.98, alpha: 1.00).cgColor], [UIColor(red: 0.30, green: 0.36, blue: 0.98, alpha: 1.00).cgColor,UIColor(red: 0.02, green: 0.60, blue: 0.95, alpha: 1.00).cgColor],[UIColor(red: 0.11, green: 0.23, blue: 0.87, alpha: 1.00).cgColor,UIColor(red: 0.13, green: 0.62, blue: 0.81, alpha: 1.00).cgColor],[UIColor(red: 0.90, green: 0.01, blue: 0.66, alpha: 1.00).cgColor,UIColor(red: 0.01, green: 0.48, blue: 0.87, alpha: 1.00).cgColor],[UIColor(red: 0.90, green: 0.01, blue: 0.66, alpha: 1.00).cgColor,UIColor(red: 0.01, green: 0.48, blue: 0.87, alpha: 1.00).cgColor],[UIColor(red: 0.02, green: 0.36, blue: 0.91, alpha: 1.00).cgColor,UIColor(red: 0.04, green: 0.78, blue: 0.98, alpha: 1.00).cgColor],[UIColor(red: 0.11, green: 0.75, blue: 0.92, alpha: 1.00).cgColor,UIColor(red: 0.00, green: 0.07, blue: 1.00, alpha: 1.00).cgColor],[UIColor(red: 0.30, green: 0.36, blue: 0.98, alpha: 1.00).cgColor,UIColor(red: 0.02, green: 0.60, blue: 0.95, alpha: 1.00).cgColor],[UIColor(red: 0.04, green: 0.93, blue: 0.98, alpha: 1.00).cgColor,UIColor(red: 0.28, green: 0.66, blue: 1.00, alpha: 1.00).cgColor],[UIColor(red: 0.02, green: 0.36, blue: 0.91, alpha: 1.00).cgColor,UIColor(red: 0.04, green: 0.78, blue: 0.98, alpha: 1.00).cgColor]]//[[CGColor]]()
    
    var currentColorSet: Int!
    
    //timeline_comments
    //parent_timeline_comments
    
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.layer.cornerRadius = imgProfile.layer.frame.height/2
            imgProfile.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblName: UILabel!
    
    let arrMenuList = ["Pages","Groups","Events","Browse","Followers","Following","Tellzme Wallet","Business Profile","Save Post"]//,"Articals"
    
    let arrMenuImage = ["Pages","Groups","Events","browse","Followers","Following","Tellzme Wallet","Business Profile","Save Post"]//,"Articals"
    
    let arrSettingList = ["General Setting","Privacy Setting","Privacy Policy","Change Password","Terms and Conditions"]//,"Deactivate Account","Logout"
    
    let arrtopcolor = [UIColor(red: 0.12, green: 0.64, blue: 1.00, alpha: 1.00),UIColor(red: 0.00, green: 0.51, blue: 0.69, alpha: 1.00),UIColor(red: 0.07, green: 0.60, blue: 0.56, alpha: 1.00),UIColor(red: 0.04, green: 0.93, blue: 0.98, alpha: 1.00),UIColor(red: 0.00, green: 0.51, blue: 0.69, alpha: 1.00),UIColor(red: 0.07, green: 0.60, blue: 0.56, alpha: 1.00),UIColor(red: 0.97, green: 0.03, blue: 0.35, alpha: 1.00),UIColor(red: 0.12, green: 0.64, blue: 1.00, alpha: 1.00),UIColor(red: 0.12, green: 0.64, blue: 1.00, alpha: 1.00)]
    let arrbottomcolor = [UIColor(red: 0.07, green: 0.85, blue: 0.98, alpha: 1.00),UIColor(red: 0.00, green: 0.71, blue: 0.86, alpha: 1.00),UIColor(red: 0.22, green: 0.94, blue: 0.49, alpha: 1.00),UIColor(red: 0.28, green: 0.66, blue: 1.00, alpha: 1.00),UIColor(red: 0.00, green: 0.71, blue: 0.86, alpha: 1.00),UIColor(red: 0.22, green: 0.94, blue: 0.49, alpha: 1.00),UIColor(red: 0.74, green: 0.31, blue: 0.61, alpha: 1.00),UIColor(red: 0.07, green: 0.85, blue: 0.98, alpha: 1.00),UIColor(red: 0.07, green: 0.85, blue: 0.98, alpha: 1.00)]
    
    @IBOutlet weak var collectionMenu: UICollectionView!
    
    @IBOutlet weak var tblMenu: UITableView!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnDownarrowOutlet: UIButton!
    
    @IBOutlet weak var dropDownView: UIView!
    var checkFlag = 0
    
    var strUserName = String()
    var datadic : DataMyprofile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        //navigationController?.setStatusBar(backgroundColor: .white)
//        self.tblHeight?.constant = 0
        
        tblMenu.backgroundColor = .clear
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapDropDown(_:)))
//        tapGesture.numberOfTapsRequired = 1
//        self.dropDownView.addGestureRecognizer(tapGesture)
//
        self.tblMenu.isHidden = true
        self.tblHeight?.constant = 0//227
        setDefault()
        
        //manageConstant()
    }
    
    func setDefault(){
        currentTabBar?.setBar(hidden: false, animated: false)
        lblName.text = loggdenUser.value(forKey: NAMELOgin)as? String
        strUserName = loggdenUser.value(forKey: USERNAME)as? String ?? ""
        let profile = loggdenUser.value(forKey: PROFILE)as! String
        let url = URL(string: profile)
        imgProfile.sd_setImage(with: url, completed: nil)
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
            if count == 0{
                currentTabBar!.setBadgeText(nil, atIndex: 3)
            }
            else{
                currentTabBar!.setBadgeText(String(count), atIndex: 3)
            }
        }
       // getProfileDetails()
    }
    
    func getProfileDetails() {
        let parameters = ["username":strUserName]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: MYPROFILEDETAILS, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: MyprofileResponsModel?) in
            if sucess {
                
                self.datadic = response?.data
               
//                self.lblFollower.text = String(dic!.followers)
//                self.lblFollowing.text = String(dic!.following)
//                self.collectionMenu.reloadData()
//                self.collectionMenu.beginUpdates()
//                self.collectionMenu.reloadRows(at: [4], with: UICollectionView.RowAnimation.none)
//                self.collectionMenu.endUpdates()
                let indexPath = IndexPath(item: 4, section: 0)
                let indexPath1 = IndexPath(item: 5, section: 0)
                self.collectionMenu.reloadItems(at: [indexPath])
                self.collectionMenu.reloadItems(at: [indexPath1])
            }
        }
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "GeneralSettingsViewController")as! GeneralSettingsViewController
               self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    @IBAction func btnVIewProfile(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @objc func tapDropDown(_ sender: UITapGestureRecognizer) {
        print("Please Help!")
        manageConstant()
    }
    
    @IBAction func btnDownarrow(_ sender: UIButton) {
//        manageConstant()
        
        super.updateViewConstraints()
        if checkFlag == 0{
            btnDownarrowOutlet.setImage(UIImage(named: "uparrow"),for: .normal)
            self.tblMenu.isHidden = false
            checkFlag = 1
            self.tblHeight?.constant = self.tblMenu.contentSize.height
         //   self.tblMenu.reloadData()
        }
        else{
            btnDownarrowOutlet.setImage(UIImage(named: "downarrow"),for: .normal)
            self.tblMenu.isHidden = true
            checkFlag = 0
            self.tblHeight?.constant = 0//227
        }
        
        super.updateViewConstraints()
    }
    
    func manageConstant() {
        super.updateViewConstraints()
        if checkFlag == 0{
            btnDownarrowOutlet.setImage(UIImage(named: "uparrow"),for: .normal)
            self.tblMenu.isHidden = false
            checkFlag = 1
            self.tblHeight?.constant = self.tblMenu.contentSize.height
            //self.tblMenu.reloadData()
        }
        else{
            btnDownarrowOutlet.setImage(UIImage(named: "downarrow"),for: .normal)
            self.tblMenu.isHidden = true
            checkFlag = 0
            self.tblHeight?.constant = 0//227
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
//         createGradientLayer()
//        collectionMenu.reloadData()
        currentTabBar?.setBar(hidden: false, animated: false)
        
        print("viewWillAppear")
     }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        super.updateViewConstraints()
        getProfileDetails()
        currentTabBar?.setBar(hidden: false, animated: false)
        print("viewDidAppear")
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        //manageConstant()
    }
    func createGradientLayer(view: UIView,index: Int) {
        let collectionViewSize = collectionMenu.frame.size.width - 30
        let arrAngle = [115,245,114,128,128,240,120,114,246,244]
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: collectionViewSize/2, height: collectionViewSize/2)
        gradientLayer.colors = colorSets[index]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.apply(angle: Double(arrAngle[index]))
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func GradientView(gridentView: UIView){
        let gradientLayer = CAGradientLayer()
        let collectionViewSize = collectionMenu.frame.size.width - 30
        gradientLayer.frame = CGRect(x: 0, y: 0, width: collectionViewSize/2, height: collectionViewSize/2)//gridentView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gridentView.layer.addSublayer(gradientLayer)
    }
    
    func GredientMainView(gView: GradientView1, topcolor: UIColor , bottomcolor: UIColor){
        gView.topColor = topcolor//UIColor(red: 0.22, green: 0.94, blue: 0.49, alpha: 1.00)
        gView.bottomColor = bottomcolor//UIColor(red: 0.07, green: 0.60, blue: 0.56, alpha: 1.00)
        gView.shadowColor = UIColor.gray
        gView.shadowX = 0
        gView.shadowY = 12
        gView.shadowBlur = 17
        gView.startPointX = 0
        gView.startPointY = 1
        gView.endPointX = 1
        gView.endPointY = 0
        gView.cornerRadius = 8
    }
    
    @IBAction func btndeactivateaccount(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "DeactiveController")as!   DeactiveController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        let alert = UIAlertController(title: "Friendzpoint", message: "Are you sure to logout?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            timer.invalidate()
            timer1.invalidate()
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




extension SettingVC: UICollisionBehaviorDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMenuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SettingsCell
        cell.lblTitle.text = arrMenuList[indexPath.row]
        cell.imgIcon.image = UIImage(named: arrMenuImage[indexPath.row])
//        createGradientLayer(view: cell.mainView, index: indexPath.row)
        
        GredientMainView(gView: cell.mainView ,topcolor: arrtopcolor[indexPath.row], bottomcolor: arrbottomcolor[indexPath.row])
        
//        GradientView(gridentView: cell.mainView)
        cell.mainView.addSubview(cell.lblCount)
        cell.mainView.addSubview(cell.lblTitle)
        cell.mainView.addSubview(cell.roundView)
        cell.mainView.addSubview(cell.imgIcon)
        if indexPath.row == 4 || indexPath.row == 5{
            cell.lblCount.isHidden = false
            cell.roundView.isHidden = false
            cell.roundViewHeight.constant = 10
            cell.lblBottom.constant = 15
            if indexPath.row == 4{
//                let strfollowers = String(self.datadic?.followers ?? "")
                cell.lblCount.text = self.datadic?.followers.description//String(datadic?.followers ?? "")
            }
            if indexPath.row == 5 {
                cell.lblCount.text = self.datadic?.following.description//String(datadic?.following ?? "")
            }
        }
        else{
            cell.lblBottom.constant = 0
            cell.roundViewHeight.constant = 0
            cell.lblCount.text = ""
            cell.lblCount.isHidden = true
            cell.roundView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  30
        let collectionViewSize = collectionView.frame.size.width - padding
        print("collectionViewSize: ",collectionViewSize)
        if indexPath.row == 4 || indexPath.row == 5{
            return CGSize(width: collectionViewSize/2, height: 109)
        }
        else{
            return CGSize(width: collectionViewSize/2, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PagesVC") as! PagesVC
//            self.navigationController?.pushViewController(obj, animated: false)
            strTitle = "Pages"
            NavigatePages()
        }
        else if indexPath.row == 1{
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyGroupVC") as! MyGroupVC
//            self.navigationController?.pushViewController(obj, animated: false)
            strTitle = "Groups"
            NavigateGroups()
        }
        else if indexPath.row == 2{
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "EventlistControllerview")as! EventlistControllerview
////            self.navigationController?.pushViewController(obj, animated: true)
//            obj.modalPresentationStyle = .fullScreen
//            self.present(obj, animated: false, completion: nil)
            strTitle = "Events"
            NavigateEvents() 
        }
        else if indexPath.row == 3 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowseVC")as! BrowseVC
//            self.navigationController?.pushViewController(obj, animated: true)
//            self.modalPresentationStyle = .overFullScreen
//            self.navigationController?.present(obj, animated: false, completion: nil)
            
//            let vc = BrowseVC()
            if #available(iOS 13.0, *) {
//                obj.isModalInPresentation = true
                obj.modalPresentationStyle = .fullScreen
//                obj.modalTransitionStyle = .partialCurl
            } else {
                // Fallback on earlier versions
            }
            present(obj, animated: false)
        }
        else if indexPath.row == 4{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController")as! FollowersViewController
            obj.modalPresentationStyle = .fullScreen
            present(obj, animated: false)//pushViewController(obj, animated: true)
        }
        else if indexPath.row == 5{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyfriendsController")as! MyfriendsController
          //  self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            present(obj, animated: false)//pushViewController(obj, animated: true)
        }
        else if indexPath.row == 6{
           
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "TellzmeHeaderVC")as! TellzmeHeaderVC //TellzmeWalletViewController
//            self.navigationController?.pushViewController(obj, animated: true)
            let isLogin = loggdenUser.bool(forKey: walletLoginTellz)
            print(isLogin)


            if isLogin {
               // NavigateWallet()
                NavigateWalletMain()
            }
            else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "MobileVC")as! MobileVC//TellzmeWalletViewController
                obj.modalPresentationStyle = .fullScreen
                present(obj, animated: false, completion: nil)//pushViewController(obj, animated: true)//self.navigationController?
            }
        }
        else if indexPath.row == 7{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//           let obj = storyboard?.instantiateViewController(withIdentifier: "PostViewController")as! PostViewController
//           let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//           self.present(naviget, animated: true, completion: nil)
            if (loggdenUser.value(forKey: USERNAME) != nil) {
                let username = loggdenUser.value(forKey: USERNAME)as! String
                let link = "https://www.friendzpoint.com/" + username + "/businessprofile"
//                print("link:",link)
                if let url = URL(string: link) {
                    UIApplication.shared.open(url)
                }
            }
        }
        else if indexPath.row == 8{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SavePostListVC")as! SavePostListVC//TellzmeWalletViewController
            obj.strUrlType = "Save"
            obj.modalPresentationStyle = .fullScreen
            self.present(obj, animated: false, completion: nil)
        }

    }
}

extension SettingVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
        cell.lblTitle.text = arrSettingList[indexPath.row]
        cell.imgIcon.image = UIImage(named: arrSettingList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "GeneralSettingsViewController")as! GeneralSettingsViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 1{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivacySettingController")as! PrivacySettingController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 2{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowserCallViewcontroller")as! BrowserCallViewcontroller
            obj.strtitle = "Privacy Policy"
            obj.privacy = "privacy"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 3 {
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
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
           
            
            self.present(alertController, animated: true, completion: nil)
        }
        else if indexPath.row == 4{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowserCallViewcontroller")as! BrowserCallViewcontroller
            obj.strtitle = "Terms and Conditions"
            obj.terms = "terms"
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath .row == 5{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DeactiveController")as!   DeactiveController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 6{
            let alert = UIAlertController(title: "Friendzpoint", message: "Are you sure to logout?", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                timer.invalidate()
                timer1.invalidate()
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
    
    
}

//helper extention to CAGradientLayer
extension CAGradientLayer {
    func apply(angle : Double) {
        let x: Double! = angle / 360.0
        let a = pow(sinf(Float(2.0 * Double.pi * ((x + 0.75) / 2.0))),2.0);
        let b = pow(sinf(Float(2*Double.pi*((x+0.0)/2))),2);
        let c = pow(sinf(Float(2*Double.pi*((x+0.25)/2))),2);
        let d = pow(sinf(Float(2*Double.pi*((x+0.5)/2))),2);
        
        endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
    }
}
