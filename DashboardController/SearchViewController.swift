//
//  SearchViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 11/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController,UISearchBarDelegate {
    
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var strSearchTxt = String()
    var arrResults = [SearchDataResoponseModel]()
    var wc = Webservice.init()
    let jobCategory = "arrResults"
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setStatusBar(backgroundColor: .black)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        
        self.navigationController?.navigationBar.isHidden = true
        searchBar.delegate = self
        if loggdenUser.value(forKey: self.jobCategory) != nil{
           
            if let savedPerson = loggdenUser.object(forKey:self.jobCategory) as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode([SearchDataResoponseModel].self, from: savedPerson) {
                    self.arrResults = loadedPerson //loggdenUser.value(forKey: self.jobCategory) as! [SearchDataResoponseModel]
                }
            }
            self.tblView.reloadData()
        }
        
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .default
        currentTabBar?.setBar(hidden: false, animated: false)
    }
    
   override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        strSearchTxt = searchText
        getSearch()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func getSearch() {
        let trimmed = strSearchTxt.trimmingCharacters(in: .whitespacesAndNewlines)
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        
        let parameters = ["search":trimmed]
        let headers: HTTPHeaders = ["Xapi": XAPI,
                       "Accept" : ACCEPT,
                       "Authorization":BEARERTOKEN]
         wc.callSimplewebservice(url: HOMESEARCH, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: HomesearchResponseModel?) in
            if sucess {
                self.arrResults = response!.data
                print("response:",response)
//                loggdenUser.set(self.arrResults, forKey:self.jobCategory)
//
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.arrResults) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: self.jobCategory)
                }
                self.tblView.reloadData()
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
    @IBAction func btncancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
//        appDel.gotoDashboardController()
        currentTabBar?.setIndex(0)
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrResults[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = arrResults[indexPath.row].username
        let type = arrResults[indexPath.row].type
        let group_Type = arrResults[indexPath.row].groups_type
        let status_group = arrResults[indexPath.row].groups_status
        let pageAdmin = arrResults[indexPath.row].is_page_admin
        let event_type = arrResults[indexPath.row].event_type
        let invite_privacy = arrResults[indexPath.row].invite_privacy
        let post_privacy = arrResults[indexPath.row].post_privacy
        let member_privacy = arrResults[indexPath.row].member_privacy
        let is_guest = arrResults[indexPath.row].is_guest
        let myprofile = loggdenUser.value(forKey: USERNAME)as! String
        
        
        if type == "user" {
            if myprofile == username {
//                currentTabBar?.setIndex(4)
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
//                loggdenUser.set(username, forKey: FRIENDSUSERNAME)
//                obj.strUserName = username
                //self.navigationController?.pushViewController(obj, animated: false)
                obj.modalPresentationStyle = .fullScreen
                self.present(obj, animated: false, completion: nil)
            }
            else {
                loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
                loggdenUser.set(username, forKey: FRIENDSUSERNAME)
                loggdenUser.set(username, forKey: UNAME)
                obj.strUserName = username
//                self.navigationController?.pushViewController(obj, animated: false)
                obj.modalPresentationStyle = .fullScreen
                self.present(obj, animated: false, completion: nil)
            }
        }
        else if type == "page" {
            if pageAdmin == 0 {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendPageProfileController")as! FriendPageProfileController
                obj.strUserName = username
                obj.onlyPost = post_privacy
                obj.onlyInvaite = invite_privacy
                loggdenUser.set(username, forKey: UNAME)
//                self.navigationController?.pushViewController(obj, animated: false)
                obj.modalPresentationStyle = .fullScreen
                self.present(obj, animated: false, completion: nil)
            }
            else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "MypageProfileViewController")as! MypageProfileViewController
                print(username)
                obj.strUserName = username
                obj.onlyPost = post_privacy
                obj.onlyInvaite = invite_privacy
                loggdenUser.set(username, forKey: UNAME)
//                self.navigationController?.pushViewController(obj, animated: false)
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
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.is_page_admin = pageAdmin
                        loggdenUser.set(username, forKey: UNAME)
//                        self.navigationController?.pushViewController(obj, animated: false)
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
//                        self.navigationController?.pushViewController(obj, animated: false)
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
//                        self.navigationController?.pushViewController(obj, animated: false)
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
//                        self.navigationController?.pushViewController(obj, animated: false)
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
//                        self.navigationController?.pushViewController(obj, animated: false)
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
//                            self.navigationController?.pushViewController(obj, animated: false)
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
//                            self.navigationController?.pushViewController(obj, animated: false)
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
//                            self.navigationController?.pushViewController(obj, animated: false)
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
//                            self.navigationController?.pushViewController(obj, animated: false)
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
//                            self.navigationController?.pushViewController(obj, animated: false)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                    }
                    else {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateEventController")as! PrivateEventController
                        obj.strUserName = username
                        obj.onlyPrivet = "onlyPrivet"
                        loggdenUser.set(username, forKey: UNAME)
//                        self.navigationController?.pushViewController(obj, animated: false)
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
//                self.navigationController?.pushViewController(obj, animated: false)
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
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
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
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
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
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "NewUserJoinGroupController")as! NewUserJoinGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
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
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
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
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
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
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openAndSecretGroupController")as! openAndSecretGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
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
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openAndSecretGroupController")as! openAndSecretGroupController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = member_privacy
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: true)
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
//                    self.navigationController?.pushViewController(obj, animated: true)
                    obj.modalPresentationStyle = .fullScreen
                    self.present(obj, animated: false, completion: nil)
                }
                else if group_Type == "open" {
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
                    obj.strUserName = username
                    obj.onlyPost = post_privacy
                    obj.onlyInvaite = member_privacy
                    loggdenUser.set(username, forKey: UNAME)
//                    self.navigationController?.pushViewController(obj, animated: true)
                    obj.modalPresentationStyle = .fullScreen
                    self.present(obj, animated: false, completion: nil)
                }
                else {
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "UserJoinedGroupViewController")as! UserJoinedGroupViewController
                    obj.strUserName = username
                    obj.onlyPost = post_privacy
                    obj.onlyInvaite = member_privacy
                    loggdenUser.set(username, forKey: UNAME)
//                    self.navigationController?.pushViewController(obj, animated: true)
                    obj.modalPresentationStyle = .fullScreen
                    self.present(obj, animated: false, completion: nil)
                }
            }
        }
    }
}
