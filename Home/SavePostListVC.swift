//
//  SavePostListVC.swift
//  FriendzPoint
//
//  Created by Anques on 01/03/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import AVFoundation
import YPImagePicker
import AVKit
import Photos
import MBProgressHUD
import AJMessage
import FSPagerView
import TTTAttributedLabel

class SavePostListVC: UIViewController {

    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SavePostListVC")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
    var strUrlType = String()
    var strUserName = String()
    var images = [String]()
    
    var hashtagpost = String()
    var arrUserTag = [userTagpeopelListResponse]()
    var tagFirstUsername = String()
    var nameTag = [String]()
    var userTag = [String]()
    var strName = String()
    var strTageName = String()
    
    @IBOutlet weak var btnback: UIButton!{
        didSet{
            let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
            btnback.setImage(image, for: .normal)
            btnback.tintColor = UIColor.white
        }
    }
    
    @IBOutlet weak var foundView: Foundview!
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    var wc = Webservice.init()
    var timeline_last_first_id = Int()
//    var arrFeed = [MyTimelineList1]()
    var arrFeed1 = [MyTimelineList]()
    var lastIndex_id = Int()
    var timeline_Type_top_bottom = String()
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var transparentView: UIView!{
        didSet{
            transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    var selectedItems = [YPMediaItem]()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    var refreshControl = UIRefreshControl()
    var spinner = UIActivityIndicatorView()
    
    var post_Id = Int()
    var strSaveUnsave = String()
    var strNotification = String()
    
    var usernamemention = String()
    
    var Postime_id = Int()
    var strDescriptionedit = String()
    var postDetail_id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foundView.isHidden = true

        // Do any additional setup after loading the view.
        
        //setStatusBar1(backgroundColor: .black)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(editPost(_:)), name: NSNotification.Name(rawValue: "editpost"), object: nil)
        setDefault()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func editPost(_ notification: NSNotification) {
        if let object = notification.object as? [String: Any] {
            if let id = object["postid"] as? Int {
                Postime_id = id
            }
        }
        if let object = notification.object as? [String: Any] {
            if let str = object["strdescription"] as? String {
                strDescriptionedit = str
            }
        }
        self.arrFeed1 = self.arrFeed1.map
        {
            var mutableBook = $0
            if $0.id == self.Postime_id
            {
                print("$0: ",$0)
                

               
               mutableBook.description = strDescriptionedit
//                self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                
                for i in 0...self.arrFeed1.count - 1 {
                    if self.arrFeed1[i].id == $0.id {
                        print(i)
                        self.arrFeed1[i].description = strDescriptionedit
                        let myIndexPath = IndexPath(row: i, section: 0)
                        self.mainTableView.beginUpdates()
                        self.mainTableView.reloadRows(at: [myIndexPath], with: UITableView.RowAnimation.none)
                        self.mainTableView.endUpdates()
                    }
                }
               
            }
            return mutableBook
        }
    }
    
    func setDefault(){
        
//        if strUrlType == "FTimeline"{
//            self.lblTitle.text = strUserName
//            firstTime()
//        }
//        else if strUrlType == "Save"{
        
       
 
        
           
//        }
//        else{
//            self.lblTitle.text = "Browse"
//            firstTime()
//        }
//        UIApplication.shared.statusBarStyle = .lightContent
        
        currentTabBar?.setBar(hidden: true, animated: false)
        navigationController?.navigationBar.isHidden = true
//        navigationController?.setStatusBar(backgroundColor: .black)
//        setStatusBar1(backgroundColor: .black)
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.isPagingEnabled = true
        mainTableView.contentInsetAdjustmentBehavior = .never
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.prefetchDataSource = self
        mainTableView.snp.makeConstraints({ make in
            make.edges.equalTo(self.loaderView)//equalToSuperview()
        })
        mainTableView.register(UINib(nibName: "HomeVCCell", bundle: nil), forCellReuseIdentifier: "cell")
        mainTableView.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(NewsfeedViewController.refresh), for: UIControl.Event.valueChanged)
        mainTableView.addSubview(refreshControl)
        
        loaderView.isHidden = false
        activity.startAnimating()
        
        if strUrlType == "post"{
           self.lblTitle.text = "Post"
           getpost()
       }
        else{
           self.lblTitle.text = "Save Post"
           GetSaveList()
        }
       
    }

    
    @objc func refresh(sender:AnyObject) {
        timeline_last_first_id = arrFeed1[0].id
        FlagDataSave = 1
        timeline_Type_top_bottom = "Top"
        //getFeed(strPage: "1")
//        firstTime()
        GetSaveList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        currentTabBar?.tabBarHeight = 50
//        currentTabBar?.setBar(hidden: false, animated: false)
        mainTableView.reloadData()
        pausePlayeVideos()
    }
    
    func getpost() {
        
        let parameters = ["post_id": postDetail_id] as [String : Any]
        print(parameters)
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: POSTBYID + "?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: selectedPostDetails?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    print(response)
                    let arr_dict = response?.data
                    self.arrFeed1.append(arr_dict!)
                    print("arrFeedpost: ",self.arrFeed1)
                    print("postcount:", self.arrFeed1.count)
                    self.mainTableView.reloadData()
                    self.mainTableView.isHidden = false
                    self.loaderView.isHidden = true
                    self.foundView.isHidden = true
                    self.activity.stopAnimating()
                }
            }
        }
    }
    
    func GetSaveList(){
//        var parameters = ["timeline_last_post_id": timeline_last_first_id,
//                          "timeline_type":timeline_Type_top_bottom] as [String : Any]//"Bottom"
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        var strUrl = String()
//        if strUrlType == "Save"{
            strUrl = SAVEPOSTList
        let parameters = ["type":"posts",
                          "timeline_last_post_id": timeline_last_first_id,
                          "timeline_type":timeline_Type_top_bottom] as [String : Any]
//        }
        
        
        
        print("parameters: ",parameters)
        print("headers: ",headers)
        print("BROWSE: ",SAVEPOSTList)
        wc.callSimplewebservice(url: strUrl, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in//AllTimelineResponseModel//MyTimelineResponseModel
            //            print("response:",response.re)
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
//                    print("firsttime: ",response)
//                    self.arrFeed.removeAll()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    self.mainTableView.isHidden = false
                    if self.arrFeed1.count == 0{
                        self.arrFeed1 = response!.data!
//                        self.mainTableView.scrollToTop()
                        self.refreshControl.endRefreshing()
                        self.spinner.stopAnimating()
                        self.mainTableView.reloadData()
                    }
                    else{
                        if FlagDataSave == 1{
                            let arr_dict = response!.data
                            if self.timeline_Type_top_bottom == "Top"{
                                self.arrFeed1.removeAll()
                            }
                            
                            for i in 0..<arr_dict!.count
                            {
                                self.arrFeed1.append((arr_dict?[i])!)
                                self.refreshControl.endRefreshing()
                                self.spinner.stopAnimating()
    //                            self.arrFeed.insert(arr_dict![i], at: 0)
                            }
                            
                            self.mainTableView.reloadData()
                            self.loaderView.isHidden = true
                            self.activity.stopAnimating()
    //                        self.mainTableView.scrollToTop()
                            FlagDataSave = 0
                        }
                        

                    }
                    self.foundView.isHidden = true
                    
                }
                else {
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.spinner.stopAnimating()
//                    self.foundView.isHidden = false
                }
            }
            else {
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
                self.refreshControl.endRefreshing()
                self.spinner.stopAnimating()
                self.foundView.isHidden = false
            }
        }
    }
    
    func GetImpression(impression: String, post_id: Int){
        let parameters = ["post_id": post_id,
                          "type":impression] as [String : Any]//"Bottom"
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        print("parameters: ",parameters)
        print("headers: ",headers)
        print("SHOWFEED: ",IMPRESSIONCLICKPOST)
        wc.callSimplewebservice(url: IMPRESSIONCLICKPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: GetImpressionModel?) in
            //            print("response:",response.re)
            if sucess {
                print(response?.success)
            }
            else {
                
            }
        }
    }
    
    func ViewCounter(post_id: Int , indexpath: IndexPath){
        let parameters = ["post_id": post_id] as [String : Any]//"Bottom"
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        print("parameters: ",parameters)
        print("headers: ",headers)
        print("SHOWFEED: ",VIEWCOUNTER)
        wc.callSimplewebservice(url: VIEWCOUNTER, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: GetViewCounterModel?) in
            //            print("response:",response.re)
            if sucess {
                self.arrFeed1[indexpath.row].post_view_counter = self.arrFeed1[indexpath.row].post_view_counter + 1
//                self.mainTableView.beginUpdates()
//                self.mainTableView.reloadRows(at: [indexpath], with: UITableView.RowAnimation.none)
//                self.mainTableView.endUpdates()
            }
            else {
                
            }
        }
    }
   
    func setLike(likedcount:String) -> NSMutableAttributedString {
        //        let normalText =  " Wendy Lambert "
        
        let boldText  = "Liked by "
        
        let normalText1 = likedcount + " people"
        
        //        let boldText1  = "and"
        
        
//        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        //        let attributedString = NSMutableAttributedString(string:normalText, attributes:attrs1)
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "SFUIText-Regular", size: 14)]//systemFont(ofSize: 15)
        let attributedString1 = NSMutableAttributedString(string:normalText1, attributes:attrs2)
        
        let attrs = [NSAttributedString.Key.font : UIFont(name: "SFUIText-Regular", size: 14)!,NSAttributedString.Key.foregroundColor: UIColor.white.cgColor] as [NSAttributedString.Key : Any]
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        
        //        let boldString1 = NSMutableAttributedString(string: boldText1, attributes:attrs)
        
        //        boldString.append(attributedString)
        boldString.append(attributedString1)
        //        boldString.append(boldString1)
       return boldString
    }
    
    @objc func btnMenuAction(_ sender: UIButton) {
        if let indexPath = self.mainTableView.indexPathForView(sender) {
            let is_my_post = arrFeed1[indexPath.row].is_my_post
            post_Id = arrFeed1[indexPath.row].id
            let SavePost = arrFeed1[indexPath.row].is_saved
            let Notification = arrFeed1[indexPath.row].is_notification
            let editdescription = arrFeed1[indexPath.row].description
            let usernamepost = arrFeed1[indexPath.row].users_name
            let shared_post_id = arrFeed1[indexPath.row].shared_post_id
            let shared_person_name = arrFeed1[indexPath.row].shared_person_name
            let shared_username = arrFeed1[indexPath.row].shared_username
            let is_users_shared = arrFeed1[indexPath.row].is_users_shared
           // let image = UIImage(named: "ProfileHeart")
            if SavePost == 0 {
                strSaveUnsave = "Save Post"
            }
            else {
                strSaveUnsave = "Unsave Post"
                
            }
            
            if Notification == 0 {
                strNotification = "Get Notifications"
            }
            else {
                strNotification = "Stop Notifications"
            }
            
           
            if is_my_post == 1 {
                let actionSheetController: UIAlertController = UIAlertController(title: "FriendzPoint", message: nil, preferredStyle: .actionSheet)
                let firstAction: UIAlertAction = UIAlertAction(title: strNotification, style: .default) { action -> Void in
                    let parameters = ["post_id":self.post_Id] as [String : Any]
                    let token = loggdenUser.value(forKey: TOKEN)as! String
                    let BEARERTOKEN = BEARER + token
                    let headers: HTTPHeaders = ["Xapi": XAPI,
                                                "Accept" : ACCEPT,
                                                "Authorization":BEARERTOKEN]
                    self.wc.callSimplewebservice(url: GETNOTIFICATIONs, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: NotificatioGetandSetResponsModel?) in
                        if sucess {
                            let sucess = response?.success
                            let message = response?.message
                            if sucess! {
                                if message == "Successfull ." {
                                    self.arrFeed1 = self.arrFeed1.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_notification = 1
                                        }
                                        return mutableBook
                                    }
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                        print("did dissmiss")
                                    }
                                }
                                else {
                                    self.arrFeed1 = self.arrFeed1.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_notification = 0
                                        }
                                        return mutableBook
                                    }
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                        print("did dissmiss")
                                    }
                                }
                            }
                        }
                    }
                }
                let secondAction: UIAlertAction = UIAlertAction(title: "Edit", style: .default) { action -> Void in
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "postEditViewController")as! postEditViewController
                    obj.postid = self.post_Id
                    obj.strdescription = editdescription
                    let naviget: UINavigationController = UINavigationController(rootViewController: obj)
                    self.present(naviget, animated: true, completion: nil)
                }
                
                let third: UIAlertAction = UIAlertAction(title: "Delete", style: .default) { action -> Void in
                    if shared_post_id == 0 {
                        let parameters = ["post_id":self.post_Id] as [String : Any]
                        self.arrFeed1.remove(at: indexPath.row)
                        self.mainTableView.deleteRows(at: [indexPath], with: .fade)
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization":BEARERTOKEN]
                        self.wc.callSimplewebservice(url: DELETEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostDeleteResponseModel?) in
                            if sucess {
                                let suc = response?.success
                                let message = response?.message
                                if suc == true {
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                        print("did dissmiss")
                                    }
                                }
                                else {
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                        print("did dissmiss")
                                    }
                                }
                            }
                        }
                    }
                    else {
                        let parameters = ["post_id":shared_post_id] as [String : Any]
                        self.arrFeed1.remove(at: indexPath.row)
                        self.mainTableView.deleteRows(at: [indexPath], with: .fade)
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization":BEARERTOKEN]
                        self.wc.callSimplewebservice(url: UNSHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
                            if sucess {
                                let suc = response?.success
                                let message = response?.message
                                if suc == true {
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                        print("did dissmiss")
                                    }
                                }
                                else {
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                            }
                        }
                    }
                    
                }
