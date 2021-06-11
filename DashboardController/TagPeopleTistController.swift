//
//  ChooseFriendViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 25/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class TagPeopleTistController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var tblFriendZList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnBext: UIButton!
    
    var arrFriendzList = [["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Mayur Godhani"],["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Jekil Dabhoya"],["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Dipak Kukadiya"],["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Manan Kathiriya"],["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Maulik Bhuva"],["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Piyush Prajapati"]]
    var arrSelected = NSMutableArray()
    var selectedTag = [TagList]()
    
    var strSearchTxt = String()
    var arrResults = [TagList]()
    var wc = Webservice.init()
    var url: URL?
    var arrUserTag = [userTagpeopelListResponse]()
    var arrgetTag = [AnyHashable : Any]()
    var arrMutable = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
    }
    
    func setDefault() {
        
       
        
        if let b = arrgetTag["Others"] { //<-check if `dict` contains value for "b"
            arrUserTag = b as! [userTagpeopelListResponse]
            print(arrUserTag)
        }
        
       
        
        tblFriendZList.reloadData()
        tblFriendZList.allowsMultipleSelection = true
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.headerView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerView.layer.addSublayer(gradientLayer)
        headerView.addSubview(btnback)
        headerView.addSubview(lblHeaderTitle)
        headerView.addSubview(btnBext)
        
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
        }
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNextAction(_ sender: UIButton) {
        print(selectedTag)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectedFriendZlistInGroup"), object: arrSelected)
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

extension TagPeopleTistController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserTag.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFriendZList.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblCellFriendzListGroup
        cell.lblName.text = arrUserTag[indexPath.row].name
        cell.imgprofile.layer.cornerRadius = 15
        cell.imgprofile.clipsToBounds = true
        let imgstr = arrUserTag[indexPath.row].avatar
        url = URL(string: imgstr)
        cell.imgprofile.sd_setImage(with: url, completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let selectedUsername = arrUserTag[indexPath.row].username
        if selectedUsername == username {
            currentTabBar?.setIndex(4)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
//            self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            //self.navigationController?.pushViewController(obj, animated: true)
            self.present(obj, animated: false, completion: nil)
        }
        else {
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
//            obj.strUserName = selectedUsername
//            self.navigationController?.pushViewController(obj, animated: true)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "navigationLoaderpageredirection")as! navigationLoaderpageredirection
            obj.strUser = selectedUsername
    //                    self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            self.present(obj, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
