//
//  ChatFriendsSearchview.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 20/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ChatFriendsSearchview: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tblFreinds: UITableView!
    
    
    var arrFollow = [FriendList]()
    var url: URL?
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var wc = Webservice.init()
    var strSearchTxt = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchbar.delegate = self
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .default
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
//    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        strSearchTxt = searchText
        getFriends()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.endEditing(true)
    }
    
    
    func getFriends() {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username":username,
                          "search":strSearchTxt]
        print(parameters)
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: MYFRIENDS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendListResponseModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    self.arrFollow = arr_dict!
                    self.tblFreinds.reloadData()
                }
            }
        }
    }
    @IBAction func btnCancelAction(_ sender: UIButton) {
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


extension ChatFriendsSearchview: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFollow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFreinds.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrFollow[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
        let username = arrFollow[indexPath.row].username
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
        loggdenUser.set(username, forKey: FRIENDSUSERNAME)
        obj.strUserName = username
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
