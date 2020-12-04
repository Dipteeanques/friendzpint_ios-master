//
//  GroupsViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 13/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import SquareFlowLayout
import AVFoundation
import ActiveLabel
import TKImageShowing
import Photos
import DKPhotoGallery
import DKImagePickerController
import Alamofire

class GroupsViewController: UIViewController {
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GroupsViewController")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
   
    var player: AVPlayer?
    var selectedIndex = Int()
    
    
   
    @IBOutlet weak var btncreate: UIButton!
   
    @IBOutlet weak var foundView: LargeFound!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    
    @IBOutlet weak var collectiongroup: UICollectionView!
   
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
  
    
    
    
    var refreshControl: UIRefreshControl!
    
    var arrSingaleImg = [String]()
    
    var arrUsergroup = [MyGroupList]()
    var url : URL?
    var index = Int()
    var dicValue = NSDictionary()
    var arrFeed = [[String : Any]]()
    var arrMultiImage = NSArray()
    var post_Id = Int()
    var strusername = String()
    var strSaveUnsave = String()
    var strNotification = String()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    let wc = Webservice.init()
    var assets: [DKAsset]?

    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(GroupsViewController.Group), name: NSNotification.Name(rawValue: "Group"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GroupsViewController.GetCreatedGroup), name: NSNotification.Name(rawValue: "GroupCreat"), object: nil)
        self.loaderView.isHidden = false
        self.activity.startAnimating()
        setDefault()
    }
    
    @objc func Group(_ notification: NSNotification) {
        collectiongroup.scrollsToTop = true
        self.loaderView.isHidden = false
        self.activity.startAnimating()
        setDefault()
    }

  
    func setDefault() {
        getGroup()
        self.navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(GroupsViewController.notificationSingaleDashboardGroupVala), name: NSNotification.Name(rawValue: "notificationSingaleDashboardGroupVala"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GroupsViewController.notificationMyGroupBackSingale), name: NSNotification.Name(rawValue: "notificationMyGroupBackSingale"), object: nil)
        
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
    
    @objc func notificationSingaleDashboardGroupVala(_ notification: NSNotification) {
        dicValue = notification.object as! NSDictionary
        let obj = storyboard?.instantiateViewController(withIdentifier: "CommentsViewControllers")as! CommentsViewControllers
        obj.strCommentImage = "strCommentImage"
        obj.dicImg = dicValue
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @objc func notificationMyGroupBackSingale(_ notification: NSNotification) {
        index = dicValue.value(forKey: "index") as! Int
        let tkImageVC = TKImageShowing()
        tkImageVC.currentIndex = index
        tkImageVC.images = arrSingaleImg.toTKImageSource()
        present(tkImageVC, animated: true, completion: nil)
    }
    
    @objc func GetCreatedGroup(_ notification: NSNotification) {
        getGroup()
    }
    
    
    
    @IBAction func btnCreateAction(_ sender: UIButton) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController")as! CreateGroupViewController
        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        self.present(naviget, animated: true, completion: nil)
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
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrUsergroup.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                        self.collectiongroup.reloadData()
                    }
                }
            }
            if self.arrUsergroup.count == 0 {
                self.foundView.isHidden = false
            }
            else {
                self.foundView.isHidden = true
                self.collectiongroup.reloadData()
            }
        }
    }
    
    //MARK: - Btn Action
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController")as! SearchViewController
        self.navigationController?.pushViewController(obj, animated: false)
        
    }
    
    @IBAction func btnCameraAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
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
        print(assets)
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
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


extension GroupsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrUsergroup.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectiongroup.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let viewback = cell.viewWithTag(2811)
            viewback?.layer.cornerRadius = 5
            viewback?.clipsToBounds = true
            let img = cell.viewWithTag(101)as! UIImageView
            let lblName = cell.viewWithTag(102)as! UILabel
            let name = arrUsergroup[indexPath.row].name
            lblName.text = name
            let strImg = arrUsergroup[indexPath.row].avatar_url_custom
            url = URL(string: strImg)
            img.sd_setImage(with: url, completed: nil)
            return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let strGroup_type = arrUsergroup[indexPath.row].type_group
        let post_privacy = arrUsergroup[indexPath.row].post_privacy
        let member_privacy = arrUsergroup[indexPath.row].member_privacy
        if strGroup_type == "closed" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "GroupProfileViewController")as! GroupProfileViewController
            obj.strUserName = arrUsergroup[indexPath.row].username
            obj.groupTimeline_id = arrUsergroup[indexPath.row].timeline_id
            obj.onlyPost = post_privacy
            obj.onlyInvaite = member_privacy
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openAndSecretGroupController")as! openAndSecretGroupController
            obj.strUserName = arrUsergroup[indexPath.row].username
            obj.groupTimeline_id = arrUsergroup[indexPath.row].timeline_id
            obj.onlyPost = post_privacy
            obj.onlyInvaite = member_privacy
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 5
        let collectionViewSize = collectiongroup.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: 187)
    }
}



extension String {
    
    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
