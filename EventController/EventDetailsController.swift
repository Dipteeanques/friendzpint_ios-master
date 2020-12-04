//
//  EventDetailsController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 14/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class EventDetailsController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tblBio: UITableView!
    
    var wc = Webservice.init()
    var strUserName = String()
    var arrBio = [String]()
    var onlyPrivet = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         NotificationCenter.default.addObserver(self, selector: #selector(EventDetailsController.GroupView), name: NSNotification.Name(rawValue: "Biodata"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(EventDetailsController.PrivateGroupView), name: NSNotification.Name(rawValue: "PrivateBiodata"), object: nil)
       // getPageDetails()
    }
    
    @objc func GroupView(_ notification: NSNotification) {
        strUserName = notification.object as! String
        contentView.isHidden = true
        contentView.bounds.size.height = 0
        getPageDetails()
    }
    
    @objc func PrivateGroupView(_ notification: NSNotification) {
        let dic = notification.object as! NSDictionary
        strUserName = dic["username"] as! String
        print(strUserName)
        contentView.isHidden = false
        contentView.bounds.size.height = 78
        getPageDetails()
    }
    

    func getPageDetails() {
        let parameters = ["username":strUserName]
        print(parameters)
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        print(headers)
        wc.callSimplewebservice(url: EVENT_SETTINGS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: eventProfileResponsModel?) in
            if sucess {
                print(response)
                let res = response?.data
                let about = res?.about
                let eventType = res?.event_type
                let Name = res?.hosted_by
                let location = res?.location
                let stratdate = res?.start_date
                let endDate = res?.end_date
                if about?.count == 0 {
                    print("jekil")
                }
                else {
                     self.arrBio.append(about!)
                }
               
                if eventType?.count == 0 {
                    print("jekil")
                }
                else {
                     self.arrBio.append(eventType! + " Event")
                }
                
                if Name?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.append("Hosted by " + Name!)
                }
               
                if location?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.append(location!)
                }
                
                if stratdate?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.append(stratdate!)
                }
                
                if endDate?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.append(endDate!)
                }
                self.tblBio.reloadData()
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

extension EventDetailsController: UITableViewDelegate,UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblBio.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblName = cell.viewWithTag(102)as! UILabel
        lblName.text = arrBio[indexPath.row]
        return cell
    }
}
