///Users/anquestechnolabs/Desktop/FriendzPoint/DashboardController/GroupView/tblGroupListCell.swift
//  GroupListViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 22/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class EventlistControllerview: UIViewController {
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblGrouplist: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: LargeFound!
    
    var arrLiked = [eventList]()
    var url : URL?
    var strUserName = String()
    var wc = Webservice.init()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView.isHidden = false
        activity.startAnimating()
        setDefault()
         NotificationCenter.default.addObserver(self, selector: #selector(EventlistControllerview.createEvent), name: NSNotification.Name(rawValue: "createdevent"), object: nil)
    }
    
    @objc func createEvent(_ notification: NSNotification) {
        eventGet()
        pageCount = 1
    }
    
    func setDefault() {
        eventGet()
        pageCount = 1
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.headerview.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerview.layer.addSublayer(gradientLayer)
        headerview.addSubview(btnBack)
        headerview.addSubview(lblTitle)
        
        
        if UIScreen.main.bounds.width == 320 {
            
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerview.bounds.origin.x, y: headerview.bounds.origin.y, width: 414, height: headerview.bounds.size.height)
        }
    }
    
    func eventGet() {
        strUserName = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username":strUserName]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: EVENTS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: MyeventList?) in
            print(response)
            if sucess {
                let sucessMy = response?.success
                //   let strMsg = response?.message
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    self.arrLiked = arr_dict!
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrLiked.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                        self.tblGrouplist.reloadData()
                    }
                }
            }
            self.loaderView.isHidden = true
            self.activity.stopAnimating()
            if self.arrLiked.count == 0 {
                self.foundView.isHidden = false
            }
            else {
                self.foundView.isHidden = true
            }
        }
    }
    
    func pageLiked(strPage : String) {
        strUserName = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username":strUserName,
                          "page":strPage]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: EVENTS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: MyeventList?) in
            
            if sucess {
                let sucessMy = response?.success
                //   let strMsg = response?.message
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrLiked.append(arr_dict![i])
                        self.tblGrouplist.beginUpdates()
                        self.tblGrouplist.insertRows(at: [
                            NSIndexPath(row: self.arrLiked.count-1, section: 0) as IndexPath], with: .fade)
                        self.tblGrouplist.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblGrouplist.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrLiked.count == 0 {
                            self.foundView.isHidden = false
                        }
                        else {
                            self.foundView.isHidden = true
                        }
                    }
                }
                else {
                    self.spinner.stopAnimating()
                    self.tblGrouplist.tableFooterView?.isHidden = true
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrLiked.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
            }
            self.spinner.stopAnimating()
            self.tblGrouplist.tableFooterView?.isHidden = true
            self.loaderView.isHidden = true
            self.activity.stopAnimating()
            if self.arrLiked.count == 0 {
                self.foundView.isHidden = false
            }
            else {
                self.foundView.isHidden = true
            }
        }
    }
    @IBAction func btnFlottingAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "EventCreateController")as! EventCreateController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
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

extension EventlistControllerview: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLiked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblGrouplist.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblname = cell.viewWithTag(102)as! UILabel
        let img = cell.viewWithTag(101)as! UIImageView
        //   let btnUnliked = cell.viewWithTag(103)as! UIButton
        // btnUnliked.addTarget(self, action: #selector(PagelikedViewController.btnUnlikedAction), for: .touchUpInside)
        lblname.text = arrLiked[indexPath.row].name
        let strImg = arrLiked[indexPath.row].avatar_url
        url = URL(string: strImg)
//        img.sd_setImage(with: url, completed: nil)
        img.sd_setImage(with: url, placeholderImage: UIImage(named: "user"), options: [], completed: nil)
        img.layer.cornerRadius = 5
        img.clipsToBounds = true
        //        btnUnliked.layer.cornerRadius = 5
        //        btnUnliked.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = arrLiked[indexPath.row].username
        let type = arrLiked[indexPath.row].type
//        if type == "private" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "EventProfileController")as! EventProfileController
            obj.strUserName = username
            self.navigationController?.pushViewController(obj, animated: false)
//        }
//        else {
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PublicEventProfileController")as! PublicEventProfileController
//            obj.strUserName = username
//            self.navigationController?.pushViewController(obj, animated: false)
//        }
//
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event_id = self.arrLiked[indexPath.row].id
            let refreshAlert = UIAlertController(title: "Notification", message: "Are you sure to delete?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.arrLiked.remove(at: indexPath.row)
                self.tblGrouplist.deleteRows(at: [indexPath], with: .fade)
                let parameters = ["event_id":event_id]as [String : Any]
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept" : ACCEPT,
                                            "Authorization":BEARERTOKEN]
                self.wc.callSimplewebservice(url: EVENT_DELETE, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: eventDeleteResponsModel?) in
                    
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tblGrouplist
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblGrouplist.bounds.width, height: CGFloat(44))
                pageCount += 1
                print(pageCount)
                pageLiked(strPage: "\(pageCount)")
                self.tblGrouplist.tableFooterView = spinner
                self.tblGrouplist.tableFooterView?.isHidden = false
            }
        }
    }
    
    @objc func btnUnlikedAction(_ sender: UIButton) {
        
    }
}