//                let four: UIAlertAction = UIAlertAction(title: "View post", style: .default) { action -> Void in
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//                    obj.postDetail_id = self.post_Id
//                    obj.usernamepost = usernamepost
//                    //self.navigationController?.pushViewController(obj, animated: true)
//                    let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//                    obj.passappDel = "passappDel"
//                    self.present(naviget, animated: true, completion: nil)
//                }
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
                actionSheetController.addAction(firstAction)
                actionSheetController.addAction(secondAction)
                actionSheetController.addAction(third)
//                actionSheetController.addAction(four)
                actionSheetController.addAction(cancelAction)
                present(actionSheetController, animated: true, completion: nil)
            }
            else {
                if is_users_shared == 1 {
                    let actionSheetController: UIAlertController = UIAlertController(title: "FriendzPoint", message: nil, preferredStyle: .actionSheet)
                    let firstAction: UIAlertAction = UIAlertAction(title: strNotification, style: .default) { action -> Void in
                        let parameters = ["post_id":self.post_Id] as [String : Any]
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization":BEARERTOKEN]
                        self.wc.callSimplewebservice(url: GETNOTIFICATIONs, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: NotificatioGetandSetResponsModel?) in
                            if sucess {
                                let sucess = response?.success
                                let message = response?.message
                                let data = response?.data
                                let noti = data?.notifications
                                if sucess! {
                                    if noti == 1 {
                                        self.arrFeed1 = self.arrFeed1.map{
                                            var mutableBook = $0
                                            if $0.id == self.post_Id {
                                                mutableBook.is_notification = 1
                                            }
                                            return mutableBook
                                        }
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.arrFeed1 = self.arrFeed1.map{
                                            var mutableBook = $0
                                            if $0.id == self.post_Id {
                                                mutableBook.is_notification = 0
                                            }
                                            return mutableBook
                                        }
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    let secondAction: UIAlertAction = UIAlertAction(title: "Hide Post", style: .default) { action -> Void in
                        let parameters = ["post_id":self.post_Id] as [String : Any]
                        self.arrFeed1.remove(at: indexPath.row)
                        self.mainTableView.deleteRows(at: [indexPath], with: .fade)
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization":BEARERTOKEN]
                        self.wc.callSimplewebservice(url: HIDEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: hidePostResponsModel?) in
                            if sucess {
                                let sucess = response?.success
                                let message = response?.message
                                let data = response?.data
                                let hide = data?.hide
                                if sucess! {
                                    if hide == 1 {
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    let third: UIAlertAction = UIAlertAction(title: strSaveUnsave, style: .default) { action -> Void in
                        let parameters = ["post_id":self.post_Id] as [String : Any]
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization":BEARERTOKEN]
                        self.wc.callSimplewebservice(url: SAVEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SavePostResponsModel?) in
                            if sucess {
                                let sucess = response?.success
                                let message = response?.message
                                let data = response?.data
                                let saved = data?.type
                                
                                if sucess! {
                                    if saved == "save" {
                                        self.arrFeed1 = self.arrFeed1.map{
                                            var mutableBook = $0
                                            if $0.id == self.post_Id {
                                                mutableBook.is_saved = 1
                                            }
                                            return mutableBook
                                        }
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.arrFeed1 = self.arrFeed1.map{
                                            var mutableBook = $0
                                            if $0.id == self.post_Id {
                                                mutableBook.is_saved = 0
                                            }
                                            return mutableBook
                                        }
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    let Four: UIAlertAction = UIAlertAction(title: "Report", style: .default) { action -> Void in
                        let parameters = ["post_id":self.post_Id] as [String : Any]
                        self.arrFeed1.remove(at: indexPath.row)
                        self.mainTableView.deleteRows(at: [indexPath], with: .fade)
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization":BEARERTOKEN]
                        self.wc.callSimplewebservice(url: REPORTPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ReportPostResponsModel?) in
                            if sucess {
                                let sucess = response?.success
                                let message = response?.message
                                let data = response?.data
                                let report = data?.reported
                                
                                if sucess! {
                                    if report == 1 {
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                }
                            }
                        }
                    }
//                    let five: UIAlertAction = UIAlertAction(title: "View post", style: .default) { action -> Void in
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//                        obj.postDetail_id = self.post_Id
//                        obj.usernamepost = usernamepost
//                        //self.navigationController?.pushViewController(obj, animated: true)
//                        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//                        obj.passappDel = "passappDel"
//                        self.present(naviget, animated: true, completion: nil)
//                    }
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
                    actionSheetController.addAction(firstAction)
                    actionSheetController.addAction(secondAction)
                    actionSheetController.addAction(third)
                    actionSheetController.addAction(Four)
//                    actionSheetController.addAction(five)
                    actionSheetController.addAction(cancelAction)
                    present(actionSheetController, animated: true, completion: nil)
                }
                else {
                    let actionSheetController: UIAlertController = UIAlertController(title: "FriendzPoint", message: nil, preferredStyle: .actionSheet)
                    let firstAction: UIAlertAction = UIAlertAction(title: strNotification, style: .default) { action -> Void in
                        let parameters = ["post_id":self.post_Id] as [String : Any]
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization":BEARERTOKEN]
                        self.wc.callSimplewebservice(url: GETNOTIFICATIONs, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: NotificatioGetandSetResponsModel?) in
                            if sucess {
                                let sucess = response?.success
                                let message = response?.message
                                let data = response?.data
                                let noti = data?.notifications
                                if sucess! {
                                    if noti == 1 {
                                        self.arrFeed1 = self.arrFeed1.map{
                                            var mutableBook = $0
                                            if $0.id == self.post_Id {
                                                mutableBook.is_notification = 1
                                            }
                                            return mutableBook
                                        }
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.arrFeed1 = self.arrFeed1.map{
                                            var mutableBook = $0
                                            if $0.id == self.post_Id {
                                                mutableBook.is_notification = 0
                                            }
                                            return mutableBook
                                        }
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    let secondAction: UIAlertAction = UIAlertAction(title: "Hide Post", style: .default) { action -> Void in
                        let parameters = ["post_id":self.post_Id] as [String : Any]
                        self.arrFeed1.remove(at: indexPath.row)
                        self.mainTableView.deleteRows(at: [indexPath], with: .fade)
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization":BEARERTOKEN]
                        self.wc.callSimplewebservice(url: HIDEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: hidePostResponsModel?) in
                            if sucess {
                                let sucess = response?.success
                                let message = response?.message
                                let data = response?.data
                                let hide = data?.hide
                                if sucess! {
                                    if hide == 1 {
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    let third: UIAlertAction = UIAlertAction(title: strSaveUnsave, style: .default) { action -> Void in
                        let parameters = ["post_id":self.post_Id] as [String : Any]
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization":BEARERTOKEN]
                        self.wc.callSimplewebservice(url: SAVEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SavePostResponsModel?) in
                            if sucess {
                                let sucess = response?.success
                                let message = response?.message
                                let data = response?.data
                                let saved = data?.type
                                
                                if sucess! {
                                    if saved == "save" {
                                        self.arrFeed1 = self.arrFeed1.map{
                                            var mutableBook = $0
                                            if $0.id == self.post_Id {
                                                mutableBook.is_saved = 1
                                            }
                                            return mutableBook
                                        }
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.arrFeed1 = self.arrFeed1.map{
                                            var mutableBook = $0
                                            if $0.id == self.post_Id {
                                                mutableBook.is_saved = 0
                                            }
                                            return mutableBook
                                        }
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    let Four: UIAlertAction = UIAlertAction(title: "Report", style: .default) { action -> Void in
                        let parameters = ["post_id":self.post_Id] as [String : Any]
                        self.arrFeed1.remove(at: indexPath.row)
                        self.mainTableView.deleteRows(at: [indexPath], with: .fade)
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization":BEARERTOKEN]
                        self.wc.callSimplewebservice(url: REPORTPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ReportPostResponsModel?) in
                            if sucess {
                                let sucess = response?.success
                                let message = response?.message
                                let data = response?.data
                                let report = data?.reported
                                
                                if sucess! {
                                    if report == 1 {
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.mainTableView.beginUpdates()
                                        self.mainTableView.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    let five: UIAlertAction = UIAlertAction(title: "Share", style: .default) { action -> Void in
                        let parameters = ["post_id":self.post_Id] as [String : Any]
                        let token = loggdenUser.value(forKey: TOKEN)as! String
                        let BEARERTOKEN = BEARER + token
                        let headers: HTTPHeaders = ["Xapi": XAPI,
                                                    "Accept" : ACCEPT,
                                                    "Authorization":BEARERTOKEN]
                        self.wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
                            if sucess {
                                let shareSucess = response?.success
                                let message = response?.message
                                if shareSucess! {
                                    self.arrFeed1 = self.arrFeed1.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_users_shared = 1
                                        }
                                        return mutableBook
                                    }
                                    print(response)
                                    AJMessage.show(title: "", message: "post is successfully shared",position:.top).onHide {_ in
                                        print("did dissmiss")
                                    }
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PostCreat"), object: nil)
                                    self.mainTableView.scrollToTop()
                                }
                            }
                        }
                    }
                    
//                    let six: UIAlertAction = UIAlertAction(title: "View post", style: .default) { action -> Void in
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//                        obj.postDetail_id = self.post_Id
//                        obj.usernamepost = usernamepost
//                        //self.navigationController?.pushViewController(obj, animated: true)
//                        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//                        obj.passappDel = "passappDel"
//                        self.present(naviget, animated: true, completion: nil)
//                    }
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
                    actionSheetController.addAction(firstAction)
                    actionSheetController.addAction(secondAction)
                    actionSheetController.addAction(third)
                    actionSheetController.addAction(Four)
                    actionSheetController.addAction(five)
//                    actionSheetController.addAction(six)
                    actionSheetController.addAction(cancelAction)
                    present(actionSheetController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnReadMoreAction(_ sender: UIButton) {
        let arrImages = arrFeed1[sender.tag].images
        print("arrImages: ",arrImages)
        
        
  
        for item in arrImages {
            let source_url = item
            print(source_url)
           
            if let url = URL(string: source_url) {
                UIApplication.shared.open(url)
            }

        }
       
    }

}


extension SavePostListVC: UITableViewDelegate,UITableViewDataSource,UITableViewDataSourcePrefetching, TTTAttributedLabelDelegate{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFeed1.count
    }
    
    @IBAction func btnImageAction(_ sender: UIButton) {
        print("Image click...")
        let arrImages = arrFeed1[sender.tag].images
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)

        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PreviewVC")as! PreviewVC
      
        
        pausePlayeVideos()
        let typeFeed = arrFeed1[sender.tag].type
        print("typeFeed: ",typeFeed)
        switch typeFeed {
        case "image":
            obj.type = typeFeed
            for item in arrImages {
                let source_url = item
                obj.source_url = source_url
            }
//            self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            self.present(obj, animated: false, completion: nil)
            break
            
        case "multi_image" :
            obj.images = arrFeed1[sender.tag].images
            obj.type = typeFeed
           // self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            self.present(obj, animated: false, completion: nil)
            break
            
        case "video":
            for item in arrImages {
                obj.type = typeFeed
                let source_url = item
                obj.source_url = source_url
            }
            obj.video_poster = arrFeed1[sender.tag].video_poster
//            self.navigationController?.pushViewController(obj, animated: true)
            obj.modalPresentationStyle = .fullScreen
            self.present(obj, animated: false, completion: nil)
            break
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeVCCell
        cell.btnStatusWidth.constant =  0
        //        cell.btnStatus.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
                let selectedUsername = arrFeed1[indexPath.row].username
                var name = arrFeed1[indexPath.row].users_name
                name = name.capitalizingFirstLetter()
                cell.lblUserName.text = name
                let shared_person_name = arrFeed1[indexPath.row].shared_person_name
                let shared_username = arrFeed1[indexPath.row].shared_username
                if shared_person_name.count == 0 {
                    arrUserTag = arrFeed1[indexPath.row].users_tagged
                    if arrUserTag.count == 1 {
                        let strName = arrUserTag[0].name
                        tagFirstUsername = arrUserTag[0].username
                        
                        let string = "\(name) with \(strName)"
                        let nsString = string as NSString
                        
                        let paragraphStyle = NSMutableParagraphStyle()
                        //UIFont.systemFont(ofSize: 15)
                        let fullAttributedString = NSAttributedString(string:string, attributes: [
                            NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont(name: "SFUIText-Medium", size: 17)!,
                            NSAttributedString.Key.foregroundColor: UIColor.white.cgColor,
                            ])
                       // cell.lblUserName.text = name//fullAttributedString;
                        
                        cell.lblTag.handleMentionTap { mentiontag in
                            self.usernamemention = strName
                            self.getMentionPost()
                        }
                        
                        cell.lblTag.text =  "@" + strName.decodeEmoji
                        cell.lblTag.enabledTypes = [.mention, .hashtag, .url]

                        cell.lblUserName.textColor = UIColor.white;
        //                cell.lblUserName.delegate = self;
                        
                        cell.lbldetailsBottom.constant = 8
                        cell.lblTagBottom.constant = 8
                    }
                    else if arrUserTag.count >= 2 {
                        for strNamegat in arrUserTag {
                            let name = strNamegat.name
                            let tagUsername = strNamegat.username
                            nameTag.append(name)
                            userTag.append(tagUsername)
                            self.strTageName = nameTag.joined(separator: ",")
                            strName = nameTag[0]
                            tagFirstUsername = userTag[0]
                        }
                        
                        var strmention = String()
                        for index in 0...arrUserTag.count - 1{
                            print("\(index)")
                            strmention = strmention.appending("@" + nameTag[index] + ",")
        //                    if index == arrUserTag.count - 1{
        //                        strmention = strmention.appending("@" + nameTag[index] )
        //                    }
        //                    else{
        //                        strmention = strmention.appending("@" + nameTag[index] + ", ")
        //                    }
                        }
                        
                    
                        let countOther = arrUserTag.count - 1
                        let strCount = String(countOther)
                        let FinalCount = strCount + " others."
                        
                        let strTC = strName
                        let strPP = FinalCount
                        
                        let string = "\(name) with \(strTC) and \(strPP)"
                        let nsString = string as NSString
                        
                        let paragraphStyle = NSMutableParagraphStyle()
                        
                        let fullAttributedString = NSAttributedString(string:string, attributes: [
                            NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont(name: "SFUIText-Medium", size: 17)!,
                            NSAttributedString.Key.foregroundColor: UIColor.white.cgColor,
                            ])
        //                cell.lblUserName.attributedText = fullAttributedString;
                        
                        
                        cell.lblTag.handleMentionTap { mentiontag in
                            self.usernamemention = mentiontag
                            self.getMentionPost()
                        }
                        
        //                let strmention1 = String(strmention.dropLast())
                        
                        strmention.remove(at: strmention.index(before: strmention.endIndex))
                        
                        cell.lblTag.text =  strmention.decodeEmoji//"@" + strTC.decodeEmoji + "@" + strPP.decodeEmoji
                        cell.lblTag.enabledTypes = [.mention, .hashtag, .url]
                        

                        cell.lblUserName.textColor = UIColor.white;
        //                cell.lblUserName.delegate = self;
                        
                        cell.lbldetailsBottom.constant = 8
                        cell.lblTagBottom.constant = 8
                    }
                    else {
                        
                        cell.lblTag.text = ""
                        cell.lbldetailsBottom.constant = -8
                        cell.lblTagBottom.constant = -8
                        
                    }

                }
                else {
                    let string = "\(name) shared \(shared_person_name) 's post"
                    let nsString = string as NSString

                    let paragraphStyle = NSMutableParagraphStyle()

                    let fullAttributedString = NSAttributedString(string:string, attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont(name: "SFUIText-Regular", size: 15)!,
                        NSAttributedString.Key.foregroundColor: UIColor.white.cgColor,
                    ])
                   // cell.lblUserName.attributedText = fullAttributedString;

                    let rangeMY = nsString.range(of: name)
                    let rangeTC = nsString.range(of: shared_person_name)

                    let MyLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor.white.cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]

                    let ppLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor.white.cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]
        //            cell.lblUserName.activeLinkAttributes = MyLinkAttributes
        //            cell.lblUserName.linkAttributes = ppLinkAttributes
        //            cell.lblUserName.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
        //            cell.lblUserName.addLink(toPhoneNumber: shared_username, with: rangeTC)
        //            cell.lblUserName.textColor = UIColor.white;
        //            cell.lblUserName.delegate = self;
                    
                    let normalText =  " shared \(shared_person_name) 's post"

                    let boldText  = name

                    let attrs1 = [NSAttributedString.Key.font : UIFont(name: "SFUIText-Regular", size: 14)!]
                    let attributedString = NSMutableAttributedString(string:normalText, attributes:attrs1)

                    let attrs = [NSAttributedString.Key.font : UIFont(name: "SFUIText-Medium", size: 17)!]
                    let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)

                    boldString.append(attributedString)
                  //  cell.lblUserName.attributedText = boldString

                    cell.lblTag.handleMentionTap { mentiontag in
                        self.usernamemention = mentiontag
                        self.getMentionPost()
                    }
                    
                    cell.lblTag.text =  "@" + shared_person_name.decodeEmoji
                    cell.lblTag.enabledTypes = [.mention, .hashtag, .url]
                    
                    if shared_person_name.count == 0{
                        
                    }
                    else{
                        cell.lbldetailsBottom.constant = 8
                        cell.lblTagBottom.constant = 8
                    }
                    
                    
                }
        cell.dotView.isHidden = true
        
        cell.btnChat.tag = indexPath.row
        cell.btnChat.addTarget(self, action: #selector(btnShowmoreComment(_:)), for: UIControl.Event.touchUpInside)
//
        cell.btnLikeClick.tag = indexPath.row
        cell.btnLikeClick.addTarget(self, action: #selector(btnTapLikes(_:)), for: UIControl.Event.touchUpInside)
//
        cell.btnClick.tag = indexPath.row
        cell.btnClick.addTarget(self, action: #selector(btnImageAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.pagerView.tag = indexPath.row
        cell.pagerView.delegate = self
//
        cell.btnStatus.isHidden = true
//        cell.btnStatus.tag = indexPath.row
//        cell.btnStatus.addTarget(self, action: #selector(btnStatusAction(_:)), for: UIControl.Event.touchUpInside)
//
        cell.btnReadMore.tag = indexPath.row
        cell.btnReadMore.addTarget(self, action: #selector(btnReadMoreAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnmore.tag = indexPath.row
        cell.btnmore.addTarget(self, action: #selector(btnMoreAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControl.Event.touchUpInside)

        cell.btnDisLike.tag = indexPath.row
        cell.btnDisLike.addTarget(self, action: #selector(btnDisLikeAction(_:)), for: UIControl.Event.touchUpInside)
        
//        if arrFeed1[indexPath.row].is_users_shared == 1{
////            cell.btnShare.isHidden = false
//            cell.btnLike.isSelected = true
//            cell.btnShare.setImage(UIImage(named: "sendfill"), for: .normal)
//        }
//        else{
////            cell.btnShare.isHidden = true
//            cell.btnLike.isSelected = false
//            cell.btnShare.setImage(UIImage(named: "send"), for: .normal)
//        }

        cell.btnShare.tag = indexPath.row
        cell.btnShare.addTarget(self, action: #selector(btnShareAction(_:)), for: UIControl.Event.touchUpInside)
//
        cell.btnMenu.tag = indexPath.row
        cell.btnMenu.addTarget(self, action: #selector(btnMenuAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnProfileClick.tag = indexPath.row
        cell.btnProfileClick.addTarget(self, action: #selector(btnProfileAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnUserNameClick.tag = indexPath.row
        cell.btnUserNameClick.addTarget(self, action: #selector(btnProfileAction(_:)), for: UIControl.Event.touchUpInside)
//
//        cell.btnChatMain.tag = indexPath.row
//        cell.btnChatMain.addTarget(self, action: #selector(btnChatAction(_:)), for: UIControl.Event.touchUpInside)
//
//        cell.btnLikePeople.tag = indexPath.row
//        cell.btnLikePeople.addTarget(self, action: #selector(btnLikesAction(_:)), for: UIControl.Event.touchUpInside)

            let typeFeed = arrFeed1[indexPath.row].type
//            cell.lblUserName.text = arrFeed1[indexPath.row].users_name
        
        cell.imgProfile.kf.setImage(with: URL(string: arrFeed1[indexPath.row].users_avatar),placeholder:UIImage(named: "Placeholder"))
      
//        let is_follow = arrFeed1[indexPath.row].is_follow
//        print("is_follow",is_follow)
//        if is_follow == 1 {
////            cell.btnStatus.isSelected = true
//            cell.btnStatus.tintColor = .ButtonTextColor
////            cell.btnStatus.setImage(UIImage(named: "Unfollow"), for: .normal)
//            cell.btnStatus.setTitle("Unfollow", for: .normal)
//        }
//        else if is_follow == 0{
////            cell.btnStatus.isSelected = false
//            cell.btnStatus.tintColor = .Blue
//            cell.btnStatus.setTitle("Follow", for: .normal)
//           // cell.btnStatus.setImage(UIImage(named: "Follow"), for: .normal)
//        }
//        else{
//            cell.btnStatus.tintColor = .Blue
//            cell.btnStatus.setTitle("Requested", for: .normal)
//        }
        
//        //MARK: - Description
//        let strdescription = arrFeed1[indexPath.row].description
//        if strdescription.count == 0 {
////            lbltop.constant = 0
////            imgtopconstraint.constant = 0
//            cell.lblDetails.isHidden = true
////            cell.lblDetailHeight.constant = 0
//        }
//        else {
////            lbltop.constant = 8
////            imgtopconstraint.constant = 8
//            cell.lblDetails.isHidden = false
//            cell.lblDetails.text = strdescription.decodeEmoji
//            cell.lblDetails.enabledTypes = [.mention, .hashtag, .url]
//            cell.lblDetails.hashtagColor = .white
//            cell.lblDetails.hashtagSelectedColor = .blue
////            cell.lblDetails.sizeToFit()
//        }

        
        cell.lblDetails.handleHashtagTap { hashtag in
            self.hashtagpost = hashtag
            self.getHashtagPost()
        }
        
        //MARK: - Date
        let postDate = arrFeed1[indexPath.row].created_at
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: postDate)!
        let datavala = Date().timeAgoSinceDate(date, numericDates: true)
        cell.lblTime.text = datavala
        cell.lblLocation.text =  arrFeed1[indexPath.row].location
//        if arrFeed1[indexPath.row].location == ""{
//            cell.btnLocationWidth.constant = 0
//        }
//        else{
//            cell.btnLocationWidth.constant = 13
//        }
        
        let totalLike = arrFeed1[indexPath.row].users_liked_count
        cell.lblLikeCount.text = String(totalLike)
        cell.lblDislikeCount.text = String(arrFeed1[indexPath.row].users_disliked_count)
//        let strLikeTotal = String(totalLike) + " Like"
//        if totalLike == 0 {
////            cell.viewtopConstraint.constant = -8
//            cell.lblLikeDescription.isHidden = true
//            cell.imgWidth1.constant = 0
//            cell.imgWidth2.constant = 0
//            cell.imgWidth3.constant = 0
//            cell.imgWidth4.constant = 0
////            cell.bottomViewHeight.constant = 110
//            cell.likeViewHeight.constant = 0
//            cell.btnLikeClick.isHidden = true
//        }
//        else{
//
//            let arrUserLiked = arrFeed1[indexPath.row].users_liked
//
//            cell.likeViewHeight.constant = 25
////            cell.viewtopConstraint.constant = 8
//            cell.lblLikeDescription.isHidden = false
//            cell.imgWidth1.constant = 25
//            cell.imgWidth2.constant = 25
//            cell.imgWidth3.constant = 25
//            cell.imgWidth4.constant = 25
////            cell.bottomViewHeight.constant = 150
//            cell.btnLikeClick.isHidden = false
//
////            if totalLike == 1{
////
////                    if arrUserLiked.count >= 1 {
////                        cell.img1.kf.setImage(with: URL(string: arrUserLiked[0]),placeholder:UIImage(named: "Placeholder"))
////                    }
////
////                cell.imgWidth1.constant = 25
////                cell.imgWidth2.constant = 0
////                cell.imgWidth3.constant = 0
////                cell.imgWidth4.constant = 0
////            }
////            else if totalLike == 2{
////
////                if arrUserLiked.count >= 2 {
////                    cell.img1.kf.setImage(with: URL(string: arrUserLiked[0]),placeholder:UIImage(named: "Placeholder"))
////                    cell.img2.kf.setImage(with: URL(string: arrUserLiked[1]),placeholder:UIImage(named: "Placeholder"))
////                }
////
////                cell.imgWidth1.constant = 25
////                cell.imgWidth2.constant = 25
////                cell.imgWidth3.constant = 0
////                cell.imgWidth4.constant = 0
////            }
////            else if totalLike == 3{
////
////                if arrUserLiked.count >= 3 {
////                    cell.img1.kf.setImage(with: URL(string: arrUserLiked[0]),placeholder:UIImage(named: "Placeholder"))
////                    cell.img2.kf.setImage(with: URL(string: arrUserLiked[1]),placeholder:UIImage(named: "Placeholder"))
////                    cell.img3.kf.setImage(with: URL(string: arrUserLiked[2]),placeholder:UIImage(named: "Placeholder"))
////                }
////
////                cell.imgWidth1.constant = 25
////                cell.imgWidth2.constant = 25
////                cell.imgWidth3.constant = 25
////                cell.imgWidth4.constant = 0
////            }
////            else if totalLike == 4{
////
////                if arrUserLiked.count >= 4 {
////                    cell.img1.kf.setImage(with: URL(string: arrUserLiked[0]),placeholder:UIImage(named: "Placeholder"))
////                    cell.img2.kf.setImage(with: URL(string: arrUserLiked[1]),placeholder:UIImage(named: "Placeholder"))
////                    cell.img3.kf.setImage(with: URL(string: arrUserLiked[2]),placeholder:UIImage(named: "Placeholder"))
////                    cell.img4.kf.setImage(with: URL(string: arrUserLiked[3]),placeholder:UIImage(named: "Placeholder"))
////                }
////
////                cell.imgWidth1.constant = 25
////                cell.imgWidth2.constant = 25
////                cell.imgWidth3.constant = 25
////                cell.imgWidth4.constant = 25
////            }
//
//        }
        
        cell.lblLikeDescription.attributedText = setLike(likedcount: String(totalLike))//boldString
//        cell.btnImgLike.setTitle(strLikeTotal, for: .normal)
        
        if arrFeed1[indexPath.row].location == ""{
            
            cell.lblTimeLeading.constant = 0
        }
        else{
            cell.lblTimeLeading.constant = 10
        }
        
        let is_liked = arrFeed1[indexPath.row].is_liked
        if is_liked == 1 {
            cell.btnLike.isSelected = true
//            cell.btnLike.setImage(UIImage(named: "likefill"), for: .normal)
            let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
            cell.btnLike.setImage(image, for: .normal)
            //cell.btnLike.tintColor = UIColor.red
            cell.btnLike.tintColor = UIColor(red: 0.93, green: 0.29, blue: 0.34, alpha: 1.00)
        }
        else {
            cell.btnLike.isSelected = false
            cell.btnLike.setImage(UIImage(named: "like"), for: .normal)
        }
        
        //MARK: - Dislike
        let is_disliked = arrFeed1[indexPath.row].is_disliked
        if is_disliked == 1 {
            cell.btnDisLike.isSelected = true
            cell.btnDisLike.setImage(UIImage(named: "dislikefill"), for: .normal)
        }
        else {
            cell.btnDisLike.isSelected = false
            cell.btnDisLike.setImage(UIImage(named: "dislike1"), for: .normal)
        }
        
        //MARK: - Description
        let strdescription = arrFeed1[indexPath.row].description
        if strdescription.count == 0 {
//            lbltop.constant = 0
//            imgtopconstraint.constant = 0
            cell.btnmore.isHidden = true
            cell.lblDetails.text = ""
            cell.btnmoreHeight.constant = 0
            cell.lbldetailsBottom.constant = -8
            cell.lblDetailsTop.constant = 0
//            cell.lblDetailHeight.constant = 0
            cell.lblDetails.isHidden = true
//            cell.lblDetailHeight.constant = 0
        }
        else {
//            lbltop.constant = 8
//            imgtopconstraint.constant = 8
//            cell.btnmore.isHidden =  false
            cell.lblDetails.numberOfLines = 1
//            cell.lblDetailHeight.constant = 17
            cell.btnmoreHeight.constant = 16
            cell.lbldetailsBottom.constant = 8
            cell.lblDetailsTop.constant = 8
            cell.lblDetails.isHidden = false
            cell.lblDetails.text = strdescription.decodeEmoji
            cell.lblDetails.enabledTypes = [.mention, .hashtag, .url]
            cell.lblDetails.hashtagColor = .white
            cell.lblDetails.hashtagSelectedColor = .blue
            
            
            let maxSize = CGSize(width: cell.lblDetails.frame.size.width, height: CGFloat(MAXFLOAT))

            let labelRect = cell.lblDetails.text?.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [
                NSAttributedString.Key.font: cell.lblDetails.font
            ], context: nil)

            print("size \(NSCoder.string(for: labelRect!.size))")
            
            if (labelRect?.size.height)! >= 16{
                cell.btnmore.isHidden = false
            }
            else{
                cell.btnmore.isHidden = true
            }

        }
        
        if arrFeed1[indexPath.row].is_sponsored == 1{
            cell.lblTime.text = "Sponsored"
            cell.lblLocation.isHidden = true
        }
        
        cell.lblviewcounter.text = String(arrFeed1[indexPath.row].post_view_counter)
        
            print("typeFeed: ",typeFeed)
            switch typeFeed {
            case "image":
//
                cell.configureCell(imageUrl: "", description: "", videoUrl:"")
                cell.btnClick.isHidden = false
//                cell.btnclick.isHidden = false
                cell.countView.isHidden = true
//                cell.pagerView.isHidden = true
//                cell.pageControl.isHidden = true
                cell.imageview.isHidden = false
                cell.imageviewBackground.isHidden = false
                cell.shotImageView.isHidden = true
//                cell.btn_play.isHidden = true
//                cell.imageview.contentMode = .scaleAspectFit
                cell.images = []
                cell.pagerView.reloadData()

                let arrImages = arrFeed1[indexPath.row].images

                for item in arrImages {
                    let source_url = item
                print(source_url)
                    cell.imageviewBackground.kf.setImage(with: URL(string: source_url),placeholder:UIImage(named: "Placeholder"))
//                    blurImage(img: cell.imageviewBackground)
                    
                    cell.imageview.kf.setImage(with: URL(string: source_url),placeholder:UIImage(named: "Placeholder"))
                }
                
            
                break

            case "multi_image" :
                
                cell.configureCell(imageUrl: "", description: "", videoUrl:"")
                cell.btnClick.isHidden = true
                
                cell.countView.isHidden = false
                
//                cell.pageControl.isHidden = true
//                cell.pagerView.isHidden = false
                cell.shotImageView.isHidden = true
                cell.imageview.isHidden = true
                cell.imageviewBackground.isHidden = false
//                cell.btn_play.isHidden = true
//                cell.countView.isHidden = false
                cell.images = arrFeed1[indexPath.row].images
                images = arrFeed1[indexPath.row].images
//                cell.pageControl.numberOfPages = arrFeed1[indexPath.row].images.count
                cell.lblPageCount.text = "1" + "/" + String(arrFeed1[indexPath.row].images.count)
//                cell.btnclick.isHidden = true
                cell.imageviewBackground.kf.setImage(with: URL(string: arrFeed1[indexPath.row].images[0]),placeholder:UIImage(named: "Placeholder"))
                cell.pagerView.reloadData()
                break

            case "video":
                cell.btnClick.isHidden = false
                let arrImages = arrFeed1[indexPath.row].images

                cell.images = []
                cell.pagerView.reloadData()
//                cell.btnclick.isHidden = false
//                cell.pagerView.isHidden = true
//                cell.pageControl.isHidden = true
                cell.imageview.isHidden = true
                cell.imageviewBackground.isHidden = false
//                cell.btn_play.isHidden = false
                cell.countView.isHidden = true
                cell.shotImageView.isHidden = false
//                cell.imageview.contentMode = .scaleToFill
//                cell.imageview.layer.cornerRadius = 5
//                cell.imageview.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
//                cell.imageview.clipsToBounds = true
//                cell.imageview.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
//                cell.imageview.layer.borderWidth = 0.5
//                cell.videoLayer.backgroundColor = UIColor.black.cgColor
//                cell.videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                cell.imageview.layer.addSublayer(cell.videoLayer)
//                cell.selectionStyle = .none
                
                for item in arrImages {
                    let source_url = item
                    cell.configureCell(imageUrl: arrFeed1[indexPath.row].video_poster, description: "Video", videoUrl:source_url)
//                    cell.imageviewBackground.kf.setImage(with: URL(string: arrFeed1[indexPath.row].video_poster),placeholder:UIImage(named: "Placeholder"))
//                    cell.configureCell(imageUrl: arrFeed1[indexPath.row].video_poster, description: "", videoUrl: source_url)
//                    cell.configure(post: arrFeed1[indexPath.row].video_poster)
                }
                
                break
                
            case "custom_url":
                cell.ViewCustomeUrl.isHidden = false
                cell.configureCell(imageUrl: "", description: "", videoUrl:"")
//                cell.btnclick.isHidden = false
                cell.countView.isHidden = true
//                cell.pagerView.isHidden = true
//                cell.pageControl.isHidden = true
                cell.imageview.isHidden = true
                cell.imageviewBackground.isHidden = true
                cell.shotImageView.isHidden = true
//                cell.btn_play.isHidden = true
//                cell.imageview.contentMode = .scaleAspectFit
                cell.images = []
                cell.pagerView.reloadData()
                cell.pagerView.backgroundColor = .gray
                let arrImages = arrFeed1[indexPath.row].images
                print("arrImages: ",arrImages)
                
                
                if arrImages.count == 0{
//
                }
                
                for item in arrImages {
                    let source_url = item
                    print(source_url)
                    cell.strURl = source_url
                    cell.displayWebView()


                }
                cell.btnClick.isHidden = true
                break
            default:
                break
            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        ViewCounter(post_id: arrFeed1[indexPath.row].id ,indexpath: indexPath)
        
        if arrFeed1[indexPath.row].is_sponsored == 1{
            GetImpression(impression: "impression", post_id: arrFeed1[indexPath.row].id)
        }
        
//        GetImpression(impression: "impression", post_id: arrFeed[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            pausePlayeVideos()
//        }
//    }
    
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: mainTableView)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: mainTableView, appEnteredFromBackground: true)
    }
    
    func getMentionPost(){
        
        let username = self.usernamemention
//            let type = arrFeed1[sender.tag].type
//            let group_Type = arrFeed[sender.tag].groups_type
//            let status_group = arrFeed[sender.tag].groups_status
//            let pageAdmin = arrFeed[sender.tag].is_page_admin
//            let event_type = arrFeed[sender.tag].event_type
//            let invite_privacy = arrFeed[sender.tag].invite_privacy
//            let post_privacy = arrFeed[sender.tag].post_privacy
//            let member_privacy = arrFeed[sender.tag].member_privacy
//            let is_guest = arrFeed[sender.tag].is_guest
            let myprofile = loggdenUser.value(forKey: USERNAME)as! String
            
            
//            if type == "user" {
                if myprofile == username {
    //                currentTabBar?.setIndex(4)
                    
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
    //                loggdenUser.set(username, forKey: FRIENDSUSERNAME)
    //                obj.strUserName = username
                    //self.navigationController?.pushViewController(obj, animated: false)
                    obj.modalPresentationStyle = .fullScreen
                    self.present(obj, animated: false, completion: nil)
                }
                else {
                    loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
                    loggdenUser.set(username, forKey: FRIENDSUSERNAME)
                    loggdenUser.set(username, forKey: UNAME)
                    obj.strUserName = username
//                    self.navigationController?.pushViewController(obj, animated: false)
                    obj.modalPresentationStyle = .fullScreen
                    self.present(obj, animated: false, completion: nil)
                }
//            }

    }
    
    func getHashtagPost(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//        let obj = self.storyboard?.instantiateViewController(withIdentifier: "HashtagSearchTimelineController")as! HashtagSearchTimelineController
//        obj.hashtagpost = hashtagpost
//        self.navigationController?.pushViewController(obj, animated: false)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowseVC")as! BrowseVC
        obj.hashtagpost = hashtagpost
        obj.strUrlType = "#"
        obj.modalPresentationStyle = .fullScreen
        self.present(obj, animated: false, completion: nil)//pushViewController(obj, animated: false)
    }

}


extension SavePostListVC{
    @IBAction func btnShowmoreComment(_ sender: UIButton) {
//        DisplayViewMain.isHidden = true
//        mainTableView.isScrollEnabled = false

        if let indexPath = self.mainTableView.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            post_Id = arrFeed1[indexPath.row].id
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewControllers")as! CommentsViewControllers
            obj.postId = self.post_Id
            //self.navigationController?.pushViewController(obj, animated: true)
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
           // self.present(naviget, animated: true, completion: nil)
            self.navigationController?.pushViewController(obj, animated: false)
        }
    }
    
    @IBAction func btnTapLikes(_ sender: UIButton) {
        print("Please Help!")
        let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let obj = launchStoryBoard.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
        obj.post_id = arrFeed1[sender.tag].id
        present(obj, animated: false, completion: nil)//pushViewController(obj, animated: false)
    }
    
    @IBAction func btnMoreAction(_ sender: UIButton) {
        if let indexPath = self.mainTableView.indexPathForView(sender) {

            let cellfeed = mainTableView.cellForRow(at: indexPath) as! HomeVCCell
            cellfeed.lblDetails.numberOfLines = 0
            cellfeed.lblDetails.sizeToFit()
            cellfeed.btnmore.isHidden = true
        }
    }
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
            
        if let indexPath = self.mainTableView.indexPathForView(sender) {

            let cellfeed = mainTableView.cellForRow(at: indexPath) as! HomeVCCell
            post_Id = arrFeed1[indexPath.row].id
            let like_count = arrFeed1[indexPath.row].users_liked_count
            let parameters = ["post_id":post_Id] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            if let button = sender as? UIButton {
                if button.isSelected {
                    button.isSelected = false
                    
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        cellfeed.btnLike.transform = cellfeed.btnLike.transform.scaledBy(x: 0.7, y: 0.7)
                        cellfeed.btnLike.setImage(UIImage(named: "like"), for: .normal)
                        }, completion: { _ in
                          UIView.animate(withDuration: 0.1, animations: {
                            cellfeed.btnLike.transform = CGAffineTransform.identity
                          })
                        })
                    
                    //cellfeed.btnLike.setImage(UIImage(named: "like"), for: .normal)
                     wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
                        if sucess {
                            if response!.liked {
                                self.arrFeed1 = self.arrFeed1.map{
                                    var mutableBook = $0
                                    if $0.id == self.post_Id {
                                        mutableBook.is_liked = 1
                                        mutableBook.users_liked_count = like_count + 1
                                    }
                                    return mutableBook
                                }
                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)

                              
                                
                                cellfeed.lblLikeDescription.attributedText = self.setLike(likedcount:likeCount ?? "0")
                                
//                                self.tblFeed.beginUpdates()
                               
//                                self.tblFeed.endUpdates()
//                                cellfeed.animatedview.isHidden = false
//                                cellfeed.lbl_coininfo.text = "-" + String(response?.coin ?? "0") + " Coin"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                    self.mainTableView.endUpdates()
                                    
                                    
                                }
                            }
                            else {
                                self.arrFeed1 = self.arrFeed1.map{
                                    var mutableBook = $0
                                    if $0.id == self.post_Id {
                                        mutableBook.is_liked = 0
                                        mutableBook.users_liked_count = like_count - 1
                                    }
                                    return mutableBook
                                }
                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)
                                cellfeed.lblLikeDescription.attributedText = self.setLike(likedcount:likeCount ?? "0")

//                                self.tblFeed.beginUpdates()
                               
                            
//                                self.tblFeed.endUpdates()
                                
//                                cellfeed.animatedview.isHidden = false
//                                cellfeed.lbl_coininfo.text = "-" + String(response?.coin ?? "0") + " Coin"
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                    self.mainTableView.endUpdates()
                                }
                            }
                        }
                    }
                } else {
                    button.isSelected = true
                    
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        cellfeed.btnLike.transform = cellfeed.btnLike.transform.scaledBy(x: 1.3, y: 1.3)
                        let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                        cellfeed.btnLike.setImage(image, for: .normal)
                       // cellfeed.btnLike.tintColor = UIColor.red
                        
                        cellfeed.btnLike.tintColor = UIColor(red: 0.93, green: 0.29, blue: 0.34, alpha: 1.00)
                        
                        }, completion: { _ in
                          UIView.animate(withDuration: 0.1, animations: {
                            cellfeed.btnLike.transform = CGAffineTransform.identity
                          })
                        })
                    
                    //cellfeed.btnLike.setImage(UIImage(named: "likefill"), for: .normal)
                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
                        if sucess {
                            if response!.liked {
                                self.arrFeed1 = self.arrFeed1.map{
                                    var mutableBook = $0
                                    if $0.id == self.post_Id {
                                        mutableBook.is_liked = 1
                                        mutableBook.users_liked_count = like_count + 1
                                    }
                                    return mutableBook
                                }
                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.animatedview.isHidden = false
//                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)
                                cellfeed.lblLikeDescription.attributedText = self.setLike(likedcount:likeCount ?? "0")
//                                cellfeed.lbl_coininfo.text = "+" + String(response?.coin ?? "0") + " Coin"

//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                            }
                            else {
                                self.arrFeed1 = self.arrFeed1.map{
                                    var mutableBook = $0
                                    if $0.id == self.post_Id {
                                        mutableBook.is_liked = 0
                                        mutableBook.users_liked_count = like_count - 1
                                    }
                                    return mutableBook
                                }
                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.animatedview.isHidden = false
//                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)
                                cellfeed.lblLikeDescription.attributedText = self.setLike(likedcount:likeCount ?? "0")
//                                cellfeed.lbl_coininfo.text = "+" + String(response?.coin ?? "0") + " Coin"

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                            }

                        }
                    }
                }
                
            }
        }


    }
    
    @IBAction func btnDisLikeAction(_ sender: UIButton) {
        if let indexPath = self.mainTableView.indexPathForView(sender) {
                let cellfeed = mainTableView.cellForRow(at: indexPath) as! HomeVCCell
                post_Id = arrFeed1[indexPath.row].id
                let like_count = arrFeed1[indexPath.row].users_disliked_count
                let parameters = ["post_id":post_Id] as [String : Any]
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept" : ACCEPT,
                                            "Authorization":BEARERTOKEN]
                if let button = sender as? UIButton {
                    if button.isSelected {
                        button.isSelected = false
                        cellfeed.btnDisLike.setImage(UIImage(named: "dislike1"), for: .normal)
                        wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
                            if sucess {
                                if response!.disliked {
                                    self.arrFeed1 = self.arrFeed1.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_disliked = 1
                                            mutableBook.users_disliked_count = like_count + 1
                                        }
                                        return mutableBook
                                    }
//                                    let likeCount = response?.dislikecount
//                                    let strLikeTotal = likeCount! + " Dislike"
//                                    cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                    self.mainTableView.endUpdates()
                                }
                                else {
                                    self.arrFeed1 = self.arrFeed1.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_disliked = 0
                                            mutableBook.users_disliked_count = like_count - 1
                                        }
                                        return mutableBook
                                    }
//                                    let likeCount = response?.dislikecount
//                                    let strLikeTotal = likeCount! + " Dislike"
//                                    cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                    self.mainTableView.endUpdates()
                                }
                            }
                        }
                    } else {
                        button.isSelected = true
                        cellfeed.btnDisLike.setImage(UIImage(named: "dislikefill"), for: .normal)
                        wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
                            if sucess {
                                if response!.disliked {
                                    self.arrFeed1 = self.arrFeed1.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_disliked = 1
                                            mutableBook.users_disliked_count = like_count + 1
                                        }
                                        return mutableBook
                                    }
//                                    let likeCount = response?.dislikecount
//                                    let strLikeTotal = likeCount! + " Dislike"
//                                    cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                                else {
                                    self.arrFeed1 = self.arrFeed1.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_disliked = 0
                                            mutableBook.users_disliked_count = like_count - 1
                                        }
                                        return mutableBook
                                    }
//                                    let likeCount = response?.dislikecount
//                                    let strLikeTotal = likeCount! + " Dislike"
//                                    cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                            }
                        }
                    }
                }
            }
        
    }
    
    @IBAction func btnShareAction(_ sender: UIButton) {
        
        if let indexPath = self.mainTableView.indexPathForView(sender) {
            //            let cellfeed = mainTableView.cellForRow(at: indexPath) as! HomeVCCell
            //            post_Id = arrFeed[indexPath.row].id
            
            let text = arrFeed1[indexPath.row].post_link ///"This is some text that I want to share."
            
            // set up activity view controller
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
            }
        
            

    }
    
    @IBAction func btnProfileAction(_ sender: UIButton){
        
        let username = arrFeed1[sender.tag].username
//            let type = arrFeed[sender.tag].type
//            let group_Type = arrFeed[sender.tag].groups_type
//            let status_group = arrFeed[sender.tag].groups_status
//            let pageAdmin = arrFeed[sender.tag].is_page_admin
//            let event_type = arrFeed[sender.tag].event_type
//            let invite_privacy = arrFeed[sender.tag].invite_privacy
//            let post_privacy = arrFeed[sender.tag].post_privacy
//            let member_privacy = arrFeed[sender.tag].member_privacy
//            let is_guest = arrFeed[sender.tag].is_guest
            let myprofile = loggdenUser.value(forKey: USERNAME)as! String
            
            
//            if type == "user" {
                if myprofile == username {
    //                currentTabBar?.setIndex(4)
                    
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
    //                loggdenUser.set(username, forKey: FRIENDSUSERNAME)
    //                obj.strUserName = username
                    self.navigationController?.pushViewController(obj, animated: false)
                }
                else {
                    loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
                    loggdenUser.set(username, forKey: FRIENDSUSERNAME)
                    loggdenUser.set(username, forKey: UNAME)
                    obj.strUserName = username
                    self.navigationController?.pushViewController(obj, animated: false)
                }
//            }

    }
}


// MARK: - ScrollView Extension
extension SavePostListVC {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let cell = self.mainTableView.cellForRow(at: IndexPath(row: self.currentIndex, section: 0)) as? HomeTableViewCell
//        cell?.replay()
//        if !decelerate {
//            pausePlayeVideos()
//        }
        if !decelerate {
            pausePlayeVideos()
        }
        print("end scrolling...")

        
        let index = mainTableView.indexPathsForVisibleRows
        for index1 in index ?? [] {
            print("count:",arrFeed1.count)
            print("indexV:",index1.row)
//            if index1.row == 0 {
//                print("indexV:",index?.last)
//            }
            if ((index1.row + 1) == arrFeed1.count){
//                mainTableView.reloadData()
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: mainTableView.bounds.width, height: CGFloat(44))
                let lastIndexPath = mainTableView.lastIndexpath()
                lastIndex_id = arrFeed1[lastIndexPath.row].id
                timeline_last_first_id = lastIndex_id
                timeline_Type_top_bottom = "Bottom"
//                print("pageCount: ",pageCount)
//                getFeed(strPage: "\(pageCount)")
                self.mainTableView.tableFooterView = spinner
                self.mainTableView.tableFooterView?.isHidden = false
                
                FlagDataSave = 1
                //firstTime()
                GetSaveList()
              
            }
        }
        
    }
    
}


extension SavePostListVC: FSPagerViewDelegate{

    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        print("PageTag: ",pagerView.tag)
        print("images: ",images)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let obj = storyboard.instantiateViewController(withIdentifier: "PreviewVC")as! PreviewVC
        let naviget = UINavigationController()// = UINavigationController(rootViewController: obj)
        obj.images = images
        obj.type = "multi_image"
        navigationController?.pushViewController(obj, animated: true)
        
        
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        self.pageControl.currentPage = targetIndex
//        lblPageCount.text = String(targetIndex+1) + "/" + String(images.count)
        let label:UILabel = self.view.viewWithTag(884) as! UILabel
        label.text = String(targetIndex+1) + "/" + String(images.count)
        
        let imageviewBackground:UIImageView = self.view.viewWithTag(885) as! UIImageView
        imageviewBackground.kf.setImage(with: URL(string:images[targetIndex]),placeholder:UIImage(named: "Placeholder"))
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
//        self.pageControl.currentPage = pagerView.currentIndex
    }
    
}

var FlagDataSave = 0
