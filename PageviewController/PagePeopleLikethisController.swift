//
//  PagePeopleLikethisController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 09/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class PagePeopleLikethisController: UIViewController {

    @IBOutlet weak var tblPeoplelikeThis: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: Foundview!
    
    var wc = Webservice.init()
    var arrAdmin = [likethispeople]()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var url: URL?
    var User_Id = Int()
    var strUsername = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         NotificationCenter.default.addObserver(self, selector: #selector(PagePeopleLikethisController.getlikeMember), name: NSNotification.Name(rawValue: "Peoplelikethis"), object: nil)
        
        strUsername = loggdenUser.value(forKey: USERNAME) as! String
        setDefault()
    }
    
    @objc func getlikeMember(_ notification: NSNotification) {
        loaderView.isHidden = false
        activity.startAnimating()
        getPeople()
        pageCount = 1
    }
    
    func setDefault(){
        loaderView.isHidden = false
        activity.startAnimating()
        getPeople()
        pageCount = 1
    }
    
    
    func getPeople() {
        let username = loggdenUser.value(forKey: PAGEUSERNAME)as! String
        let parameters = ["username":username] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: PAGE_LIKES, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: Peplelikethis?) in
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
                    let data = response?.data
                    let arr_dict = data?.data
                    self.arrAdmin = arr_dict!
                    self.tblPeoplelikeThis.reloadData()
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
                self.tblPeoplelikeThis.tableFooterView?.isHidden = true
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
            self.tblPeoplelikeThis.tableFooterView?.isHidden = true
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
    
    func getPeople(strPage : String) {
        let username = loggdenUser.value(forKey: PAGEUSERNAME)as! String
        let parameters = ["username":username,
                          "page" : strPage] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: PAGE_LIKES, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: Peplelikethis?) in
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
                    let data = response?.data
                    let arr_dict = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrAdmin.insert(arr_dict![i], at: 0)
                        self.tblPeoplelikeThis.beginUpdates()
                        self.tblPeoplelikeThis.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        self.tblPeoplelikeThis.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblPeoplelikeThis.tableFooterView?.isHidden = true
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
                self.tblPeoplelikeThis.tableFooterView?.isHidden = true
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
            self.tblPeoplelikeThis.tableFooterView?.isHidden = true
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


extension PagePeopleLikethisController : UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAdmin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPeoplelikeThis.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(101)as! UIImageView
        let btnAdmin = cell.viewWithTag(103)as! UIButton
        let lblname = cell.viewWithTag(102)as! UILabel
        lblname.text = arrAdmin[indexPath.row].name
        let strimg = arrAdmin[indexPath.row].avatar
        url = URL(string: strimg)
        img.sd_setImage(with: url, completed: nil)
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        btnAdmin.addTarget(self, action: #selector(PagePeopleLikethisController.btnAdminAction), for: UIControl.Event.touchUpInside)
        btnAdmin.layer.cornerRadius = 5
        btnAdmin.clipsToBounds = true
        let username = arrAdmin[indexPath.row].username
        let is_friend = arrAdmin[indexPath.row].is_friend
        if strUsername == username {
            btnAdmin.isHidden = true
        }
        else {
            if is_friend == 1 {
                btnAdmin.isHidden = true
            }
            else {
                btnAdmin.isHidden = false
            }
        }        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
        let usernameUser = loggdenUser.value(forKey: USERNAME)as! String
        let username = arrAdmin[indexPath.row].username
        if usernameUser == username {
            currentTabBar?.setIndex(4)
        }
        else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
            print(username)
            loggdenUser.set(username, forKey: FRIENDSUSERNAME)
            obj.strUserName = username
//            loggdenUser.setValue(username, forKey: UNAME)
//            self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            //self.navigationController?.pushViewController(obj, animated: true)
            self.present(obj, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tblPeoplelikeThis {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblPeoplelikeThis.bounds.width, height: CGFloat(44))
                pageCount += 1
                getPeople(strPage: "\(pageCount)")
                self.tblPeoplelikeThis.tableFooterView = spinner
                self.tblPeoplelikeThis.tableFooterView?.isHidden = false
            }
        }
    }
    @objc func btnAdminAction(_ sender: UIButton) {
        if let indexPath = self.tblPeoplelikeThis.indexPathForView(sender) {
            let cell = self.tblPeoplelikeThis.cellForRow(at: indexPath)
            let btnFriends = cell!.viewWithTag(103)as! UIButton
            let timeVala_id = arrAdmin[indexPath.row].timeline_id
                let parameters = ["timeline_id" : timeVala_id]
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept" : ACCEPT,
                                            "Authorization":BEARERTOKEN]
                
                wc.callSimplewebservice(url: FOLLOW, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendsResponsModel?) in
                    if sucess {
                        let suc = response?.success
                        if suc! {
//                            let data = response?.data
                            let follow = response?.followed
                            if follow  == true {
                                btnFriends.setTitle("Unfollow", for: .normal)
                            }
                            else {
//                                btnFriends.setTitle("Add Friends", for: .normal)
                                btnFriends.setTitle("Follow", for: .normal)
                            }
                        }
                    }
                }
            }
        }
    

    }

