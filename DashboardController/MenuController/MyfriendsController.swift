//
//  MyfriendsController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 26/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class MyfriendsController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var tblFreinds: UITableView!
    @IBOutlet weak var gredientView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var foundView: LargeFound!
    
    var arrFollow = [FriendList]()
    var url: URL?
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var wc = Webservice.init()
    var strSearchTxt = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView.isHidden = false
        activity.startAnimating()
        setDefault()
    }
    
    func setDefault() {
        
      //  searchbar.delegate = self
        getFriends()
        pageCount = 1
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.gredientView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gredientView.layer.addSublayer(gradientLayer)
        gredientView.addSubview(btnBack)
        gredientView.addSubview(lblTitle)
        if UIScreen.main.bounds.width == 320 {
            
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: gredientView.bounds.origin.x, y: gredientView.bounds.origin.y, width: 414, height: gredientView.bounds.size.height)
        }
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
    
    
    func getFriends() {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username":username,
                          "search":strSearchTxt]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: following, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendListResponseModel?) in
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
    }
    

    @IBAction func btnbackAction(_ sender: UIButton) {
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



extension MyfriendsController : UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFollow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFreinds.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblname = cell.viewWithTag(101)as! UILabel
        let btnRemove = cell.viewWithTag(102)as! UIButton
        let img = cell.viewWithTag(2811)as! UIImageView
        img.layer.cornerRadius = 25
        img.clipsToBounds = true
        btnRemove.layer.cornerRadius = 5
        btnRemove.clipsToBounds = true
        let strimg = arrFollow[indexPath.row].avatar
        url = URL(string: strimg)
        img.sd_setImage(with: url, completed: nil)
        lblname.text = arrFollow[indexPath.row].name
        btnRemove.addTarget(self, action: #selector(MyfriendsController.btnfriendsRemoveAction), for: UIControl.Event.touchUpInside)
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
    
    @objc func btnfriendsRemoveAction(_ sender: UIButton) {
         if let indexPath = self.tblFreinds.indexPathForView(sender) {
            let timeVala_id = arrFollow[indexPath.row].timeline_id
            self.arrFollow.remove(at: indexPath.row)
            self.tblFreinds.deleteRows(at: [indexPath], with: .fade)
            let parameters = ["timeline_id" : timeVala_id]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callSimplewebservice(url: REMOVEFRIENDS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: RemoveFriendsResponseModel?) in
                if sucess {
                    let status = response?.status
                    if status == "200" {
                        print("sucess")
                    }
                }
            }
        }
    }
}
