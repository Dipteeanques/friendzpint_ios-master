//
//  NewsfeedViewController.swift
//  FriendzPoint/Users/anquestechnolabs/Desktop/FriendzPoint/DashboardController/ProfileController/tblTimelineCell.swift
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
import TTTAttributedLabel
import AJMessage

import SnapKit
import Alamofire
import AVFoundation
import YPImagePicker
import AVKit
import Photos
import MBProgressHUD
import AJMessage

class TimelineViewCiontroller: UIViewController,TTTAttributedLabelDelegate {
    
    enum CellType {
        case normal
        case expanded
    }
    
    @IBOutlet weak var Collection: UICollectionView!
    var selectedItems = [YPMediaItem]()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    var player: AVPlayer?
    var selectedIndex = Int()
    internal var TexttagTapHandler: ((String) -> ())?
    var strHashtag = String()
    var boolGlobalDisco = Bool()
    var muteBool = true
    var hashtagpost = String()
    
    @IBOutlet weak var tblFeed: UITableView!
    @IBOutlet weak var foundView: Foundview!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    private let layoutValues: [CellType] = [.expanded,.expanded,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.expanded]
    
    let shotTableViewCellIdentifier = "ShotTableViewCell"
    let loadingCellTableViewCellCellIdentifier = "LoadingCellTableViewCell"
    var refreshControl = UIRefreshControl()
    let videos = [
        "https://v.pinimg.com/videos/720p/77/4f/21/774f219598dde62c33389469f5c1b5d1.mp4",
        "https://v.pinimg.com/videos/720p/75/40/9a/75409a62e9fb61a10b706d8f0c94de9a.mp4",
        "https://v.pinimg.com/videos/720p/0d/29/18/0d2918323789eabdd7a12cdd658eda04.mp4",
        "https://v.pinimg.com/videos/720p/dd/24/bb/dd24bb9cd68e9e25d1def88cad0a9ea7.mp4",
        "https://v.pinimg.com/videos/720p/d5/15/78/d51578c69d36c93c6e20144e9f887c73.mp4",
        "https://v.pinimg.com/videos/720p/c2/6d/2b/c26d2bacb4a9f6402d2aa0721193e06e.mp4",
        "https://v.pinimg.com/videos/720p/62/81/60/628160e025f9d61b826ecc921b9132cd.mp4",
        "https://v.pinimg.com/videos/720p/5f/aa/3d/5faa3d057eb31dd05876f622ea2e7502.mp4",
        "https://v.pinimg.com/videos/720p/65/b0/54/65b05496c385c89f79635738adc3b15d.mp4",
        "https://v.pinimg.com/videos/720p/86/a1/c6/86a1c63fc58b2e1ef18878b7428912dc.mp4"
    ]
    
    let textView = UITextView(frame: CGRect.zero)
   
    var arrSingaleImg = [String]()
    var url: URL?
    var index = Int()
    var dicValue = NSDictionary()
    var arrFeed = [MyTimelineList1]()
    var arrUserTag = [userTagpeopelListResponse]()
    var arrResults = [SearchDataResoponseModel]()
    var arrMultiImage = [String]()
    var post_Id = Int()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var arrMultiVala = NSMutableArray()
    var strUserName = String()
    var wc = Webservice.init()
    var arrImages = [String]()
    var arrPostLiked = [LikesetRespons]()
    var arrPostDislked = [LikesetRespons]()
    var strSaveUnsave = String()
    var strNotification = String()
    var timeline_last_first_id = Int()
    var timeline_Type_top_bottom = String()
    var lastIndex_id = Int()
    var encodeData = [Data]()
    var decodedData = [Data]()
    var pianoSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "blop", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    var nameTag = [String]()
    var userTag = [String]()
    var strName = String()
    var selectedUsername = String()
    var tagFirstUsername = String()
    var strTageName = String()
    
    // MARK: - UI Components
    var mainTableView: UITableView!
//    var wc = Webservice.init()
//    var timeline_last_first_id = Int()
//    var arrFeed = [MyTimelineList]()
//    var spinner = UIActivityIndicatorView()
    var isNewDataLoading = false
//    var timeline_Type_top_bottom = String()
    // MARK: - Variables
    let cellId = "cell"
//    var pageCount = Int()
//    var lastIndex_id = Int()
//    var arrmulti_image = ["https://i.pinimg.com/originals/9f/55/28/9f5528c7a02b3169e4e1c6c814d28fe6.jpg", "https://cdn.wallpapersafari.com/19/30/voSBxR.jpg","https://blog.hdwallsource.com/wp-content/uploads/2015/05/lovely-mood-wallpaper-38930-39824-hd-wallpapers.jpg"]
//    var arrVideo = "https://friendzpoint.blob.core.windows.net/frp/uploads/users/gallery/20201226114814LtpiPdCASW.mp4"
//
//    var arrmulti_image1 = ["https://i.pinimg.com/originals/9f/55/28/9f5528c7a02b3169e4e1c6c814d28fe6.jpg", "https://cdn.wallpapersafari.com/19/30/voSBxR.jpg","https://blog.hdwallsource.com/wp-content/uploads/2015/05/lovely-mood-wallpaper-38930-39824-hd-wallpapers.jpg"]
//    var arrimages = ["https://lava360.com/wp-content/uploads/2015/06/cute-iphone-wallpaper-22.jpg",
//                     "https://i.pinimg.com/originals/86/07/f4/8607f4a9cfba77dcfb4bf8c0fc7c06b1.jpg",
//                     "https://i.pinimg.com/736x/9c/3f/51/9c3f51863dc220b436ae5d9ae69f223c.jpg",
//                     "multi",
//                     "https://i.pinimg.com/originals/f1/66/04/f166048af1dada596ef552f56b04343c.jpg",
//                     "https://i.pinimg.com/originals/3f/24/13/3f24134d56b3f23c4ff108f9ef4c53ce.jpg",
//                     "video",
//                     "https://images.unsplash.com/photo-1425082661705-1834bfd09dca?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb",
//                     "video",
//                     "https://indiabright.com/wp-content/uploads/2015/10/beautiful-and-cute-animals-wallpaper-21.jpg"]
//    var arrIsLiked = ["0","0","0","0","0","0","0","0","0","0"]
//    var arrDisLiked = ["0","0","0","0","0","0","0","0","0","0"]
//    var arrFollow = ["0","0","0","0","0","0","0","0","0","0"]
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
    
//    var post_Id = Int()
//    var strSaveUnsave = String()
//    var strNotification = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setDefault()
//        NotificationCenter.default.addObserver(self, selector: #selector(TimelineViewCiontroller.profileTimeline), name: NSNotification.Name(rawValue: "profileTimeline"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(TimelineViewCiontroller.GetCreatedPost), name: NSNotification.Name(rawValue: "PostCreat"), object: nil)
//
//
//        getFeed()
        strUserName = loggdenUser.value(forKey: USERNAME)as! String
        setupView()
        navigationController?.setStatusBar(backgroundColor: .black)
        self.navigationController?.navigationBar.isHidden = true
    
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollchange(notification:)), name: Notification.Name("scrollchange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollchange1(notification:)), name: Notification.Name("scrollchange1"), object: nil)
       
        // Do any additional setup after loading the view.
//        mainTableView.rowHeight = UITableView.automaticDimension;
//        mainTableView.estimatedRowHeight = UIScreen.main.bounds.height
        firstTime()
        DisplayViewMain.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
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
        
        scrollView.frame = CGRect(x: 0, y: 80, width: self.DisplayViewMain.frame.width, height: self.DisplayViewMain.frame.height-80)
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
        shotImageView.contentMode = .scaleAspectFit
        
//        DispatchQueue.global(qos: .default).async(execute: { [self] in
//            // Do something...
//            DispatchQueue.main.async(execute: { [self] in
//                MBProgressHUD.hide(for: view, animated: true)
//            })
//        })
        
        blurImage(img: imgbackground)
        
    }

//    func blurImage(img:UIImageView){
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = img.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        img.addSubview(blurEffectView)
//    }
    
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
                          "timeline_type":"Bottom",
                          "username":strUserName] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        print("parameters: ",parameters)
        print("headers: ",headers)
        print("BROWSE: ",BROWSE)
        wc.callSimplewebservice(url: MYTIMELINELIST+"?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel1?) in
            //            print("response:",response.re)
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
//                    print("firsttime: ",response)
//                    self.arrFeed.removeAll()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
//                    self.mainTableView.isHidden = false
                    self.mainTableView.isHidden = true
                    self.Collection.isHidden = false
                    if self.arrFeed.count == 0{
                        self.arrFeed = response!.data!
//                        self.mainTableView.scrollToTop()
//                        self.mainTableView.reloadData()
                        self.Collection.reloadData()
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
//                        self.mainTableView.reloadData()
                        self.Collection.reloadData()
                    }
                 
                    
                }
                else {
                    self.loaderView.isHidden = true
                    self.foundView.isHidden = false
                    self.activity.stopAnimating()
                    self.Collection.reloadData()
                }
            }
            else {
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
                self.foundView.isHidden = false
                self.Collection.reloadData()
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
            make.edges.equalTo(self.loaderView!)//equalToSuperview()
        })
        mainTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.prefetchDataSource = self
        
        mainTableView.isHidden = true
        loaderView.isHidden = false
//        MBProgressHUD.show()//show(for: view, animated: true)
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
    
//    func setDefault() {
//        strUserName = loggdenUser.value(forKey: USERNAME)as! String
//        refreshControl.addTarget(self, action: #selector(TimelineViewCiontroller.refresh), for: UIControl.Event.valueChanged)
//        tblFeed.addSubview(refreshControl)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.appEnteredFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(TimelineViewCiontroller.notificationSingaleDashboardTimeline), name: NSNotification.Name(rawValue: "notificationSingaleDashboardTimeline"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(TimelineViewCiontroller.notificationMyTimelineBackSingale), name: NSNotification.Name(rawValue: "notificationMyTimelineBackSingale"), object: nil)
//
//        tblFeed.register(UINib(nibName: "ImgcellTimeline", bundle: nil), forCellReuseIdentifier: "ImgcellTimeline")
//        tblFeed.register(UINib(nibName: "MultiImgcellTimeline", bundle: nil), forCellReuseIdentifier: "MultiImgcellTimeline")
//        tblFeed.register(UINib(nibName: "TxtcellTimeline", bundle: nil), forCellReuseIdentifier: "TxtcellTimeline")
//        tblFeed.register(UINib(nibName: "YoutubeVideoPlaycell", bundle: nil), forCellReuseIdentifier: "YoutubeVideoPlaycell")
//        tblFeed.register(UINib(nibName: "MetacellTimeline", bundle: nil), forCellReuseIdentifier: "MetacellTimeline")
//    }
    
