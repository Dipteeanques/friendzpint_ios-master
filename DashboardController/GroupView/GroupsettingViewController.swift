//
//  GroupsettingViewController.swift
//  Fr/Users/anquestechnolabs/Desktop/FriendzPoint/DashboardController/GroupView/tblGroupsettingCell.swiftiendzPoint
//
//  Created by Anques Technolabs on 22/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class GroupsettingViewController: UIViewController {
    
    @IBOutlet weak var tblGroupSetting: UITableView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var arrSetting = [["img":#imageLiteral(resourceName: "notiSetting"),"name":"Loremipsum is  a simply dummy text of the  printing and type setting industry","title":"Notification"],["img":#imageLiteral(resourceName: "GroupPageGroup"),"name":"Loremipsum is  a simply dummy text of the  printing and type setting industry","title":"Membership"]]
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

extension GroupsettingViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSetting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblGroupSetting.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblGroupsettingCell
        cell.imgIcon.image = (self.arrSetting[indexPath.row]as AnyObject).value(forKey: "img") as? UIImage
        cell.lblDescraibe.text = (self.arrSetting[indexPath.row]as AnyObject).value(forKey: "name") as? String
        cell.lblTitle.text = (self.arrSetting[indexPath.row]as AnyObject).value(forKey: "title")as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

