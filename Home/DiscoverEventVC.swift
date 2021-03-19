//
//  DiscoverEventVC.swift
//  FriendzPoint
//
//  Created by Anques on 18/03/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class DiscoverEventVC: UIViewController {
    
    @IBOutlet weak var foundview: Foundview!
    var wc = Webservice.init()
    var arrMyEvent : MyDiscoverEventData?

    @IBOutlet weak var tblevent: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        geDiscoverEvent()
    }
    
    
    func geDiscoverEvent() {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        
//        let parameters = ["username":username,
//                          "page":strPage] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: DISCOVEREVENT, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (sucess, response: MyDiscoverEvent?) in
            
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
//                    let data = response?.data
                    self.arrMyEvent = response?.data
                    self.tblevent.reloadData()
                    self.foundview.isHidden = true
                }
                else {
                    self.foundview.isHidden = false
                }
            }
            else{
                self.foundview.isHidden = false
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

extension DiscoverEventVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyEvent?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiscoverEventCell
        cell.imgeventdate.text = convertDateFormater(arrMyEvent?.data[indexPath.row].start_date ?? "")
        cell.imgeventname.text = arrMyEvent?.data[indexPath.row].name
        cell.imgeventlocation.text = arrMyEvent?.data[indexPath.row].location
        cell.imgeventgoing.text = (arrMyEvent?.data[indexPath.row].is_going.description ?? "0") + " going"
        let url = arrMyEvent?.data[indexPath.row].cover_url ?? ""
        let url1 = URL(string: url)
        cell.imgevent.sd_setImage(with: url1, completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let username = arrMyEvent?.data[indexPath.row].username
//        let type = arrMyEvent?.data[indexPath.row].type
////        if type == "private" {
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "EventProfileController")as! EventProfileController
//        obj.strUserName = username ?? ""
//        obj.modalPresentationStyle = .fullScreen
//        self.present(obj, animated: false, completion: nil)
        
        let username = arrMyEvent?.data[indexPath.row].username ?? ""
        let type = arrMyEvent?.data[indexPath.row].type
//        let group_Type = arrMyEvent?.data[indexPath.row].groups_type
//        let status_group = arrMyEvent?.data[indexPath.row].groups_status
        let pageAdmin = arrMyEvent?.data[indexPath.row].is_hosting ?? 0
        let event_type = arrMyEvent?.data[indexPath.row].event_type ?? ""
        let invite_privacy = arrMyEvent?.data[indexPath.row].invite_privacy ?? ""
        let post_privacy = arrMyEvent?.data[indexPath.row].timeline_post_privacy ?? ""
       // let member_privacy = arrMyEvent?.data[indexPath.row].invite_privacy ?? ""
        let is_guest = arrMyEvent?.data[indexPath.row].is_guest
        //let myprofile = loggdenUser.value(forKey: USERNAME)as! String
        
        if type == "event" {
            if pageAdmin == 0 {
                if event_type == "public" {
                    if invite_privacy == "only_admins" && post_privacy == "only_admins"  {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PublicEventProfileController")as! PublicEventProfileController
                        obj.strUserName = username
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.is_page_admin = pageAdmin
                        loggdenUser.set(username, forKey: UNAME)
//                        self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                    else if invite_privacy == "only_guests" && post_privacy == "only_guests"  {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "publicAndGuestProfileViewController")as! publicAndGuestProfileViewController
                        obj.strUserName = username
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.is_page_admin = pageAdmin
                        loggdenUser.set(username, forKey: UNAME)
//                        self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                    else if invite_privacy == "only_admins" && post_privacy == "only_guests"  {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PublicEventProfileController")as! PublicEventProfileController
                        obj.strUserName = username
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.is_page_admin = pageAdmin
                        loggdenUser.set(username, forKey: UNAME)
//                        self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                    else if invite_privacy == "only_guests" && post_privacy == "only_admins" {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "publicAndGuestProfileViewController")as! publicAndGuestProfileViewController
                        obj.strUserName = username
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.is_page_admin = pageAdmin
                        loggdenUser.set(username, forKey: UNAME)
//                        self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                    else {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PublicEventProfileController")as! PublicEventProfileController
                        obj.strUserName = username
                        obj.onlyPost = post_privacy
                        obj.onlyInvaite = invite_privacy
                        obj.is_page_admin = pageAdmin
                        loggdenUser.set(username, forKey: UNAME)
//                        self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                }
                else {
                    if is_guest == 1 {
                        if invite_privacy == "only_admins" && post_privacy == "only_admins"  {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = invite_privacy
                            obj.is_page_admin = pageAdmin
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: false)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if invite_privacy == "only_guests" && post_privacy == "only_guests"  {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = invite_privacy
                            obj.is_page_admin = pageAdmin
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: false)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if invite_privacy == "only_admins" && post_privacy == "only_guests"  {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = invite_privacy
                            obj.is_page_admin = pageAdmin
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: false)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else if invite_privacy == "only_guests" && post_privacy == "only_admins" {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = invite_privacy
                            obj.is_page_admin = pageAdmin
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: false)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                        else {
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateAndMemberController")as! PrivateAndMemberController
                            obj.strUserName = username
                            obj.onlyPost = post_privacy
                            obj.onlyInvaite = invite_privacy
                            obj.is_page_admin = pageAdmin
                            loggdenUser.set(username, forKey: UNAME)
//                            self.navigationController?.pushViewController(obj, animated: false)
                            obj.modalPresentationStyle = .fullScreen
                            self.present(obj, animated: false, completion: nil)
                        }
                    }
                    else {
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PrivateEventController")as! PrivateEventController
                        obj.strUserName = username
                        obj.onlyPrivet = "onlyPrivet"
                        loggdenUser.set(username, forKey: UNAME)
//                        self.navigationController?.pushViewController(obj, animated: false)
                        obj.modalPresentationStyle = .fullScreen
                        self.present(obj, animated: false, completion: nil)
                    }
                }
            }
            else {
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "EventProfileController")as! EventProfileController
                obj.strUserName = username
                obj.is_page_admin = pageAdmin
                loggdenUser.set(username, forKey: UNAME)
//                self.navigationController?.pushViewController(obj, animated: false)
                obj.modalPresentationStyle = .fullScreen
                self.present(obj, animated: false, completion: nil)
            }
        }
    }
    
    func convertDateFormater(_ date: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "E, d MMM HH:mm"
            return  dateFormatter.string(from: date!)

        }

}
