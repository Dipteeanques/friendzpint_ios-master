//
//  GroupAdminController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 10/07/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class GroupAdminController: UIViewController {

    @IBOutlet weak var tblAdmin: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: Foundview!
    
    
    var wc = Webservice.init()
    var arrAdmin = [AdminList]()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var url: URL?
    var User_Id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(GroupAdminController.getAdminMember), name: NSNotification.Name(rawValue: "Admins"), object: nil)
    }
    
    @objc func getAdminMember(_ notification: NSNotification) {
        loaderView.isHidden = false
        activity.startAnimating()
        getAdmin()
        pageCount = 1
    }
    
    func getAdmin() {
        let group_id = loggdenUser.value(forKey: GROUPID)as! Int
        let username = loggdenUser.value(forKey: GROUPUSERNAME)as! String
        let parameters = ["group_id":group_id,
                          "username":username] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: GROUPADMINLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: GroupAminListResponse?) in
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
                    let data = response?.data
                    let arr_dict = data?.data
                    self.arrAdmin = arr_dict!
                    self.tblAdmin.reloadData()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrAdmin.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
                self.spinner.stopAnimating()
                self.tblAdmin.tableFooterView?.isHidden = true
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
                if self.arrAdmin.count == 0 {
                    self.foundView.isHidden = false
                }
                else {
                    self.foundView.isHidden = true
                }
            }
            self.spinner.stopAnimating()
            self.tblAdmin.tableFooterView?.isHidden = true
            self.loaderView.isHidden = true
            self.activity.stopAnimating()
            if self.arrAdmin.count == 0 {
                self.foundView.isHidden = false
            }
                else {
                self.foundView.isHidden = true
            }
        }
    }
    
    func getAdmin(strPage : String) {
        let group_id = loggdenUser.value(forKey: GROUPID)as! Int
        let username = loggdenUser.value(forKey: GROUPUSERNAME)as! String
        let parameters = ["group_id":group_id,
                          "username":username,
                          "page" : strPage] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: GROUPADMINLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: GroupAminListResponse?) in
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
                    let data = response?.data
                    let arr_dict = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrAdmin.insert(arr_dict![i], at: 0)
                        self.tblAdmin.beginUpdates()
                        self.tblAdmin.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        self.tblAdmin.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblAdmin.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrAdmin.count == 0 {
                            self.foundView.isHidden = false
                        }
                        else {
                            self.foundView.isHidden = true
                        }
                    }
                }
                self.spinner.stopAnimating()
                self.tblAdmin.tableFooterView?.isHidden = true
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
                if self.arrAdmin.count == 0 {
                    self.foundView.isHidden = false
                }
                else {
                    self.foundView.isHidden = true
                }
            }
            self.spinner.stopAnimating()
            self.tblAdmin.tableFooterView?.isHidden = true
            self.loaderView.isHidden = true
            self.activity.stopAnimating()
            if self.arrAdmin.count == 0 {
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

extension GroupAdminController : UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAdmin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblAdmin.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(101)as! UIImageView
        let btnAdmin = cell.viewWithTag(103)as! UIButton
        let lblname = cell.viewWithTag(102)as! UILabel
        lblname.text = arrAdmin[indexPath.row].name
        let strimg = arrAdmin[indexPath.row].avatar
        url = URL(string: strimg)
        img.sd_setImage(with: url, completed: nil)
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        let is_page_admin = arrAdmin[indexPath.row].is_page_admin
        if arrAdmin.count == 1 {
            btnAdmin.isHidden = true
        }
        else {
            if is_page_admin == 1 {
                btnAdmin.isHidden = false
                btnAdmin.addTarget(self, action: #selector(PageMembersController.btnAdminAction), for: UIControl.Event.touchUpInside)
                btnAdmin.layer.cornerRadius = 5
                btnAdmin.clipsToBounds = true
            }
            else {
                btnAdmin.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let selectedUsername = arrAdmin[indexPath.row].username
        if selectedUsername == username {
            currentTabBar?.setIndex(4)
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
        if scrollView == tblAdmin {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblAdmin.bounds.width, height: CGFloat(44))
                pageCount += 1
                getAdmin(strPage: "\(pageCount)")
                self.tblAdmin.tableFooterView = spinner
                self.tblAdmin.tableFooterView?.isHidden = false
            }
        }
    }
    @objc func btnAdminAction(_ sender: UIButton) {
        if let indexPath = self.tblAdmin.indexPathForView(sender) {
            User_Id = arrAdmin[indexPath.row].id
            let group_id = loggdenUser.value(forKeyPath: GROUPID)as! Int
            self.arrAdmin.remove(at: indexPath.row)
            self.tblAdmin.deleteRows(at: [indexPath], with: .left)
            let parameters = ["group_id" : group_id,
                              "user_id":User_Id,
                              "member_role": 2] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callSimplewebservice(url: MEMBER_UPDATE_ROLE, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: AssignModelResponseModel?) in
                if sucess {
                    let res = response?.success
                    if res! {
                        if self.arrAdmin.count == 1 {
                             self.getAdmin()
                        }
                        else {
                            print("jekil")
                        }
                    }
                }
            }
        }
    }
}
