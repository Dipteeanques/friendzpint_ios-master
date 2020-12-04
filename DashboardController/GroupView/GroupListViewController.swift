///Users/anquestechnolabs/Desktop/FriendzPoint/DashboardController/GroupView/tblGroupListCell.swift
//  GroupListViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 22/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class GroupListViewController: UIViewController {

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var tblGrouplist: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var arrgroup = ["School group","Rocks Group","Royal Group","Black Royal","Save water","College friends","School group","Rocks Group","Royal Group","Black Royal","Save water"]
    
    var arrUsergroup = [MyGroupList]()
    var url : URL?
    var wc = Webservice.init()
    var strusername = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getGroup()
       setDeafult()
    }
    
    func setDeafult() {
        self.navigationController?.navigationBar.isHidden = true
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.headerView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerView.layer.addSublayer(gradientLayer)
        headerView.addSubview(btnback)
        headerView.addSubview(lblTitle)
        
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
        }
    }
    
    func getGroup() {
        strusername = loggdenUser.value(forKey: USERNAME) as! String
        let parameters = ["username":strusername]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: GROUPLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: MygroupListResponse?) in
            if sucess {
                let res = response?.success
                if res! {
                    let data = response?.data
                    self.arrUsergroup = data!.data
                    self.tblGrouplist.reloadData()
                }
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

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GroupListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsergroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblGrouplist.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblGroupListCell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
