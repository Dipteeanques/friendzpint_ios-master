//
//  PostViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 20/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//


import UIKit
import AVKit
import Alamofire


class postEditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtWatchlive: UITextField!
    @IBOutlet weak var txtDescrption: UITextView!
    @IBOutlet weak var txtheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var footorView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btntag: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var emojiCollection: UICollectionView!
    @IBOutlet weak var viewEmo: UIView!
    @IBOutlet weak var emoviewHeight: NSLayoutConstraint!
    
    enum CellType {
        case normal
        case expanded
    }
    
    var arrSelected = [TagList]()
    var boolSingale = Bool()
    var multibool = Bool()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var url: URL?
    var arrTag = [TagList]()
    var strTageName = String()
    var selectedIndex = Int()
    var arrImages = [UIImage]()
    var object = NSDictionary()
    var wc = Webservice.init()
    var uploadProfilePhoto: UploadParameterMode! = nil
    var postSelected = String()
    var MyProfile = String()
    var GroupTimeline_Id = Int()
    var TimelineAll = Int()
    var strLocation = String()
    var selectedBool = true
    var youtube_video_id = String()
    var emoSelectedBool = true
    var arrEmoji = [String]()
    var arrselectedemo = [String]()
    var nameTag = [String]()
    var nameIdTag = [String]()
    var strTage_id = String()
    var postid = Int()
    var strdescription = String()
    
  
    
    var tabController:AZTabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
        lblName.text = loggdenUser.value(forKey: NAMELOgin)as? String
        lblUserName.text = loggdenUser.value(forKey: NAMELOgin)as? String
        let profile = loggdenUser.value(forKey: PROFILE)as! String
        url = URL(string: profile)
        imgIcon.sd_setImage(with: url, completed: nil)
        setDeafult()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func setDeafult() {
        
        print(postid)
       
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
       
//        let gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = self.HeaderView.bounds
//
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        HeaderView.layer.addSublayer(gradientLayer)
//        HeaderView.addSubview(btnback)
//        HeaderView.addSubview(lblName)
//        HeaderView.addSubview(btnPost)
//        HeaderView.addSubview(activity)
        imgIcon.layer.cornerRadius = 25
        imgIcon.clipsToBounds = true
        
//        if UIScreen.main.bounds.width == 414 {
//            gradientLayer.frame = CGRect(x: HeaderView.bounds.origin.x, y: HeaderView.bounds.origin.y, width: 414, height: HeaderView.bounds.size.height)
//        }
//        else if UIScreen.main.bounds.height == 812 {
//            // txtviewHeightConstraint.constant = 400
//        }
//        else if UIScreen.main.bounds.width == 320 {
//            //txtviewHeightConstraint.constant = 190
////            bottomViewHeight.constant = 50
//        }
        
        if txtDescrption.text.isEmpty {
            txtDescrption.text = "Write Something..."
            txtDescrption.textColor = UIColor.lightGray
            txtDescrption.delegate = self
        }
        else {
            txtDescrption.text = strdescription
            txtDescrption.textColor = UIColor.black
            txtDescrption.delegate = self
        }
        
        
    }
    
    func UpdateEdit() {
        btnPost.isHidden = true
        activity.isHidden = false
        activity.startAnimating()
        let parameters = ["post_id":postid,
                          "description": txtDescrption.text!.encodeEmoji] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        self.wc.callSimplewebservice(url: EDITPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: EditPostresponsmodel?) in
            if sucess {
                let sucess = response?.success
                if sucess! {
                    self.btnPost.isHidden = false
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    let object: [String: Any] = ["postid": self.postid, "strdescription": self.txtDescrption.text!]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editpost"), object: object)
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    
                }
            }
        }
    }
       

    
    @IBAction func btnPostAction(_ sender: UIButton) {
        UpdateEdit()
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
    
    


extension postEditViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtDescrption.textColor == UIColor.lightGray {
            txtDescrption.text = ""
            txtDescrption.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtDescrption.text == "" {
            
            txtDescrption.text = "Write Something..."
            txtDescrption.textColor = UIColor.lightGray
        }
    }
}

