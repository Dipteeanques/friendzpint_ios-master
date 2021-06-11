//
//  MyfriendsController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 26/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ProfileGuestEventController: UIViewController {
    
    @IBOutlet weak var tblEvent: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: UIView!
    
    var arrFollow = [UserEventList]()
    var url: URL?
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var wc = Webservice.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileGuestEventController.Guestevents), name: NSNotification.Name(rawValue: "Guestevents"), object: nil)
        getEvent()
    }
    
    @objc func Guestevents(_ notification: NSNotification) {
        loaderView.isHidden = false
        activity.startAnimating()
        getEvent()
        pageCount = 1
    }
    
    func getEvent() {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username":username]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: EVENT_GUESTS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: UserEventGroupResponseModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    self.arrFollow = arr_dict!
                    self.tblEvent.reloadData()
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
                    self.tblEvent.tableFooterView?.isHidden = true
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
                self.tblEvent.tableFooterView?.isHidden = true
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
    
    func getEvent(strPage : String) {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username":username,
                          "page" : strPage]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: EVENT_GUESTS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: UserEventGroupResponseModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrFollow.insert(arr_dict![i], at: 0)
                        self.tblEvent.beginUpdates()
                        self.tblEvent.insertRows(at: [
                            NSIndexPath(row: self.arrFollow.count-1, section: 0) as IndexPath], with: .fade)
                        self.tblEvent.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblEvent.tableFooterView?.isHidden = true
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
                    self.tblEvent.tableFooterView?.isHidden = true
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
                self.tblEvent.tableFooterView?.isHidden = true
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

extension ProfileGuestEventController : UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFollow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblEvent.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblname = cell.viewWithTag(101)as! UILabel
        let img = cell.viewWithTag(2811)as! UIImageView
        let strimg = arrFollow[indexPath.row].avatar_url
        url = URL(string: strimg)
        img.sd_setImage(with: url, completed: nil)
        lblname.text = arrFollow[indexPath.row].name
        img.layer.cornerRadius = 25
        img.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
        let username = arrFollow[indexPath.row].username
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
        print(username)
        loggdenUser.set(username, forKey: FRIENDSUSERNAME)
        obj.strUserName = username
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tblEvent
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblEvent.bounds.width, height: CGFloat(44))
                pageCount += 1
                print(pageCount)
                getEvent(strPage: "\(pageCount)")
                self.tblEvent.tableFooterView = spinner
                self.tblEvent.tableFooterView?.isHidden = false
            }
        }
    }
}
