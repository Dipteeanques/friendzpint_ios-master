//
//  NotificationController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 30/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class NotificationController: UIViewController {

    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationController")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
    @IBOutlet weak var foundView: Foundview!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMark: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    
//    var arrNotification = ["School group","Rocks Group","Royal Group","Black Royal","Save water","College friends","School group","Rocks Group","Royal Group","Black Royal","Save water"]
    
    var arrNotification = [NotificationList]()
    var url : URL?
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var wc = Webservice.init()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseReels"), object: nil)
        
        //navigationController?.setStatusBar(backgroundColor: .black)
        loaderView.isHidden = false
        activity.startAnimating()
        setDeafult()
        
//        tabBarItem.badgeValue = "1"
        //currentTabBar!.setBadgeText(nil, atIndex: 3)
        
        loggdenUser.set(nil, forKey: BADGECOUNT)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        currentTabBar?.setBar(hidden: false, animated: false)
//    }
    
    func setDeafult() {
        getNotification(strPage: "1")
         pageCount = 1
        self.navigationController?.navigationBar.isHidden = true
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.headerView.bounds
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        headerView.layer.addSublayer(gradientLayer)
//        headerView.addSubview(btnBack)
//        headerView.addSubview(lblTitle)
//        headerView.addSubview(btnMark)
//
//        if UIScreen.main.bounds.width == 414 {
//            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
//        }
    }
    func getNotification(strPage : String) {
        let parameters = ["page" : strPage]
        print(parameters)
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers : HTTPHeaders = ["Xapi": XAPI,
                                     "Accept" : ACCEPT,
                                     "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: GETNOTIFICATIONSUSERLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: NotificationResponseModel?) in
            print(response)
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrNotification.append(arr_dict![i])
                        self.tblView.beginUpdates()
                        self.tblView.insertRows(at: [
                            NSIndexPath(row: self.arrNotification.count-1, section: 0) as IndexPath], with: .fade)
                        self.tblView.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblView.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrNotification.count == 0 {
                            self.foundView.isHidden = false
                        }
                        else {
                            self.foundView.isHidden = true
                        }

                    }
                }
                else {
                    self.spinner.stopAnimating()
                    self.tblView.tableFooterView?.isHidden = true
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrNotification.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
            }
            self.spinner.stopAnimating()
            self.tblView.tableFooterView?.isHidden = true
            self.loaderView.isHidden = true
            self.activity.stopAnimating()
            if self.arrNotification.count == 0 {
                self.foundView.isHidden = false
            }
            else {
                self.foundView.isHidden = true
            }
        }
    }
    
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnMarkedNotiAction(_ sender: UIButton) {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers : HTTPHeaders = ["Xapi": XAPI,
                                     "Accept" : ACCEPT,
                                     "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: MARKALLNOTIFICATION, parameters: [:], headers: headers, fromView: self.view, isLoading: false) { (sucess, response: markedallnotiRespons?) in
            if sucess {
                let message = response?.message
                let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                    loggdenUser.removeObject(forKey: BADGECOUNT)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BadgeCleare"), object: nil)
                }))
            }
        }
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

