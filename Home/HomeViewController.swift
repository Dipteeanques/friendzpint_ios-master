//
//  HomeViewController.swift
//  FriendzPoint
//
//  Created by Anques on 09/01/21.
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

class HomeViewController: UIViewController {
    
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
    var selectedItems = [YPMediaItem]()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!

    // MARK: - UI Components
    var mainTableView: UITableView!
    var wc = Webservice.init()
    var timeline_last_first_id = Int()
    var arrFeed = [MyTimelineList]()
    var spinner = UIActivityIndicatorView()
    var isNewDataLoading = false
    var timeline_Type_top_bottom = String()
    // MARK: - Variables
    let cellId = "cell"
    var pageCount = Int()
    var lastIndex_id = Int()
    var arrmulti_image = ["https://i.pinimg.com/originals/9f/55/28/9f5528c7a02b3169e4e1c6c814d28fe6.jpg", "https://cdn.wallpapersafari.com/19/30/voSBxR.jpg","https://blog.hdwallsource.com/wp-content/uploads/2015/05/lovely-mood-wallpaper-38930-39824-hd-wallpapers.jpg"]
    var arrVideo = "https://friendzpoint.blob.core.windows.net/frp/uploads/users/gallery/20201226114814LtpiPdCASW.mp4"
    
    var arrmulti_image1 = ["https://i.pinimg.com/originals/9f/55/28/9f5528c7a02b3169e4e1c6c814d28fe6.jpg", "https://cdn.wallpapersafari.com/19/30/voSBxR.jpg","https://blog.hdwallsource.com/wp-content/uploads/2015/05/lovely-mood-wallpaper-38930-39824-hd-wallpapers.jpg"]
    var arrimages = ["https://lava360.com/wp-content/uploads/2015/06/cute-iphone-wallpaper-22.jpg",
                     "https://i.pinimg.com/originals/86/07/f4/8607f4a9cfba77dcfb4bf8c0fc7c06b1.jpg",
                     "https://i.pinimg.com/736x/9c/3f/51/9c3f51863dc220b436ae5d9ae69f223c.jpg",
                     "multi",
                     "https://i.pinimg.com/originals/f1/66/04/f166048af1dada596ef552f56b04343c.jpg",
                     "https://i.pinimg.com/originals/3f/24/13/3f24134d56b3f23c4ff108f9ef4c53ce.jpg",
                     "video",
                     "https://images.unsplash.com/photo-1425082661705-1834bfd09dca?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb",
                     "video",
                     "https://indiabright.com/wp-content/uploads/2015/10/beautiful-and-cute-animals-wallpaper-21.jpg"]
    var arrIsLiked = ["0","0","0","0","0","0","0","0","0","0"]
    var arrDisLiked = ["0","0","0","0","0","0","0","0","0","0"]
    var arrFollow = ["0","0","0","0","0","0","0","0","0","0"]
    var DisplayViewMain = UIView()
    var imgUrl = String()
    var imageViewMain = UIImageView()
    var imgbackground = UIImageView()
    var scrollView = UIScrollView()
    var btnClose = UIButton()
    var post: Post?
    ///
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    var shotImageView = UIImageView()
    