//    @objc func GetCreatedPost(_ notification: NSNotification) {
//        timeline_last_first_id = arrFeed[0].id
//        timeline_Type_top_bottom = "Top"
//        getFeed(strPage: "1")
//    }
//
//    @objc func profileTimeline(_ notification: NSNotification) {
//        loaderView.isHidden = false
//        activity.startAnimating()
//        getFeed()
//        setDefault()
//        pageCount = 1
//    }
//
//    @objc func refresh(sender:AnyObject) {
//        timeline_last_first_id = arrFeed[0].id
//        timeline_Type_top_bottom = "Top"
//        getFeed(strPage: "1")
//    }
//
//    @objc func notificationSingaleDashboardTimeline(_ notification: NSNotification) {
//        dicValue = notification.object as! NSDictionary
//        let obj = storyboard?.instantiateViewController(withIdentifier: "CommentsViewControllers")as! CommentsViewControllers
//        obj.strCommentImage = "strCommentImage"
//        obj.dicImg = dicValue
//        self.navigationController?.pushViewController(obj, animated: true)
//    }
//
//    @objc func notificationMyTimelineBackSingale(_ notification: NSNotification) {
//        index = dicValue.value(forKey: "index") as! Int
//        let tkImageVC = TKImageShowing()
//        tkImageVC.currentIndex = index
//        tkImageVC.images = arrSingaleImg.toTKImageSource()
//        present(tkImageVC, animated: true, completion: nil)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        pausePlayeVideos()
//    }
//
//    func getFeed() {
////        strUserName = "mayurgodhani"
//        let parameters = ["timeline_last_post_id": timeline_last_first_id,
//                          "timeline_type":timeline_Type_top_bottom,
//                          "username":strUserName] as [String : Any]
//        print("timeline-pro: ",parameters)
//        let token = loggdenUser.value(forKey: TOKEN)as! String
//        let BEARERTOKEN = BEARER + token
//        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                    "Accept" : ACCEPT,
//                                    "Authorization":BEARERTOKEN]
//        wc.callSimplewebservice(url: MYTIMELINELIST+"?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in
//            if sucess {
//                print(response)
//                let sucessMy = response?.success
//                if sucessMy! {
//                    let arr_dict  = response?.data
//                    for i in 0..<arr_dict!.count
//                    {
//                        self.arrFeed.append(arr_dict![i])
//                        self.tblFeed.beginUpdates()
//                        self.tblFeed.insertRows(at: [
//                            NSIndexPath(row: self.arrFeed.count-1, section: 0) as IndexPath], with: .fade)
//                        self.spinner.stopAnimating()
//                        self.tblFeed.tableFooterView?.isHidden = true
//                        self.loaderView.isHidden = true
//                        self.activity.stopAnimating()
//                        self.tblFeed.endUpdates()
//                        if self.arrFeed.count == 0 {
//                            self.foundView.isHidden = false
//                        }
//                        else {
//                            self.foundView.isHidden = true
//                        }
//                    }
//                }
//                else {
//                    self.spinner.stopAnimating()
//                    self.tblFeed.tableFooterView?.isHidden = true
//                    self.loaderView.isHidden = true
//                    self.activity.stopAnimating()
//                    if self.arrFeed.count == 0 {
//                        self.foundView.isHidden = false
//                    }
//                    else {
//                        self.foundView.isHidden = true
//                    }
//                }
//            }
//            self.spinner.stopAnimating()
//            self.tblFeed.tableFooterView?.isHidden = true
//            self.loaderView.isHidden = true
//            self.activity.stopAnimating()
//            if self.arrFeed.count == 0 {
//                self.foundView.isHidden = false
//            }
//            else {
//                self.foundView.isHidden = true
//            }
//        }
//    }
//
//    func getFeed(strPage : String) {
//        if timeline_Type_top_bottom == "Top" {
//            let parameters = ["timeline_last_post_id": timeline_last_first_id,
//                              "timeline_type":timeline_Type_top_bottom,
//                "username":strUserName] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            wc.callSimplewebservice(url: MYTIMELINELIST + "?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in
//                if sucess {
//                    let sucessMy = response?.success
//                    if sucessMy! {
//                        var arr_dict  = response?.data
//                        for i in 0..<arr_dict!.count
//                        {
//                            self.arrFeed.insert(arr_dict![i], at: 0)
//                            self.tblFeed.beginUpdates()
//                            self.tblFeed.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
//                            self.spinner.stopAnimating()
//                            self.tblFeed.tableFooterView?.isHidden = true
//                            self.refreshControl.endRefreshing()
//                            self.loaderView.isHidden = true
//                            self.activity.stopAnimating()
//                            self.tblFeed.endUpdates()
//                            if self.arrFeed.count == 0 {
//                                self.foundView.isHidden = false
//                            }
//                            else {
//                                self.foundView.isHidden = true
//                            }
//                        }
//                    }
//                    else {
//                        self.refreshControl.endRefreshing()
//                        self.spinner.stopAnimating()
//                        self.tblFeed.tableFooterView?.isHidden = true
//                        self.loaderView.isHidden = true
//                        self.activity.stopAnimating()
//                        if self.arrFeed.count == 0 {
//                            self.foundView.isHidden = false
//                        }
//                        else {
//                            self.foundView.isHidden = true
//                        }
//                    }
//                }
//                else {
//                    self.refreshControl.endRefreshing()
//                    self.spinner.stopAnimating()
//                    self.tblFeed.tableFooterView?.isHidden = true
//                    self.loaderView.isHidden = true
//                    self.activity.stopAnimating()
//                    if self.arrFeed.count == 0 {
//                        self.foundView.isHidden = false
//                    }
//                    else {
//                        self.foundView.isHidden = true
//                    }
//                }
//            }
//        }
//        else {
//            let parameters = ["timeline_last_post_id": timeline_last_first_id,
//                              "timeline_type":timeline_Type_top_bottom,
//                              "username":strUserName] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            wc.callSimplewebservice(url: MYTIMELINELIST + "?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in
//                if sucess {
//                    let sucessMy = response?.success
//                    if sucessMy! {
//                        let arr_dict  = response?.data
//                        for i in 0..<arr_dict!.count
//                        {
//                            self.arrFeed.append(arr_dict![i])
//                            self.tblFeed.beginUpdates()
//                            self.tblFeed.insertRows(at: [
//                                NSIndexPath(row: self.arrFeed.count-1, section: 0) as IndexPath], with: .fade)
//                            self.spinner.stopAnimating()
//                            self.tblFeed.tableFooterView?.isHidden = true
//                            self.loaderView.isHidden = true
//                            self.activity.stopAnimating()
//                            self.tblFeed.endUpdates()
//                            if self.arrFeed.count == 0 {
//                                self.foundView.isHidden = false
//                            }
//                            else {
//                                self.foundView.isHidden = true
//                            }
//                        }
//                    }
//                    else {
//                        self.spinner.stopAnimating()
//                        self.tblFeed.tableFooterView?.isHidden = true
//                        self.loaderView.isHidden = true
//                        self.activity.stopAnimating()
//                        if self.arrFeed.count == 0 {
//                            self.foundView.isHidden = false
//                        }
//                        else {
//                            self.foundView.isHidden = true
//                        }
//                    }
//                }
//                self.spinner.stopAnimating()
//                self.tblFeed.tableFooterView?.isHidden = true
//                self.loaderView.isHidden = true
//                self.activity.stopAnimating()
//                if self.arrFeed.count == 0 {
//                    self.foundView.isHidden = false
//                }
//                else {
//                    self.foundView.isHidden = true
//                }
//            }
//        }
//    }
//
    func getHashtagPost() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "HashtagSearchTimelineController")as! HashtagSearchTimelineController
        obj.hashtagpost = hashtagpost
        self.navigationController?.pushViewController(obj, animated: false)
    }
    
    @IBAction func btnfloatAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = storyboard?.instantiateViewController(withIdentifier: "PostViewController")as! PostViewController
        obj.MyProfile = "MyProfile"
        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        self.present(naviget, animated: true, completion: nil)
    }
}

