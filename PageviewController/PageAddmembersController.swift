//
//  GroupAddMemberController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 10/07/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class PageAddmembersController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var foundView: Foundview!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tblMemberFriends: UITableView!
    var selectedTag = [TagList]()
    var strSearchTxt = String()
    var arrResults = [searchmemberListPage]()
    var wc = Webservice.init()
    var url: URL?
    var arrSelected = NSMutableArray()
    var User_Id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        strSearchTxt = searchText
        getSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        searchBar.endEditing(true)
        getSearch()
    }
    
    func getSearch() {
        let page_id = loggdenUser.value(forKeyPath: PAGEID)as! Int
        let trimmed = strSearchTxt.trimmingCharacters(in: .whitespacesAndNewlines)
        let parameters = ["page_id": page_id,
                          "searchname":trimmed] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: GET_MEMBERS_JOIN, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: pageSearchAddmemberrespons?) in
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
                    self.arrResults = response!.data
                    self.tblMemberFriends.reloadData()
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

extension PageAddmembersController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMemberFriends.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblcellPageaddmembercontroller
        cell.lblName.text = arrResults[indexPath.row].name
        cell.imgProfile.layer.cornerRadius = 20
        cell.imgProfile.clipsToBounds = true
        let imgstr = arrResults[indexPath.row].image
        url = URL(string: imgstr)
        cell.imgProfile.sd_setImage(with: url, completed: nil)
        cell.btnJoin.layer.cornerRadius = 5
        cell.btnJoin.clipsToBounds = true
        cell.btnJoin.addTarget(self, action: #selector(PageAddmembersController.btnJoinAction), for: UIControl.Event.touchUpInside)
        let user_status = arrResults[indexPath.row].is_join
        if user_status == 0 {
            cell.btnJoin.setTitle("Join", for: .normal)
        }else {
            cell.btnJoin.setTitle("Joined", for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let selectedUsername = arrResults[indexPath.row].username
        if selectedUsername == username {
            currentTabBar?.setIndex(4)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
//            self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            //self.navigationController?.pushViewController(obj, animated: true)
            self.present(obj, animated: false, completion: nil)
        }
        else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
            obj.strUserName = selectedUsername
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @objc func btnJoinAction(_ sender : UIButton) {
        if let indexPath = self.tblMemberFriends.indexPathForView(sender) {
            let cell = tblMemberFriends.cellForRow(at: indexPath) as! tblcellPageaddmembercontroller
            User_Id = arrResults[indexPath.row].id
            let user_status = arrResults[indexPath.row].is_join
            var statusJoin = String()
            if user_status == 0 {
                statusJoin = "Join"
                cell.btnJoin.setTitle("Joined", for: .normal)
            }else {
                statusJoin = "Joined"
                cell.btnJoin.setTitle("Join", for: .normal)
            }
            let page_id = loggdenUser.value(forKeyPath: PAGEID)as! Int
            
            let parameters = ["page_id" : page_id,
                              "user_id":User_Id,
                              "user_status":statusJoin] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callSimplewebservice(url: ADD_PAGE_MEMBERS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: JoinandUnjoinedResponse?) in
                if sucess {
                    
                    let message = response?.message
                    if message == "successfully added" {
                        self.arrResults = self.arrResults.map{
                            var mutableBook = $0
                            if $0.id == self.User_Id {
                                mutableBook.is_join = 1
                            }
                            return mutableBook
                        }
                        self.tblMemberFriends.beginUpdates()
                        self.tblMemberFriends.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                        self.tblMemberFriends.endUpdates()
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Members"), object: nil)
                    }
                    else {
                        self.arrResults = self.arrResults.map{
                            var mutableBook = $0
                            if $0.id == self.User_Id {
                                mutableBook.is_join = 0
                            }
                            return mutableBook
                        }
                        self.tblMemberFriends.beginUpdates()
                        self.tblMemberFriends.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                        self.tblMemberFriends.endUpdates()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Members"), object: nil)
                    }
                }
            }
        }
    }
}
