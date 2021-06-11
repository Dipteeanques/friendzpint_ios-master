//
//  GroupjoinRequestListController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 01/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class GroupjoinRequestListController: UIViewController {

    
    @IBOutlet weak var tblGroupRequest: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: Foundview!
    
    
    var wc = Webservice.init()
    var arrRequest = [GroupjoinrequestList]()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var url: URL?
    var User_Id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(GroupjoinRequestListController.JoinRequests), name: NSNotification.Name(rawValue: "JoinRequests"), object: nil)
    }
    
    @objc func JoinRequests(_ notification: NSNotification) {
        loaderView.isHidden = false
        activity.startAnimating()
        getJoinreq()
        pageCount = 1
    }
    
    func getJoinreq() {
        let group_id = loggdenUser.value(forKey: GROUPID)as! Int
        let parameters = ["group_id":group_id] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: GROUPJOINREQUESTLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: groupJoinedRequestLisModel?) in
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    self.arrRequest = arr_dict!
                    self.tblGroupRequest.reloadData()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrRequest.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
                else {
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrRequest.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
                
            }
            self.loaderView.isHidden = true
            self.activity.stopAnimating()
            if self.arrRequest.count == 0 {
                self.foundView.isHidden = false
            }
            else {
                self.foundView.isHidden = true
            }
        }
    }
    
    func getRequest(strPage : String) {
        let group_id = loggdenUser.value(forKey: GROUPID)as! Int
        let parameters = ["group_id":group_id] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: GROUPJOINREQUESTLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: groupJoinedRequestLisModel?) in
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrRequest.insert(arr_dict![i], at: 0)
                        self.tblGroupRequest.beginUpdates()
                        self.tblGroupRequest.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        self.tblGroupRequest.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblGroupRequest.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrRequest.count == 0 {
                            self.foundView.isHidden = false
                        }
                        else {
                            self.foundView.isHidden = true
                        }
                    }
                }
                else {
                    self.spinner.stopAnimating()
                    self.tblGroupRequest.tableFooterView?.isHidden = true
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrRequest.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
            }
            self.spinner.stopAnimating()
            self.tblGroupRequest.tableFooterView?.isHidden = true
            self.loaderView.isHidden = true
            self.activity.stopAnimating()
            if self.arrRequest.count == 0 {
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

extension GroupjoinRequestListController: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblGroupRequest.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblcellGroupjoinrequestlist
        cell.imgProfile.layer.cornerRadius = 20
        cell.imgProfile.clipsToBounds = true
        cell.lblName.text = arrRequest[indexPath.row].name
        let strimg = arrRequest[indexPath.row].avatar
        url = URL(string: strimg)
        cell.imgProfile.sd_setImage(with: url, completed: nil)
        cell.btnAccept.layer.cornerRadius = 5
        cell.btnAccept.clipsToBounds = true
        cell.btnDelete.layer.cornerRadius = 5
        cell.btnDelete.clipsToBounds = true
        cell.btnAccept.addTarget(self, action: #selector(GroupjoinRequestListController.btnAcceptAction), for: UIControl.Event.touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(GroupjoinRequestListController.btnDeleteAction), for: UIControl.Event.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usernameUser = loggdenUser.value(forKey: USERNAME)as! String
        let username = arrRequest[indexPath.row].username
        if usernameUser == username {
            currentTabBar?.setIndex(4)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
//            self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            //self.navigationController?.pushViewController(obj, animated: true)
            self.present(obj, animated: false, completion: nil)
        }
        else {
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
//            print(username)
//            obj.strUserName = username
//            //self.navigationController?.pushViewController(obj, animated: true)
//            obj.modalPresentationStyle = .fullScreen
//            //self.navigationController?.pushViewController(obj, animated: true)
//            self.present(obj, animated: false, completion: nil)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "navigationLoaderpageredirection")as! navigationLoaderpageredirection
            obj.strUser = username
    //                    self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            self.present(obj, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tblGroupRequest {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblGroupRequest.bounds.width, height: CGFloat(44))
                if arrRequest.count == 9 {
                    print("jekil")
                }
                else {
                    pageCount += 1
                    getRequest(strPage: "\(pageCount)")
                    self.tblGroupRequest.tableFooterView = spinner
                    self.tblGroupRequest.tableFooterView?.isHidden = false
                }
            }
        }
    }
    
    @objc func btnAcceptAction(_ sender: UIButton) {
        if let indexPath = self.tblGroupRequest.indexPathForView(sender) {
            User_Id = arrRequest[indexPath.row].id
            let group_id = loggdenUser.value(forKeyPath: GROUPID)as! Int
            self.arrRequest.remove(at: indexPath.row)
            self.tblGroupRequest.deleteRows(at: [indexPath], with: .left)
            let parameters = ["group_id" : group_id,
                              "user_id":User_Id] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]

            wc.callSimplewebservice(url: GROUPJOINACCEPT, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: groupjoinrequestAcceptModel?) in
                if sucess {
                    let res = response?.success
                    if res! {
                       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Requested"), object: nil)
                    }
                }
            }
        }
    }
    
    
    @objc func btnDeleteAction(_ sender: UIButton) {
        if let indexPath = self.tblGroupRequest.indexPathForView(sender) {
            User_Id = arrRequest[indexPath.row].id
            let group_id = loggdenUser.value(forKeyPath: GROUPID)as! Int
            self.arrRequest.remove(at: indexPath.row)
            self.tblGroupRequest.deleteRows(at: [indexPath], with: .left)
            let parameters = ["group_id" : group_id,
                              "user_id":User_Id] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callSimplewebservice(url: GROUPJOINREJECT, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: groupjoinrequestREjectedtModel?) in
                if sucess {
                    let res = response?.success
                    if res! {
                       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Requested"), object: nil)
                    }
                }
            }
        }
    }
    
}