    var post_Id = Int()
    var strSaveUnsave = String()
    var strNotification = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(loaderView)
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
//            if count == 0{
//                currentTabBar!.setBadgeText(nil, atIndex: 3)
//            }
//            else{
//                currentTabBar!.setBadgeText(String(count), atIndex: 3)
//            }
        }
        setupView()
      //  navigationController?.setStatusBar(backgroundColor: .white)
        self.navigationController?.navigationBar.isHidden = true
    
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollchange(notification:)), name: Notification.Name("scrollchange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollchange1(notification:)), name: Notification.Name("scrollchange1"), object: nil)
       
        // Do any additional setup after loading the view.
//        mainTableView.rowHeight = UITableView.automaticDimension;
//        mainTableView.estimatedRowHeight = UIScreen.main.bounds.height
        firstTime()
        DisplayViewMain.frame = CGRect(x: 0, y: self.loaderView.frame.origin.y, width: self.view.frame.width, height: self.loaderView.frame.height)
        DisplayViewMain.backgroundColor = .white
        self.view.addSubview(DisplayViewMain)
        DisplayViewMain.isHidden = true
        
        
        imgbackground.frame = CGRect(x: 0, y: 0, width: self.DisplayViewMain.frame.width, height: self.DisplayViewMain.frame.height)
//        imageViewMain.backgroundColor = .clear
        self.DisplayViewMain.addSubview(imgbackground)
        imgbackground.contentMode = .scaleAspectFill
        
        btnClose.frame = CGRect(x:self.view.frame.width - 50 , y: 20, width: 50, height: 50)
        btnClose.setImage(UIImage(named: "Cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.DisplayViewMain.addSubview(btnClose)
        btnClose.addTarget(self, action: #selector(btnHide(_:)), for: .allTouchEvents)
        btnClose.tintColor = UIColor.black
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.DisplayViewMain.frame.width, height: self.DisplayViewMain.frame.height)
        self.DisplayViewMain.addSubview(scrollView)
        
        imageViewMain.frame = CGRect(x: 0, y: 0, width: self.DisplayViewMain.frame.width, height: self.scrollView.frame.height)
//        imageViewMain.backgroundColor = .clear
        self.scrollView.addSubview(imageViewMain)
        imageViewMain.contentMode = .scaleAspectFit
        


        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        
        scrollView.delegate = self
        //
        shotImageView.frame = CGRect(x: 0, y: 80, width: imageViewMain.frame.size.width, height: imageViewMain.frame.size.height-80)
        shotImageView.backgroundColor = UIColor.black
        videoLayer.backgroundColor = UIColor.black.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        
        self.DisplayViewMain.addSubview(shotImageView)
        self.DisplayViewMain.sendSubviewToBack(shotImageView)
        shotImageView.layer.addSublayer(videoLayer)
//        shotImageView.contentMode = .scaleAspectFit
        
//        DispatchQueue.global(qos: .default).async(execute: { [self] in
//            // Do something...
//            DispatchQueue.main.async(execute: { [self] in
//                MBProgressHUD.hide(for: view, animated: true)
//            })
//        })
        
        blurImage(img: imgbackground)
        
//        if let items = self.tabBarController?.tabBar.items as NSArray? {
//            let tabItem = items.object(at: 3) as! UITabBarItem
//            tabItem.badgeValue = "34"
//        }
    }
    
//    func blurImage(img:UIImageView){
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = img.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        img.addSubview(blurEffectView)
//    }
//
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewMain
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageViewMain.image {
                let ratioW = imageViewMain.frame.width / image.size.width
                let ratioH = imageViewMain.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageViewMain.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageViewMain.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imageViewMain.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - imageViewMain.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
    
    @IBAction func btnHide(_ sender: UIButton) {
        DisplayViewMain.isHidden = true
        ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: videoLayer, url:videoURL ?? "")
    }
    
    func firstTime(){
        let parameters = ["timeline_last_post_id": timeline_last_first_id,
                          "timeline_type":"Bottom"] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        print("parameters: ",parameters)
        print("headers: ",headers)
        print("SHOWFEED: ",SHOWFEED)
        wc.callSimplewebservice(url: SHOWFEED, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in
            //            print("response:",response.re)
            if sucess {
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
                        self.mainTableView.reloadData()
                    }
                    else{
                        let arr_dict = response!.data!
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        
                        for i in 0..<arr_dict.count
                        {
                            self.arrFeed.append(arr_dict[i])
//                            self.arrFeed.insert(arr_dict![i], at: 0)
                        }
                        self.mainTableView.reloadData()
                    }
                 
                    
                }
                else {
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
            }
            else {
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
            }
        }
    }
    
//    func AddFriends() {
//        let parameters = ["timeline_id" : timeVala_id]
//        let token = loggdenUser.value(forKey: TOKEN)as! String
//        let BEARERTOKEN = BEARER + token
//        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                    "Accept" : ACCEPT,
//                                    "Authorization":BEARERTOKEN]
//        
//        wc.callSimplewebservice(url: USERFOLLOWREQUEST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendsRequestSentResponsModel?) in
//            if sucess {
//                let suc = response?.success
//                if suc! {
//                    let data = response?.data
//                    let follow = data?.followrequest
//                    if follow! {
////                        self.btnFriends.setTitle("Requested", for: .normal)
//                    }
//                    else {
////                        self.btnFriends.setTitle("Add Friends", for: .normal)
////                        self.btnFriends.setTitle("Follow", for: .normal)
//                    }
//                }
//            }
//        }
//    }
    
    /// Set up Views
    func setupView(){
        // Table View
        mainTableView = UITableView()
//        mainTableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        mainTableView.backgroundColor = .white
        mainTableView.translatesAutoresizingMaskIntoConstraints = false  // Enable Auto Layout
        mainTableView.tableFooterView = UIView()
        mainTableView.isPagingEnabled = true
        mainTableView.contentInsetAdjustmentBehavior = .never
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.separatorStyle = .none
        view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints({ make in
            make.edges.equalTo(self.loaderView)//equalToSuperview()
        })
        mainTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.prefetchDataSource = self
        
        mainTableView.isHidden = true
        loaderView.isHidden = false
        activity.startAnimating()
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
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseReels"), object: nil)
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
                let four: UIAlertAction = UIAlertAction(title: "View post", style: .default) { action -> Void in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseReels"), object: nil)
                    
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
                    obj.postDetail_id = self.post_Id
                    obj.usernamepost = usernamepost
                    //self.navigationController?.pushViewController(obj, animated: true)
                    let naviget: UINavigationController = UINavigationController(rootViewController: obj)
                    obj.passappDel = "passappDel"
                    self.present(naviget, animated: true, completion: nil)
                }
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
                actionSheetController.addAction(firstAction)
                actionSheetController.addAction(secondAction)
                actionSheetController.addAction(third)
                actionSheetController.addAction(four)
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
                    let five: UIAlertAction = UIAlertAction(title: "View post", style: .default) { action -> Void in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseReels"), object: nil)
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
                        obj.postDetail_id = self.post_Id
                        obj.usernamepost = usernamepost
                        //self.navigationController?.pushViewController(obj, animated: true)
                        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
                        obj.passappDel = "passappDel"
                        self.present(naviget, animated: true, completion: nil)
                    }
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
                    actionSheetController.addAction(firstAction)
                    actionSheetController.addAction(secondAction)
                    actionSheetController.addAction(third)
                    actionSheetController.addAction(Four)
                    actionSheetController.addAction(five)
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
                    
                    let six: UIAlertAction = UIAlertAction(title: "View post", style: .default) { action -> Void in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseReels"), object: nil)
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
                        obj.postDetail_id = self.post_Id
                        obj.usernamepost = usernamepost
                        //self.navigationController?.pushViewController(obj, animated: true)
                        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
                        obj.passappDel = "passappDel"
                        self.present(naviget, animated: true, completion: nil)
                    }
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
                    actionSheetController.addAction(firstAction)
                    actionSheetController.addAction(secondAction)
                    actionSheetController.addAction(third)
                    actionSheetController.addAction(Four)
                    actionSheetController.addAction(five)
                    actionSheetController.addAction(six)
                    actionSheetController.addAction(cancelAction)
                    present(actionSheetController, animated: true, completion: nil)
                }
            }
        }
    }

}
// MARK: - Table View Extensions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching{
    
    @IBAction func btnChatAction(_ sender: UIButton) {
        let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let obj = launchStoryBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    @IBAction func btnShowmoreComment(_ sender: UIButton) {
        DisplayViewMain.isHidden = true
//        mainTableView.isScrollEnabled = false

        if let indexPath = self.mainTableView.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseReels"), object: nil)
            post_Id = arrFeed[indexPath.row].id
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
            obj.postDetail_id = self.post_Id
            //self.navigationController?.pushViewController(obj, animated: true)
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
            obj.passappDel = "passappDel"
            self.present(naviget, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCameraAction(_ sender: UIButton) {
        showPicker()
    }
    
    @IBAction func btnStatusAction(_ sender: UIButton) {
        
        //        if let indexPath = self.mainTableView.indexPathForView(sender) {
        //            let cell = mainTableView.cellForRow(at: indexPath) as! HomeTableViewCell
        //            if arrFollow[sender.tag] == "1" {
        //                cell.btnStatus.setTitle("Follow", for: .normal)
        //                cell.btnStatus.tintColor = .Blue
        //                arrFollow[sender.tag] = "0"
        //            } else {
        //                cell.btnStatus.setTitle("Unfollow", for: .normal)
        //                cell.btnStatus.tintColor = .ButtonTextColor
        //                arrFollow[sender.tag] = "1"
        //            }
        //        }
        
        //        @objc func btnfriendsRemoveAction(_ sender: UIButton) {
        if let indexPath = self.mainTableView.indexPathForView(sender) {
            let cell = mainTableView.cellForRow(at: indexPath) as! HomeTableViewCell
            let timeVala_id = arrFeed[indexPath.row].timeline_id
            //                self.arrFeed.remove(at: indexPath.row)
            //                self.mainTableView.deleteRows(at: [indexPath], with: .fade)
            let parameters = ["timeline_id" : timeVala_id]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            if arrFeed[indexPath.row].is_follow == 1{
                wc.callSimplewebservice(url: REMOVEFRIENDS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: RemoveFriendsResponseModel?) in
                    if sucess {
                        let status = response?.status
                        if status == "200" {
                            print("sucess")
                            cell.btnStatus.setTitle("Follow", for: .normal)
                            self.arrFeed[indexPath.row].is_follow = 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                    cellfeed.animatedview.isHidden = true
                                self.mainTableView.beginUpdates()
                                self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.mainTableView.endUpdates()
                                
                                
                            }
                        }
                    }
                }
            }
            else if arrFeed[indexPath.row].is_follow == 0{
                wc.callSimplewebservice(url: USERFOLLOWREQUEST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendsRequestSentResponsModel?) in
                    if sucess {
                        let suc = response?.success
                        if suc! {
                            let data = response?.data
                            let follow = data?.followrequest
                            if follow! {
                                cell.btnStatus.setTitle("Requested", for: .normal)
                                self.arrFeed[indexPath.row].is_follow = 2
                            }
                            else {
                                cell.btnStatus.setTitle("Follow", for: .normal)
                                self.arrFeed[indexPath.row].is_follow = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                    cellfeed.animatedview.isHidden = true
                                self.mainTableView.beginUpdates()
                                self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.mainTableView.endUpdates()
                                
                                
                            }
                        }
                    }
                }
                
                
            }
        }
        
    }

    func AddFriends(timeVala_id: Int) {
        let parameters = ["timeline_id" : timeVala_id]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: USERFOLLOWREQUEST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendsRequestSentResponsModel?) in
            if sucess {
                let suc = response?.success
                if suc! {
                    let data = response?.data
                    let follow = data?.followrequest
                    if follow! {
//                        self.btnFriends.setTitle("Requested", for: .normal)
                    }
                    else {
//                        self.btnFriends.setTitle("Add Friends", for: .normal)
//                        self.btnFriends.setTitle("Follow", for: .normal)
                    }
                }
            }
        }
    }
    

    
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
            
        if let indexPath = self.mainTableView.indexPathForView(sender) {

            let cellfeed = mainTableView.cellForRow(at: indexPath) as! HomeTableViewCell
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
                    cellfeed.btnlike.setImage(UIImage(named: "like"), for: .normal)
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
                    cellfeed.btnlike.setImage(UIImage(named: "likefill"), for: .normal)
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
                let cellfeed = mainTableView.cellForRow(at: indexPath) as! HomeTableViewCell
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
                        cellfeed.btndislike.setImage(UIImage(named: "dislike1"), for: .normal)
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
                        cellfeed.btndislike.setImage(UIImage(named: "dislikefill"), for: .normal)
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
        
    }
    
    @objc func btnLikesAction(_ sender: UIButton) {
        if let indexPath = self.mainTableView.indexPathForView(sender) {
            post_Id = arrFeed[indexPath.row].id
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseReels"), object: nil)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
            obj.post_id = post_Id
            self.navigationController?.pushViewController(obj, animated: false)
        }
    }
    
    @IBAction func btnImageAction(_ sender: UIButton) {
        print("Image click...")
        let arrImages = arrFeed[sender.tag].images
        
        for item in arrImages {
            let source_url = item
            imgUrl = source_url
        }
        
        let typeFeed = arrFeed[sender.tag].type
        print("typeFeed: ",typeFeed)
        switch typeFeed {
        case "image":
            scrollView.addSubview(btnClose)
            imgbackground.isHidden = false
            scrollView.isHidden = false
            self.DisplayViewMain.isHidden = false
            imageViewMain.isHidden = false
            shotImageView.isHidden = true
            self.DisplayViewMain.backgroundColor = .white
            btnClose.tintColor = UIColor.black
            imageViewMain.kf.setImage(with: URL(string: imgUrl),placeholder:UIImage(named: "Placeholder"))
            imgbackground.kf.setImage(with: URL(string: imgUrl),placeholder:UIImage(named: "Placeholder"))
            
            break
            
        case "multi_image" :
            self.DisplayViewMain.isHidden = true
            break
            
        case "video":
            DisplayViewMain.addSubview(btnClose)
            self.DisplayViewMain.isHidden = false
            self.DisplayViewMain.backgroundColor = .black
            imageViewMain.isHidden = true
            scrollView.isHidden = true
            shotImageView.isHidden = false
            imgbackground.isHidden = true
            configureCell(imageUrl:  arrFeed[sender.tag].video_poster, description: "", videoUrl:imgUrl )
            btnClose.tintColor = UIColor.white
            break
        default:
            break
        }
        
    }
    
    @objc private func scrollchange(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        DisplayViewMain.isHidden = true
        mainTableView.isScrollEnabled = true
    }
    
    @objc private func scrollchange1(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        DisplayViewMain.isHidden = true
        mainTableView.isScrollEnabled = false
    }
    //LikeViewController
    
