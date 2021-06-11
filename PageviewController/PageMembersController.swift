//
//  GroupmemberController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 10/07/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class PageMembersController: UIViewController {
    
    @IBOutlet weak var tblmember: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: Foundview!
    
    var wc = Webservice.init()
    var arrAdmin = [MemberListPage]()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var url: URL?
    var User_Id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(PageMembersController.getMemberAction), name: NSNotification.Name(rawValue: "Members"), object: nil)
        
        activity.startAnimating()
        getMember()
    }
    
    
    @objc func getMemberAction(_ notification: NSNotification) {
        loaderView.isHidden = false
        activity.startAnimating()
        getMember()
        pageCount = 1
    }
    
    func getMember() {
        arrAdmin.removeAll()
        let username = loggdenUser.value(forKey: PAGEUSERNAME)as? String
        let parameters = ["username":username ?? ""] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: GETPAGEMEMBER, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: pageMemberListResponseGet?) in
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
                    let data = response?.data
                    let arr_dict = data?.data
                    self.arrAdmin = arr_dict!
                    self.tblmember.reloadData()
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
                self.tblmember.tableFooterView?.isHidden = true
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
            self.tblmember.tableFooterView?.isHidden = true
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
        let username = loggdenUser.value(forKey: PAGEUSERNAME)as! String
        
        let parameters = ["username":username,
                          "page" : strPage] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: GETPAGEMEMBER, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: pageMemberListResponseGet?) in
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
                    let data = response?.data
                    let arr_dict = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrAdmin.insert(arr_dict![i], at: 0)
                        self.tblmember.beginUpdates()
                        self.tblmember.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        self.tblmember.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblmember.tableFooterView?.isHidden = true
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
                self.tblmember.tableFooterView?.isHidden = true
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
            self.tblmember.tableFooterView?.isHidden = true
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

extension PageMembersController : UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAdmin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblmember.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
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
        if is_page_admin == 1 {
            btnAdmin.isHidden = false
            btnAdmin.addTarget(self, action: #selector(PageMembersController.btnAdminAction), for: UIControl.Event.touchUpInside)
            btnAdmin.layer.cornerRadius = 5
            btnAdmin.clipsToBounds = true
        }
        else {
            btnAdmin.isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let selectedUsername = arrAdmin[indexPath.row].username
        if selectedUsername == username {
            currentTabBar?.setIndex(4)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
//            self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            //self.navigationController?.pushViewController(obj, animated: true)
            self.present(obj, animated: false, completion: nil)
        }
        else {
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
//            obj.strUserName = selectedUsername
//            self.navigationController?.pushViewController(obj, animated: true)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "navigationLoaderpageredirection")as! navigationLoaderpageredirection
            obj.strUser = selectedUsername
    //                    self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            self.present(obj, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tblmember {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblmember.bounds.width, height: CGFloat(44))
                if arrAdmin.count == 9 {
                    print("jekil")
                }
                else {
                    pageCount += 1
                    getAdmin(strPage: "\(pageCount)")
                    self.tblmember.tableFooterView = spinner
                    self.tblmember.tableFooterView?.isHidden = false
                }
            }
        }
    }
    
    @objc func btnAdminAction(_ sender: UIButton) {
        if let indexPath = self.tblmember.indexPathForView(sender) {
            User_Id = arrAdmin[indexPath.row].id
            let page_id = loggdenUser.value(forKeyPath: PAGEID)as! Int
            self.arrAdmin.remove(at: indexPath.row)
            self.tblmember.deleteRows(at: [indexPath], with: .left)
            let parameters = ["page_id" : page_id,
                              "user_id":User_Id,
                              "member_role": 1] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callSimplewebservice(url: MEMBER_UPDATEPAGE_ROLE, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: AssignModelResponseModel?) in
                if sucess {
                    let res = response?.success
                    if res! {
                        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Admins"), object: nil)
                    }
                }
            }
        }
    }
    
}