extension NotificationController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblNotiCell
        cell.lblUser.text = arrNotification[indexPath.row].description
        let strImg = arrNotification[indexPath.row].avatar
        url = URL(string: strImg)
        cell.imgUser.sd_setImage(with: url, completed: nil)
        cell.imgUser.layer.cornerRadius = 25
        cell.imgUser.clipsToBounds = true
        let postDate = arrNotification[indexPath.row].created_at
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: postDate)!
        let datavala = Date().timeAgoSinceDate(date, numericDates: true)
        cell.lblDay.text = datavala
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let refreshAlert = UIAlertController(title: "Notification", message: "Are you sure to delete?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                self.arrNotification.remove(at: indexPath.row)
//                self.tblView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tblView
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblView.bounds.width, height: CGFloat(44))
                pageCount += 1
                print(pageCount)
                getNotification(strPage: "\(pageCount)")
                self.tblView.tableFooterView = spinner
                self.tblView.tableFooterView?.isHidden = false
            }
        }
    }
    
   // (redirect_action: "MyGroupDetails", type: "group", username: "itmasters", post_id: 0, id: 9, name: "IT Masters", invite_privacy: "", member_privacy: "members", post_privacy: "only_admins", groups_status: "joined", is_guest: 0, is_page_admin: 1, groups_type: "closed", event_type: "")
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let api_notification_data = arrNotification[indexPath.row].api_notification_data
        print(api_notification_data)
        let username = api_notification_data.username
        let type = api_notification_data.type
        let group_Type = api_notification_data.groups_type
        let status_group = api_notification_data.groups_status
        let pageAdmin = api_notification_data.is_page_admin
        let event_type = api_notification_data.event_type
        let invite_privacy = api_notification_data.invite_privacy
        let post_privacy = api_notification_data.post_privacy
        let member_privacy = api_notification_data.member_privacy
        let is_guest = api_notification_data.is_guest
        let post_id = api_notification_data.post_id
        let myprofile = loggdenUser.value(forKey: USERNAME)as! String
        
        print("type: ",type)
        
        let maintype = arrNotification[indexPath.row].type
        if maintype == "join_event" || maintype == "unjoin_event" || maintype == "follow" || maintype == "unfollow" || maintype == "accept_follow_request" || maintype == "reject_follow_request" || maintype == "join_group" || maintype == "unjoin_group" || maintype == "remove_group_member" || maintype == "accept_group_join" || maintype == "reject_group_join" || maintype == "follow_requested" || maintype == "like_page" || maintype == "unlike_page" || maintype == "remove_page_member"{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "navigationLoaderpageredirection")as! navigationLoaderpageredirection
            obj.strUser = arrNotification[indexPath.row].username//username
                       print("username: ",username)
           //                    self.navigationController?.pushViewController(obj, animated: true)
                       obj.modalPresentationStyle = .fullScreen
                       self.present(obj, animated: false, completion: nil)
        }
       else if type == "post" {
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
//
//            obj.postDetail_id = post_id
//            self.navigationController?.pushViewController(obj, animated: true)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "SavePostListVC")as! SavePostListVC
            
            obj.postDetail_id = post_id
            
            obj.strUrlType = "post"
            obj.modalPresentationStyle = .fullScreen
            self.present(obj, animated: false, completion: nil)
        }