//MARK: - tableview method
//extension TimelineViewCiontroller: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrFeed.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let typeFeed = arrFeed[indexPath.row].type
//        switch typeFeed {
//        case "image":
//            let cell = tblFeed.dequeueReusableCell(withIdentifier: "ImgcellTimeline", for: indexPath) as! ImgcellTimeline
//            cell.arrSingaleImage = arrFeed[indexPath.row]
//            let cellFrame = cell.frame.size
//            arrImages = arrFeed[indexPath.row].images
//            for item in arrImages {
//                let source_url = item
//                url = URL(string: source_url)
//                cell.imgPost.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Placeholder") , options: [], completed: { (theImage, error, cache, url) in
//                    cell.setNeedsLayout()
//                    cell.imgpostHeight?.constant = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
//                    //                        UIView.performWithoutAnimation {
//                    //                            self.tblFeed.beginUpdates()
//                    //                            cell.imgpostHeight.constant = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
//                    //                            self.tblFeed.endUpdates()
//                    //                        }
//                })
//                break
//            }
//            let name = arrFeed[indexPath.row].users_name
//            cell.lblDetails.handleHashtagTap { hashtag in
//                self.hashtagpost = hashtag
//                self.getHashtagPost()
//            }
//
//            let selectedUsername = arrFeed[indexPath.row].username
//            cell.btnSingaleImg.addTarget(self, action: #selector(TimelineViewCiontroller.openAction), for: UIControl.Event.touchUpInside)
//            cell.btnSingaleImageMenu.addTarget(self, action: #selector(TimelineViewCiontroller.btnMenuAction), for: UIControl.Event.touchUpInside)
//            cell.btnImgLike.addTarget(self, action: #selector(TimelineViewCiontroller.btnImgLikeAction), for: UIControl.Event.touchUpInside)
//            cell.btnComment.addTarget(self, action: #selector(TimelineViewCiontroller.btnCommentAction), for: UIControl.Event.touchUpInside)
//            cell.btnpostComment.addTarget(self, action: #selector(TimelineViewCiontroller.btnCommentPostAction), for: UIControl.Event.touchUpInside)
//            cell.btnLikeImgCell.addTarget(self, action: #selector(TimelineViewCiontroller.btnLikeImgcellAction), for: UIControl.Event.touchUpInside)
//            cell.btnProImgClick.addTarget(self, action: #selector(TimelineViewCiontroller.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
//            cell.dislike.addTarget(self, action: #selector(TimelineViewCiontroller.btndislikeAction), for: UIControl.Event.touchUpInside)
//            cell.dislikeCount.addTarget(self, action: #selector(TimelineViewCiontroller.btndislikeCountAction), for: UIControl.Event.touchUpInside)
//
//            let shared_person_name = arrFeed[indexPath.row].shared_person_name
//            let shared_username = arrFeed[indexPath.row].shared_username
//            if shared_person_name.count == 0 {
//                arrUserTag = arrFeed[indexPath.row].users_tagged
//                if arrUserTag.count == 1 {
//                    let strName = arrUserTag[0].name
//                    tagFirstUsername = arrUserTag[0].username
//
//                    let string = "\(name) with \(strName)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblSingaleTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//                    let rangeTC = nsString.range(of: strName)
//
//                    let MyLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblSingaleTitle.activeLinkAttributes = MyLinkAttributes
//                    cell.lblSingaleTitle.linkAttributes = ppLinkAttributes
//                    cell.lblSingaleTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblSingaleTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
//                    cell.lblSingaleTitle.textColor = UIColor.black;
//                    cell.lblSingaleTitle.delegate = self;
//                }
//                else if arrUserTag.count >= 2 {
//                    for strNamegat in arrUserTag {
//                        let name = strNamegat.name
//                        let tagUsername = strNamegat.username
//                        nameTag.append(name)
//                        userTag.append(tagUsername)
//                        self.strTageName = nameTag.joined(separator: ",")
//                        strName = nameTag[0]
//                        tagFirstUsername = userTag[0]
//                    }
//
//                    let countOther = arrUserTag.count - 1
//                    let strCount = String(countOther)
//                    let FinalCount = strCount + " others."
//
//                    let strTC = strName
//                    let strPP = FinalCount
//
//                    let string = "\(name) with \(strTC) and \(strPP)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblSingaleTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//                    let rangeTC = nsString.range(of: strTC)
//                    let rangePP = nsString.range(of: strPP)
//
//                    let MyLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//                    let ppActiveLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblSingaleTitle.activeLinkAttributes = MyLinkAttributes
//                    cell.lblSingaleTitle.activeLinkAttributes = ppActiveLinkAttributes
//                    cell.lblSingaleTitle.linkAttributes = ppLinkAttributes
//                    cell.lblSingaleTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblSingaleTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
//                    cell.lblSingaleTitle.addLink(toAddress: ["Others":arrUserTag], with: rangePP)
//                    cell.lblSingaleTitle.textColor = UIColor.black;
//                    cell.lblSingaleTitle.delegate = self;
//                }
//                else {
//                    let string = "\(name)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblSingaleTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblSingaleTitle.linkAttributes = ppLinkAttributes
//                    cell.lblSingaleTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblSingaleTitle.textColor = UIColor.black;
//                    cell.lblSingaleTitle.delegate = self;
//                }
//            }
//            else {
//                let string = "\(name) shared \(shared_person_name) 's post"
//                let nsString = string as NSString
//
//                let paragraphStyle = NSMutableParagraphStyle()
//
//                let fullAttributedString = NSAttributedString(string:string, attributes: [
//                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                    ])
//                cell.lblSingaleTitle.attributedText = fullAttributedString;
//
//                let rangeMY = nsString.range(of: name)
//                let rangeTC = nsString.range(of: shared_person_name)
//
//                let MyLinkAttributes: [String: Any] = [
//                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                    NSAttributedString.Key.underlineStyle.rawValue: false,
//                ]
//
//                let ppLinkAttributes: [String: Any] = [
//                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                    NSAttributedString.Key.underlineStyle.rawValue: false,
//                ]
//                cell.lblSingaleTitle.activeLinkAttributes = MyLinkAttributes
//                cell.lblSingaleTitle.linkAttributes = ppLinkAttributes
//                cell.lblSingaleTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                cell.lblSingaleTitle.addLink(toPhoneNumber: shared_username, with: rangeTC)
//                cell.lblSingaleTitle.textColor = UIColor.black;
//                cell.lblSingaleTitle.delegate = self;
//            }
//
//            return cell
//        case "multi_image" :
//            let cell = tblFeed.dequeueReusableCell(withIdentifier: "MultiImgcellTimeline", for: indexPath) as! MultiImgcellTimeline
//            cell.arrMultiImage = arrFeed[indexPath.row]
//            cell.collectionImage.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
//            cell.collectionImage.delegate = self
//            cell.collectionImage.dataSource = self
//            cell.collectionImage.tag = 1001
//            cell.collectionImage.layoutIfNeeded()
//            cell.collectionImage.reloadData()
//            self.arrMultiVala.add(self.arrFeed[indexPath.row])
//            let name = arrFeed[indexPath.row].users_name
//            let selectedUsername = arrFeed[indexPath.row].username
//            arrUserTag = arrFeed[indexPath.row].users_tagged
//            let shared_username = arrFeed[indexPath.row].shared_username
//            let shared_person_name = arrFeed[indexPath.row].shared_person_name
//            if shared_person_name.count == 0 {
//                if arrUserTag.count == 1 {
//                    let strName = arrUserTag[0].name
//                    tagFirstUsername = arrUserTag[0].username
//
//                    let string = "\(name) with \(strName)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//                    let rangeTC = nsString.range(of: strName)
//
//                    let MyLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//                else if arrUserTag.count >= 2 {
//                    for strNamegat in arrUserTag {
//                        let name = strNamegat.name
//                        let tagUsername = strNamegat.username
//                        nameTag.append(name)
//                        userTag.append(tagUsername)
//                        self.strTageName = nameTag.joined(separator: ",")
//                        strName = nameTag[0]
//                        tagFirstUsername = userTag[0]
//                    }
//
//                    let countOther = arrUserTag.count - 1
//                    let strCount = String(countOther)
//                    let FinalCount = strCount + " others."
//                    let strTC = strName
//                    let strPP = FinalCount
//
//                    let string = "\(name) with \(strTC) and \(strPP)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//                    let rangeTC = nsString.range(of: strTC)
//                    let rangePP = nsString.range(of: strPP)
//
//                    let MyLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//                    let ppActiveLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                    cell.lblTitle.activeLinkAttributes = ppActiveLinkAttributes
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
//                    cell.lblTitle.addLink(toAddress: ["Others":arrUserTag], with: rangePP)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//                else {
//                    let string = "\(name)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//            }
//            else {
//                let string = "\(name) shared \(shared_person_name) 's post"
//                let nsString = string as NSString
//
//                let paragraphStyle = NSMutableParagraphStyle()
//
//                let fullAttributedString = NSAttributedString(string:string, attributes: [
//                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                    ])
//                cell.lblTitle.attributedText = fullAttributedString;
//
//                let rangeMY = nsString.range(of: name)
//                let rangeTC = nsString.range(of: shared_person_name)
//
//                let MyLinkAttributes: [String: Any] = [
//                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                    NSAttributedString.Key.underlineStyle.rawValue: false,
//                ]
//
//                let ppLinkAttributes: [String: Any] = [
//                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                    NSAttributedString.Key.underlineStyle.rawValue: false,
//                ]
//                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                cell.lblTitle.linkAttributes = ppLinkAttributes
//                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                cell.lblTitle.addLink(toPhoneNumber: shared_username, with: rangeTC)
//                cell.lblTitle.textColor = UIColor.black;
//                cell.lblTitle.delegate = self;
//            }
//            arrMultiImage = arrFeed[indexPath.row].images
//            if arrMultiImage.count == 2 {
//                if UIScreen.main.bounds.width == 320
//                {
//                    cell.collectionHeight.constant = 160
//                    let padding: CGFloat = 1
//                    let screenWidth = UIScreen.main.bounds.width - padding
//                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
//                    layout.minimumInteritemSpacing = 0
//                    layout.minimumLineSpacing = 0
//                    cell.collectionImage.collectionViewLayout = layout
//                }
//                else if UIScreen.main.bounds.width == 414
//                {
//                    cell.collectionHeight.constant = 210
//                    let padding: CGFloat = 1
//                    let screenWidth = UIScreen.main.bounds.width - padding
//                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
//                    layout.minimumInteritemSpacing = 0
//                    layout.minimumLineSpacing = 0
//                    cell.collectionImage.collectionViewLayout = layout
//                }
//                else
//                {
//                    cell.collectionHeight.constant = 190
//                    let padding: CGFloat = 1
//                    let screenWidth = UIScreen.main.bounds.width - padding
//                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
//                    layout.minimumInteritemSpacing = 0
//                    layout.minimumLineSpacing = 0
//                    cell.collectionImage.collectionViewLayout = layout
//                }
//            }
//            else if arrMultiImage.count == 3
//            {
//                if UIScreen.main.bounds.width == 320
//                {
//                    cell.collectionHeight.constant = 230
//                    let flowLayout = SquareFlowLayout()
//                    flowLayout.flowDelegate = self
//                    cell.collectionImage.collectionViewLayout = flowLayout
//                }
//                else if UIScreen.main.bounds.width == 414
//                {
//                    cell.collectionHeight.constant = 280
//                    let flowLayout = SquareFlowLayout()
//                    flowLayout.flowDelegate = self
//                    cell.collectionImage.collectionViewLayout = flowLayout
//                }
//                else
//                {
//                    cell.collectionHeight.constant = 255
//                    let flowLayout = SquareFlowLayout()
//                    flowLayout.flowDelegate = self
//                    cell.collectionImage.collectionViewLayout = flowLayout
//                }
//            }
//            else if arrMultiImage.count == 4 {
//                if UIScreen.main.bounds.width == 320
//                {
//                    cell.collectionHeight.constant = 320
//                    let padding: CGFloat = 1
//                    let screenWidth = UIScreen.main.bounds.width - padding
//                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
//                    layout.minimumInteritemSpacing = 0
//                    layout.minimumLineSpacing = 0
//                    cell.collectionImage.collectionViewLayout = layout
//                }
//                else if UIScreen.main.bounds.width == 414
//                {
//                    cell.collectionHeight.constant = 420
//                    let padding: CGFloat = 1
//                    let screenWidth = UIScreen.main.bounds.width - padding
//                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
//                    layout.minimumInteritemSpacing = 0
//                    layout.minimumLineSpacing = 0
//                    cell.collectionImage.collectionViewLayout = layout
//                }
//                else
//                {
//                    cell.collectionHeight.constant = 375
//                    let padding: CGFloat = 1
//                    let screenWidth = UIScreen.main.bounds.width - padding
//                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
//                    layout.minimumInteritemSpacing = 0
//                    layout.minimumLineSpacing = 0
//                    cell.collectionImage.collectionViewLayout = layout
//                }
//            }
//            else if arrMultiImage.count == 5
//            {
//                if UIScreen.main.bounds.width == 320
//                {
//                    cell.collectionHeight.constant = 320
//                    let flowLayout = SquareFlowLayout()
//                    flowLayout.flowDelegate = self
//                    cell.collectionImage.collectionViewLayout = flowLayout
//                }
//                else if UIScreen.main.bounds.width == 414
//                {
//                    cell.collectionHeight.constant = 415
//                    let flowLayout = SquareFlowLayout()
//                    flowLayout.flowDelegate = self
//                    cell.collectionImage.collectionViewLayout = flowLayout
//                }
//                else
//                {
//                    cell.collectionHeight.constant = 375
//                    let flowLayout = SquareFlowLayout()
//                    flowLayout.flowDelegate = self
//                    cell.collectionImage.collectionViewLayout = flowLayout
//                }
//            }
//
//            else if arrMultiImage.count >= 6
//            {
//                if UIScreen.main.bounds.width == 320
//                {
//                    selectedIndex = 5
//                    let flowLayout = SquareFlowLayout()
//                    flowLayout.flowDelegate = self
//                    cell.collectionImage.collectionViewLayout = flowLayout
//                }
//                else if UIScreen.main.bounds.width == 414
//                {
//                    selectedIndex = 5
//                    cell.collectionHeight.constant = 415
//                    let flowLayout = SquareFlowLayout()
//                    flowLayout.flowDelegate = self
//                    cell.collectionImage.collectionViewLayout = flowLayout
//                }
//                else
//                {
//                    selectedIndex = 5
//                    cell.collectionHeight.constant = 375
//                    let flowLayout = SquareFlowLayout()
//                    flowLayout.flowDelegate = self
//                    cell.collectionImage.collectionViewLayout = flowLayout
//                }
//            }
//            cell.lblDescrip.handleHashtagTap { hashtag in
//                self.hashtagpost = hashtag
//                self.getHashtagPost()
//            }
//            cell.btnLikeCount.addTarget(self, action: #selector(TimelineViewCiontroller.btnAllLikeMultiCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnCommentCount.addTarget(self, action: #selector(TimelineViewCiontroller.btnAllCommentMultiCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnCommentMulticell.addTarget(self, action: #selector(TimelineViewCiontroller.btnCommentMultiCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnLikeMulticell.addTarget(self, action: #selector(TimelineViewCiontroller.btnLikeMulticellAction), for: UIControl.Event.touchUpInside)
//            cell.btnMultiImgmenu.addTarget(self, action: #selector(TimelineViewCiontroller.btnMenuAction), for: UIControl.Event.touchUpInside)
//            cell.btnMultiImagePass.addTarget(self, action: #selector(TimelineViewCiontroller.btnImgPassAction), for: UIControl.Event.touchUpInside)
//            cell.btnMultiimgProfile.addTarget(self, action: #selector(TimelineViewCiontroller.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
//            cell.btndislike.addTarget(self, action: #selector(TimelineViewCiontroller.btndislikeMultiAction), for: UIControl.Event.touchUpInside)
//            cell.btnDislikeCount.addTarget(self, action: #selector(TimelineViewCiontroller.btndislikeCountAction), for: UIControl.Event.touchUpInside)
//
//
//            cell.layoutMargins = UIEdgeInsets.zero
//            cell.separatorInset = UIEdgeInsets.zero
//            cell.setNeedsUpdateConstraints()
//            cell.updateConstraintsIfNeeded()
//            cell.sizeToFit()
//            return cell
//
//        case "text":
//            let cell = tblFeed.dequeueReusableCell(withIdentifier: "TxtcellTimeline", for: indexPath) as! TxtcellTimeline
//            cell.arrText = arrFeed[indexPath.row]
//            let name = arrFeed[indexPath.row].users_name
//            let selectedUsername = arrFeed[indexPath.row].username
//            cell.lblDesc.handleHashtagTap { hashtag in
//                self.hashtagpost = hashtag
//                self.getHashtagPost()
//            }
//
//            arrUserTag = arrFeed[indexPath.row].users_tagged
//            let shared_username = arrFeed[indexPath.row].shared_username
//            let shared_person_name = arrFeed[indexPath.row].shared_person_name
//            if shared_person_name.count == 0 {
//                if arrUserTag.count == 1 {
//                    let strName = arrUserTag[0].name
//                    tagFirstUsername = arrUserTag[0].username
//
//                    let string = "\(name) with \(strName)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//                    let rangeTC = nsString.range(of: strName)
//
//                    let MyLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//                else if arrUserTag.count >= 2 {
//                    for strNamegat in arrUserTag {
//                        let name = strNamegat.name
//                        let tagUsername = strNamegat.username
//                        nameTag.append(name)
//                        userTag.append(tagUsername)
//                        self.strTageName = nameTag.joined(separator: ",")
//                        strName = nameTag[0]
//                        tagFirstUsername = userTag[0]
//                    }
//
//                    let countOther = arrUserTag.count - 1
//                    let strCount = String(countOther)
//                    let FinalCount = strCount + " others."
//                    let strTC = strName
//                    let strPP = FinalCount
//
//                    let string = "\(name) with \(strTC) and \(strPP)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//                    let rangeTC = nsString.range(of: strTC)
//                    let rangePP = nsString.range(of: strPP)
//
//                    let MyLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//                    let ppActiveLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                    cell.lblTitle.activeLinkAttributes = ppActiveLinkAttributes
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
//                    cell.lblTitle.addLink(toAddress: ["Others":arrUserTag], with: rangePP)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//                else {
//                    let string = "\(name)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//            }
//            else {
//                let string = "\(name) shared \(shared_person_name) 's post"
//                let nsString = string as NSString
//
//                let paragraphStyle = NSMutableParagraphStyle()
//
//                let fullAttributedString = NSAttributedString(string:string, attributes: [
//                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                    ])
//                cell.lblTitle.attributedText = fullAttributedString;
//
//                let rangeMY = nsString.range(of: name)
//                let rangeTC = nsString.range(of: shared_person_name)
//
//                let MyLinkAttributes: [String: Any] = [
//                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                    NSAttributedString.Key.underlineStyle.rawValue: false,
//                ]
//
//                let ppLinkAttributes: [String: Any] = [
//                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                    NSAttributedString.Key.underlineStyle.rawValue: false,
//                ]
//                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                cell.lblTitle.linkAttributes = ppLinkAttributes
//                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                cell.lblTitle.addLink(toPhoneNumber: shared_username, with: rangeTC)
//                cell.lblTitle.textColor = UIColor.black;
//                cell.lblTitle.delegate = self;
//            }
//
//            cell.layoutMargins = UIEdgeInsets.zero
//            cell.separatorInset = UIEdgeInsets.zero
//            cell.setNeedsUpdateConstraints()
//            cell.updateConstraintsIfNeeded()
//            cell.sizeToFit()
//            cell.btnLikeCount.addTarget(self, action: #selector(TimelineViewCiontroller.btnAllLikeTxtCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnCommentCount.addTarget(self, action: #selector(TimelineViewCiontroller.btnAllCommenttxtCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnCommenttxtCell.addTarget(self, action: #selector(TimelineViewCiontroller.btnCommenttxtCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnLiketxtCell.addTarget(self, action: #selector(TimelineViewCiontroller.btnLiketxtcellAction), for: UIControl.Event.touchUpInside)
//            cell.btntxtMenu.addTarget(self, action: #selector(TimelineViewCiontroller.btnMenuAction), for: UIControl.Event.touchUpInside)
//            cell.btntxtProfile.addTarget(self, action: #selector(TimelineViewCiontroller.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
//            cell.btndislike.addTarget(self, action: #selector(TimelineViewCiontroller.btndislikeTxtAction), for: UIControl.Event.touchUpInside)
//            cell.btnDislikeCount.addTarget(self, action: #selector(TimelineViewCiontroller.btndislikeCountAction), for: UIControl.Event.touchUpInside)
//
//            return cell
//        case "url":
//            let cell = tblFeed.dequeueReusableCell(withIdentifier: "YoutubeVideoPlaycell", for: indexPath) as! YoutubeVideoPlaycell
//            cell.arrYoutube = arrFeed[indexPath.row]
//            let name = arrFeed[indexPath.row].users_name
//            let selectedUsername = arrFeed[indexPath.row].username
//            cell.lblDesc.handleHashtagTap { hashtag in
//                self.hashtagpost = hashtag
//                self.getHashtagPost()
//            }
//
//            arrUserTag = arrFeed[indexPath.row].users_tagged
//            let shared_username = arrFeed[indexPath.row].shared_username
//            let shared_person_name = arrFeed[indexPath.row].shared_person_name
//            if shared_person_name.count == 0 {
//                if arrUserTag.count == 1 {
//                    let strName = arrUserTag[0].name
//                    tagFirstUsername = arrUserTag[0].username
//
//                    let string = "\(name) with \(strName)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//                    let rangeTC = nsString.range(of: strName)
//
//                    let MyLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//                else if arrUserTag.count >= 2 {
//                    for strNamegat in arrUserTag {
//                        let name = strNamegat.name
//                        let tagUsername = strNamegat.username
//                        nameTag.append(name)
//                        userTag.append(tagUsername)
//                        self.strTageName = nameTag.joined(separator: ",")
//                        strName = nameTag[0]
//                        tagFirstUsername = userTag[0]
//                    }
//
//                    let countOther = arrUserTag.count - 1
//                    let strCount = String(countOther)
//                    let FinalCount = strCount + " others."
//                    let strTC = strName
//                    let strPP = FinalCount
//
//                    let string = "\(name) with \(strTC) and \(strPP)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//                    let rangeTC = nsString.range(of: strTC)
//                    let rangePP = nsString.range(of: strPP)
//
//                    let MyLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//                    let ppActiveLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                    cell.lblTitle.activeLinkAttributes = ppActiveLinkAttributes
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
//                    cell.lblTitle.addLink(toAddress: ["Others":arrUserTag], with: rangePP)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//                else {
//                    let string = "\(name)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//            }
//            else {
//                let string = "\(name) shared \(shared_person_name) 's post"
//                let nsString = string as NSString
//
//                let paragraphStyle = NSMutableParagraphStyle()
//
//                let fullAttributedString = NSAttributedString(string:string, attributes: [
//                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                    ])
//                cell.lblTitle.attributedText = fullAttributedString;
//
//                let rangeMY = nsString.range(of: name)
//                let rangeTC = nsString.range(of: shared_person_name)
//
//                let MyLinkAttributes: [String: Any] = [
//                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                    NSAttributedString.Key.underlineStyle.rawValue: false,
//                ]
//
//                let ppLinkAttributes: [String: Any] = [
//                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                    NSAttributedString.Key.underlineStyle.rawValue: false,
//                ]
//                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                cell.lblTitle.linkAttributes = ppLinkAttributes
//                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                cell.lblTitle.addLink(toPhoneNumber: shared_username, with: rangeTC)
//                cell.lblTitle.textColor = UIColor.black;
//                cell.lblTitle.delegate = self;
//            }
//
//            cell.btnLikeCount.addTarget(self, action: #selector(TimelineViewCiontroller.btnAllLikeVideoCellAction), for: UIControl.Event.touchUpInside)
//            cell.btncommentcount.addTarget(self, action: #selector(TimelineViewCiontroller.btnAllCommentVideoCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnCommentVideoCell.addTarget(self, action: #selector(TimelineViewCiontroller.btnCommentVideoCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnLikeVideoCell.addTarget(self, action: #selector(TimelineViewCiontroller.btnLikevideocellAction), for: UIControl.Event.touchUpInside)
//            cell.btnVideoMenu.addTarget(self, action: #selector(TimelineViewCiontroller.btnMenuAction), for: UIControl.Event.touchUpInside)
//            cell.btnVideoprofile.addTarget(self, action: #selector(TimelineViewCiontroller.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
//            cell.btndislike.addTarget(self, action: #selector(TimelineViewCiontroller.btndislikeVideoAction), for: UIControl.Event.touchUpInside)
//            cell.btndislikeCount.addTarget(self, action: #selector(TimelineViewCiontroller.btndislikeCountAction), for: UIControl.Event.touchUpInside)
//
//            cell.layoutMargins = UIEdgeInsets.zero
//            cell.separatorInset = UIEdgeInsets.zero
//            cell.setNeedsUpdateConstraints()
//            cell.updateConstraintsIfNeeded()
//            cell.sizeToFit()
//            return cell
//        case "meta":
//            let cell = tblFeed.dequeueReusableCell(withIdentifier: "MetacellTimeline", for: indexPath) as! MetacellTimeline
//            cell.arrMeta = arrFeed[indexPath.row]
//            cell.viewMeta.layer.cornerRadius = 5
//            cell.viewTop.constant = 0
//            cell.lbltop.constant = 0
//            let name = arrFeed[indexPath.row].users_name
//            let selectedUsername = arrFeed[indexPath.row].username
//            arrUserTag = arrFeed[indexPath.row].users_tagged
//            let shared_username = arrFeed[indexPath.row].shared_username
//            let shared_person_name = arrFeed[indexPath.row].shared_person_name
//            if shared_person_name.count == 0 {
//                if arrUserTag.count == 1 {
//                    let strName = arrUserTag[0].name
//                    tagFirstUsername = arrUserTag[0].username
//
//                    let string = "\(name) with \(strName)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//                    let rangeTC = nsString.range(of: strName)
//
//                    let MyLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//                else if arrUserTag.count >= 2 {
//                    for strNamegat in arrUserTag {
//                        let name = strNamegat.name
//                        let tagUsername = strNamegat.username
//                        nameTag.append(name)
//                        userTag.append(tagUsername)
//                        self.strTageName = nameTag.joined(separator: ",")
//                        strName = nameTag[0]
//                        tagFirstUsername = userTag[0]
//                    }
//
//                    let countOther = arrUserTag.count - 1
//                    let strCount = String(countOther)
//                    let FinalCount = strCount + " others."
//                    let strTC = strName
//                    let strPP = FinalCount
//
//                    let string = "\(name) with \(strTC) and \(strPP)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//                    let rangeTC = nsString.range(of: strTC)
//                    let rangePP = nsString.range(of: strPP)
//
//                    let MyLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//                    let ppActiveLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                    cell.lblTitle.activeLinkAttributes = ppActiveLinkAttributes
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
//                    cell.lblTitle.addLink(toAddress: ["Others":arrUserTag], with: rangePP)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//                else {
//                    let string = "\(name)"
//                    let nsString = string as NSString
//
//                    let paragraphStyle = NSMutableParagraphStyle()
//
//                    let fullAttributedString = NSAttributedString(string:string, attributes: [
//                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                        ])
//                    cell.lblTitle.attributedText = fullAttributedString;
//
//                    let rangeMY = nsString.range(of: name)
//
//                    let ppLinkAttributes: [String: Any] = [
//                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                        NSAttributedString.Key.underlineStyle.rawValue: false,
//                    ]
//
//                    cell.lblTitle.linkAttributes = ppLinkAttributes
//                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                    cell.lblTitle.textColor = UIColor.black;
//                    cell.lblTitle.delegate = self;
//                }
//            }
//            else {
//                let string = "\(name) shared \(shared_person_name) 's post"
//                let nsString = string as NSString
//
//                let paragraphStyle = NSMutableParagraphStyle()
//
//                let fullAttributedString = NSAttributedString(string:string, attributes: [
//                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
//                    ])
//                cell.lblTitle.attributedText = fullAttributedString;
//
//                let rangeMY = nsString.range(of: name)
//                let rangeTC = nsString.range(of: shared_person_name)
//
//                let MyLinkAttributes: [String: Any] = [
//                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                    NSAttributedString.Key.underlineStyle.rawValue: false,
//                ]
//
//                let ppLinkAttributes: [String: Any] = [
//                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
//                    NSAttributedString.Key.underlineStyle.rawValue: false,
//                ]
//                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
//                cell.lblTitle.linkAttributes = ppLinkAttributes
//                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
//                cell.lblTitle.addLink(toPhoneNumber: shared_username, with: rangeTC)
//                cell.lblTitle.textColor = UIColor.black;
//                cell.lblTitle.delegate = self;
//            }
//
//            cell.btnLikeCount.addTarget(self, action: #selector(TimelineViewCiontroller.btnAllLikeMetaCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnCommentCount.addTarget(self, action: #selector(TimelineViewCiontroller.btnAllCommentMetaCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnCommentMetaCell.addTarget(self, action: #selector(TimelineViewCiontroller.btnCommentMetaCellAction), for: UIControl.Event.touchUpInside)
//            cell.viewMeta.clipsToBounds = true
//            cell.btnMetaClick.addTarget(self, action: #selector(TimelineViewCiontroller.btnMetaAction), for: .touchUpInside)
//            cell.btnMetaMenu.addTarget(self, action: #selector(TimelineViewCiontroller.btnMenuAction), for: UIControl.Event.touchUpInside)
//            cell.btnLikeMetaCell.addTarget(self, action: #selector(TimelineViewCiontroller.btnLikeMetacellAction), for: UIControl.Event.touchUpInside)
//            cell.btnMetaProfile.addTarget(self, action: #selector(TimelineViewCiontroller.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
//            cell.btndislike.addTarget(self, action: #selector(TimelineViewCiontroller.btndislikeMetaAction), for: UIControl.Event.touchUpInside)
//            cell.btndislikeCount.addTarget(self, action: #selector(TimelineViewCiontroller.btndislikeCountAction), for: UIControl.Event.touchUpInside)
//            cell.layoutMargins = UIEdgeInsets.zero
//            cell.separatorInset = UIEdgeInsets.zero
//            cell.setNeedsUpdateConstraints()
//            cell.updateConstraintsIfNeeded()
//            cell.sizeToFit()
//            return cell
//        default:
//            print("hello")
//        }
//        return UITableViewCell()
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        lastIndex_id = arrFeed[indexPath.row].id
//    }
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
//    {
//        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
//            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
//        }
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        pausePlayeVideos()
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            pausePlayeVideos()
//        }
//
//        if scrollView == tblFeed {
//            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
//            {
//                spinner = UIActivityIndicatorView(style: .gray)
//                spinner.startAnimating()
//                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblFeed.bounds.width, height: CGFloat(44))
//                pageCount += 1
//                print(pageCount)
//                timeline_last_first_id = lastIndex_id
//                timeline_Type_top_bottom = "Bottom"
//                getFeed(strPage: "\(pageCount)")
//                self.tblFeed.tableFooterView = spinner
//                self.tblFeed.tableFooterView?.isHidden = false
//            }
//        }
//    }
//
//    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
//        if url.absoluteString == "action://TC" {
//            print("TC click",url.absoluteString)
//        }
//        else if url.absoluteString == "action://PP" {
//            print("PP click")
//        }
//        else {
//            print(url)
//        }
//    }
//
//    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
//        let myname = loggdenUser.value(forKey: USERNAME)as! String
//        if myname == phoneNumber {
//            //currentTabBar?.setIndex(4)
//        }
//        else {
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "navigationLoaderpageredirection")as! navigationLoaderpageredirection
//            obj.strUser = phoneNumber
//            self.navigationController?.pushViewController(obj, animated: true)
//        }
//    }
//
//
//
//    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithAddress addressComponents: [AnyHashable : Any]!) {
//        let obj = self.storyboard?.instantiateViewController(withIdentifier: "TagPeopleTistController")as! TagPeopleTistController
//        obj.arrgetTag = addressComponents
//        self.navigationController?.pushViewController(obj, animated: true)
//    }
//
//    func pausePlayeVideos(){
//        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tblFeed)
//
//    }
//
//    @objc func appEnteredFromBackground() {
//        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tblFeed, appEnteredFromBackground: true)
//    }
//
//    func getAspectRatioAccordingToiPhones(cellImageFrame:CGSize,downloadedImage: UIImage)->CGFloat {
//        let widthOffset = downloadedImage.size.width - cellImageFrame.width
//        let widthOffsetPercentage = (widthOffset*100)/downloadedImage.size.width
//        let heightOffset = (widthOffsetPercentage * downloadedImage.size.height)/100
//        let effectiveHeight = downloadedImage.size.height - heightOffset
//        return(effectiveHeight)
//    }
//    // MARK: Optional function for resize of image
//    func resizeHighImage(image:UIImage)->UIImage {
//        let size = image.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
//        let hasAlpha = false
//        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
//        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
//        image.draw(in: CGRect(origin: .zero, size: size))
//        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return scaledImage!
//    }
//
//
//
//
//    //MARK: ______________ Meats Data
//
//    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void)) {
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            completion(data, response, error)
//        }).resume()
//    }
//
//    func downloadImage(_ url: URL, imageView: UIImageView){
//        print("Download Started")
//        print("lastPathComponent: " + url.lastPathComponent)
//        getDataFromUrl(url) { (data, response, error)  in
//            DispatchQueue.main.async(execute: {
//                guard let data = data , error == nil else { return }
//                print(response?.suggestedFilename ?? "")
//                print("Download Finished")
//                imageView.image = UIImage(data: data)
//            })
//        }
//    }
//
//
//    @objc func openAction(_ sender: UIButton) {
//        arrSingaleImg.removeAll()
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! ImgcellTimeline
//            let images = arrFeed[indexPath.row].images
//            for item in images {
//                let source_url = item
//                arrSingaleImg.append(source_url)
//                let tkImageVC = TKImageShowing()
//               // tkImageVC.tblFeedDashboard = "tblFeedDashboard"
//                tkImageVC.animatedView  = cellfeed.imgPost
//                // tkImageVC.arrTimeline = arrFeed[indexPath.row]
//                //  tkImageVC.currentIndex = indexPath.row
//                tkImageVC.images = arrSingaleImg.toTKImageSource()
//                //self.present(tkImageVC, animated: true, completion: nil)
//                let naviget: UINavigationController = UINavigationController(rootViewController: tkImageVC)
//                self.present(naviget, animated: true, completion: nil)
//            }
//        }
//    }
//
//
//    @objc func btnImgPassAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            //            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MultiplaePhotoViewControllerList")as! MultiplaePhotoViewControllerList
//            let arrMultiImage = arrFeed[indexPath.row].images
//            let tkImageVC = TKImageShowing()
//            //  tkImageVC.animatedView  = arrMultiImage[indexPath.row].count
//            // tkImageVC.currentIndex = indexPath.row
//            tkImageVC.images = arrMultiImage.toTKImageSource()
//            let naviget: UINavigationController = UINavigationController(rootViewController: tkImageVC)
//            self.present(naviget, animated: true, completion: nil)
//        }
//    }
//
//
//
//    @objc func btnWebviewAction(_ sender : UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            let strLink = arrFeed[indexPath.row].location
//            guard let url = URL(string: strLink) else { return }
//            UIApplication.shared.open(url)
//        }
//    }
//
//
//    @objc func btnMuteAction(_ sender : UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! VideocellTimeline
//            if muteBool == true {
//                cellfeed.btnmute.isSelected = true
//                muteBool = false
//                cellfeed.videoLayer.player?.isMuted = true
//            }
//            else {
//                cellfeed.btnmute.isSelected = false
//                muteBool = true
//                cellfeed.videoLayer.player?.isMuted = false
//            }
//        }
//    }
//
//
//    @objc func btndislikeCountAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            post_Id = arrFeed[indexPath.row].id
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DislikeViewController") as! DislikeViewController
//            obj.post_id = post_Id
//            self.navigationController?.pushViewController(obj, animated: false)
//        }
//    }
//
//
//    //MARK: - Like And Comment Action
//
//    //Mark: - FirstImg
//
//    @objc func btnImgLikeAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            post_Id = arrFeed[indexPath.row].id
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
//            obj.post_id = post_Id
//            self.navigationController?.pushViewController(obj, animated: false)
//        }
//    }
//
//    @objc func btnCommentAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            post_Id = arrFeed[indexPath.row].id
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//            obj.postDetail_id = self.post_Id
//            //self.navigationController?.pushViewController(obj, animated: true)
//            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
//            self.present(naviget, animated: true, completion: nil)
//        }
//    }
//
//    @objc func btnCommentPostAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            post_Id = arrFeed[indexPath.row].id
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//            obj.postDetail_id = self.post_Id
//            //self.navigationController?.pushViewController(obj, animated: true)
//            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
//            self.present(naviget, animated: true, completion: nil)
//        }
//    }
//
//    @objc func btnLikeImgcellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
//                audioPlayer.play()
//            } catch {
//                // couldn't load file :(
//            }
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! ImgcellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let like_count = arrFeed[indexPath.row].users_liked_count
//            let parameters = ["post_id":post_Id] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            if let button = sender as? UIButton {
//                if button.isSelected {
//                    button.isSelected = false
//                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
//                        if sucess {
//                            if response!.liked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 1
//                                        mutableBook.users_liked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 0
//                                        mutableBook.users_liked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                } else {
//                    button.isSelected = true
//                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
//                        if sucess {
//                            if response!.liked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 1
//                                        mutableBook.users_liked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 0
//                                        mutableBook.users_liked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    @objc func btnshareImgAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! ImgcellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let userType = arrFeed[indexPath.row].users_type
//            if userType == "user" {
//                let parameters = ["post_id":post_Id] as [String : Any]
//                let token = loggdenUser.value(forKey: TOKEN)as! String
//                let BEARERTOKEN = BEARER + token
//                let headers: HTTPHeaders = ["Xapi": XAPI,
//                                            "Accept" : ACCEPT,
//                                            "Authorization":BEARERTOKEN]
//                wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
//                    if sucess {
//                        let shareSucess = response?.success
//                        let message = response?.message
//                        if shareSucess! {
//                            if message == "successfully shared" {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_users_shared = 1
//                                    }
//                                    return mutableBook
//                                }
//                                //cellfeed.btnShareimgCell.setTitle("Unshare", for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_users_shared = 0
//                                    }
//                                    return mutableBook
//                                }
//                                // cellfeed.btnShareimgCell.setTitle("Share", for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//            }
//            else {
//                print("jekil")
//            }
//        }
//    }
//
//
//    @objc func btnImgProfileClickAction(_ sender: UIButton) {
//        //        if let indexPath = self.tblFeed.indexPathForView(sender) {
//        //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//        //            let username = loggdenUser.value(forKey: USERNAME)as! String
//        //            let selectedUsername = arrFeed[indexPath.row].username
//        //            if selectedUsername == username {
//        //                currentTabBar?.setIndex(4)
//        //            }
//        //            else {
//        //                let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
//        //                obj.strUserName = selectedUsername
//        //                self.navigationController?.pushViewController(obj, animated: true)
//        //            }
//        //        }
//    }
//
//
//    @objc func btndislikeAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
//                audioPlayer.play()
//            } catch {
//                // couldn't load file :(
//            }
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! ImgcellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let like_count = arrFeed[indexPath.row].users_disliked_count
//            let parameters = ["post_id":post_Id] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            if let button = sender as? UIButton {
//                if button.isSelected {
//                    button.isSelected = false
//                    wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
//                        print(response)
//                        if sucess {
//                            if response!.disliked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 1
//                                        mutableBook.users_disliked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 0
//                                        mutableBook.users_disliked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                } else {
//                    button.isSelected = true
//                    wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
//                        if sucess {
//                            if response!.disliked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 1
//                                        mutableBook.users_disliked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 0
//                                        mutableBook.users_disliked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//
//    @objc func btndislikeMetaAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
//                audioPlayer.play()
//            } catch {
//                // couldn't load file :(
//            }
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MetacellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let like_count = arrFeed[indexPath.row].users_disliked_count
//            let parameters = ["post_id":post_Id] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            if let button = sender as? UIButton {
//                if button.isSelected {
//                    button.isSelected = false
//                    wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
//                        print(response)
//                        if sucess {
//                            if response!.disliked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 1
//                                        mutableBook.users_disliked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 0
//                                        mutableBook.users_disliked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                } else {
//                    button.isSelected = true
//                    wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
//                        if sucess {
//                            if response!.disliked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 1
//                                        mutableBook.users_disliked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 0
//                                        mutableBook.users_disliked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    @objc func btndislikeVideoAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
//                audioPlayer.play()
//            } catch {
//                // couldn't load file :(
//            }
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! YoutubeVideoPlaycell
//            post_Id = arrFeed[indexPath.row].id
//            let like_count = arrFeed[indexPath.row].users_disliked_count
//            let parameters = ["post_id":post_Id] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            if let button = sender as? UIButton {
//                if button.isSelected {
//                    button.isSelected = false
//                    wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
//                        print(response)
//                        if sucess {
//                            if response!.disliked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 1
//                                        mutableBook.users_disliked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 0
//                                        mutableBook.users_disliked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                } else {
//                    button.isSelected = true
//                    wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
//                        if sucess {
//                            if response!.disliked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 1
//                                        mutableBook.users_disliked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 0
//                                        mutableBook.users_disliked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    @objc func btndislikeTxtAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
//                audioPlayer.play()
//            } catch {
//                // couldn't load file :(
//            }
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! TxtcellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let like_count = arrFeed[indexPath.row].users_disliked_count
//            let parameters = ["post_id":post_Id] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            if let button = sender as? UIButton {
//                if button.isSelected {
//                    button.isSelected = false
//                    wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
//                        print(response)
//                        if sucess {
//                            if response!.disliked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 1
//                                        mutableBook.users_disliked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 0
//                                        mutableBook.users_disliked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                } else {
//                    button.isSelected = true
//                    wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
//                        if sucess {
//                            if response!.disliked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 1
//                                        mutableBook.users_disliked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 0
//                                        mutableBook.users_disliked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    @objc func btndislikeMultiAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
//                audioPlayer.play()
//            } catch {
//                // couldn't load file :(
//            }
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MultiImgcellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let like_count = arrFeed[indexPath.row].users_disliked_count
//            let parameters = ["post_id":post_Id] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            if let button = sender as? UIButton {
//                if button.isSelected {
//                    button.isSelected = false
//                    wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
//                        print(response)
//                        if sucess {
//                            if response!.disliked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 1
//                                        mutableBook.users_disliked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 0
//                                        mutableBook.users_disliked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                } else {
//                    button.isSelected = true
//                    wc.callSimplewebservice(url: DISLIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: dislikeResponsModel?) in
//                        if sucess {
//                            if response!.disliked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 1
//                                        mutableBook.users_disliked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_disliked = 0
//                                        mutableBook.users_disliked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.dislikecount
//                                let strLikeTotal = likeCount! + " Dislike"
//                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//
//
//
//    //MARK: - Second Text
//    @objc func btnAllLikeTxtCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            post_Id = arrFeed[indexPath.row].id
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
//            obj.post_id = post_Id
//            self.navigationController?.pushViewController(obj, animated: false)
//        }
//    }
//
//    @objc func btnAllCommenttxtCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            post_Id = arrFeed[indexPath.row].id
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//            obj.postDetail_id = self.post_Id
//            //self.navigationController?.pushViewController(obj, animated: true)
//            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
//            self.present(naviget, animated: true, completion: nil)
//        }
//    }
//
//    @objc func btnCommenttxtCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            post_Id = arrFeed[indexPath.row].id
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//            obj.postDetail_id = self.post_Id
//            //self.navigationController?.pushViewController(obj, animated: true)
//            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
//            self.present(naviget, animated: true, completion: nil)
//        }
//    }
//
//    @objc func btnLiketxtcellAction(_ sender: UIButton) {
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
//            audioPlayer.play()
//        } catch {
//            // couldn't load file :(
//        }
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! TxtcellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let like_count = arrFeed[indexPath.row].users_liked_count
//            let parameters = ["post_id":post_Id] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            if let button = sender as? UIButton {
//                if button.isSelected {
//                    button.isSelected = false
//                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
//                        if sucess {
//                            if response!.liked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 1
//                                        mutableBook.users_liked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 0
//                                        mutableBook.users_liked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//                else
//                {
//                    button.isSelected = true
//                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
//                        if sucess {
//                            if response!.liked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 1
//                                        mutableBook.users_liked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 0
//                                        mutableBook.users_liked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    @objc func btnshareTxtAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! TxtcellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let userType = arrFeed[indexPath.row].users_type
//            if userType == "user" {
//                let parameters = ["post_id":post_Id] as [String : Any]
//                let token = loggdenUser.value(forKey: TOKEN)as! String
//                let BEARERTOKEN = BEARER + token
//                let headers: HTTPHeaders = ["Xapi": XAPI,
//                                            "Accept" : ACCEPT,
//                                            "Authorization":BEARERTOKEN]
//                wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
//                    if sucess {
//                        let shareSucess = response?.success
//                        if shareSucess! {
//                            self.arrFeed = self.arrFeed.map{
//                                var mutableBook = $0
//                                if $0.id == self.post_Id {
//                                    mutableBook.is_users_shared = 1
//                                }
//                                return mutableBook
//                            }
//                            // cellfeed.btnSharetxtCell.setTitle("Unshare", for: .normal)
//                            self.tblFeed.beginUpdates()
//                            self.tblFeed.endUpdates()
//                        }
//                        else {
//                            self.arrFeed = self.arrFeed.map{
//                                var mutableBook = $0
//                                if $0.id == self.post_Id {
//                                    mutableBook.is_users_shared = 0
//                                }
//                                return mutableBook
//                            }
//                            //cellfeed.btnSharetxtCell.setTitle("Share", for: .normal)
//                            self.tblFeed.beginUpdates()
//                            self.tblFeed.endUpdates()
//                        }
//                    }
//                }
//            }
//            else {
//                print("jekil")
//            }
//        }
//    }
//
//    //MARK: - Multi Image
//    @objc func btnAllLikeMultiCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            post_Id = arrFeed[indexPath.row].id
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
//            obj.post_id = post_Id
//            self.navigationController?.pushViewController(obj, animated: false)
//        }
//    }
//
//    @objc func btnAllCommentMultiCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            post_Id = arrFeed[indexPath.row].id
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//            obj.postDetail_id = self.post_Id
//            //self.navigationController?.pushViewController(obj, animated: true)
//            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
//            self.present(naviget, animated: true, completion: nil)
//        }
//    }
//
//    @objc func btnCommentMultiCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            post_Id = arrFeed[indexPath.row].id
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//            obj.postDetail_id = self.post_Id
//            //self.navigationController?.pushViewController(obj, animated: true)
//            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
//            self.present(naviget, animated: true, completion: nil)
//        }
//    }
//
//    @objc func btnLikeMulticellAction(_ sender: UIButton) {
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
//            audioPlayer.play()
//        } catch {
//            // couldn't load file :(
//        }
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MultiImgcellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let like_count = arrFeed[indexPath.row].users_liked_count
//            let parameters = ["post_id":post_Id] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            if let button = sender as? UIButton {
//                if button.isSelected {
//                    button.isSelected = false
//                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
//                        if sucess {
//                            if response!.liked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 1
//                                        mutableBook.users_liked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 0
//                                        mutableBook.users_liked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//                else {
//                    button.isSelected = true
//                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
//                        if sucess {
//                            if response!.liked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 1
//                                        mutableBook.users_liked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 0
//                                        mutableBook.users_liked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    @objc func btnshareMultiAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MultiImgcellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let userType = arrFeed[indexPath.row].users_type
//            if userType == "user" {
//                let parameters = ["post_id":post_Id] as [String : Any]
//                let token = loggdenUser.value(forKey: TOKEN)as! String
//                let BEARERTOKEN = BEARER + token
//                let headers: HTTPHeaders = ["Xapi": XAPI,
//                                            "Accept" : ACCEPT,
//                                            "Authorization":BEARERTOKEN]
//                wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
//                    if sucess {
//                        let shareSucess = response?.success
//                        if shareSucess! {
//                            self.arrFeed = self.arrFeed.map{
//                                var mutableBook = $0
//                                if $0.id == self.post_Id {
//                                    mutableBook.is_users_shared = 1
//                                }
//                                return mutableBook
//                            }
//                            // cellfeed.btnshareMultiCell.setTitle("Unshare", for: .normal)
//                            self.tblFeed.beginUpdates()
//                            self.tblFeed.endUpdates()
//                        }
//                        else {
//                            self.arrFeed = self.arrFeed.map{
//                                var mutableBook = $0
//                                if $0.id == self.post_Id {
//                                    mutableBook.is_users_shared = 0
//                                }
//                                return mutableBook
//                            }
//                            //cellfeed.btnshareMultiCell.setTitle("Share", for: .normal)
//                            self.tblFeed.beginUpdates()
//                            self.tblFeed.endUpdates()
//                        }
//                    }
//                }
//            }
//            else {
//                print("jekil")
//            }
//        }
//    }
//
//    //MARK: - Video
//    @objc func btnAllLikeVideoCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            post_Id = arrFeed[indexPath.row].id
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
//            obj.post_id = post_Id
//            self.navigationController?.pushViewController(obj, animated: false)
//        }
//    }
//
//    @objc func btnAllCommentVideoCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            post_Id = arrFeed[indexPath.row].id
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//            obj.postDetail_id = self.post_Id
//            //self.navigationController?.pushViewController(obj, animated: true)
//            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
//            self.present(naviget, animated: true, completion: nil)
//        }
//    }
//
//    @objc func btnCommentVideoCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            post_Id = arrFeed[indexPath.row].id
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//            obj.postDetail_id = self.post_Id
//            //self.navigationController?.pushViewController(obj, animated: true)
//            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
//            self.present(naviget, animated: true, completion: nil)
//        }
//    }
//
//    @objc func btnLikevideocellAction(_ sender: UIButton) {
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
//            audioPlayer.play()
//        } catch {
//            // couldn't load file :(
//        }
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! YoutubeVideoPlaycell
//            post_Id = arrFeed[indexPath.row].id
//            let like_count = arrFeed[indexPath.row].users_liked_count
//            let parameters = ["post_id":post_Id] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            if let button = sender as? UIButton {
//                if button.isSelected {
//                    button.isSelected = false
//                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
//                        if sucess {
//                            if response!.liked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 1
//                                        mutableBook.users_liked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 0
//                                        mutableBook.users_liked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//                else {
//                    button.isSelected = true
//                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
//                        if sucess {
//                            if response!.liked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 1
//                                        mutableBook.users_liked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 0
//                                        mutableBook.users_liked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    @objc func btnsharevideoAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! YoutubeVideoPlaycell
//            post_Id = arrFeed[indexPath.row].id
//            let userType = arrFeed[indexPath.row].users_type
//            if userType == "user" {
//                let parameters = ["post_id":post_Id] as [String : Any]
//                let token = loggdenUser.value(forKey: TOKEN)as! String
//                let BEARERTOKEN = BEARER + token
//                let headers: HTTPHeaders = ["Xapi": XAPI,
//                                            "Accept" : ACCEPT,
//                                            "Authorization":BEARERTOKEN]
//                wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
//                    if sucess {
//                        let shareSucess = response?.success
//                        if shareSucess! {
//                            self.arrFeed = self.arrFeed.map{
//                                var mutableBook = $0
//                                if $0.id == self.post_Id {
//                                    mutableBook.is_users_shared = 1
//                                }
//                                return mutableBook
//                            }
//                            //cellfeed.btnshareVideoCell.setTitle("Unshare", for: .normal)
//                            self.tblFeed.beginUpdates()
//                            self.tblFeed.endUpdates()
//                        }
//                        else {
//                            self.arrFeed = self.arrFeed.map{
//                                var mutableBook = $0
//                                if $0.id == self.post_Id {
//                                    mutableBook.is_users_shared = 0
//                                }
//                                return mutableBook
//                            }
//                            //cellfeed.btnshareVideoCell.setTitle("Share", for: .normal)
//                            self.tblFeed.beginUpdates()
//                            self.tblFeed.endUpdates()
//                        }
//                    }
//                }
//            }
//            else {
//                print("jekil")
//            }
//        }
//    }
//
//    //MARK: - Meta
//    @objc func btnAllLikeMetaCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            post_Id = arrFeed[indexPath.row].id
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
//            obj.post_id = post_Id
//            self.navigationController?.pushViewController(obj, animated: false)
//        }
//    }
//
//    @objc func btnAllCommentMetaCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            post_Id = arrFeed[indexPath.row].id
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//            obj.postDetail_id = self.post_Id
//            //self.navigationController?.pushViewController(obj, animated: true)
//            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
//            self.present(naviget, animated: true, completion: nil)
//        }
//    }
//
//    @objc func btnCommentMetaCellAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            post_Id = arrFeed[indexPath.row].id
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
//            obj.postDetail_id = self.post_Id
//            //self.navigationController?.pushViewController(obj, animated: true)
//            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
//            self.present(naviget, animated: true, completion: nil)
//        }
//    }
//
//    @objc func btnLikeMetacellAction(_ sender: UIButton) {
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
//            audioPlayer.play()
//        } catch {
//            // couldn't load file :(
//        }
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MetacellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let like_count = arrFeed[indexPath.row].users_liked_count
//            let parameters = ["post_id":post_Id] as [String : Any]
//            let token = loggdenUser.value(forKey: TOKEN)as! String
//            let BEARERTOKEN = BEARER + token
//            let headers: HTTPHeaders = ["Xapi": XAPI,
//                                        "Accept" : ACCEPT,
//                                        "Authorization":BEARERTOKEN]
//            if let button = sender as? UIButton {
//                if button.isSelected {
//                    button.isSelected = false
//                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
//                        if sucess {
//                            if response!.liked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 1
//                                        mutableBook.users_liked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 0
//                                        mutableBook.users_liked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//                else {
//                    button.isSelected = true
//                    wc.callSimplewebservice(url: LIKEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostLikeResponseModel?) in
//                        if sucess {
//                            if response!.liked {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 1
//                                        mutableBook.users_liked_count = like_count + 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                            else {
//                                self.arrFeed = self.arrFeed.map{
//                                    var mutableBook = $0
//                                    if $0.id == self.post_Id {
//                                        mutableBook.is_liked = 0
//                                        mutableBook.users_liked_count = like_count - 1
//                                    }
//                                    return mutableBook
//                                }
//                                let likeCount = response?.likecount
//                                let strLikeTotal = likeCount! + " Like"
//                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
//                                self.tblFeed.beginUpdates()
//                                self.tblFeed.endUpdates()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    @objc func btnsharemetaAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MetacellTimeline
//            post_Id = arrFeed[indexPath.row].id
//            let userType = arrFeed[indexPath.row].users_type
//            if userType == "user" {
//                let parameters = ["post_id":post_Id] as [String : Any]
//                let token = loggdenUser.value(forKey: TOKEN)as! String
//                let BEARERTOKEN = BEARER + token
//                let headers: HTTPHeaders = ["Xapi": XAPI,
//                                            "Accept" : ACCEPT,
//                                            "Authorization":BEARERTOKEN]
//                wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
//                    if sucess {
//                        let shareSucess = response?.success
//                        if shareSucess! {
//                            self.arrFeed = self.arrFeed.map{
//                                var mutableBook = $0
//                                if $0.id == self.post_Id {
//                                    mutableBook.is_users_shared = 1
//                                }
//                                return mutableBook
//                            }
//                            //cellfeed.btnShareMetaCell.setTitle("Unshare", for: .normal)
//                            self.tblFeed.beginUpdates()
//                            self.tblFeed.endUpdates()
//                        }
//                        else {
//                            self.arrFeed = self.arrFeed.map{
//                                var mutableBook = $0
//                                if $0.id == self.post_Id {
//                                    mutableBook.is_users_shared = 0
//                                }
//                                return mutableBook
//                            }
//                            //cellfeed.btnShareMetaCell.setTitle("Share", for: .normal)
//                            self.tblFeed.beginUpdates()
//                            self.tblFeed.endUpdates()
//                        }
//                    }
//                }
//            }
//            else {
//                print("jekil")
//            }
//        }
//    }
//
//
//
//    @objc func btnMetaAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let Metas = arrFeed[indexPath.row].description
//            guard let url = URL(string: Metas) else { return }
//            UIApplication.shared.open(url)
//        }
//    }
//
//    //MARK: ------ btnMenuAction
//
//    @objc func btnMenuAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            let is_my_post = arrFeed[indexPath.row].is_my_post
//            post_Id = arrFeed[indexPath.row].id
//            let SavePost = arrFeed[indexPath.row].is_saved
//            let Notification = arrFeed[indexPath.row].is_notification
//            let editdescription = arrFeed[indexPath.row].description
//            let usernamepost = arrFeed[indexPath.row].users_name
//            let shared_post_id = arrFeed[indexPath.row].shared_post_id
//            let shared_person_name = arrFeed[indexPath.row].shared_person_name
//            let shared_username = arrFeed[indexPath.row].shared_username
//            let is_users_shared = arrFeed[indexPath.row].is_users_shared
//
//            if SavePost == 0 {
//                strSaveUnsave = "Save Post"
//            }
//            else {
//                strSaveUnsave = "Unsave Post"
//            }
//
//            if Notification == 0 {
//                strNotification = "Get Notifications"
//            }
//            else {
//                strNotification = "Stop Notifications"
//            }
//
//
//            if is_my_post == 1 {
//                let actionSheetController: UIAlertController = UIAlertController(title: "FriendzPoint", message: nil, preferredStyle: .actionSheet)
//                let firstAction: UIAlertAction = UIAlertAction(title: strNotification, style: .default) { action -> Void in
//                    let parameters = ["post_id":self.post_Id] as [String : Any]
//                    let token = loggdenUser.value(forKey: TOKEN)as! String
//                    let BEARERTOKEN = BEARER + token
//                    let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                "Accept" : ACCEPT,
//                                                "Authorization":BEARERTOKEN]
//                    self.wc.callSimplewebservice(url: GETNOTIFICATIONs, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: NotificatioGetandSetResponsModel?) in
//                        if sucess {
//                            let sucess = response?.success
//                            let message = response?.message
//                            if sucess! {
//                                if message == "Successfull ." {
//                                    self.arrFeed = self.arrFeed.map{
//                                        var mutableBook = $0
//                                        if $0.id == self.post_Id {
//                                            mutableBook.is_notification = 1
//                                        }
//                                        return mutableBook
//                                    }
//                                    self.tblFeed.beginUpdates()
//                                    self.tblFeed.endUpdates()
//                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                        print("did dissmiss")
//                                    }
//                                }
//                                else {
//                                    self.arrFeed = self.arrFeed.map{
//                                        var mutableBook = $0
//                                        if $0.id == self.post_Id {
//                                            mutableBook.is_notification = 0
//                                        }
//                                        return mutableBook
//                                    }
//                                    self.tblFeed.beginUpdates()
//                                    self.tblFeed.endUpdates()
//                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                        print("did dissmiss")
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                let secondAction: UIAlertAction = UIAlertAction(title: "Edit", style: .default) { action -> Void in
//
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "postEditViewController")as! postEditViewController
//                    obj.postid = self.post_Id
//                    obj.strdescription = editdescription
//                    let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//                    self.present(naviget, animated: true, completion: nil)
//                }
//
//                let third: UIAlertAction = UIAlertAction(title: "Delete", style: .default) { action -> Void in
//                    if shared_post_id == 0 {
//                        let parameters = ["post_id":self.post_Id] as [String : Any]
//                        self.arrFeed.remove(at: indexPath.row)
//                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
//                        let token = loggdenUser.value(forKey: TOKEN)as! String
//                        let BEARERTOKEN = BEARER + token
//                        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                    "Accept" : ACCEPT,
//                                                    "Authorization":BEARERTOKEN]
//                        self.wc.callSimplewebservice(url: DELETEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: PostDeleteResponseModel?) in
//                            if sucess {
//                                let suc = response?.success
//                                let message = response?.message
//                                if suc == true {
//                                    self.tblFeed.beginUpdates()
//                                    self.tblFeed.endUpdates()
//                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                        print("did dissmiss")
//                                    }
//                                }
//                                else {
//                                    self.tblFeed.beginUpdates()
//                                    self.tblFeed.endUpdates()
//                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                        print("did dissmiss")
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    else {
//                        let parameters = ["post_id":shared_post_id] as [String : Any]
//                        self.arrFeed.remove(at: indexPath.row)
//                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
//                        let token = loggdenUser.value(forKey: TOKEN)as! String
//                        let BEARERTOKEN = BEARER + token
//                        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                    "Accept" : ACCEPT,
//                                                    "Authorization":BEARERTOKEN]
//                        self.wc.callSimplewebservice(url: UNSHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
//                            if sucess {
//                                let suc = response?.success
//                                let message = response?.message
//                                if suc == true {
//                                    self.tblFeed.beginUpdates()
//                                    self.tblFeed.endUpdates()
//                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                        print("did dissmiss")
//                                    }
//                                }
//                                else {
//                                    self.tblFeed.beginUpdates()
//                                    self.tblFeed.endUpdates()
//                                }
//                            }
//                        }
//                    }
//
//                }
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
//                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
//                actionSheetController.addAction(firstAction)
//                actionSheetController.addAction(secondAction)
//                actionSheetController.addAction(third)
//                actionSheetController.addAction(four)
//                actionSheetController.addAction(cancelAction)
//                present(actionSheetController, animated: true, completion: nil)
//            }
//            else {
//                if is_users_shared == 1 {
//                    let actionSheetController: UIAlertController = UIAlertController(title: "FriendzPoint", message: nil, preferredStyle: .actionSheet)
//                    let firstAction: UIAlertAction = UIAlertAction(title: strNotification, style: .default) { action -> Void in
//                        let parameters = ["post_id":self.post_Id] as [String : Any]
//                        let token = loggdenUser.value(forKey: TOKEN)as! String
//                        let BEARERTOKEN = BEARER + token
//                        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                    "Accept" : ACCEPT,
//                                                    "Authorization":BEARERTOKEN]
//                        self.wc.callSimplewebservice(url: GETNOTIFICATIONs, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: NotificatioGetandSetResponsModel?) in
//                            if sucess {
//                                let sucess = response?.success
//                                let message = response?.message
//                                let data = response?.data
//                                let noti = data?.notifications
//                                if sucess! {
//                                    if noti == 1 {
//                                        self.arrFeed = self.arrFeed.map{
//                                            var mutableBook = $0
//                                            if $0.id == self.post_Id {
//                                                mutableBook.is_notification = 1
//                                            }
//                                            return mutableBook
//                                        }
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                    else {
//                                        self.arrFeed = self.arrFeed.map{
//                                            var mutableBook = $0
//                                            if $0.id == self.post_Id {
//                                                mutableBook.is_notification = 0
//                                            }
//                                            return mutableBook
//                                        }
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//
//                    let secondAction: UIAlertAction = UIAlertAction(title: "Hide Post", style: .default) { action -> Void in
//                        let parameters = ["post_id":self.post_Id] as [String : Any]
//                        self.arrFeed.remove(at: indexPath.row)
//                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
//                        let token = loggdenUser.value(forKey: TOKEN)as! String
//                        let BEARERTOKEN = BEARER + token
//                        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                    "Accept" : ACCEPT,
//                                                    "Authorization":BEARERTOKEN]
//                        self.wc.callSimplewebservice(url: HIDEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: hidePostResponsModel?) in
//                            if sucess {
//                                let sucess = response?.success
//                                let message = response?.message
//                                let data = response?.data
//                                let hide = data?.hide
//                                if sucess! {
//                                    if hide == 1 {
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                    else {
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    let third: UIAlertAction = UIAlertAction(title: strSaveUnsave, style: .default) { action -> Void in
//                        let parameters = ["post_id":self.post_Id] as [String : Any]
//                        let token = loggdenUser.value(forKey: TOKEN)as! String
//                        let BEARERTOKEN = BEARER + token
//                        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                    "Accept" : ACCEPT,
//                                                    "Authorization":BEARERTOKEN]
//                        self.wc.callSimplewebservice(url: SAVEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SavePostResponsModel?) in
//                            if sucess {
//                                let sucess = response?.success
//                                let message = response?.message
//                                let data = response?.data
//                                let saved = data?.type
//
//                                if sucess! {
//                                    if saved == "save" {
//                                        self.arrFeed = self.arrFeed.map{
//                                            var mutableBook = $0
//                                            if $0.id == self.post_Id {
//                                                mutableBook.is_saved = 1
//                                            }
//                                            return mutableBook
//                                        }
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                    else {
//                                        self.arrFeed = self.arrFeed.map{
//                                            var mutableBook = $0
//                                            if $0.id == self.post_Id {
//                                                mutableBook.is_saved = 0
//                                            }
//                                            return mutableBook
//                                        }
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    let Four: UIAlertAction = UIAlertAction(title: "Report", style: .default) { action -> Void in
//                        let parameters = ["post_id":self.post_Id] as [String : Any]
//                        self.arrFeed.remove(at: indexPath.row)
//                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
//                        let token = loggdenUser.value(forKey: TOKEN)as! String
//                        let BEARERTOKEN = BEARER + token
//                        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                    "Accept" : ACCEPT,
//                                                    "Authorization":BEARERTOKEN]
//                        self.wc.callSimplewebservice(url: REPORTPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ReportPostResponsModel?) in
//                            if sucess {
//                                let sucess = response?.success
//                                let message = response?.message
//                                let data = response?.data
//                                let report = data?.reported
//
//                                if sucess! {
//                                    if report == 1 {
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                    else {
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
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
//                    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
//                    actionSheetController.addAction(firstAction)
//                    actionSheetController.addAction(secondAction)
//                    actionSheetController.addAction(third)
//                    actionSheetController.addAction(Four)
//                    actionSheetController.addAction(five)
//                    actionSheetController.addAction(cancelAction)
//                    present(actionSheetController, animated: true, completion: nil)
//                }
//                else {
//                    let actionSheetController: UIAlertController = UIAlertController(title: "FriendzPoint", message: nil, preferredStyle: .actionSheet)
//                    let firstAction: UIAlertAction = UIAlertAction(title: strNotification, style: .default) { action -> Void in
//                        let parameters = ["post_id":self.post_Id] as [String : Any]
//                        let token = loggdenUser.value(forKey: TOKEN)as! String
//                        let BEARERTOKEN = BEARER + token
//                        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                    "Accept" : ACCEPT,
//                                                    "Authorization":BEARERTOKEN]
//                        self.wc.callSimplewebservice(url: GETNOTIFICATIONs, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: NotificatioGetandSetResponsModel?) in
//                            if sucess {
//                                let sucess = response?.success
//                                let message = response?.message
//                                let data = response?.data
//                                let noti = data?.notifications
//                                if sucess! {
//                                    if noti == 1 {
//                                        self.arrFeed = self.arrFeed.map{
//                                            var mutableBook = $0
//                                            if $0.id == self.post_Id {
//                                                mutableBook.is_notification = 1
//                                            }
//                                            return mutableBook
//                                        }
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                    else {
//                                        self.arrFeed = self.arrFeed.map{
//                                            var mutableBook = $0
//                                            if $0.id == self.post_Id {
//                                                mutableBook.is_notification = 0
//                                            }
//                                            return mutableBook
//                                        }
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//
//                    let secondAction: UIAlertAction = UIAlertAction(title: "Hide Post", style: .default) { action -> Void in
//                        let parameters = ["post_id":self.post_Id] as [String : Any]
//
//                        self.arrFeed.remove(at: indexPath.row)
//                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
//                        let token = loggdenUser.value(forKey: TOKEN)as! String
//                        let BEARERTOKEN = BEARER + token
//                        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                    "Accept" : ACCEPT,
//                                                    "Authorization":BEARERTOKEN]
//                        self.wc.callSimplewebservice(url: HIDEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: hidePostResponsModel?) in
//                            if sucess {
//                                let sucess = response?.success
//                                let message = response?.message
//                                let data = response?.data
//                                let hide = data?.hide
//                                if sucess! {
//                                    if hide == 1 {
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                    else {
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    let third: UIAlertAction = UIAlertAction(title: strSaveUnsave, style: .default) { action -> Void in
//                        let parameters = ["post_id":self.post_Id] as [String : Any]
//                        let token = loggdenUser.value(forKey: TOKEN)as! String
//                        let BEARERTOKEN = BEARER + token
//                        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                    "Accept" : ACCEPT,
//                                                    "Authorization":BEARERTOKEN]
//                        self.wc.callSimplewebservice(url: SAVEPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SavePostResponsModel?) in
//                            if sucess {
//                                let sucess = response?.success
//                                let message = response?.message
//                                let data = response?.data
//                                let saved = data?.type
//
//                                if sucess! {
//                                    if saved == "save" {
//                                        self.arrFeed = self.arrFeed.map{
//                                            var mutableBook = $0
//                                            if $0.id == self.post_Id {
//                                                mutableBook.is_saved = 1
//                                            }
//                                            return mutableBook
//                                        }
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                    else {
//                                        self.arrFeed = self.arrFeed.map{
//                                            var mutableBook = $0
//                                            if $0.id == self.post_Id {
//                                                mutableBook.is_saved = 0
//                                            }
//                                            return mutableBook
//                                        }
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    let Four: UIAlertAction = UIAlertAction(title: "Report", style: .default) { action -> Void in
//                        let parameters = ["post_id":self.post_Id] as [String : Any]
//                        self.arrFeed.remove(at: indexPath.row)
//                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
//                        let token = loggdenUser.value(forKey: TOKEN)as! String
//                        let BEARERTOKEN = BEARER + token
//                        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                    "Accept" : ACCEPT,
//                                                    "Authorization":BEARERTOKEN]
//                        self.wc.callSimplewebservice(url: REPORTPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ReportPostResponsModel?) in
//                            if sucess {
//                                let sucess = response?.success
//                                let message = response?.message
//                                let data = response?.data
//                                let report = data?.reported
//
//                                if sucess! {
//                                    if report == 1 {
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                    else {
//                                        self.tblFeed.beginUpdates()
//                                        self.tblFeed.endUpdates()
//                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                            print("did dissmiss")
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    let five: UIAlertAction = UIAlertAction(title: "Share", style: .default) { action -> Void in
//                        let parameters = ["post_id":self.post_Id] as [String : Any]
//                        let token = loggdenUser.value(forKey: TOKEN)as! String
//                        let BEARERTOKEN = BEARER + token
//                        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                                    "Accept" : ACCEPT,
//                                                    "Authorization":BEARERTOKEN]
//                        self.wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
//                            if sucess {
//                                let shareSucess = response?.success
//                                let message = response?.message
//                                if shareSucess! {
//                                    self.arrFeed = self.arrFeed.map{
//                                        var mutableBook = $0
//                                        if $0.id == self.post_Id {
//                                            mutableBook.is_users_shared = 1
//                                        }
//                                        return mutableBook
//                                    }
//                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
//                                        print("did dissmiss")
//                                    }
//                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PostCreat"), object: nil)
//                                    self.tblFeed.scrollToTop()
//                                }
//                            }
//                        }
//                    }
//
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
//                    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
//                    actionSheetController.addAction(firstAction)
//                    actionSheetController.addAction(secondAction)
//                    actionSheetController.addAction(third)
//                    actionSheetController.addAction(Four)
//                    actionSheetController.addAction(five)
//                    actionSheetController.addAction(six)
//                    actionSheetController.addAction(cancelAction)
//                    present(actionSheetController, animated: true, completion: nil)
//                }
//            }
//        }
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "bounds"{
//            if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
//                let margin:CGFloat = 8.0
//                textView.frame = CGRect.init(x: rect.origin.x + margin, y: rect.origin.y + margin, width: rect.width - 2*margin, height: rect.height / 2)
//                textView.bounds = CGRect.init(x: rect.origin.x + margin, y: rect.origin.y + margin, width: rect.width - 2*margin, height: rect.height / 2)
//            }
//        }
//    }
//
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }
//
//    //UIPopoverPresentationControllerDelegate
//    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
//
//    }
//
//    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
//        return true
//    }
//}

//extension TimelineViewCiontroller: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return arrMultiImage.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        let source_url = arrMultiImage[indexPath.row]
//        url = URL(string: source_url)
//        cell.imageView.sd_setImage(with: url, completed: nil)
//
//        if arrMultiImage.count >= 7 {
//            if selectedIndex == indexPath.row {
//                cell.transView.isHidden = false
//                let countvalue = arrMultiImage.count - 6
//                let strString = String(countvalue)
//                cell.lblCount.text = "+ " + strString
//            } else {
//                cell.transView.isHidden = true
//            }
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        //        let obj = self.storyboard?.instantiateViewController(withIdentifier: "MultiplaePhotoViewControllerList")as! MultiplaePhotoViewControllerList
//        //        obj.arrMultipale = arrMultiImage
//        //        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//        //        self.present(naviget, animated: true, completion: nil)
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
//        let tkImageVC = TKImageShowing()
//        tkImageVC.animatedView  = cell!.imageView
//        tkImageVC.currentIndex = indexPath.row
//        tkImageVC.images = arrMultiImage.toTKImageSource()
//        let naviget: UINavigationController = UINavigationController(rootViewController: tkImageVC)
//        self.present(naviget, animated: true, completion: nil)
//        //self.present(tkImageVC, animated: true, completion: nil)
//    }
//
//    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    //            let padding: CGFloat = 1
//    //            let collectionViewSize = collectionView.bounds.width - padding
//    //            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
//    //    }
//}
//
//extension TimelineViewCiontroller: SquareFlowLayoutDelegate {
//    func shouldExpandItem(at indexPath: IndexPath) -> Bool {
//        if arrMultiImage.count == 5 {
//            return self.layoutValues[indexPath.row] == .normal
//        }
//        return self.layoutValues[indexPath.row] == .expanded
//    }
//}


// MARK: - Table View Extensions
extension TimelineViewCiontroller: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching{
    
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
//
    @IBAction func btnStatusAction(_ sender: UIButton) {
//
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
                   
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        cellfeed.btnlike.transform = cellfeed.btnlike.transform.scaledBy(x: 0.7, y: 0.7)
                        cellfeed.btnlike.setImage(UIImage(named: "like"), for: .normal)
                        }, completion: { _ in
                          UIView.animate(withDuration: 0.1, animations: {
                            cellfeed.btnlike.transform = CGAffineTransform.identity
                          })
                        })
                    
                    //cellfeed.btnlike.setImage(UIImage(named: "like"), for: .normal)
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
                 
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        cellfeed.btnlike.transform = cellfeed.btnlike.transform.scaledBy(x: 1.3, y: 1.3)
                        let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                        cellfeed.btnlike.setImage(image, for: .normal)
                        cellfeed.btnlike.tintColor = UIColor.red
                        
                        }, completion: { _ in
                          UIView.animate(withDuration: 0.1, animations: {
                            cellfeed.btnlike.transform = CGAffineTransform.identity
                          })
                        })
                    
                    //cellfeed.btnlike.setImage(UIImage(named: "likefill"), for: .normal)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        
        cell.btnStatus.isHidden = true
        cell.imglogo.isHidden = true
        cell.btnCamera.isHidden = true
        cell.btnChatMain.isHidden = true
        cell.transparentView.isHidden = true
        
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
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapLikes(_:)))
//        tapGesture.numberOfTapsRequired = 1
//        cell.lblLikeDescription.addGestureRecognizer(tapGesture)
        
        
//        if arrFollow[indexPath.row] == "1"{
//            cell.btnStatus.setTitle("Unfollow", for: .normal)
//            cell.btnStatus.tintColor = .ButtonTextColor
//        }
//        else{
//            cell.btnStatus.setTitle("Follow", for: .normal)
//            cell.btnStatus.tintColor = .Blue
//        }
//
//        if arrIsLiked[indexPath.row] == "1" {
//            cell.btnlike.setImage(UIImage(named: "likefill"), for: .normal)
//        } else {
//            cell.btnlike.setImage(UIImage(named: "like"), for: .normal)
//        }
//
//        if arrDisLiked[indexPath.row] == "2" {
//            cell.btndislike.setImage(UIImage(named: "dislikefill"), for: .normal)
//        } else {
//            cell.btndislike.setImage(UIImage(named: "dislike1"), for: .normal)
//        }

//        if indexPath.row == 3{
//            cell.countView.isHidden = false
//            cell.pageControl.isHidden = true
//            cell.pagerView.isHidden = false
//            cell.imageview.isHidden = true
//            cell.imageviewBackground.isHidden = true
//            cell.btn_play.isHidden = true
//            cell.countView.isHidden = false
//            cell.images = arrmulti_image
//            cell.pageControl.numberOfPages = arrmulti_image.count//arrFeed[indexPath.row].images.count
//            cell.lblPageCount.text = "1" + "/" + String(arrmulti_image.count)
//            cell.btnclick.isHidden = true
//            cell.pagerView.reloadData()
//        }
//        else if indexPath.row == 6{
//            cell.btnclick.isHidden = false
//            cell.pagerView.isHidden = true
//            cell.pageControl.isHidden = true
//            cell.imageview.isHidden = false
//            cell.imageviewBackground.isHidden = false
//            cell.btn_play.isHidden = false
//            cell.countView.isHidden = true
////            cell.configureCell(imageUrl: "https://friendzpoint.blob.core.windows.net/frp/uploads/users/gallery/poster/20201226114814LtpiPdCASW.mp4.jpg", description: "", videoUrl: arrVideo)
//            cell.configure(post: "https://friendzpoint.blob.core.windows.net/frp/uploads/users/gallery/poster/20201226114814LtpiPdCASW.mp4.jpg")
//        }
//        else if indexPath.row == 8{
//            cell.btnclick.isHidden = false
//            cell.pagerView.isHidden = true
//            cell.pageControl.isHidden = true
//            cell.imageview.isHidden = false
//            cell.imageviewBackground.isHidden = false
//            cell.btn_play.isHidden = false
//            cell.countView.isHidden = true
//            cell.configure(post: "https://friendzpoint.blob.core.windows.net/frp/uploads/users/gallery/poster/20201226114814LtpiPdCASW.mp4.jpg")
//        }
//        else{
//            cell.btnclick.isHidden = false
//            cell.countView.isHidden = true
//            cell.pagerView.isHidden = true
//            cell.pageControl.isHidden = true
//            cell.imageview.isHidden = false
//            cell.imageviewBackground.isHidden = false
//            cell.btn_play.isHidden = true
//            cell.configure(post: arrimages[indexPath.row])
//
//        }
//        else{
            let typeFeed = arrFeed[indexPath.row].type
            cell.lblUserName.text = arrFeed[indexPath.row].users_name
        
        //MARK: STATUS
//        let send_request = getProfileDetails(strUserName: arrFeed[indexPath.row].users_name)
//        if send_request == "approved" {
//            RemoveFriends()
            cell.btnStatus.setTitle("Unfollow", for: .normal)
            cell.btnStatus.tintColor = .ButtonTextColor
//        }
//        else if send_request == "addfriend" {
////            AddFriends()
//            cell.btnStatus.setTitle("Follow", for: .normal)
//            cell.btnStatus.tintColor = .Blue
//        }
//        else {
//            cell.btnStatus.setTitle("AAAA", for: .normal)
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
        let strLikeTotal = String(totalLike) + " Like"
        
        cell.lblLikeDescription.attributedText = setLike(likedcount: String(totalLike))//boldString
//        cell.btnImgLike.setTitle(strLikeTotal, for: .normal)
        
        
        let is_liked = arrFeed[indexPath.row].is_liked
        if is_liked == 1 {
            cell.btnlike.isSelected = true
           // cell.btnlike.setImage(UIImage(named: "likefill"), for: .normal)
            let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
            cell.btnlike.setImage(image, for: .normal)
            cell.btnlike.tintColor = UIColor.red
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
        
        self.shotImageView.imageURL = imageUrl
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
extension TimelineViewCiontroller {
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


extension TimelineViewCiontroller: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFeed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GroupCollCell
        
        let typeFeed = arrFeed[indexPath.row].type
        print("typeFeed:", typeFeed)
        switch typeFeed {
        case "image":
            let arrImages = arrFeed[indexPath.row].images
            for item in arrImages {
                let source_url = item
               // url = URL(string: source_url)
                cell.imgProfileF.kf.setImage(with: URL(string: source_url),placeholder:UIImage(named: "Placeholder"))
                
            }
            break
        case "multi_image" :
            
            cell.imgProfileF.kf.setImage(with: URL(string: arrFeed[indexPath.row].images[0]),placeholder:UIImage(named: "Placeholder"))
         //   break
       
        case "video":
            cell.imgProfileF.kf.setImage(with: URL(string: arrFeed[indexPath.row].video_poster),placeholder:UIImage(named: "Placeholder"))
            break
            
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let obj = launchStoryBoard.instantiateViewController(withIdentifier: "BrowseVC") as! BrowseVC
        obj.strUrlType = "FTimeline"
        obj.strUserName = strUserName
        if indexPath.row == 0 {
            obj.timeline_last_first_id = 0
        }
        else{
            obj.timeline_last_first_id = arrFeed[indexPath.row - 1].id
        }
        obj.timeline_Type_top_bottom = "Bottom"
//        self.navigationController?.pushViewController(obj, animated: true)
        self.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(obj, animated: true)
        self.present(obj, animated: false, completion: nil)
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let padding: CGFloat =  30
//        let collectionViewSize = Collection.frame.size.width - padding
//        print("collectionViewSize: ",collectionViewSize)
////        if indexPath.row == 4 || indexPath.row == 5{
//            return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
//        }
//        else{
//            return CGSize(width: collectionViewSize/2, height: 80)
//        }
        
        let yourWidth = Collection.bounds.width/3.0
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let padding: CGFloat =  1
//        let collectionViewSize = collectionView.frame.size.width - padding
//        return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
//    }
    
}

extension TimelineViewCiontroller: YPImagePickerDelegate{
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
                self.appDel.gotoDashboardController()
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
