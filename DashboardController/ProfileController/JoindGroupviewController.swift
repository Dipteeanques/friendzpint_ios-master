///Users/anquestechnolabs/Desktop/FriendzPoint/DashboardController/GroupView/tblGroupListCell.swift
//  GroupListViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 22/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class JoindGroupviewController: UIViewController {
    
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var tblGrouplist: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: Foundview!
    
    @IBAction func btnLinkAction(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: linkAD)! as URL)
    }
    var arrUsergroup = [UserJointGroupList]()
    var url : URL?
    var timeline_id = Int()
    var strUserName = String()
    var wc = Webservice.init()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var decodedData = [Data]()
    var linkAD = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(JoindGroupviewController.Joinedgroups), name: NSNotification.Name(rawValue: "Joinedgroups"), object: nil)
        
        
//        pageCount = 1
        if (loggdenUser.value(forKey: ADjoingroup) != nil) {
            decodedData = loggdenUser.value(forKey: ADjoingroup) as! [Data]
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
        setDefault()
    }
    
    func setDefault(){
        loaderView.isHidden = false
        activity.startAnimating()
        getJoinedGroup()
        pageCount = 1
    }
    
    @objc func Joinedgroups(_ notification: NSNotification) {
        loaderView.isHidden = false
        activity.startAnimating()
        getJoinedGroup()
        pageCount = 1
    }
    
    func getJoinedGroup() {
        strUserName = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username":strUserName]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: JOINGROUPLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: UserJointGroupResponseModel?) in
            if sucess {
                print(response)
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    self.arrUsergroup = arr_dict!
                    self.tblGrouplist.reloadData()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrUsergroup.count == 0 {
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
                    if self.arrUsergroup.count == 0 {
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
                if self.arrUsergroup.count == 0 {
                    self.foundView.isHidden = false
                }
                else {
                    self.foundView.isHidden = true
                }
        }
    }
    
    func getGroup(strPage : String) {
         strUserName = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username":strUserName,
                          "page":strPage]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                       "Accept" : ACCEPT,
                       "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: JOINGROUPLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: UserJointGroupResponseModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict  = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrUsergroup.append(arr_dict![i])
                        self.tblGrouplist.beginUpdates()
                        self.tblGrouplist.insertRows(at: [
                            NSIndexPath(row: self.arrUsergroup.count-1, section: 0) as IndexPath], with: .fade)
                        self.tblGrouplist.endUpdates()
                        self.spinner.stopAnimating()
                       // self.tblGrouplist.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrUsergroup.count == 0 {
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
                    if self.arrUsergroup.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
            }
                self.spinner.stopAnimating()
               // self.tblGrouplist.tableFooterView?.isHidden = true
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
                if self.arrUsergroup.count == 0 {
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

extension JoindGroupviewController: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsergroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblGrouplist.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblJoinedGroupCell
        cell.imgGroup.layer.cornerRadius = 5
        cell.imgGroup.clipsToBounds = true
        let name = arrUsergroup[indexPath.row].name
         cell.lblGroupname.text = name
        let strImg = arrUsergroup[indexPath.row].avatar_url_custom
        url = URL(string: strImg)
        cell.imgGroup.sd_setImage(with: url, completed: nil)
        cell.lblpublic.text = arrUsergroup[indexPath.row].type_group
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loggdenUser.removeObject(forKey: GROUPUSERNAME)
        let username = arrUsergroup[indexPath.row].username
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "GroupProfileViewController")as! GroupProfileViewController
        print(username)
        loggdenUser.set(username, forKey: GROUPUSERNAME)
        loggdenUser.set(username, forKey: UNAME)
        obj.strUserName = username
        obj.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(obj, animated: true)
        self.present(obj, animated: false, completion: nil)
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
                getGroup(strPage: "\(pageCount)")
                //self.tblGrouplist.tableFooterView = spinner
                self.tblGrouplist.tableFooterView?.isHidden = false
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            timeline_id = (self.arrUsergroup[indexPath.row]as AnyObject).value(forKey: "timeline_id")as! Int
//            let refreshAlert = UIAlertController(title: "Notification", message: "Are you sure to delete?", preferredStyle: UIAlertController.Style.alert)
//
//            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                let parameters = ["timeline_id":self.timeline_id]
//                let token = loggdenUser.value(forKey: TOKEN)as! String
//                let BEARERTOKEN = BEARER + token
//                let headers = ["Xapi": XAPI,
//                               "Accept" : ACCEPT,
//                               "Authorization":BEARERTOKEN]
//                Alamofire.request(JOINGROUPREMOVE,method: .post, parameters: parameters,headers: headers).responseJSON { response in
//                    print(response)
//                    let dic = response.value as! NSDictionary
//                    let success = dic.value(forKey: "joined")as! Bool
//                    if success {
//                        self.getGroup()
//                    }
//                }
//               // self.arrUsergroup.remove(indexPath.row)
//                //self.tblGrouplist.deleteRows(at: [indexPath], with: .fade)
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
}
