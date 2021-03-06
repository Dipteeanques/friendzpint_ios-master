//
//  FollowersViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 05/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class FollowersViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblFreinds: UITableView!
    @IBOutlet weak var gredientView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var foundView: LargeFound!
    
    var arrFollow = [DatumFollower]()
    var arrFollow1 = [DatumFollower]()
    var url: URL?
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var wc = Webservice.init()
    var strSearchTxt = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblFreinds.delegate = self
        tblFreinds.dataSource = self
        searchBar.delegate = self
        loaderView.isHidden = false
        activity.startAnimating()
        setDefault()
    }
    
    func setDefault() {
        currentTabBar?.setBar(hidden: true, animated: false)
      //  searchbar.delegate = self
        getFriends()
        pageCount = 1
//        let gradientLayer = CAGradientLayer()
//        
//        gradientLayer.frame = self.gredientView.bounds
//        
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        gredientView.layer.addSublayer(gradientLayer)
//        gredientView.addSubview(btnBack)
//        gredientView.addSubview(lblTitle)
//        if UIScreen.main.bounds.width == 320 {
//            
//        } else if UIScreen.main.bounds.width == 414 {
//            gradientLayer.frame = CGRect(x: gredientView.bounds.origin.x, y: gredientView.bounds.origin.y, width: 414, height: gredientView.bounds.size.height)
//        }
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        strSearchTxt = searchText
//        getFriends()
//    }
//
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchbar.endEditing(true)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        arrFollow1.removeAll()
        if let searchText = searchBar.text, !searchText.isEmpty {
            self.arrFollow1 = self.arrFollow.filter { recipe in
                 let ingredients = recipe.name //else { return false }
                return ingredients.lowercased().contains(searchText.lowercased())//ingredients.contains { $0.range(of: searchText, options: .caseInsensitive) != nil }
                
            }
        } else {
            self.arrFollow1 = self.arrFollow
        }

        print("arrFollow1:",arrFollow1)
        tblFreinds.reloadData();
        tblFreinds.reloadInputViews();
//        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.endEditing(true)
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
        wc.callSimplewebservice(url: followers, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FollowersResponsModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    self.arrFollow = arr_dict!
                    self.arrFollow1 = self.arrFollow
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
    /*
    func friendRequest(strPage : String) {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username":username,
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
    }*/
    

    @IBAction func btnbackAction(_ sender: UIButton) {
        self.searchBar.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
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



extension FollowersViewController : UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFollow1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFreinds.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblname = cell.viewWithTag(101)as! UILabel
        let btnRemove = cell.viewWithTag(102)as! UIButton
        let img = cell.viewWithTag(2811)as! UIImageView
//        img.layer.cornerRadius = 25
//        img.clipsToBounds = true
//        btnRemove.layer.cornerRadius = 5
//        btnRemove.clipsToBounds = true
        let strimg = arrFollow1[indexPath.row].avatar
        url = URL(string: strimg)
//        img.sd_setImage(with: url, completed: nil)
        img.sd_setImage(with: url, placeholderImage: UIImage(named: "user"), options: [], completed: nil)
        lblname.text = arrFollow1[indexPath.row].name
        
       

        let is_follow = arrFollow1[indexPath.row].isFollow
        print("is_follow",is_follow)
        if is_follow == 1 {
            btnRemove.setTitle("Unfollow", for: .normal)
        }
        else if is_follow == 0{
            btnRemove.setTitle("Follow", for: .normal)
        }
        
        btnRemove.addTarget(self, action: #selector(self.btnfriendsRemoveAction), for: UIControl.Event.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
        let username = arrFollow1[indexPath.row].username
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
        loggdenUser.set(username, forKey: FRIENDSUSERNAME)
        loggdenUser.set(username, forKey: UNAME)
        obj.strUserName = username
        //self.navigationController?.pushViewController(obj, animated: true)
        present(obj, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
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
               // friendRequest(strPage: "\(pageCount)")
                self.tblFreinds.tableFooterView = spinner
                self.tblFreinds.tableFooterView?.isHidden = false
            }
        }
    }
    
    @objc func btnfriendsRemoveAction(_ sender: UIButton) {
        
        if let indexPath = self.tblFreinds.indexPathForView(sender) {
            print(indexPath)
            let cell = tblFreinds.cellForRow(at: indexPath)
            let btnRemove = cell?.viewWithTag(102)as! UIButton
            let timeVala_id = arrFollow1[indexPath.row].timelineID
            print(timeVala_id)
            
            if  self.arrFollow1[indexPath.row].isFollow == 1{
                btnRemove.setTitle("Follow", for: .normal)
                for i in 0...(self.arrFollow1.count-1){
                    if self.arrFollow1[i].timelineID == timeVala_id{
                        self.arrFollow1[i].isFollow = 0
                    }
                }
            }
            else{
                btnRemove.setTitle("Unfollow", for: .normal)//Unfollow
                for i in 0...(self.arrFollow1.count-1){
                    if self.arrFollow1[i].timelineID == timeVala_id{
                        self.arrFollow1[i].isFollow = 1
                    }
                }
            }
            self.tblFreinds.beginUpdates()
            self.tblFreinds.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            self.tblFreinds.endUpdates()

            let parameters = ["timeline_id" : timeVala_id]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callSimplewebservice(url: FOLLOW, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: FriendsResponsModel?) in
                if sucess {
                    let suc = response?.success
                    if suc! {

                    }
                }
            }
            
        }
        
//         if let indexPath = self.tblFreinds.indexPathForView(sender) {
//            let timeVala_id = arrFollow1[indexPath.row].timelineID
//            self.arrFollow1.remove(at: indexPath.row)
//            self.tblFreinds.deleteRows(at: [indexPath], with: .fade)
//            let parameters = ["timeline_id" : timeVala_id]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//
//            wc.callSimplewebservice(url: REMOVEFRIENDS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: RemoveFriendsResponseModel?) in
//                if sucess {
//                    let status = response?.status
//                    if status == "200" {
//                        print("sucess")
//                    }
//                }
//            }
//        }
    }
}

