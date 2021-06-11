///Users/anquestechnolabs/Desktop/FriendzPoint/DashboardController/GroupView/tblGroupListCell.swift
//  GroupListViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 22/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class JoinedMeGroupViewController: UIViewController {
    
    @IBOutlet weak var collectionSuggestedGroup: UICollectionView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var tblGrouplist: UITableView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: LargeFound!
    
    var arrgroup = ["School group","Rocks Group","Royal Group","Black Royal","Save water","College friends","School group","Rocks Group","Royal Group","Black Royal","Save water"]
    
    var arrUsergroup = [UserJointGroupList]()
    var url : URL?
    var timeline_id = Int()
    var strUserName = String()
    var wc = Webservice.init()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var arrSugestgroup = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView.isHidden = false
        activity.startAnimating()
        setDefault()
    }
    
    func setDefault() {
        
        self.foundView.isHidden = true
        
        getSuggestedGroup()
        getGroup(strPage: "1")
        pageCount = 1
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.header.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        header.layer.addSublayer(gradientLayer)
        header.addSubview(btnback)
        header.addSubview(lblTitle)
        
        
        if UIScreen.main.bounds.width == 320 {
            
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 414, height: header.bounds.size.height)
        }
    }
    
    func getSuggestedGroup() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        AF.request(FindsuggestedGroups, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { response in
                print(response)
                let json = response.value as! NSDictionary
                let success = json.value(forKey: "success")as! Bool
                if success == true {
                    self.arrSugestgroup = json.value(forKey: "data") as! NSArray
                    self.collectionSuggestedGroup.reloadData()
                }
            }
        }

    
    func getGroup(strPage : String) {
        strUserName = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username":strUserName,
                          "page":strPage]
        print(parameters)
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: JOINGROUPLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: UserJointGroupResponseModel?) in
            if sucess {
                let sucessMy = response?.success
                //   let strMsg = response?.message
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrUsergroup.append(arr_dict![i])
                        self.tblGrouplist.beginUpdates()
                        self.tblGrouplist.insertRows(at: [
                            NSIndexPath(row: self.arrUsergroup.count-1, section: 0) as IndexPath], with: .fade)
                        self.tblGrouplist.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblGrouplist.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrUsergroup.count == 0 {
//                            self.foundView.isHidden = false
                        }
                        else {
//                            self.foundView.isHidden = true
                        }
                    }
                }
                else {
                    self.spinner.stopAnimating()
                    self.tblGrouplist.tableFooterView?.isHidden = true
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrUsergroup.count == 0 {
//                        self.foundView.isHidden = false
                    }
                    else {
//                        self.foundView.isHidden = true
                    }
                }
            }
                self.spinner.stopAnimating()
                self.tblGrouplist.tableFooterView?.isHidden = true
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
                if self.arrUsergroup.count == 0 {
//                    self.foundView.isHidden = false
                }
                else {
//                    self.foundView.isHidden = true
                }
        }
    }
    
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

extension JoinedMeGroupViewController: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsergroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblGrouplist.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblJoinedMeGroup
        cell.imgGroup.layer.cornerRadius = 5
        cell.imgGroup.clipsToBounds = true
        cell.lblGroupname.text = arrUsergroup[indexPath.row].name
        let strImg = arrUsergroup[indexPath.row].avatar_url_custom
        url = URL(string: strImg)
        cell.imgGroup.sd_setImage(with: url, completed: nil)
        cell.lblpublic.text = arrUsergroup[indexPath.row].type_group
        cell.btnJoined.layer.cornerRadius = 5
        cell.btnJoined.clipsToBounds = true
        cell.btnJoined.addTarget(self, action: #selector(JoinedMeGroupViewController.btnjoinedAction), for: UIControl.Event.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = arrUsergroup[indexPath.row].username
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "navigationLoaderpageredirection")as! navigationLoaderpageredirection
        obj.strUser = username
//                    self.navigationController?.pushViewController(obj, animated: true)
        obj.modalPresentationStyle = .fullScreen
        self.present(obj, animated: false, completion: nil)
        
