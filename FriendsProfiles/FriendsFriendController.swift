//
//  MyfriendsController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 26/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class FriendsFriendController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tblFreinds: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: Foundview!
    
    
    var arr = [["name":"Mayur Godhani","mutul":"25"],["name":"Jekil Dabhoya","mutul":"34"],["name":"Dipak kukadiya","mutul":"15"],["name":"Maulik Bhuva","mutul":"65"],["name":"Manna kathiriya","mutul":"105"],["name":"Piyush Prajapati","mutul":"75"]]
    
    var arrFollow = [FriendList]()
    var url: URL?
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var wc = Webservice.init()
    var strUserName = String()
    var strSearchTxt = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         searchbar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(FriendsFriendController.Friends), name: NSNotification.Name(rawValue: "Friends"), object: nil)
       
    }
    
    @objc func Friends(_ notification: NSNotification) {
        loaderView.isHidden = false
        activity.startAnimating()
        getFriends()
        pageCount = 1
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        strSearchTxt = searchText
        getFriends()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.endEditing(true)
    }
    
    func getFriends() {
        strUserName = loggdenUser.value(forKey: FRIENDSUSERNAME)as! String
        let parameters = ["username":strUserName,
                          "search":strSearchTxt]
        
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
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrFollow.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
                else {
                    self.spinner.stopAnimating()
                    self.tblFreinds.tableFooterView?.isHidden = true
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrFollow.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
            }
                self.spinner.stopAnimating()
                self.tblFreinds.tableFooterView?.isHidden = true
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
                if self.arrFollow.count == 0 {
                    self.foundView.isHidden = false
                }
                else {
                    self.foundView.isHidden = true
                }
        }
    }
    
    
    func friendRequest(strPage : String) {
        strUserName = loggdenUser.value(forKey: FRIENDSUSERNAME)as! String
        let parameters = ["username":strUserName,
                          "search":strSearchTxt,
                          "page" : strPage]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: MYFRIENDS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendListResponseModel?) in
            if sucess {
                let sucessMy = response?.success
                //   let strMsg = response?.message
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrFollow.append(arr_dict![i])
                        self.tblFreinds.beginUpdates()
                        self.tblFreinds.insertRows(at: [
                            NSIndexPath(row: self.arrFollow.count-1, section: 0) as IndexPath], with: .fade)
                        self.tblFreinds.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblFreinds.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrFollow.count == 0 {
                            self.foundView.isHidden = false
                        }
                        else {
                            self.foundView.isHidden = true
                        }
                    }
                }
                else {
                    self.spinner.stopAnimating()
                    self.tblFreinds.tableFooterView?.isHidden = true
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrFollow.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
            }
                self.spinner.stopAnimating()
                self.tblFreinds.tableFooterView?.isHidden = true
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
                if self.arrFollow.count == 0 {
                    self.foundView.isHidden = false
                }
                else {
                    self.foundView.isHidden = true
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

extension FriendsFriendController : UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFollow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFreinds.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblname = cell.viewWithTag(101)as! UILabel
        let img = cell.viewWithTag(2811)as! UIImageView
        let strimg = arrFollow[indexPath.row].avatar
        url = URL(string: strimg)
        img.sd_setImage(with: url, completed: nil)
        lblname.text = arrFollow[indexPath.row].name
        img.layer.cornerRadius = 25
        img.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = arrFollow[indexPath.row].username
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
        obj.strUserName = username
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tblFreinds
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblFreinds.bounds.width, height: CGFloat(44))
                pageCount += 1
                print(pageCount)
                friendRequest(strPage: "\(pageCount)")
                self.tblFreinds.tableFooterView = spinner
                self.tblFreinds.tableFooterView?.isHidden = false
            }
        }
    }
}