//    @objc func btnShowImage(_ sender: UITapGestureRecognizer){
//        print("clickimg",sender)
//        print("imgUrl: ",imgUrl)
//    }
    
    @IBAction func btnTapLikes(_ sender: UIButton) {
        print("Please Help!")
        let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let obj = launchStoryBoard.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFeed.count//arrimages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeTableViewCell
        cell.btnChat.tag = indexPath.row
        cell.btnChat.addTarget(self, action: #selector(btnShowmoreComment(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnCamera.tag = indexPath.row
        cell.btnCamera.addTarget(self, action: #selector(btnCameraAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnclick.tag = indexPath.row
        cell.btnclick.addTarget(self, action: #selector(btnImageAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnStatus.tag = indexPath.row
        cell.btnStatus.addTarget(self, action: #selector(btnStatusAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnlike.tag = indexPath.row
        cell.btnlike.addTarget(self, action: #selector(btnLikeAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btndislike.tag = indexPath.row
        cell.btndislike.addTarget(self, action: #selector(btnDisLikeAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btn_share.tag = indexPath.row
        cell.btn_share.addTarget(self, action: #selector(btnShareAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnmenu.tag = indexPath.row
        cell.btnmenu.addTarget(self, action: #selector(btnMenuAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnChatMain.tag = indexPath.row
        cell.btnChatMain.addTarget(self, action: #selector(btnChatAction(_:)), for: UIControl.Event.touchUpInside)
        
        cell.btnLikePeople.tag = indexPath.row
        cell.btnLikePeople.addTarget(self, action: #selector(btnLikesAction(_:)), for: UIControl.Event.touchUpInside)

            let typeFeed = arrFeed[indexPath.row].type
            cell.lblUserName.text = arrFeed[indexPath.row].users_name
      
        let is_follow = arrFeed[indexPath.row].is_follow
        print("is_follow",is_follow)
        if is_follow == 1 {
//            cell.btnStatus.isSelected = true
            cell.btnStatus.tintColor = .ButtonTextColor
//            cell.btnStatus.setImage(UIImage(named: "Unfollow"), for: .normal)
            cell.btnStatus.setTitle("Unfollow", for: .normal)
        }
        else if is_follow == 0{
//            cell.btnStatus.isSelected = false
            cell.btnStatus.tintColor = .Blue
            cell.btnStatus.setTitle("Follow", for: .normal)
           // cell.btnStatus.setImage(UIImage(named: "Follow"), for: .normal)
        }
        else{
            cell.btnStatus.tintColor = .Blue
            cell.btnStatus.setTitle("Requested", for: .normal)
        }
        
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
        let strLikeTotal = String(totalLike) + " Like"
        
        cell.lblLikeDescription.attributedText = setLike(likedcount: String(totalLike))//boldString
//        cell.btnImgLike.setTitle(strLikeTotal, for: .normal)
        
        
        let is_liked = arrFeed[indexPath.row].is_liked
        if is_liked == 1 {
            cell.btnlike.isSelected = true
            cell.btnlike.setImage(UIImage(named: "likefill"), for: .normal)
        }
        else {
            cell.btnlike.isSelected = false
            cell.btnlike.setImage(UIImage(named: "like"), for: .normal)
        }
        
        //MARK: - Dislike
        let is_disliked = arrFeed[indexPath.row].is_disliked
        if is_disliked == 1 {
            cell.btndislike.isSelected = true
            cell.btndislike.setImage(UIImage(named: "dislikefill"), for: .normal)
        }
        else {
            cell.btndislike.isSelected = false
            cell.btndislike.setImage(UIImage(named: "dislike1"), for: .normal)
        }
        
            print("typeFeed: ",typeFeed)
            switch typeFeed {
            case "image":
//                cell.countView.isHidden = true
//                cell.pagerView.isHidden = true
//                cell.pageControl.isHidden = true
//                cell.imageview.isHidden = false
//                cell.imageviewBackground.isHidden = false
////                cell.imageviewBackground.addSubview(cell.imageview)
//                cell.btn_play.isHidden = true
//                //            cell.imgPost.isHidden = false
                cell.btnclick.isHidden = false
                cell.countView.isHidden = true
                cell.pagerView.isHidden = true
                cell.pageControl.isHidden = true
                cell.imageview.isHidden = false
                cell.imageviewBackground.isHidden = false
                cell.btn_play.isHidden = true
                
                let arrImages = arrFeed[indexPath.row].images

                for item in arrImages {
                    let source_url = item
                    cell.configure(post: source_url)
                }
                
                
//                cell.configure(post: arrimages[indexPath.row])
                break

            case "multi_image" :
                //            cell.imgPost.isHidden = true
//                cell.countView.isHidden = false
//                cell.pageControl.isHidden = true
//                cell.pagerView.isHidden = false
//                cell.imageview.isHidden = true
//                cell.imageviewBackground.isHidden = true
//                cell.btn_play.isHidden = true
//                cell.images = arrFeed[indexPath.row].images
//                print("arrmulti_image: ",arrFeed[indexPath.row].images)
//                cell.pageControl.numberOfPages = arrFeed[indexPath.row].images.count
//                cell.pagerView.reloadData()
                
                cell.countView.isHidden = false
                cell.pageControl.isHidden = true
                cell.pagerView.isHidden = false
                cell.imageview.isHidden = true
                cell.imageviewBackground.isHidden = true
                cell.btn_play.isHidden = true
                cell.countView.isHidden = false
                cell.images = arrFeed[indexPath.row].images
                cell.pageControl.numberOfPages = arrFeed[indexPath.row].images.count
                cell.lblPageCount.text = "1" + "/" + String(arrFeed[indexPath.row].images.count)
                cell.btnclick.isHidden = true
                cell.pagerView.reloadData()
                break

            case "video":
                let arrImages = arrFeed[indexPath.row].images

//                cell.pagerView.isHidden = true
//                cell.pageControl.isHidden = true
//                cell.imageview.isHidden = true
//                cell.imageviewBackground.isHidden = true
//                cell.btn_play.isHidden = false
//                cell.countView.isHidden = true

                cell.btnclick.isHidden = false
                cell.pagerView.isHidden = true
                cell.pageControl.isHidden = true
                cell.imageview.isHidden = false
                cell.imageviewBackground.isHidden = false
                cell.btn_play.isHidden = false
                cell.countView.isHidden = true

                
                for item in arrImages {
                    let source_url = item
//                    cell.configureCell(imageUrl: arrFeed[indexPath.row].video_poster, description: "", videoUrl: source_url)
                    cell.configure(post: arrFeed[indexPath.row].video_poster)
                }
                
                break
            default:
                break
            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        imgUrl = arrimages[indexPath.row]
//
//        print("didselect..",imgUrl)
//
//         if indexPath.row == 6 || indexPath.row == 8{
//
//            self.DisplayViewMain.isHidden = false
//            imageViewMain.isHidden = true
//            shotImageView.isHidden = false
//            configureCell(imageUrl:  "https://friendzpoint.blob.core.windows.net/frp/uploads/users/gallery/poster/20201226114814LtpiPdCASW.mp4.jpg", description: "", videoUrl:arrVideo )
//        }
//        if indexPath.row == 3{
//            self.DisplayViewMain.isHidden = true
//        }
//        else{
//            self.DisplayViewMain.isHidden = false
//            imageViewMain.isHidden = false
//            shotImageView.isHidden = true
//            imageViewMain.kf.setImage(with: URL(string: imgUrl),placeholder:UIImage(named: "Placeholder"))
//        }

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.loaderView.frame.height

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.loaderView.frame.height
    }
    
    
//    private func tableView(_ tableView: UITableView,
//                   heightForRowAt indexPath: IndexPath) -> CGFloat{
//        return self.view.frame.height
//
//    }
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
        print("imageUrl:",imageUrl!)
        print("videoUrl:",videoUrl!)
        
//        self.shotImageView.imageURL = imageUrl
        self.videoURL = videoUrl
//        shotImageView.layer.addSublayer(videoLayer)
        ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: videoLayer, url: videoURL ?? "")
        
    }
    
    override func viewDidLayoutSubviews() {
        let horizontalMargin: CGFloat = 0
        let width: CGFloat = self.view.frame.size.width - horizontalMargin * 2
        let height: CGFloat = (width * 0.999).rounded(.up)
        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let horizontalMargin: CGFloat = 0
//        let width: CGFloat = bounds.size.width - horizontalMargin * 2
//        let height: CGFloat = (width * 0.999).rounded(.up)
//        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
//    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            pausePlayeVideos()
//        }
//    }
//
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: mainTableView)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: mainTableView, appEnteredFromBackground: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("cellHeight: ",tableView.frame.height)
//       // return self.mainTableView.bounds.height//tableView.frame.height//tableView.frame.height
//        return tableView.frame.height
////        return UITableView.automaticDimension
//    }
//    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // If the cell is the first cell in the tableview, the queuePlayer automatically starts.
//        // If the cell will be displayed, pause the video until the drag on the scroll view is ended
//        if let cell = cell as? HomeTableViewCell{
////            oldAndNewIndices.1 = indexPath.row
////            currentIndex = indexPath.row
////            cell.pause()
//        }
//    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // Pause the video if the cell is ended displaying
//        if let cell = cell as? HomeTableViewCell {
////            cell.pause()
//        }
//    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            print(indexPath.row)
//        }
    }
    
    
}

// MARK: - ScrollView Extension
extension HomeViewController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let cell = self.mainTableView.cellForRow(at: IndexPath(row: self.currentIndex, section: 0)) as? HomeTableViewCell
//        cell?.replay()
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
                let lastIndexPath = mainTableView.lastIndexpath()
                lastIndex_id = arrFeed[lastIndexPath.row].id
                timeline_last_first_id = lastIndex_id
                timeline_Type_top_bottom = "Bottom"
//                print("pageCount: ",pageCount)
//                getFeed(strPage: "\(pageCount)")
                firstTime()
              
            }
        }
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset.y
//        let height = scrollView.contentSize.height
//        if offset > height - scrollView.contentSize.height {
//           if !isNewDataLoading {
//               spinner = UIActivityIndicatorView(style: .gray)
//               spinner.startAnimating()
//               spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: mainTableView.bounds.width, height: CGFloat(44))
//               let lastIndexPath = mainTableView.lastIndexpath()
//               lastIndex_id = arrFeed[lastIndexPath.row].id
//            print("lastIndexPath.row:",lastIndexPath.row)
//            print("count:",arrFeed.count)
//               timeline_last_first_id = lastIndex_id
//               timeline_Type_top_bottom = "Bottom"
//            print("pageCount: ",pageCount)
//               getFeed(strPage: "\(pageCount)")
//               self.mainTableView.tableFooterView = spinner
//               self.mainTableView.tableFooterView?.isHidden = false
//               isNewDataLoading = true
//            print("scrolltag: ",scrollView.tag)
//           }
//
//        }
//    }
    
}

extension HomeViewController: YPImagePickerDelegate{
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
    
    func setLike(likedcount:String) -> NSMutableAttributedString {
        //        let normalText =  " Wendy Lambert "
        
        let boldText  = "Liked by "
        
        let normalText1 = likedcount + " people"
        
        //        let boldText1  = "and"
        
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        //        let attributedString = NSMutableAttributedString(string:normalText, attributes:attrs1)
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let attributedString1 = NSMutableAttributedString(string:normalText1, attributes:attrs2)
        
        let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor] as [NSAttributedString.Key : Any]
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        
        //        let boldString1 = NSMutableAttributedString(string: boldText1, attributes:attrs)
        
        //        boldString.append(attributedString)
        boldString.append(attributedString1)
        //        boldString.append(boldString1)
       return boldString
    }
}

// MARK: - Navigation Delegate
// TODO: Customized Transition
//extension HomeViewController: HomeCellNavigationDelegate {
//    func navigateToProfilePage(uid: String, name: String) {
////        self.navigationController?.pushViewController(ProfileViewController(), animated: true)
//    }
//}


var TopFalse = 0


class Post {
    var isLiked = false
    var likeCount = 0
}
