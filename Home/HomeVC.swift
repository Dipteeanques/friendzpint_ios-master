//
//  HomeVC.swift
//  FriendzPoint
//
//  Created by Anques on 12/02/21.
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

class HomeVC: UIViewController {
    @IBOutlet weak var imgLogo: UIImageView!
    
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    var wc = Webservice.init()
    var timeline_last_first_id = Int()
    var arrFeed = [MyTimelineList]()
    var lastIndex_id = Int()
    var timeline_Type_top_bottom = String()
    
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
    
    var images = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        setDefault()
    }
    
    func setDefault(){
        

        navigationController?.navigationBar.isHidden = true
        navigationController?.setStatusBar(backgroundColor: .black)
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
        firstTime()
       
    }
    
    @objc func refresh(sender:AnyObject) {
        timeline_last_first_id = arrFeed[0].id
        timeline_Type_top_bottom = "Top"
        transparentView.backgroundColor = .clear
        imgLogo.isHidden = true
        
        //getFeed(strPage: "1")
        FlagData = 1
        firstTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainTableView.beginUpdates()
        currentTabBar?.setBar(hidden: false, animated: false)
        mainTableView.endUpdates()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainTableView.beginUpdates()
//        currentTabBar?.tabBarHeight = 50
        currentTabBar?.setBar(hidden: false, animated: false)
        mainTableView.endUpdates()
//        mainTableView.reloadData()
        
        pausePlayeVideos()
    }
    
    @IBAction func btnCameraAction(_ sender: Any) {
        Flag = 2
//        showPicker()
        let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let obj = launchStoryBoard.instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
        obj.check = "camera"
        obj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(obj, animated: false, completion: nil)
        
    }
    
    @IBAction func btnChatAction(_ sender: Any) {
        let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let obj = launchStoryBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        //self.navigationController?.pushViewController(obj, animated: false)
        obj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(obj, animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func firstTime(){
        let parameters = ["timeline_last_post_id": timeline_last_first_id,
                          "timeline_type":timeline_Type_top_bottom] as [String : Any]//"Bottom"
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
//        print("parameters: ",parameters)
//        print("headers: ",headers)
//        print("SHOWFEED: ",SHOWFEED)
        wc.callSimplewebservice(url: SHOWFEED, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in
            //            print("response:",response.re)
            if sucess {
                
                self.transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.imgLogo.isHidden = false
                let sucessMy = response?.success
                if sucessMy! {
//                    print("firsttime: ",response)
//                    self.arrFeed.removeAll()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    self.mainTableView.isHidden = false
                    if self.arrFeed.count == 0{
                        self.arrFeed = response!.data!
//                        self.mainTableView.scrollToTop()
                        self.refreshControl.endRefreshing()
                        self.spinner.stopAnimating()
                        self.mainTableView.reloadData()
                    }
                    else{
                        if FlagData == 1{
                            print("parameters: ",parameters)
                            print("headers: ",headers)
                            print("SHOWFEED: ",SHOWFEED)
                            let arr_dict = response!.data!
                            self.loaderView.isHidden = true
                            self.activity.stopAnimating()
                            
                            if self.timeline_Type_top_bottom == "Top"{
                                
                                if arr_dict.count > 0{
                                    self.arrFeed.removeAll()
                                    
                                }
                               
                            }
//                            else{
                                for i in 0..<arr_dict.count
                                {
                                    self.arrFeed.append(arr_dict[i])
                                    self.refreshControl.endRefreshing()
                                    self.spinner.stopAnimating()
        //                            self.arrFeed.insert(arr_dict![i], at: 0)
                                }
//                            }
                            

                            self.mainTableView.reloadData()
                            FlagData = 0
                        }
                    }
                 
                    
                }
                else {
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.spinner.stopAnimating()
                }
            }
            else {
                self.transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.imgLogo.isHidden = false
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
                self.refreshControl.endRefreshing()
                self.spinner.stopAnimating()
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
        
        let attrs = [NSAttributedString.Key.font : UIFont(name: "SFUIText-Regular", size: 14)!,NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor] as [NSAttributedString.Key : Any]
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        
        //        let boldString1 = NSMutableAttributedString(string: boldText1, attributes:attrs)
        
        //        boldString.append(attributedString)
        boldString.append(attributedString1)
        //        boldString.append(boldString1)
       return boldString
    }
    //MARK: ------ btnMenuAction
    
    @objc func btnMenuAction(_ sender: UIButton) {
        if let indexPath = self.mainTableView.indexPathForView(sender) {
            let is_my_post = arrFeed[indexPath.row].is_my_post
            post_Id = arrFeed[indexPath.row].id
            let SavePost = arrFeed[indexPath.row].is_saved
            let Notification = arrFeed[indexPath.row].is_notification
            let editdescription = arrFeed[indexPath.row].description
            let usernamepost = arrFeed[indexPath.row].users_name
            let shared_post_id = arrFeed[indexPath.row].shared_post_id
            let shared_person_name = arrFeed[indexPath.row].shared_person_name
            let shared_username = arrFeed[indexPath.row].shared_username
            let is_users_shared = arrFeed[indexPath.row].is_users_shared
            
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
                                    self.arrFeed = self.arrFeed.map{
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
                                    self.arrFeed = self.arrFeed.map{
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
                        self.arrFeed.remove(at: indexPath.row)
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
                        self.arrFeed.remove(at: indexPath.row)
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
                                        self.arrFeed = self.arrFeed.map{
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
                                        self.arrFeed = self.arrFeed.map{
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
                        self.arrFeed.remove(at: indexPath.row)
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
                                        self.arrFeed = self.arrFeed.map{
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
                                        self.arrFeed = self.arrFeed.map{
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
                        self.arrFeed.remove(at: indexPath.row)
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
                                        self.arrFeed = self.arrFeed.map{
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
                                        self.arrFeed = self.arrFeed.map{
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
                        self.arrFeed.remove(at: indexPath.row)
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
                                        self.arrFeed = self.arrFeed.map{
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
                                        self.arrFeed = self.arrFeed.map{
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
                        self.arrFeed.remove(at: indexPath.row)
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
                                    self.arrFeed = self.arrFeed.map{
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
    

    
    @IBAction func btnStatusAction(_ sender: UIButton) {
        
        if let indexPath = self.mainTableView.indexPathForView(sender) {
            let cell = mainTableView.cellForRow(at: indexPath) as! HomeVCCell
            cell.btnStatus.showLoader(userInteraction: true)
            cell.btnStatus.setTitle("", for: .normal)
            let timeVala_id = arrFeed[indexPath.row].timeline_id
            //                self.arrFeed.remove(at: indexPath.row)
            //                self.mainTableView.deleteRows(at: [indexPath], with: .fade)
            
            let parameters = ["timeline_id" : timeVala_id]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callSimplewebservice(url: FOLLOW, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: FriendsResponsModel?) in
                if sucess {
                    let suc = response?.success
                    if suc! {
                        if response?.followed == true{
                            cell.btnStatus.setTitle("Unfollow", for: .normal)
                            cell.btnStatus.tintColor = .ButtonTextColor
                            for i in 0...(self.arrFeed.count-1){
                                if self.arrFeed[i].timeline_id == timeVala_id{
                                    self.arrFeed[i].is_follow = 1
                                }
                            }
                            cell.btnStatus.hideLoader()
                        }
                        else{
                            cell.btnStatus.setTitle("Follow", for: .normal)
                            cell.btnStatus.tintColor = .Blue
                            for i in 0...(self.arrFeed.count-1){
                                if self.arrFeed[i].timeline_id == timeVala_id{
                                    self.arrFeed[i].is_follow = 0
                                }
                            }
                            cell.btnStatus.hideLoader()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.mainTableView.beginUpdates()
                            self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                            self.mainTableView.endUpdates()
                           
                        }
                    }
                }
            }
            
//            let parameters = ["timeline_id" : timeVala_id]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
            
//            if arrFeed[indexPath.row].is_follow == 1{
//                wc.callSimplewebservice(url: REMOVEFRIENDS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: RemoveFriendsResponseModel?) in
//                    if sucess {
//                        let status = response?.status
//                        if status == "200" {
//                            print("sucess")
//                            cell.btnStatus.setTitle("Follow", for: .normal)
//                            self.arrFeed[indexPath.row].is_follow = 0
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
////                                    cellfeed.animatedview.isHidden = true
//                                self.mainTableView.beginUpdates()
//                                self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.mainTableView.endUpdates()
//
//
//                            }
//                        }
//                    }
//                }
//            }
//            else if arrFeed[indexPath.row].is_follow == 0{
//                wc.callSimplewebservice(url: USERFOLLOWREQUEST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendsRequestSentResponsModel?) in
//                    if sucess {
//                        let suc = response?.success
//                        if suc! {
//                            let data = response?.data
//                            let follow = data?.followrequest
//                            if follow! {
//                                cell.btnStatus.setTitle("Requested", for: .normal)
//                                self.arrFeed[indexPath.row].is_follow = 2
//                            }
//                            else {
//                                cell.btnStatus.setTitle("Follow", for: .normal)
//                                self.arrFeed[indexPath.row].is_follow = 1
//                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
////                                    cellfeed.animatedview.isHidden = true
//                                self.mainTableView.beginUpdates()
//                                self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.mainTableView.endUpdates()
//
//
//                            }
//                        }
//                    }
//                }
//
//
//            }
        }
        
    }
}

extension HomeVC: UITableViewDelegate,UITableViewDataSource,UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFeed.count
    }
    
    
    @IBAction func btnImageAction(_ sender: UIButton) {
        print("Image click...")
        let arrImages = arrFeed[sender.tag].images
        

        let obj = self.storyboard?.instantiateViewController(withIdentifier: "PreviewVC")as! PreviewVC
      
        self.modalPresentationStyle = .fullScreen
        pausePlayeVideos()
        let typeFeed = arrFeed[sender.tag].type
        print("typeFeed: ",typeFeed)
        switch typeFeed {
        case "image":
            obj.type = typeFeed
            for item in arrImages {
                let source_url = item
                obj.source_url = source_url
            }
            //self.navigationController?.pushViewController(obj, animated: true)
            self.navigationController?.present(obj, animated: false, completion: nil)
            break
            
        case "multi_image" :
            obj.images = arrFeed[sender.tag].images
            obj.type = typeFeed
//            self.navigationController?.pushViewController(obj, animated: true)
            self.navigationController?.present(obj, animated: false, completion: nil)
            break
            
        case "video":
            for item in arrImages {
                obj.type = typeFeed
                let source_url = item
                obj.source_url = source_url
            }
            obj.video_poster = arrFeed[sender.tag].video_poster
//            self.navigationController?.pushViewController(obj, animated: true)
            self.navigationController?.present(obj, animated: false, completion: nil)
            break
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeVCCell
       
        let myprofile = loggdenUser.value(forKey: USERNAME)as! String
        
        if arrFeed[indexPath.row].username == myprofile{
            cell.btnStatus.isHidden = true
        }
        else{
            cell.btnStatus.isHidden = false
        }
        
        
        cell.btnStatus.backgroundColor = .ButtonColor
        let is_follow = arrFeed[indexPath.row].is_follow
        print("is_follow",is_follow)
        if is_follow == 1 {
//            cell.btnStatus = LoadingButton(text: "Unfollow", textColor: .ButtonTextColor, bgColor: .ButtonColor)
//            cell.btnStatus.isSelected = true
            cell.btnStatus.tintColor = .ButtonTextColor
//            cell.btnStatus.setImage(UIImage(named: "Unfollow"), for: .normal)
            cell.btnStatus.setTitle("Unfollow", for: .normal)
        }
        else if is_follow == 0{
//            cell.btnStatus.isSelected = false
//            cell.btnStatus = LoadingButton(text: "Follow", textColor: .Blue, bgColor: .ButtonColor)
            cell.btnStatus.tintColor = .Blue
            cell.btnStatus.setTitle("Follow", for: .normal)
           // cell.btnStatus.setImage(UIImage(named: "Follow"), for: .normal)
        }
        
        if arrFeed[indexPath.row].is_users_shared == 1{
            cell.btnShare.isHidden = false
        }
        else{
            cell.btnShare.isHidden = true
        }
        
        cell.arrFeed1 = arrFeed
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
        cell.btnStatus.tag = indexPath.row
        cell.btnStatus.addTarget(self, action: #selector(btnStatusAction(_:)), for: UIControl.Event.touchUpInside)
//
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControl.Event.touchUpInside)

        cell.btnDisLike.tag = indexPath.row
        cell.btnDisLike.addTarget(self, action: #selector(btnDisLikeAction(_:)), for: UIControl.Event.touchUpInside)

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

            let typeFeed = arrFeed[indexPath.row].type
            cell.lblUserName.text = arrFeed[indexPath.row].users_name
        
        cell.imgProfile.kf.setImage(with: URL(string: arrFeed[indexPath.row].users_avatar),placeholder:UIImage(named: "Placeholder"))
      

//        else{
//            cell.btnStatus.tintColor = .Blue
//            cell.btnStatus.setTitle("Requested", for: .normal)
//        }
        
        //MARK: - Date
        let postDate = arrFeed[indexPath.row].created_at
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: postDate)!
        let datavala = Date().timeAgoSinceDate(date, numericDates: true)
        cell.lblTime.text = datavala
        cell.lblLocation.text =  arrFeed[indexPath.row].location
        if arrFeed[indexPath.row].location == ""{
            cell.btnLocationWidth.constant = 0
        }
        else{
            cell.btnLocationWidth.constant = 13
        }
        
        let totalLike = arrFeed[indexPath.row].users_liked_count
//        let strLikeTotal = String(totalLike) + " Like"
        if totalLike == 0 {
            cell.lblLikeDescription.isHidden = true
            cell.imgWidth1.constant = 0
            cell.imgWidth2.constant = 0
            cell.imgWidth3.constant = 0
            cell.imgWidth4.constant = 0
            cell.bottomViewHeight.constant = 110
            cell.btnLikeClick.isHidden = true
        }
        else{
            cell.lblLikeDescription.isHidden = false
            cell.imgWidth1.constant = 25
            cell.imgWidth2.constant = 25
            cell.imgWidth3.constant = 25
            cell.imgWidth4.constant = 25
            cell.bottomViewHeight.constant = 150
            cell.btnLikeClick.isHidden = false
            
            if totalLike == 1{
                cell.imgWidth1.constant = 25
                cell.imgWidth2.constant = 0
                cell.imgWidth3.constant = 0
                cell.imgWidth4.constant = 0
            }
            else if totalLike == 2{
                cell.imgWidth1.constant = 25
                cell.imgWidth2.constant = 25
                cell.imgWidth3.constant = 0
                cell.imgWidth4.constant = 0
            }
            else if totalLike == 3{
                cell.imgWidth1.constant = 25
                cell.imgWidth2.constant = 25
                cell.imgWidth3.constant = 25
                cell.imgWidth4.constant = 0
            }

        }
        
        cell.lblLikeDescription.attributedText = setLike(likedcount: String(totalLike))//boldString
//        cell.btnImgLike.setTitle(strLikeTotal, for: .normal)
        
        
        let is_liked = arrFeed[indexPath.row].is_liked
        if is_liked == 1 {
            cell.btnLike.isSelected = true
//            cell.btnLike.setImage(UIImage(named: "likefill"), for: .normal)
            
            let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
            cell.btnLike.setImage(image, for: .normal)
            cell.btnLike.tintColor = UIColor.red
        }
        else {
            cell.btnLike.isSelected = false
            cell.btnLike.setImage(UIImage(named: "like"), for: .normal)
        }
        
        //MARK: - Dislike
        let is_disliked = arrFeed[indexPath.row].is_disliked
        if is_disliked == 1 {
            cell.btnDisLike.isSelected = true
            cell.btnDisLike.setImage(UIImage(named: "dislikefill"), for: .normal)
        }
        else {
            cell.btnDisLike.isSelected = false
            cell.btnDisLike.setImage(UIImage(named: "dislike1"), for: .normal)
        }
        
            print("typeFeed: ",typeFeed)
            switch typeFeed {
            case "image":
//
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

                let arrImages = arrFeed[indexPath.row].images

                for item in arrImages {
                    let source_url = item
                    cell.imageviewBackground.kf.setImage(with: URL(string: source_url),placeholder:UIImage(named: "Placeholder"))
//                    blurImage(img: cell.imageviewBackground)
                    
                    cell.imageview.kf.setImage(with: URL(string: source_url),placeholder:UIImage(named: "Placeholder"))
                }
                cell.btnClick.isHidden = false
            
                break

            case "multi_image" :

                cell.btnClick.isHidden = true
                cell.countView.isHidden = false
                
//                cell.pageControl.isHidden = true
//                cell.pagerView.isHidden = false
                cell.shotImageView.isHidden = true
                cell.imageview.isHidden = true
                cell.imageviewBackground.isHidden = true
//                cell.btn_play.isHidden = true
//                cell.countView.isHidden = false
                cell.images = arrFeed[indexPath.row].images
                images = arrFeed[indexPath.row].images
//                cell.pageControl.numberOfPages = arrFeed[indexPath.row].images.count
                cell.lblPageCount.text = "1" + "/" + String(arrFeed[indexPath.row].images.count)
//                cell.btnclick.isHidden = true
                cell.pagerView.reloadData()
                break

            case "video":
                cell.btnClick.isHidden = false
                let arrImages = arrFeed[indexPath.row].images

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
                    cell.configureCell(imageUrl: arrFeed[indexPath.row].video_poster, description: "Video", videoUrl:source_url)
//                    cell.imageviewBackground.kf.setImage(with: URL(string: arrFeed[indexPath.row].video_poster),placeholder:UIImage(named: "Placeholder"))
//                    cell.configureCell(imageUrl: arrFeed[indexPath.row].video_poster, description: "", videoUrl: source_url)
//                    cell.configure(post: arrFeed[indexPath.row].video_poster)
                }
                
                break
            default:
                break
            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.loaderView.frame.height

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.loaderView.frame.height
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
    
}

extension HomeVC{
    @IBAction func btnShowmoreComment(_ sender: UIButton) {
//        DisplayViewMain.isHidden = true
//        mainTableView.isScrollEnabled = false

        if let indexPath = self.mainTableView.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            post_Id = arrFeed[indexPath.row].id
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewControllers")as! CommentsViewControllers
            obj.postId = self.post_Id
            //self.navigationController?.pushViewController(obj, animated: true)
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
           // self.present(naviget, animated: true, completion: nil)
//            self.navigationController?.pushViewController(obj, animated: false)
            self.navigationController?.present(naviget, animated: false, completion: nil)
        }
    }
    
    @IBAction func btnTapLikes(_ sender: UIButton) {
        print("Please Help!")
        let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let obj = launchStoryBoard.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
        obj.post_id = arrFeed[sender.tag].id
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
//    func animate(newImage: UIImage, newScale: CGFloat) {
//        var transform = CGAffineTransform()
//        UIView.animate(withDuration: 0.1, animations: {
////          let newImage = self.isLiked ? self.likedImage : self.unlikedImage
////          let newScale = self.isLiked ? self.likedScale : self.unlikedScale
//          transform = transform.scaledBy(x: newScale, y: newScale)
//          self.setImage(newImage, for: .normal)
//        }, completion: { _ in
//          UIView.animate(withDuration: 0.1, animations: {
//            transform = CGAffineTransform.identity
//          })
//        })
//      }
    
    
    
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
            
        if let indexPath = self.mainTableView.indexPathForView(sender) {

            let cellfeed = mainTableView.cellForRow(at: indexPath) as! HomeVCCell
            post_Id = arrFeed[indexPath.row].id
            let like_count = arrFeed[indexPath.row].users_liked_count
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
                    
//                    cellfeed.btnLike.setImage(UIImage(named: "like"), for: .normal)
                     wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
                        if sucess {
                            if response!.liked {
                                self.arrFeed = self.arrFeed.map{
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
                                self.arrFeed = self.arrFeed.map{
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
//                    cellfeed.btnLike.setImage(UIImage(named: "likefill"), for: .normal)
                    
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        cellfeed.btnLike.transform = cellfeed.btnLike.transform.scaledBy(x: 1.3, y: 1.3)
                        let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                        cellfeed.btnLike.setImage(image, for: .normal)
                        cellfeed.btnLike.tintColor = UIColor.red
                        
                        }, completion: { _ in
                          UIView.animate(withDuration: 0.1, animations: {
                            cellfeed.btnLike.transform = CGAffineTransform.identity
                          })
                        })
                    
                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
                        if sucess {
                            if response!.liked {
                                self.arrFeed = self.arrFeed.map{
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
                                self.arrFeed = self.arrFeed.map{
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
                post_Id = arrFeed[indexPath.row].id
                let like_count = arrFeed[indexPath.row].users_disliked_count
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
                                    self.arrFeed = self.arrFeed.map{
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
                                    self.arrFeed = self.arrFeed.map{
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
                                    self.arrFeed = self.arrFeed.map{
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
                                    self.arrFeed = self.arrFeed.map{
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
                    self.arrFeed = self.arrFeed.map{
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
    
    @IBAction func btnProfileAction(_ sender: UIButton){
        
        let username = arrFeed[sender.tag].username
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
                    //self.navigationController?.pushViewController(obj, animated: false)
                    self.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(obj, animated: false, completion: nil)
                }
                else {
                    loggdenUser.removeObject(forKey: FRIENDSUSERNAME)
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
                    loggdenUser.set(username, forKey: FRIENDSUSERNAME)
                    loggdenUser.set(username, forKey: UNAME)
                    obj.strUserName = username
//                    self.navigationController?.pushViewController(obj, animated: false)
                    self.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(obj, animated: false, completion: nil)
                }
//            }

    }
}

// MARK: - ScrollView Extension
extension HomeVC {
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
            print("count:",arrFeed.count)
            print("indexV:",index1.row)
//            if index1.row == 0 {
//                print("indexV:",index?.last)
//            }
            if ((index1.row + 1) == arrFeed.count){
//                mainTableView.reloadData()
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: mainTableView.bounds.width, height: CGFloat(44))
                let lastIndexPath = mainTableView.lastIndexpath()
                lastIndex_id = arrFeed[lastIndexPath.row].id
                timeline_last_first_id = lastIndex_id
                timeline_Type_top_bottom = "Bottom"
//                print("pageCount: ",pageCount)
//                getFeed(strPage: "\(pageCount)")
                self.mainTableView.tableFooterView = spinner
                self.mainTableView.tableFooterView?.isHidden = false
                FlagData = 1
                firstTime()
              
            }
        }
        
    }
    
}

extension HomeVC: YPImagePickerDelegate{
    // MARK: - Configuration
    @objc
    func showPicker() {

        var config = YPImagePickerConfiguration()

        /* Uncomment and play around with the configuration 👨‍🔬 🚀 */

        /* Set this to true if you want to force the  library output to be a squared image. Defaults to false */
//         config.library.onlySquare = true

        /* Set this to true if you want to force the camera output to be a squared image. Defaults to true */
        // config.onlySquareImagesFromCamera = false

        /* Ex: cappedTo:1024 will make sure images from the library or the camera will be
           resized to fit in a 1024x1024 box. Defaults to original image size. */
        // config.targetImageSize = .cappedTo(size: 1024)

        /* Choose what media types are available in the library. Defaults to `.photo` */
        config.library.mediaType = .photo
        config.library.itemOverlayType = .grid
        /* Enables selecting the front camera by default, useful for avatars. Defaults to false */
        // config.usesFrontCamera = true

        /* Adds a Filter step in the photo taking process. Defaults to true */
        // config.showsFilters = false

        /* Manage filters by yourself */
//        config.filters = [YPFilter(name: "Mono", coreImageFilterName: "CIPhotoEffectMono"),
//                          YPFilter(name: "Normal", coreImageFilterName: "")]
//        config.filters.remove(at: 1)
//        config.filters.insert(YPFilter(name: "Blur", coreImageFilterName: "CIBoxBlur"), at: 1)

        /* Enables you to opt out from saving new (or old but filtered) images to the
           user's photo library. Defaults to true. */
        config.shouldSaveNewPicturesToAlbum = false

        /* Choose the videoCompression. Defaults to AVAssetExportPresetHighestQuality */
        config.video.compression = AVAssetExportPresetMediumQuality

        /* Defines the name of the album when saving pictures in the user's photo library.
           In general that would be your App name. Defaults to "DefaultYPImagePickerAlbumName" */
        // config.albumName = "ThisIsMyAlbum"

        /* Defines which screen is shown at launch. Video mode will only work if `showsVideo = true`.
           Default value is `.photo` */
        config.startOnScreen = .library

        /* Defines which screens are shown at launch, and their order.
           Default value is `[.library, .photo]` */
        config.screens = [.photo]//, .video

        /* Can forbid the items with very big height with this property */
//        config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8

        /* Defines the time limit for recording videos.
           Default is 30 seconds. */
        // config.video.recordingTimeLimit = 5.0

        /* Defines the time limit for videos from the library.
           Defaults to 60 seconds. */
        config.video.libraryTimeLimit = 500.0

        /* Adds a Crop step in the photo taking process, after filters. Defaults to .none */
//        config.showsCrop = .rectangle(ratio: (16/9))

        /* Defines the overlay view for the camera. Defaults to UIView(). */
        // let overlayView = UIView()
        // overlayView.backgroundColor = .red
        // overlayView.alpha = 0.3
        // config.overlayView = overlayView

        /* Customize wordings */
        config.wordings.libraryTitle = "Gallery"

        /* Defines if the status bar should be hidden when showing the picker. Default is true */
        config.hidesStatusBar = false

        /* Defines if the bottom bar should be hidden when showing the picker. Default is false */
        config.hidesBottomBar = false

        config.maxCameraZoomFactor = 2.0

        config.library.maxNumberOfItems = 5
        config.gallery.hidesRemoveButton = false

        /* Disable scroll to change between mode */
        // config.isScrollToChangeModesEnabled = false
//        config.library.minNumberOfItems = 2

        /* Skip selection gallery after multiple selections */
        // config.library.skipSelectionsGallery = true

        /* Here we use a per picker configuration. Configuration is always shared.
           That means than when you create one picker with configuration, than you can create other picker with just
           let picker = YPImagePicker() and the configuration will be the same as the first picker. */

        /* Only show library pictures from the last 3 days */
        //let threDaysTimeInterval: TimeInterval = 3 * 60 * 60 * 24
        //let fromDate = Date().addingTimeInterval(-threDaysTimeInterval)
        //let toDate = Date()
        //let options = PHFetchOptions()
        // options.predicate = NSPredicate(format: "creationDate > %@ && creationDate < %@", fromDate as CVarArg, toDate as CVarArg)
        //
        ////Just a way to set order
        //let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        //options.sortDescriptors = [sortDescriptor]
        //
        //config.library.options = options

        config.library.preselectedItems = selectedItems


        // Customise fonts
        //config.fonts.menuItemFont = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        //config.fonts.pickerTitleFont = UIFont.systemFont(ofSize: 22.0, weight: .black)
        //config.fonts.rightBarButtonFont = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        //config.fonts.navigationBarTitleFont = UIFont.systemFont(ofSize: 22.0, weight: .heavy)
        //config.fonts.leftBarButtonFont = UIFont.systemFont(ofSize: 22.0, weight: .heavy)

        let picker = YPImagePicker(configuration: config)

        picker.imagePickerDelegate = self

        /* Change configuration directly */
        // YPImagePickerConfiguration.shared.wordings.libraryTitle = "Gallery2"

        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in

            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
//                self.appDel.gotoDashboardController()
                self.currentTabBar?.setIndex(0)
                return
            }
            _ = items.map { print("🧀 \($0)") }

            self.selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    
                    picker.dismiss(animated: true, completion: nil)
                    let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let obj = launchStoryBoard.instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
                    obj.selectedImageV.image = photo.image
                    self.navigationController?.pushViewController(obj, animated: true)
                case .video(let video):
                    let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let obj = launchStoryBoard.instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
                    obj.selectedImageV.image = video.thumbnail
                    self.navigationController?.pushViewController(obj, animated: true)
                    let assetURL = video.url
                    let playerVC = AVPlayerViewController()
                    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
                    playerVC.player = player

                    picker.dismiss(animated: true, completion: { [weak self] in
                        self?.present(playerVC, animated: true, completion: nil)
//                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                }
            }
        }

        /* Single Photo implementation. */
        // picker.didFinishPicking { [unowned picker] items, _ in
        //     self.selectedItems = items
        //     self.selectedImageV.image = items.singlePhoto?.image
        //     picker.dismiss(animated: true, completion: nil)
        // }

        /* Single Video implementation. */
        //picker.didFinishPicking { [unowned picker] items, cancelled in
        //    if cancelled { picker.dismiss(animated: true, completion: nil); return }
        //
        //    self.selectedItems = items
        //    self.selectedImageV.image = items.singleVideo?.thumbnail
        //
        //    let assetURL = items.singleVideo!.url
        //    let playerVC = AVPlayerViewController()
        //    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
        //    playerVC.player = player
        //
        //    picker.dismiss(animated: true, completion: { [weak self] in
        //        self?.present(playerVC, animated: true, completion: nil)
        //        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
        //    })
        //}

        present(picker, animated: true, completion: nil)
    }
    
    func noPhotos() {}

    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true// indexPath.row != 2
    }
    
}
extension HomeVC: FSPagerViewDelegate{

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
    
}


extension UIViewController{
    func blurImage(img:UIImageView){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = img.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        img.addSubview(blurEffectView)
    }
}



var FlagData = 0