//        else if type == "homepage" {
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "navigationLoaderpageredirection")as! navigationLoaderpageredirection
//            obj.strUser = username
//            print("username: ",username)
////                    self.navigationController?.pushViewController(obj, animated: true)
//            obj.modalPresentationStyle = .fullScreen
//            self.present(obj, animated: false, completion: nil)
//        }
        else if type == "user" {
            if myprofile == username {
               // currentTabBar?.setIndex(4)
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
               // self.navigationController?.pushViewController(obj, animated: true)
                obj.modalPresentationStyle = .fullScreen
                self.present(obj, animated: false, completion: nil)
            }
            else {
                loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
                loggdenUser.set(username, forKey: FRIENDSUSERNAME)
                loggdenUser.set(username, forKey: UNAME)
                obj.strUserName = username
                //self.navigationController?.pushViewController(obj, animated: false)
                obj.modalPresentationStyle = .fullScreen
                self.present(obj, animated: false, completion: nil)
            }
        }
        else if type == "page" {
            if pageAdmin == 0 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendPageProfileController")as! FriendPageProfileController
                loggdenUser.set(username, forKey: UNAME)
                obj.strUserName = username
                obj.onlyPost = post_privacy
                obj.onlyInvaite = invite_privacy
                //self.navigationController?.pushViewController(obj, animated: false)
                obj.modalPresentationStyle = .fullScreen
                self.present(obj, animated: false, completion: nil)
            }
            else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "MypageProfileViewController")as! MypageProfileViewController
                print(username)
                loggdenUser.setValue(username, forKey: UNAME)
                obj.strUserName = username
                obj.onlyPost = post_privacy
                obj.onlyInvaite = invite_privacy
                //self.navigationController?.pushViewController(obj, animated: false)
                obj.modalPresentationStyle = .fullScreen
                self.present(obj, animated: false, completion: nil)
            }
        }
        else if type == "event" {
            if pageAdmin == 0 {
                if event_type == "public" {
                    if invite_privacy == "only_admins" && post_privacy == "only_admins"  {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PublicEventProfileController")as! PublicEventProfileController
                        obj.strUserName = username
                        loggdenUser.set(username, forKey: UNAME)
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.is_page_admin = pageAdmin
                       // self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                    else if invite_privacy == "only_guests" && post_privacy == "only_guests"  {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "publicAndGuestProfileViewController")as! publicAndGuestProfileViewController
                        obj.strUserName = username
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.is_page_admin = pageAdmin
                        loggdenUser.set(username, forKey: UNAME)
                        //self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                    else if invite_privacy == "only_admins" && post_privacy == "only_guests"  {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PublicEventProfileController")as! PublicEventProfileController
                        obj.strUserName = username
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.is_page_admin = pageAdmin
                        loggdenUser.set(username, forKey: UNAME)
                       // self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                    else if invite_privacy == "only_guests" && post_privacy == "only_admins" {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "publicAndGuestProfileViewController")as! publicAndGuestProfileViewController
                        obj.strUserName = username
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.is_page_admin = pageAdmin
                        loggdenUser.set(username, forKey: UNAME)
                        //self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                    else {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PublicEventProfileController")as! PublicEventProfileController
                        obj.strUserName = username
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.is_page_admin = pageAdmin
                        loggdenUser.set(username, forKey: UNAME)
                        //self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                }
                else {
                    if is_guest == 1 {
                        if invite_privacy == "only_admins" && post_privacy == "only_admins"  {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = invite_privacy
                            obj.is_page_admin = pageAdmin
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: false)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if invite_privacy == "only_guests" && post_privacy == "only_guests"  {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = invite_privacy
                            obj.is_page_admin = pageAdmin
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: false)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if invite_privacy == "only_admins" && post_privacy == "only_guests"  {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = invite_privacy
                            obj.is_page_admin = pageAdmin
                            loggdenUser.set(username, forKey: UNAME)
                           // self.navigationController?.pushViewController(obj, animated: false)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if invite_privacy == "only_guests" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = invite_privacy
                            obj.is_page_admin = pageAdmin
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: false)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = invite_privacy
                            obj.is_page_admin = pageAdmin
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: false)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                    }
                    else {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateEventController")as! PrivateEventController
                        obj.strUserName = username
                        obj.onlyPrivet = "onlyPrivet"
                        loggdenUser.set(username, forKey: UNAME)
                        //self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                }
            }
            else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "EventProfileController")as! EventProfileController
                obj.strUserName = username
                obj.is_page_admin = pageAdmin
                loggdenUser.set(username, forKey: UNAME)
                //self.navigationController?.pushViewController(obj, animated: false)
                obj.modalPresentationStyle = .fullScreen
                self.present(obj, animated: false, completion: nil)
            }
        }
        else {
            if pageAdmin == 0 {
                if group_Type == "closed" {
                    if status_group == "join" {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                           // self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                    }
                    else if status_group == "pending" {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                    }
                    else if status_group == "joined" {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                    }
                }
                else if group_Type == "open" {
                    if status_group == "joined" {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                           // self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                    }
                    else {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                    }
                }
                else {
                    if status_group == "joined" {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openAndSecretGroupController")as! openAndSecretGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                    }
                    else {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                           // self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openAndSecretGroupController")as! openAndSecretGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
                            //self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                    }
                }
            }
            else {
                if group_Type == "closed" {
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "GroupProfileViewController")as! GroupProfileViewController
                    obj.strUserName = username
                    obj.onlyPost = post_privacy
                    obj.onlyInvaite = member_privacy
                    loggdenUser.set(username, forKey: UNAME)
                    //self.navigationController?.pushViewController(obj, animated: true)
                    obj.modalPresentationStyle = .fullScreen
                    self.present(obj, animated: false, completion: nil)
                }
                else if group_Type == "open" {
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                    obj.strUserName = username
                    obj.onlyPost = post_privacy
                    obj.onlyInvaite = member_privacy
                    loggdenUser.set(username, forKey: UNAME)
                    //self.navigationController?.pushViewController(obj, animated: true)
                    obj.modalPresentationStyle = .fullScreen
                    self.present(obj, animated: false, completion: nil)
                }
                else {
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                    obj.strUserName = username
                    obj.onlyPost = post_privacy
                    obj.onlyInvaite = member_privacy
                    loggdenUser.set(username, forKey: UNAME)
                    //self.navigationController?.pushViewController(obj, animated: true)
                    obj.modalPresentationStyle = .fullScreen
                    self.present(obj, animated: false, completion: nil)
                }
            }
        }
    }
}