//        let group_Type = arrUsergroup[indexPath.row].type_group
//        let status_group = arrUsergroup[indexPath.row].status
//        let is_page_admin = arrUsergroup[indexPath.row].is_page_admin
//        let post_privacy = arrUsergroup[indexPath.row].post_privacy
//        let member_privacy = arrUsergroup[indexPath.row].member_privacy
//        loggdenUser.set(username, forKey: UNAME)
//        loggdenUser.set(username, forKey: USERNAME)
//        loggdenUser.set(username, forKey: GROUPUSERNAME)
//        loggdenUser.set(username, forKey: PAGEUSERNAME)
        
//        let myprofile = loggdenUser.value(forKey: USERNAME)as! String
//
//
////            if type == "user" {
//            if myprofile == username {
////                currentTabBar?.setIndex(4)
//
//                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
////                loggdenUser.set(username, forKey: FRIENDSUSERNAME)
////                obj.strUserName = username
//                //self.navigationController?.pushViewController(obj, animated: false)
//                obj.modalPresentationStyle = .fullScreen
//                self.present(obj, animated: false, completion: nil)
//            }
//            else {
//
//                let obj = self.storyboard?.instantiateViewController(withIdentifier: "navigationLoaderpageredirection")as! navigationLoaderpageredirection
//                obj.strUser = username
////                    self.navigationController?.pushViewController(obj, animated: true)
//                obj.modalPresentationStyle = .fullScreen
//                self.present(obj, animated: false, completion: nil)
//            }
        
//            if is_page_admin == 0 {
//                if group_Type == "closed" {
//                    if status_group == "join" {
//                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                           // self.navigationController?.pushViewController(obj, animated: true)
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                    }
//                    else if status_group == "pending" {
//                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                    }
//                    else if status_group == "joined" {
//                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                    }
//                }
//                else if group_Type == "open" {
//                    if status_group == "joined" {
//                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                    }
//                    else {
//                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                    }
//                }
//                else {
//                    if status_group == "joined" {
//                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openAndSecretGroupController")as! openAndSecretGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                    }
//                    else {
//                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openAndSecretGroupController")as! openAndSecretGroupController
//                            obj.strUserName = username
//                            obj.onlyPost = post_privacy
//                            obj.onlyInvaite = member_privacy
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                    }
//                }
//            }
//            else {
//                if group_Type == "closed" {
//                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "GroupProfileViewController")as! GroupProfileViewController
//                    obj.strUserName = username
//                    obj.onlyPost = post_privacy
//                    obj.onlyInvaite = member_privacy
//                    obj.modalPresentationStyle = .fullScreen
//                    //self.navigationController?.pushViewController(obj, animated: true)
//                    self.present(obj, animated: false, completion: nil)
//                }
//                else if group_Type == "open" {
//                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                    obj.strUserName = username
//                    obj.onlyPost = post_privacy
//                    obj.onlyInvaite = member_privacy
//                    obj.modalPresentationStyle = .fullScreen
//                    //self.navigationController?.pushViewController(obj, animated: true)
//                    self.present(obj, animated: false, completion: nil)
//                }
//                else {
//                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
//                    obj.strUserName = username
//                    obj.onlyPost = post_privacy
//                    obj.onlyInvaite = member_privacy
//                    obj.modalPresentationStyle = .fullScreen
//                    //self.navigationController?.pushViewController(obj, animated: true)
//                    self.present(obj, animated: false, completion: nil)
//                }
//            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            timeline_id = arrUsergroup[indexPath.row].timeline_id
            let refreshAlert = UIAlertController(title: "Notification", message: "Are you sure to delete?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.arrUsergroup.remove(at: indexPath.row)
                self.tblGrouplist.deleteRows(at: [indexPath], with: .fade)
                let parameters = ["timeline_id":self.timeline_id]
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let headers: HTTPHeaders = ["Xapi": XAPI,
                               "Accept" : ACCEPT,
                               "Authorization":BEARERTOKEN]
                self.wc.callSimplewebservice(url: JOINGROUPREMOVE, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: joinedgroupRemoveReponseModel?) in
                    
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tblGrouplist
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblGrouplist.bounds.width, height: CGFloat(44))
                pageCount += 1
                print(pageCount)
                getGroup(strPage: "\(pageCount)")
                self.tblGrouplist.tableFooterView = spinner
                self.tblGrouplist.tableFooterView?.isHidden = false
            }
        }
    }
    
    @objc func btnjoinedAction(_ sender: UIButton) {
        
//         if let indexPath = self.tblGrouplist.indexPathForView(sender) {
//            let refreshAlert = UIAlertController(title: "Notification", message: "Are you sure to delete?", preferredStyle: UIAlertController.Style.alert)
//
//            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                let group_id = loggdenUser.value(forKey: GROUPID)as! Int
//                let parameters = ["group_id": group_id]as [String : Any]
//                let token = loggdenUser.value(forKey: TOKEN)as! String
//                let BEARERTOKEN = BEARER + token
//                let headers: HTTPHeaders = ["Xapi": XAPI,
//                                            "Accept" : ACCEPT,
//                                            "Authorization":BEARERTOKEN]
//                self.wc.callSimplewebservice(url: GROUPDELETE, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: GroupDeleteResponsModel?) in
//                    if sucess {
//
//                    }
//                }
//            }))
//
//            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//            }))
//
//            present(refreshAlert, animated: true, completion: nil)
//        }
    }
    
}

