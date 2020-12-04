///Users/anquestechnolabs/Desktop/FriendzPoint/DashboardController/GroupView/tblGroupListCell.swift
//  GroupListViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 22/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class FriendsLikedPageController: UIViewController {
    
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var tblGrouplist: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: Foundview!
    
    @IBAction func btnLinkAction(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: linkAD)! as URL)
    }
    var arrLiked = [UserPageLikeList]()
    var url : URL?
    var strUserName = String()
    var wc = Webservice.init()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var decodedData = [Data]()
    var linkAD = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(FriendsLikedPageController.Likedpages), name: NSNotification.Name(rawValue: "Likedpages"), object: nil)
       
        if (loggdenUser.value(forKey: ADlikepage) != nil) {
            decodedData = loggdenUser.value(forKey: ADlikepage) as! [Data]
            for i in 0..<decodedData.count
            {
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode(adsData.self, from: decodedData[i])
                let strImage = decoded?.image
                linkAD = decoded!.link
                let active = decoded?.active
                if active == 1 {
                    url = URL(string: strImage!)
                    imgBanner.sd_setImage(with: url, completed: nil)
                }
                else {
                    viewFooter.height = 0
                }
            }
        }
    }
    
    
    @objc func Likedpages(_ notification: NSNotification) {
        loaderView.isHidden = false
        activity.startAnimating()
        print("likeed")
        getLikedPage()
        pageCount = 1
    }
    
    func getLikedPage() {
        strUserName = loggdenUser.value(forKey: FRIENDSUSERNAME)as! String
        let parameters = ["username":strUserName]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: MY_LIKED_PAGES, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: UserPageLikeGroupResponseModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    self.arrLiked = arr_dict!
                    self.tblGrouplist.reloadData()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrLiked.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
                else {
                    self.spinner.stopAnimating()
                    //self.tblGrouplist.tableFooterView?.isHidden = true
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
                //self.tblGrouplist.tableFooterView?.isHidden = true
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
        strUserName = loggdenUser.value(forKey: FRIENDSUSERNAME)as! String
        let parameters = ["username":strUserName,
                          "page":strPage]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                       "Accept" : ACCEPT,
                       "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: MY_LIKED_PAGES, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: UserPageLikeGroupResponseModel?) in
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
                        //self.tblGrouplist.tableFooterView?.isHidden = true
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
                    //self.tblGrouplist.tableFooterView?.isHidden = true
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
                //self.tblGrouplist.tableFooterView?.isHidden = true
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension FriendsLikedPageController: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLiked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblGrouplist.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblname = cell.viewWithTag(102)as! UILabel
        let img = cell.viewWithTag(101)as! UIImageView
//        let btnUnliked = cell.viewWithTag(103)as! UIButton
//        btnUnliked.addTarget(self, action: #selector(PagelikedViewController.btnUnlikedAction), for: .touchUpInside)
        lblname.text = arrLiked[indexPath.row].name
        let strImg = arrLiked[indexPath.row].avatar
        url = URL(string: strImg)
        img.sd_setImage(with: url, completed: nil)
        img.layer.cornerRadius = 5
        img.clipsToBounds = true
//        btnUnliked.layer.cornerRadius = 5
//        btnUnliked.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageAdmin = arrLiked[indexPath.row].is_page_admin
        let username = arrLiked[indexPath.row].username
        if pageAdmin == 0 {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendPageProfileController")as! FriendPageProfileController
            obj.strUserName = username
            self.navigationController?.pushViewController(obj, animated: false)
        }
        else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MypageProfileViewController")as! MypageProfileViewController
            obj.strUserName = username
            self.navigationController?.pushViewController(obj, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
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
                //self.tblGrouplist.tableFooterView = spinner
                self.tblGrouplist.tableFooterView?.isHidden = false
            }
        }
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            let refreshAlert = UIAlertController(title: "Notification", message: "Are you sure to delete?", preferredStyle: UIAlertController.Style.alert)
    //
    //            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
    //                self.arrgroup.remove(at: indexPath.row)
    //                self.tblGrouplist.deleteRows(at: [indexPath], with: .fade)
    //            }))
    //
    //            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
    //            }))
    //
    //            present(refreshAlert, animated: true, completion: nil)
    //        } else if editingStyle == .insert {
    //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    //        }
    //    }
    
//    @objc func btnUnlikedAction(_ sender: UIButton) {
//        if let indexPath = self.tblGrouplist.indexPathForView(sender) {
//            let liked_timelineid = (self.arrLiked[indexPath.row]as AnyObject).value(forKey: "timeline_id")as! Int
//            let parameters = ["timeline_id":liked_timelineid]as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers = ["Xapi": XAPI,
//                           "Accept" : ACCEPT,
//                           "Authorization":BEARERTOKEN]
//           /* Alamofire.request(PAGE_LIKED,method: .post, parameters: parameters,headers: headers).responseJSON { response in
//                print(response)
//                let dic = response.value as! NSDictionary
//                let liked = dic.value(forKey: "liked")as! Bool
//                if liked {
//                    self.pageLiked()
//                }
//                else {
//                    self.pageLiked()
//                }
//            }*/
//        }
//    }
}
