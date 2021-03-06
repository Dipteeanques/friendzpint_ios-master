//
//  navigationLoaderpageredirection.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 03/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class navigationLoaderpageredirection: UIViewController {

    
    @IBOutlet weak var activity: UIActivityIndicatorView!
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
    
    var wc = Webservice.init()
    var arrResults = [SearchDataResoponseModel]()
    var strUser = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.startAnimating()
        setDefault()
    }
    
    func setDefault() {
        getUserProfile()
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
        
        if UIScreen.main.bounds.width == 320 {
            
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: gridentView.bounds.size.height)
        }
    }
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Mark: - userNameSelected
    
    func getUserProfile() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        
        let parameters = ["search":strUser]
        print("Loadparameters: ",parameters)
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: USERNAMEWISESEARCH, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: HomesearchResponseModel?) in
            if sucess {
                self.arrResults = response!.data
                var username = String()
                var type = String()
                var group_Type = String()
                var status_group = String()
                var pageAdmin = Int()
                var event_type = String()
                var invite_privacy = String()
                var post_privacy = String()
                var member_privacy = String()
                var is_guest = Int()
                
                
                if self.arrResults.count > 0{
                    username = self.arrResults[0].username
                    type = self.arrResults[0].type
                    group_Type = self.arrResults[0].groups_type
                    status_group = self.arrResults[0].groups_status
                    pageAdmin = self.arrResults[0].is_page_admin
                    event_type = self.arrResults[0].event_type
                    invite_privacy = self.arrResults[0].invite_privacy
                    post_privacy = self.arrResults[0].post_privacy
                    member_privacy = self.arrResults[0].member_privacy
                    is_guest = self.arrResults[0].is_guest
                }
                else{
                    loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
                    loggdenUser.set(username, forKey: FRIENDSUSERNAME)
                    loggdenUser.set(username, forKey: UNAME)
                    obj.strUserName = username
                    obj.passBackvala = "passBackvala"
//                    self.navigationController?.pushViewController(obj, animated: false)
                    obj.modalPresentationStyle = .fullScreen
                    self.present(obj, animated: false, completion: nil)
                }

                print("group_Type: ",group_Type)
                print("status_group: ",status_group)
                print("post_privacy: ",post_privacy)
                print("member_privacy: ",member_privacy)
                
                let myprofile = loggdenUser.value(forKey: USERNAME)as! String
                
                if type == "user" {
                    if myprofile == username {
                        self.currentTabBar?.setIndex(4)
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
            //            self.navigationController?.pushViewController(obj, animated: true)
                        obj.modalPresentationStyle = .fullScreen
                        obj.passBackvala = "passBackvala"
                        //self.navigationController?.pushViewController(obj, animated: true)
                        self.present(obj, animated: false, completion: nil)
                    }
                    else {
                        loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
                        loggdenUser.set(username, forKey: FRIENDSUSERNAME)
                        loggdenUser.set(username, forKey: FRIENDSUSERNAME)
                        loggdenUser.set(username, forKey: UNAME)
                        obj.strUserName = username
                        obj.passBackvala = "passBackvala"
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
                        obj.passBackvala = "passBackvala"
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                    else {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "MypageProfileViewController")as! MypageProfileViewController
                        loggdenUser.setValue(username, forKey: UNAME)
                        print(username)
                        obj.strUserName = username
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.passBackvala = "passBackvala"
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                }
                else if type == "event" {
                    if pageAdmin == 0 {
                        if event_type == "public" {
                            if invite_privacy == "only_admins" && post_privacy == "only_admins"  {
                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "PublicEventProfileController")as! PublicEventProfileController
                                loggdenUser.set(username, forKey: UNAME)
                                obj.strUserName = username
                                obj.onlyPost = post_privacy
                                obj.onlyInvaite = invite_privacy
                                obj.is_page_admin = pageAdmin
                                obj.passBackvala = "passBackvala"
                                obj.modalPresentationStyle = .fullScreen
                                self.present(obj, animated: false, completion: nil)
                            }
                            else if invite_privacy == "only_guests" && post_privacy == "only_guests"  {
                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "publicAndGuestProfileViewController")as! publicAndGuestProfileViewController
                                obj.strUserName = username
                                obj.onlyPost = post_privacy
                                obj.onlyInvaite = invite_privacy
                                obj.is_page_admin = pageAdmin
                                obj.passBackvala = "passBackvala"
                                loggdenUser.set(username, forKey: UNAME)
                                obj.modalPresentationStyle = .fullScreen
                                self.present(obj, animated: false, completion: nil)
                            }
                            else if invite_privacy == "only_admins" && post_privacy == "only_guests"  {
                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "PublicEventProfileController")as! PublicEventProfileController
                                obj.strUserName = username
                                loggdenUser.set(username, forKey: UNAME)
                                obj.onlyPost = post_privacy
                                obj.onlyInvaite = invite_privacy
                                obj.is_page_admin = pageAdmin
                                obj.passBackvala = "passBackvala"
                                obj.modalPresentationStyle = .fullScreen
                                self.present(obj, animated: false, completion: nil)
                            }
                            else if invite_privacy == "only_guests" && post_privacy == "only_admins" {
                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "publicAndGuestProfileViewController")as! publicAndGuestProfileViewController
                                obj.strUserName = username
                                loggdenUser.set(username, forKey: UNAME)
                                obj.onlyPost = post_privacy
                                obj.onlyInvaite = invite_privacy
                                obj.is_page_admin = pageAdmin
                                obj.passBackvala = "passBackvala"
                                obj.modalPresentationStyle = .fullScreen
                                self.present(obj, animated: false, completion: nil)
                            }
                            else {
                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "PublicEventProfileController")as! PublicEventProfileController
                                obj.strUserName = username
                                loggdenUser.set(username, forKey: UNAME)
                                obj.onlyPost = post_privacy
                                obj.onlyInvaite = invite_privacy
                                obj.is_page_admin = pageAdmin
                                obj.passBackvala = "passBackvala"
                                obj.modalPresentationStyle = .fullScreen
                                self.present(obj, animated: false, completion: nil)
                            }
                        }
                        else {
                            if is_guest == 1 {
                                if invite_privacy == "only_admins" && post_privacy == "only_admins"  {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = invite_privacy
                                    obj.is_page_admin = pageAdmin
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if invite_privacy == "only_guests" && post_privacy == "only_guests"  {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = invite_privacy
                                    obj.is_page_admin = pageAdmin
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if invite_privacy == "only_admins" && post_privacy == "only_guests"  {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = invite_privacy
                                    obj.is_page_admin = pageAdmin
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if invite_privacy == "only_guests" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = invite_privacy
                                    obj.is_page_admin = pageAdmin
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = invite_privacy
                                    obj.is_page_admin = pageAdmin
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                            }
                            else {
                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateEventController")as! PrivateEventController
                                obj.strUserName = username
                                loggdenUser.set(username, forKey: UNAME)
                                obj.onlyPrivet = "onlyPrivet"
                                obj.passBackvala = "passBackvala"
                                obj.modalPresentationStyle = .fullScreen
                                self.present(obj, animated: false, completion: nil)
                            }
                        }
                    }
                    else {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "EventProfileController")as! EventProfileController
                        obj.strUserName = username
                        loggdenUser.set(username, forKey: UNAME)
                        obj.is_page_admin = pageAdmin
                        obj.passBackvala = "passBackvala"
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
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                            }
                            else if status_group == "pending" {
                                if member_privacy == "only_admins" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                            }
                            else if status_group == "joined" {
                                if member_privacy == "only_admins" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
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
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                            }
                            else {
                                if member_privacy == "only_admins" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
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
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openAndSecretGroupController")as! openAndSecretGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                            }
                            else {
                                if member_privacy == "only_admins" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "only_admins" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "only_admins" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "members" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
                                    obj.modalPresentationStyle = .fullScreen
                                    self.present(obj, animated: false, completion: nil)
                                }
                                else if member_privacy == "members" && post_privacy == "everyone" {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openAndSecretGroupController")as! openAndSecretGroupController
                                    obj.strUserName = username
                                    loggdenUser.set(username, forKey: UNAME)
                                    obj.onlyPost = post_privacy
                                    obj.onlyInvaite = member_privacy
                                    obj.passBackvala = "passBackvala"
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
                            loggdenUser.set(username, forKey: UNAME)
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            obj.passBackvala = "passBackvala"
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if group_Type == "open" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            loggdenUser.set(username, forKey: UNAME)
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            obj.passBackvala = "passBackvala"
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            loggdenUser.set(username, forKey: UNAME)
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            obj.passBackvala = "passBackvala"
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                    }
                }
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