extension JoinedMeGroupViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSugestgroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let suggested = arrSugestgroup[indexPath.item]
        let cell = collectionSuggestedGroup.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! SuggestGroupCell
        let image = (suggested as AnyObject).value(forKey: "avatar_url")as! String
        url = URL(string: image)
        cell.image.sd_setImage(with: url, completed: nil)
        cell.lblTitle.text = (suggested as AnyObject).value(forKey: "name")as? String
        cell.btnclick.tag = indexPath.row
        cell.btnjoin.addTarget(self, action: #selector(JoinedMeGroupViewController.btnjoinedActionopen), for: .touchUpInside)
        cell.btnclick.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return cell
    }
    
    
    @objc func btnClick(_ sender: UIButton){
        let suggested = arrSugestgroup[sender.tag]
        let username = (suggested as AnyObject).value(forKey: "username")as? String//arrSugestgroup[sender.tag].username
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "navigationLoaderpageredirection")as! navigationLoaderpageredirection
        obj.strUser = username ?? ""
//                    self.navigationController?.pushViewController(obj, animated: true)
        obj.modalPresentationStyle = .fullScreen
        self.present(obj, animated: false, completion: nil)
        
//        let group_Type = (suggested as AnyObject).value(forKey: "type_group")as? String//arrSugestgroup[indexPath.row].type_group
//        let status_group = (suggested as AnyObject).value(forKey: "status")as? String//arrSugestgroup[indexPath.row].status
//        let is_page_admin = (suggested as AnyObject).value(forKey: "is_page_admin")as? String//arrSugestgroup[indexPath.row].is_page_admin
//        let post_privacy = (suggested as AnyObject).value(forKey: "post_privacy")as? String//arrSugestgroup[indexPath.row].post_privacy
//        let member_privacy = (suggested as AnyObject).value(forKey: "member_privacy")as? String//arrSugestgroup[indexPath.row].member_privacy
//           // if is_page_admin == 0 {
//
//        let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//        obj.strUserName = username ?? ""
//        obj.onlyPost = post_privacy ?? ""
//        obj.onlyInvaite = member_privacy ?? ""
//        obj.modalPresentationStyle = .fullScreen
//        //self.navigationController?.pushViewController(obj, animated: true)
//        self.present(obj, animated: false, completion: nil)
        
