//
//  ChatViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 13/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Photos
import DKPhotoGallery
import DKImagePickerController
import Alamofire

class ChatViewController: UIViewController {
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
    @IBOutlet weak var foundView: LargeFound!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tblChatlist: UITableView!
    @IBOutlet weak var lblbadge: BadgeLabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var iconSearch: UIImageView!
    @IBOutlet weak var btnCameraleading: NSLayoutConstraint!
    @IBOutlet weak var btnnotitrailing: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var gridentView: UIView!
    @IBOutlet weak var btncamera: UIButton!
    
     var arrFriends = ["Mayur Godhani","Jekil Dabhoya","Dipak kukadiya","Maulik Bhuva","Manna kathiriya","Piyush Prajapati","Mayur Godhani","Jekil Dabhoya","Dipak kukadiya","Maulik Bhuva","Manna kathiriya","Piyush Prajapati"]
    var assets: [DKAsset]?
    var arrChatList = NSArray()
    var url: URL?
    var dic = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loaderView.isHidden = false
        activity.startAnimating()
        setDefault()
    }
    
    func setDefault() {
        chatList()
        self.navigationController?.navigationBar.isHidden = true
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.gridentView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gridentView.layer.addSublayer(gradientLayer)
        gridentView.addSubview(btncamera)
        gridentView.addSubview(btnNotification)
        gridentView.addSubview(lineView)
        gridentView.addSubview(iconSearch)
        gridentView.addSubview(lblSearch)
        gridentView.addSubview(btnSearch)
        gridentView.addSubview(lblbadge)
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
            self.lblbadge.badge(text: String(count))
        }
        
        if UIScreen.main.bounds.width == 320 {
            
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: gridentView.bounds.size.height)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.BadgeCleare), name: NSNotification.Name(rawValue: "BadgeCleare"), object: nil)
    }
    
    @objc func BadgeCleare(_ notification: NSNotification) {
        self.lblbadge.badge(text: nil)
    }
    
    func chatList() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
       
        guard let url = URL(string: GET_MESSAGES) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(ACCEPT, forHTTPHeaderField: "Accept")
        request.addValue(XAPI, forHTTPHeaderField: "Xapi")
        request.addValue(BEARERTOKEN, forHTTPHeaderField: "Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: [:], options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    let dic = json as! NSDictionary
                    let dataDic = dic.value(forKey: "data")as! NSDictionary
                    self.arrChatList = dataDic.value(forKey: "data") as! NSArray
                    if self.arrChatList.count == 0 {
                        DispatchQueue.main.async {
                            self.foundView.isHidden = false
                            self.loaderView.isHidden = true
                            self.activity.stopAnimating()
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.loaderView.isHidden = true
                            self.activity.stopAnimating()
                            self.tblChatlist.reloadData()
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    //MARK: - Btn Action
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseAllButton"), object: nil)
//        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChatFriendsSearchview")as! ChatFriendsSearchview
//        self.navigationController?.pushViewController(obj, animated: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController")as! SearchViewController
        self.navigationController?.pushViewController(obj, animated: false)
        
    }
    
    @IBAction func btnCameraAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseAllButton"), object: nil)
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            self.updateAssets(assets: assets)
        }
        pickerController.showsCancelButton = true
        pickerController.allowMultipleTypes = false
        pickerController.maxSelectableCount = 10
        self.present(pickerController, animated: true) {}
    }
    
    func updateAssets(assets: [DKAsset]) {
        self.assets = assets
        if assets.count == 0 {
            print("null")
        }
        else if assets.count == 1 {
            let obj = storyboard?.instantiateViewController(withIdentifier: "PostViewController")as! PostViewController
            obj.assets = assets
            obj.postSelected = "postSelected"
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
            self.present(naviget, animated: true, completion: nil)
        } else {
            let obj = storyboard?.instantiateViewController(withIdentifier: "PostViewController")as! PostViewController
            obj.assets = assets
            obj.postSelected = "postSelected"
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
            self.present(naviget, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnNotificationAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseAllButton"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController")as! NotificationController
        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        self.present(naviget, animated: true, completion: nil)
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

extension ChatViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrChatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblChatlist.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblChatlistCell
        if (self.arrChatList[indexPath.row]as AnyObject).value(forKey: "lastMessage") is NSNull {
            print("jekil")
            cell.lblmsg.isHidden = true
        }
        else {
            let dic = (self.arrChatList[indexPath.row]as AnyObject).value(forKey: "lastMessage")as! NSDictionary
            let strLatmessage = dic.value(forKey: "body")as! String
            cell.lblmsg.text = strLatmessage
        }
        
        let dicUser = (self.arrChatList[indexPath.row]as AnyObject).value(forKey: "user")as! NSDictionary
        let strName = dicUser.value(forKey: "name")as! String
        cell.lblName.text = strName
        let strAvater = dicUser.value(forKey: "avatar")as! String
        cell.imgprofile.layer.cornerRadius = 25
        cell.imgprofile.clipsToBounds = true
        url = URL(string: strAvater)
        cell.imgprofile.sd_setImage(with: url, completed: nil)
        let strDate = dicUser.value(forKey: "updated_at")as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strDate)!
        let datavala = Date().timeAgoSinceDate(date, numericDates: true)
        cell.lblSDate.text = datavala
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = (self.arrChatList[indexPath.row]as AnyObject).value(forKey: "id")as! Int
        let dic = (self.arrChatList[indexPath.row]as AnyObject).value(forKey: "user")as! NSDictionary
        let user_id = dic.value(forKey: "id")as! Int
        let receiverUsername = dic.value(forKey: "name")as! String
        let avatar = dic.value(forKey: "avatar")as! String
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChatConversionController")as! ChatConversionController
        obj.Id = id
        obj.user_id = user_id
        obj.receiverUsername = receiverUsername
        obj.avatar = avatar
        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        self.present(naviget, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