//                if group_Type == "closed" {
//
//                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username ?? ""
//                            obj.onlyPost = post_privacy ?? ""
//                            obj.onlyInvaite = member_privacy ?? ""
//                           // self.navigationController?.pushViewController(obj, animated: true)
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username ?? ""
//                            obj.onlyPost = post_privacy ?? ""
//                            obj.onlyInvaite = member_privacy ?? ""
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username ?? ""
//                            obj.onlyPost = post_privacy ?? ""
//                            obj.onlyInvaite = member_privacy ?? ""
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "only_admins" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username ?? ""
//                            obj.onlyPost = post_privacy ?? ""
//                            obj.onlyInvaite = member_privacy ?? ""
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "members" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username ?? ""
//                            obj.onlyPost = post_privacy ?? ""
//                            obj.onlyInvaite = member_privacy ?? ""
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//                        else if member_privacy == "members" && post_privacy == "everyone" {
//                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
//                            obj.strUserName = username ?? ""
//                            obj.onlyPost = post_privacy ?? ""
//                            obj.onlyInvaite = member_privacy ?? ""
//                            obj.modalPresentationStyle = .fullScreen
//                            //self.navigationController?.pushViewController(obj, animated: true)
//                            self.present(obj, animated: false, completion: nil)
//                        }
//
//
//                }
//                else if group_Type == "open" {
//
//                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
//                    obj.strUserName = username ?? ""
//                    obj.onlyPost = post_privacy ?? ""
//                    obj.onlyInvaite = member_privacy ?? ""
//                    obj.modalPresentationStyle = .fullScreen
//                    //self.navigationController?.pushViewController(obj, animated: true)
//                    self.present(obj, animated: false, completion: nil)
////                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
////                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
////                            obj.strUserName = username ?? ""
////                            obj.onlyPost = post_privacy ?? ""
////                            obj.onlyInvaite = member_privacy ?? ""
////                            obj.modalPresentationStyle = .fullScreen
////                            //self.navigationController?.pushViewController(obj, animated: true)
////                            self.present(obj, animated: false, completion: nil)
////                        }
////                        else if member_privacy == "only_admins" && post_privacy == "members" {
////                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
////                            obj.strUserName = username ?? ""
////                            obj.onlyPost = post_privacy ?? ""
////                            obj.onlyInvaite = member_privacy ?? ""
////                            obj.modalPresentationStyle = .fullScreen
////                            //self.navigationController?.pushViewController(obj, animated: true)
////                            self.present(obj, animated: false, completion: nil)
////                        }
////                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
////                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
////                            obj.strUserName = username ?? ""
////                            obj.onlyPost = post_privacy ?? ""
////                            obj.onlyInvaite = member_privacy ?? ""
////                            obj.modalPresentationStyle = .fullScreen
////                            //self.navigationController?.pushViewController(obj, animated: true)
////                            self.present(obj, animated: false, completion: nil)
////                        }
////                        else if member_privacy == "members" && post_privacy == "only_admins" {
////                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
////                            obj.strUserName = username ?? ""
////                            obj.onlyPost = post_privacy ?? ""
////                            obj.onlyInvaite = member_privacy ?? ""
////                            obj.modalPresentationStyle = .fullScreen
////                            //self.navigationController?.pushViewController(obj, animated: true)
////                            self.present(obj, animated: false, completion: nil)
////                        }
////                        else if member_privacy == "members" && post_privacy == "members" {
////                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
////                            obj.strUserName = username ?? ""
////                            obj.onlyPost = post_privacy ?? ""
////                            obj.onlyInvaite = member_privacy ?? ""
////                            obj.modalPresentationStyle = .fullScreen
////                            //self.navigationController?.pushViewController(obj, animated: true)
////                            self.present(obj, animated: false, completion: nil)
////                        }
////                        else if member_privacy == "members" && post_privacy == "everyone" {
////                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
////                            obj.strUserName = username ?? ""
////                            obj.onlyPost = post_privacy ?? ""
////                            obj.onlyInvaite = member_privacy ?? ""
////                            obj.modalPresentationStyle = .fullScreen
////                            //self.navigationController?.pushViewController(obj, animated: true)
////                            self.present(obj, animated: false, completion: nil)
////                        }
//
//                }
//

        
    }
    
    @objc func btnjoinedActionopen(_ sender: UIButton) {
       if let indexPath = self.collectionSuggestedGroup.indexPathForView(sender) {
        let cell = collectionSuggestedGroup.cellForItem(at: indexPath)as! SuggestGroupCell
        let groupTimeline_id = (self.arrSugestgroup[indexPath.row]as AnyObject).value(forKey: "timeline_id")as! Int
        
        let parameters = ["timeline_id":groupTimeline_id]
              let token = loggdenUser.value(forKey: TOKEN)as! String
              let BEARERTOKEN = BEARER + token
              let headers: HTTPHeaders = ["Xapi": XAPI,
                                          "Accept" : ACCEPT,
                                          "Authorization":BEARERTOKEN]
              self.wc.callSimplewebservice(url: JOINGROUPREMOVE, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: joinedgroupRemoveReponseModel?) in
                  if sucess {
                      let joined = response?.joined
                      if joined! {
                        cell.btnjoin.setTitle("Joined", for: .normal)
                      }
                      else {
                          cell.btnjoin.setTitle("Join", for: .normal)
                      }
                  }
              }
        }
    }
}

class SuggestGroupCell: UICollectionViewCell {
    
    @IBOutlet weak var btnjoin: UIButton! {
    didSet {
            btnjoin.layer.cornerRadius = 5
            btnjoin.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var btnclick: UIButton!
}
