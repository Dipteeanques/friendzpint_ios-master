//
//  NewsfeedViewController.swift
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
import TTTAttributedLabel
import SafariServices
import WebKit
import MessageUI
import PSHTMLView
import AJMessage
import MediaPlayer

class NewsfeedViewController: UIViewController,UIPopoverPresentationControllerDelegate,TTTAttributedLabelDelegate,PSHTMLViewDelegate {//UIWebViewDelegate,
    func presentAlert(_ alertController: UIAlertController) {
        
    }
    
    func heightChanged(height: CGFloat) {
       // tblFeed.reloadData()
    }
    
    func shouldNavigate(for navigationAction: WKNavigationAction) -> Bool {
        return true
    }
    
    func handleScriptMessage(_ message: WKScriptMessage) {
        
    }
    
    func loadingProgress(progress: Float) {
        
    }
    
    func didFinishLoad() {
        
    }
    
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsfeedViewController")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
    
    enum CellType {
        case normal
        case expanded
    }
    @IBAction func btnLinkadAction(_ sender: UIButton) {
        print("linkAD:",linkAD)
         UIApplication.shared.openURL(NSURL(string: linkAD)! as URL)
    }
    
    @IBAction func btnEditAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "GeneralSettingsViewController")as! GeneralSettingsViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    //MARK: - VARIABLE
    var selectedIndex = Int()
    internal var TexttagTapHandler: ((String) -> ())?
    @IBOutlet weak var adTop: NSLayoutConstraint!
    @IBOutlet weak var viewhedline: UIView!
    @IBOutlet weak var hedlinheight: NSLayoutConstraint!
    @IBOutlet weak var viewHeaderBanner: UIView!
    @IBOutlet weak var foundView: LargeFound!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var btnfloat: UIButton!
    @IBOutlet weak var trailingconstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblFeed: UITableView!
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
    
     var moviePlayer:MPMoviePlayerController!
    private let layoutValues: [CellType] = [
        .expanded, .expanded, .normal,
        .normal, .normal,.normal, .normal, .normal,
        .normal, .normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.expanded]
    var assets: [DKAsset]?
    let shotTableViewCellIdentifier = "ShotTableViewCell"
    let loadingCellTableViewCellCellIdentifier = "LoadingCellTableViewCell"
    var refreshControl = UIRefreshControl()

    
    var FirstTime = ""
    
    var versionNumber = ""
    let textView = UITextView(frame: CGRect.zero)
    var arrSingaleImg = [String]()
    var url: URL?
    var index = Int()
    var dicValue = NSDictionary()
    var muteBool = true
    var ActivityIndi = UIActivityIndicatorView()
    var arrFeed = [MyTimelineList]()
    var timelinead = [MyTimelineList]()
    var arrUserTag = [userTagpeopelListResponse]()
    var arrMultiImage = [String]()
    var post_Id = Int()
    var strSaveUnsave = String()
    var strNotification = String()
    var hashtagpost = String()
    var nextPage = String()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var arrMultiVala = NSMutableArray()
    var wc = Webservice.init()
    var arrImages = [String]()
    var timeline_last_first_id = Int()
    var timeline_Type_top_bottom = String()
    var lastIndex_id = Int()
    var encodeData = [Data]()
    var decodedData = [Data]()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var strTageName = String()
    var pianoSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "blop", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    var rowHeights:[Int:CGFloat] = [:]
    var nameTag = [String]()
    var userTag = [String]()
    var strName = String()
    var selectedUsername = String()
    var tagFirstUsername = String()
    var Postime_id = Int()
    var strDescriptionedit = String()
    var strFcm = String()
    var linkAD = String()
    var isNewDataLoading = false
    var limit = 0
    var totalEntries = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // viewHeaderBanner.height = 0
        getProfileDetails()
        loaderView.isHidden = false
        activity.startAnimating()
        setDefault()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.TimelineReload), name: NSNotification.Name(rawValue: "Timeline"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.CommentCountSet), name: NSNotification.Name(rawValue: "CommentCount"), object: nil)
        
        tblFeed.rowHeight = UITableView.automaticDimension;
        tblFeed.estimatedRowHeight = 0;
        
        print("Bundle version : \(Bundle.main.appName) v \(Bundle.main.versionNumber) (Build \(Bundle.main.buildNumber))")
        versionNumber = "\(Bundle.main.versionNumber)"
        
        if (loggdenUser.value(forKey: ADtimeline) != nil) {
            decodedData = loggdenUser.value(forKey: ADtimeline) as! [Data]
            for i in 0..<decodedData.count
            {
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode(adsData.self, from: decodedData[i])
                let strImage = decoded?.image
                linkAD = decoded!.link
                let active = decoded?.active
                if active == 1 {
                    if (loggdenUser.value(forKey: UPDATEPROFILE) != nil) {
                        let complited = loggdenUser.value(forKey: UPDATEPROFILE) as! Int
                        print("complited:",complited)
                        if complited == 1 {
                            viewhedline.isHidden = true
                            adTop.constant = 0
                            hedlinheight.constant = 0
                            viewHeaderBanner.height = 158
                            url = URL(string: strImage!)
                            imgBanner.sd_setImage(with: url, completed: nil)
                        }
                        else {
                            viewhedline.isHidden = true
                            adTop.constant = 0
                            hedlinheight.constant = 0
                            viewHeaderBanner.height = 0
                            url = URL(string: strImage!)
                            imgBanner.sd_setImage(with: url, completed: nil)
                        }
                    }
                    else {
                        viewhedline.isHidden = true
                        adTop.constant = 0
                        hedlinheight.constant = 0
                        viewHeaderBanner.height = 0
                        url = URL(string: strImage!)
                        imgBanner.sd_setImage(with: url, completed: nil)
                    }
                }
                else {
                    if (loggdenUser.value(forKey: UPDATEPROFILE) != nil) {
                        let complited = loggdenUser.value(forKey: UPDATEPROFILE) as! Int
                        if complited == 1 {
                            viewHeaderBanner.height = 0
                            viewhedline.isHidden = true
                        }
                        else {
                            viewHeaderBanner.height = 50
                            hedlinheight.constant = 50
                        }
                    }
                }
                break;
            }
        }
        else {
            if (loggdenUser.value(forKey: UPDATEPROFILE) != nil) {
                let complited = loggdenUser.value(forKey: UPDATEPROFILE) as! Int
                if complited == 1 {
                    viewHeaderBanner.height = 50
                    hedlinheight.constant = 50
                }
                else {
                    viewHeaderBanner.height = 0
                }
            }
            else {
                viewhedline.isHidden = true
                 viewHeaderBanner.height = 0
            }
        }
        getVersion()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblFeed.layoutSubviews()
        UIView.performWithoutAnimation {
            tblFeed.beginUpdates()
            tblFeed.endUpdates()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblFeed.layoutSubviews()
        UIView.performWithoutAnimation {
            tblFeed.beginUpdates()
            tblFeed.endUpdates()
        }
    }
    
    
    func getVersion() {
        let parameters = ["app_version_android":"1.0.0",
                          "app_version_ios":versionNumber]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: GETAPPVERSION, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: VersionResponsModel?) in
            if sucess {
                let mysucess = response?.success
                if mysucess! {
                    let data = response?.data
                    let IOS = data?.ios
                    let SucessVersion = IOS?.success
                    if SucessVersion == true {
                        let uiAlert = UIAlertController(title: "FriendzPoint", message: "Your Application Update is Available", preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            UIApplication.shared.openURL(NSURL(string: "https://apps.apple.com/in/app/friendzpoint/id1479401734")! as URL)
                            self.dismiss(animated: true, completion: nil)
                        }))
                        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                        }))
                    }
                }
            }
        }
    }
    
    internal func webViewDidFinishLoad(_ webView: WKWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
    }
    
    @objc func refresh(sender:AnyObject) {
        timeline_last_first_id = arrFeed[0].id
        timeline_Type_top_bottom = "Top"
        getFeed(strPage: "1")
    }
    
    func getProfileDetails() {
        let strUsername = loggdenUser.value(forKey: USERNAME)as! String
        strFcm = loggdenUser.value(forKey: FCMTOKEN)as! String
        let parameters = ["username":strUsername,
                          "device_token":strFcm,
                          "device_type":"ios"]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: MYPROFILEDETAILS, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: MyprofileResponseModel?) in
            if sucess {
            }
        }
    }
    
    
    
    func setDefault() {
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        tblFeed.register(UINib(nibName: "AdtblCell", bundle: nil), forCellReuseIdentifier: "AdtblCell")
        tblFeed.register(UINib(nibName: "ImgcellTimeline", bundle: nil), forCellReuseIdentifier: "ImgcellTimeline")
        tblFeed.register(UINib(nibName: "MultiImgcellTimeline", bundle: nil), forCellReuseIdentifier: "MultiImgcellTimeline")
        tblFeed.register(UINib(nibName: "TxtcellTimeline", bundle: nil), forCellReuseIdentifier: "TxtcellTimeline")
        tblFeed.register(UINib(nibName: "YoutubeVideoPlaycell", bundle: nil), forCellReuseIdentifier: "YoutubeVideoPlaycell")
        tblFeed.register(UINib(nibName: "MetacellTimeline", bundle: nil), forCellReuseIdentifier: "MetacellTimeline")
        tblFeed.register(UINib(nibName: "VideocellTimeline", bundle: nil), forCellReuseIdentifier: "VideocellTimeline")
        if UIScreen.main.bounds.width == 320 {
            bottomConstraint.constant = -5
            trailingconstraint.constant = 10
        }
       
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.GetCreatedPost), name: NSNotification.Name(rawValue: "PostCreat"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.editPost), name: NSNotification.Name(rawValue: "editpost"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appEnteredFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.notificationSingaleDashboard), name: NSNotification.Name(rawValue: "notificationSingaleDashboard"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.notificationMyFeedBackSingale), name: NSNotification.Name(rawValue: "notificationMyFeedBackSingale"), object: nil)
        
        
        refreshControl.addTarget(self, action: #selector(NewsfeedViewController.refresh), for: UIControl.Event.valueChanged)
        tblFeed.addSubview(refreshControl)
        
       
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
            
            if UIScreen.main.bounds.width == 320 {
                
            } else if UIScreen.main.bounds.width == 414 {
                gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: gridentView.bounds.size.height)
            }
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
            self.lblbadge.badge(text: String(count))
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.BadgeCleare), name: NSNotification.Name(rawValue: "BadgeCleare"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.UserBlock), name: NSNotification.Name(rawValue: "UserBlock"), object: nil)
        
        firstTime()
    }
    
    @objc func UserBlock(_ notification: NSNotification) {
        firstTime()
    }
    
    @objc func BadgeCleare(_ notification: NSNotification) {
        self.lblbadge.badge(text: nil)
    }
    
    @objc func TimelineReload(_ notification: NSNotification) {
        tblFeed.scrollToTop()
    }
    
    @objc func CommentCountSet(_ notification: NSNotification) {
        let postid = notification.object as! Int
        self.arrFeed = self.arrFeed.map
            {
                var mutableBook = $0
                if $0.id == postid
                {
                    self.tblFeed.beginUpdates()
                    let value = mutableBook.comments_count
                    let coment = value + 1
                    mutableBook.comments_count = coment
                    self.tblFeed.endUpdates()
                }
                return mutableBook
        }
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
        self.arrFeed = self.arrFeed.map
        {
            var mutableBook = $0
            if $0.id == self.Postime_id
            {
               self.tblFeed.beginUpdates()
               mutableBook.description = strDescriptionedit
               self.tblFeed.endUpdates()
            }
            return mutableBook
        }
    }
    
    @objc func GetCreatedPost(_ notification: NSNotification) {
        timeline_last_first_id = arrFeed[0].id
        timeline_Type_top_bottom = "Top"
        getFeed(strPage: "1")
    }
    
    @objc func notificationSingaleDashboard(_ notification: NSNotification) {
        dicValue = notification.object as! NSDictionary
        let obj = storyboard?.instantiateViewController(withIdentifier: "CommentsViewControllers")as! CommentsViewControllers
        obj.strCommentImage = "strCommentImage"
        obj.dicImg = dicValue
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @objc func notificationMyFeedBackSingale(_ notification: NSNotification) {
        index = dicValue.value(forKey: "index") as! Int
        let tkImageVC = TKImageShowing()
        tkImageVC.currentIndex = index
        tkImageVC.images = arrSingaleImg.toTKImageSource()
        present(tkImageVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
        
        
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
        wc.callSimplewebservice(url: SHOWFEED, parameters: [:], headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in
//            print("response:",response.re)
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    self.arrFeed = response!.data!
                    self.totalEntries = self.arrFeed.count
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrFeed.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                        self.tblFeed.reloadData()
                    }
                }
                else {
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrFeed.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
            }
            else {
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
                if self.arrFeed.count == 0 {
                    self.foundView.isHidden = false
                }
                else {
                    self.foundView.isHidden = true
                }
            }
        }
    }
   
    
    func getFeed(strPage : String) {
        if timeline_Type_top_bottom == "Top" {
            let parameters = ["timeline_last_post_id": timeline_last_first_id,
                              "timeline_type":timeline_Type_top_bottom] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            wc.callSimplewebservice(url: SHOWFEED, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in
                print("response:",response)
                if sucess {
                    let sucessMy = response?.success
                    if sucessMy! {
                        let arr_dict  = response?.data
                        for i in 0..<arr_dict!.count
                        {
                            self.arrFeed.insert(arr_dict![i], at: 0)
                            self.tblFeed.beginUpdates()
                            self.tblFeed.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                            self.spinner.stopAnimating()
                            self.tblFeed.tableFooterView?.isHidden = true
                            self.refreshControl.endRefreshing()
                            self.loaderView.isHidden = true
                            self.activity.stopAnimating()
                            self.tblFeed.endUpdates()
                        }
                    }
                    else {
                        self.refreshControl.endRefreshing()
                        self.spinner.stopAnimating()
                        self.tblFeed.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                    }
                }
                else {
                    self.refreshControl.endRefreshing()
                    self.spinner.stopAnimating()
                    self.tblFeed.tableFooterView?.isHidden = true
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
            }
        }
        else {
            let parameters = ["timeline_last_post_id": timeline_last_first_id,
                              "timeline_type":timeline_Type_top_bottom] as [String : Any]
            
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            wc.callSimplewebservice(url: SHOWFEED, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in
                 print("response:",response)
                if sucess {
                    let sucessMy = response?.success
                    if sucessMy! {
                        let arr_dict  = response?.data
                        for i in 0..<arr_dict!.count
                        {
                            self.arrFeed.append(arr_dict![i])
                            self.totalEntries = self.arrFeed.count
                            self.spinner.stopAnimating()
                            self.tblFeed.tableFooterView?.isHidden = true
                            self.loaderView.isHidden = true
                            self.activity.stopAnimating()
                            self.isNewDataLoading = false
                            if self.arrFeed.count == 0 {
                                self.foundView.isHidden = false
                            }
                            else {
                                self.foundView.isHidden = true
                            }
                        }
                        self.tblFeed.reloadData()
                    }
                    else {
                        self.spinner.stopAnimating()
                        self.tblFeed.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrFeed.count == 0 {
                            self.foundView.isHidden = false
                        }
                        else {
                            self.foundView.isHidden = true
                        }
                    }
                }
                else {
                    self.spinner.stopAnimating()
                    self.tblFeed.tableFooterView?.isHidden = true
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrFeed.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
            }
        }
    }
    
    func getHashtagPost(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "HashtagSearchTimelineController")as! HashtagSearchTimelineController
        obj.hashtagpost = hashtagpost
        self.navigationController?.pushViewController(obj, animated: false)
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
    
    @IBAction func btnfloatAction(_ sender: UIButton) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = storyboard?.instantiateViewController(withIdentifier: "PostViewController")as! PostViewController
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

//MARK: - tableview method
extension NewsfeedViewController: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let typeFeed = arrFeed[indexPath.row].type
        switch typeFeed {
        case "image":
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "ImgcellTimeline", for: indexPath) as! ImgcellTimeline
            arrImages = arrFeed[indexPath.row].images
//            cell.imgpostHeight.constant = 333
            for item in arrImages {
                let source_url = item
                imageChangedAtCell(cell, image: source_url)
                break
            }
            cell.arrSingaleImage = arrFeed[indexPath.row]
            let name = arrFeed[indexPath.row].users_name
            cell.lblDetails.handleHashtagTap { hashtag in
                self.hashtagpost = hashtag
                self.getHashtagPost()
            }
            let selectedUsername = arrFeed[indexPath.row].username
            cell.btnSingaleImg.addTarget(self, action: #selector(NewsfeedViewController.openAction), for: UIControl.Event.touchUpInside)
            cell.btnSingaleImageMenu.addTarget(self, action: #selector(NewsfeedViewController.btnMenuAction), for: UIControl.Event.touchUpInside)
            cell.btnImgLike.addTarget(self, action: #selector(NewsfeedViewController.btnImgLikeAction), for: UIControl.Event.touchUpInside)
            cell.btnComment.addTarget(self, action: #selector(NewsfeedViewController.btnCommentAction), for: UIControl.Event.touchUpInside)
            cell.btnpostComment.addTarget(self, action: #selector(NewsfeedViewController.btnCommentPostAction), for: UIControl.Event.touchUpInside)
            cell.btnLikeImgCell.addTarget(self, action: #selector(NewsfeedViewController.btnLikeImgcellAction), for: UIControl.Event.touchUpInside)
            cell.btnProImgClick.addTarget(self, action: #selector(NewsfeedViewController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.dislike.addTarget(self, action: #selector(NewsfeedViewController.btndislikeAction), for: UIControl.Event.touchUpInside)
            cell.dislikeCount.addTarget(self, action: #selector(NewsfeedViewController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
            let shared_person_name = arrFeed[indexPath.row].shared_person_name
            let shared_username = arrFeed[indexPath.row].shared_username
            if shared_person_name.count == 0 {
                arrUserTag = arrFeed[indexPath.row].users_tagged
                if arrUserTag.count == 1 {
                    let strName = arrUserTag[0].name
                    tagFirstUsername = arrUserTag[0].username
                    
                    let string = "\(name) with \(strName)"
                    let nsString = string as NSString
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    
                    let fullAttributedString = NSAttributedString(string:string, attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                        ])
                    cell.lblSingaleTitle.attributedText = fullAttributedString;
                    let rangeMY = nsString.range(of: name)
                    let rangeTC = nsString.range(of: strName)
                    
                    let MyLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]
                    
                    let ppLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]
                    
                    cell.lblSingaleTitle.activeLinkAttributes = MyLinkAttributes
                    cell.lblSingaleTitle.linkAttributes = ppLinkAttributes
                    cell.lblSingaleTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                    cell.lblSingaleTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                    cell.lblSingaleTitle.textColor = UIColor.black;
                    cell.lblSingaleTitle.delegate = self;
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
                    
                    let countOther = arrUserTag.count - 1
                    let strCount = String(countOther)
                    let FinalCount = strCount + " others."
                    
                    let strTC = strName
                    let strPP = FinalCount
                    
                    let string = "\(name) with \(strTC) and \(strPP)"
                    let nsString = string as NSString
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    
                    let fullAttributedString = NSAttributedString(string:string, attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                        ])
                    cell.lblSingaleTitle.attributedText = fullAttributedString;
                    
                    let rangeMY = nsString.range(of: name)
                    let rangeTC = nsString.range(of: strTC)
                    let rangePP = nsString.range(of: strPP)
                    
                    let MyLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]
                    
                    let ppLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]
                    let ppActiveLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]
                    
                    cell.lblSingaleTitle.activeLinkAttributes = MyLinkAttributes
                    cell.lblSingaleTitle.activeLinkAttributes = ppActiveLinkAttributes
                    cell.lblSingaleTitle.linkAttributes = ppLinkAttributes
                    cell.lblSingaleTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                    cell.lblSingaleTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                    cell.lblSingaleTitle.addLink(toAddress: ["Others":arrUserTag], with: rangePP)
                    cell.lblSingaleTitle.textColor = UIColor.black;
                    cell.lblSingaleTitle.delegate = self;
                }
                else {
                    let string = "\(name)"
                    let nsString = string as NSString
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    
                    let fullAttributedString = NSAttributedString(string:string, attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                        ])
                    cell.lblSingaleTitle.attributedText = fullAttributedString;
                    
                    let rangeMY = nsString.range(of: name)
                    
                    let ppLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]
                    
                    cell.lblSingaleTitle.linkAttributes = ppLinkAttributes
                    cell.lblSingaleTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                    cell.lblSingaleTitle.textColor = UIColor.black;
                    cell.lblSingaleTitle.delegate = self;
                }
            }
            else {
                let string = "\(name) shared \(shared_person_name) 's post"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblSingaleTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: shared_person_name)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                cell.lblSingaleTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblSingaleTitle.linkAttributes = ppLinkAttributes
                cell.lblSingaleTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblSingaleTitle.addLink(toPhoneNumber: shared_username, with: rangeTC)
                cell.lblSingaleTitle.textColor = UIColor.black;
                cell.lblSingaleTitle.delegate = self;
            }
            return cell
        case "multi_image" :
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "MultiImgcellTimeline", for: indexPath) as! MultiImgcellTimeline
            cell.arrMultiImage = arrFeed[indexPath.row]
            cell.collectionImage.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
            cell.collectionImage.delegate = self
            cell.collectionImage.dataSource = self
            cell.collectionImage.tag = 1001
            cell.collectionImage.layoutIfNeeded()
            cell.collectionImage.reloadData()
            self.arrMultiVala.add(self.arrFeed[indexPath.row])
            let name = arrFeed[indexPath.row].users_name
            let selectedUsername = arrFeed[indexPath.row].username
            let shared_username = arrFeed[indexPath.row].shared_username
            let shared_person_name = arrFeed[indexPath.row].shared_person_name
            arrUserTag = arrFeed[indexPath.row].users_tagged
        if shared_person_name.count == 0 {
            if arrUserTag.count == 1 {
                let strName = arrUserTag[0].name
                tagFirstUsername = arrUserTag[0].username
                
                let string = "\(name) with \(strName)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: strName)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
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
                
                let countOther = arrUserTag.count - 1
                let strCount = String(countOther)
                let FinalCount = strCount + " others."
                
                let strTC = strName
                let strPP = FinalCount
                
                let string = "\(name) with \(strTC) and \(strPP)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: strTC)
                let rangePP = nsString.range(of: strPP)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                let ppActiveLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.activeLinkAttributes = ppActiveLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                cell.lblTitle.addLink(toAddress: ["Others":arrUserTag], with: rangePP)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
            }
            else {
                let string = "\(name)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
            }
        }
             else {
                let string = "\(name) shared \(shared_person_name) 's post"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: shared_person_name)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: shared_username, with: rangeTC)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
            }
            arrMultiImage = arrFeed[indexPath.row].images
            if arrMultiImage.count == 2 {
                if UIScreen.main.bounds.width == 320
                {
                    cell.collectionHeight.constant = 160
                    let padding: CGFloat = 1
                    let screenWidth = UIScreen.main.bounds.width - padding
                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0
                    cell.collectionImage.collectionViewLayout = layout
                }
                else if UIScreen.main.bounds.width == 414
                {
                    cell.collectionHeight.constant = 210
                    let padding: CGFloat = 1
                    let screenWidth = UIScreen.main.bounds.width - padding
                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0
                    cell.collectionImage.collectionViewLayout = layout
                }
                else
                {
                    cell.collectionHeight.constant = 190
                    let padding: CGFloat = 1
                    let screenWidth = UIScreen.main.bounds.width - padding
                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0
                    cell.collectionImage.collectionViewLayout = layout
                }
            }
            else if arrMultiImage.count == 3
            {
                if UIScreen.main.bounds.width == 320
                {
                    cell.collectionHeight.constant = 230
                    let flowLayout = SquareFlowLayout()
                    flowLayout.flowDelegate = self
                    cell.collectionImage.collectionViewLayout = flowLayout
                }
                else if UIScreen.main.bounds.width == 414
                {
                    cell.collectionHeight.constant = 280
                    let flowLayout = SquareFlowLayout()
                    flowLayout.flowDelegate = self
                    cell.collectionImage.collectionViewLayout = flowLayout
                }
                else
                {
                    cell.collectionHeight.constant = 255
                    let flowLayout = SquareFlowLayout()
                    flowLayout.flowDelegate = self
                    cell.collectionImage.collectionViewLayout = flowLayout
                }
            }
            else if arrMultiImage.count == 4 {
                if UIScreen.main.bounds.width == 320
                {
                    cell.collectionHeight.constant = 320
                    let padding: CGFloat = 1
                    let screenWidth = UIScreen.main.bounds.width - padding
                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0
                    cell.collectionImage.collectionViewLayout = layout
                }
                else if UIScreen.main.bounds.width == 414
                {
                    cell.collectionHeight.constant = 420
                    let padding: CGFloat = 1
                    let screenWidth = UIScreen.main.bounds.width - padding
                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0
                    cell.collectionImage.collectionViewLayout = layout
                }
                else
                {
                    cell.collectionHeight.constant = 375
                    let padding: CGFloat = 1
                    let screenWidth = UIScreen.main.bounds.width - padding
                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
                    layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0
                    cell.collectionImage.collectionViewLayout = layout
                }
            }
            else if arrMultiImage.count == 5
            {
                if UIScreen.main.bounds.width == 320
                {
                    cell.collectionHeight.constant = 320
                    let flowLayout = SquareFlowLayout()
                    flowLayout.flowDelegate = self
                    cell.collectionImage.collectionViewLayout = flowLayout
                }
                else if UIScreen.main.bounds.width == 414
                {
                    cell.collectionHeight.constant = 415
                    let flowLayout = SquareFlowLayout()
                    flowLayout.flowDelegate = self
                    cell.collectionImage.collectionViewLayout = flowLayout
                }
                else
                {
                    cell.collectionHeight.constant = 375
                    let flowLayout = SquareFlowLayout()
                    flowLayout.flowDelegate = self
                    cell.collectionImage.collectionViewLayout = flowLayout
                }
            }
                
            else if arrMultiImage.count >= 6
            {
                if UIScreen.main.bounds.width == 320
                {
                    selectedIndex = 5
                    let flowLayout = SquareFlowLayout()
                    flowLayout.flowDelegate = self
                    cell.collectionImage.collectionViewLayout = flowLayout
                }
                else if UIScreen.main.bounds.width == 414
                {
                    selectedIndex = 5
                    cell.collectionHeight.constant = 415
                    let flowLayout = SquareFlowLayout()
                    flowLayout.flowDelegate = self
                    cell.collectionImage.collectionViewLayout = flowLayout
                }
                else
                {
                    selectedIndex = 5
                    cell.collectionHeight.constant = 375
                    let flowLayout = SquareFlowLayout()
                    flowLayout.flowDelegate = self
                    cell.collectionImage.collectionViewLayout = flowLayout
                }
            }
            cell.lblDescrip.handleHashtagTap { hashtag in
                self.hashtagpost = hashtag
                self.getHashtagPost()
            }
            cell.btnLikeCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllLikeMultiCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllCommentMultiCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentMulticell.addTarget(self, action: #selector(NewsfeedViewController.btnCommentMultiCellAction), for: UIControl.Event.touchUpInside)
            cell.btnLikeMulticell.addTarget(self, action: #selector(NewsfeedViewController.btnLikeMulticellAction), for: UIControl.Event.touchUpInside)
            cell.btnMultiImgmenu.addTarget(self, action: #selector(NewsfeedViewController.btnMenuAction), for: UIControl.Event.touchUpInside)
            cell.btnMultiImagePass.addTarget(self, action: #selector(NewsfeedViewController.btnImgPassAction), for: UIControl.Event.touchUpInside)
            cell.btnMultiimgProfile.addTarget(self, action: #selector(NewsfeedViewController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.btndislike.addTarget(self, action: #selector(NewsfeedViewController.btndislikeMultiAction), for: UIControl.Event.touchUpInside)
            cell.btnDislikeCount.addTarget(self, action: #selector(NewsfeedViewController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
           
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            return cell
        case "video":
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "VideocellTimeline", for: indexPath) as! VideocellTimeline
            cell.arrvideo = arrFeed[indexPath.row]
            
            arrImages = arrFeed[indexPath.row].images
            for item in arrImages {
                cell.configureCell(imageUrl: arrFeed[indexPath.row].video_poster, description: "", videoUrl: item)
            }
            let name = arrFeed[indexPath.row].users_name
            let selectedUsername = arrFeed[indexPath.row].username
            cell.lblDesc.handleHashtagTap { hashtag in
                self.hashtagpost = hashtag
                self.getHashtagPost()
            }

            arrUserTag = arrFeed[indexPath.row].users_tagged
            let shared_username = arrFeed[indexPath.row].shared_username
            let shared_person_name = arrFeed[indexPath.row].shared_person_name
            if shared_person_name.count == 0 {
                if arrUserTag.count == 1 {
                    let strName = arrUserTag[0].name
                    tagFirstUsername = arrUserTag[0].username

                    let string = "\(name) with \(strName)"
                    let nsString = string as NSString

                    let paragraphStyle = NSMutableParagraphStyle()

                    let fullAttributedString = NSAttributedString(string:string, attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                    cell.lblTitle.attributedText = fullAttributedString;

                    let rangeMY = nsString.range(of: name)
                    let rangeTC = nsString.range(of: strName)

                    let MyLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]

                    let ppLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]

                    cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                    cell.lblTitle.linkAttributes = ppLinkAttributes
                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                    cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                    cell.lblTitle.textColor = UIColor.black;
                    cell.lblTitle.delegate = self;
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

                    let countOther = arrUserTag.count - 1
                    let strCount = String(countOther)
                    let FinalCount = strCount + " others."

                    let strTC = strName
                    let strPP = FinalCount

                    let string = "\(name) with \(strTC) and \(strPP)"
                    let nsString = string as NSString

                    let paragraphStyle = NSMutableParagraphStyle()

                    let fullAttributedString = NSAttributedString(string:string, attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                    cell.lblTitle.attributedText = fullAttributedString;

                    let rangeMY = nsString.range(of: name)
                    let rangeTC = nsString.range(of: strTC)
                    let rangePP = nsString.range(of: strPP)

                    let MyLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]

                    let ppLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]
                    let ppActiveLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]

                    cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                    cell.lblTitle.activeLinkAttributes = ppActiveLinkAttributes
                    cell.lblTitle.linkAttributes = ppLinkAttributes
                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                    cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                    cell.lblTitle.addLink(toAddress: ["Others":arrUserTag], with: rangePP)
                    cell.lblTitle.textColor = UIColor.black;
                    cell.lblTitle.delegate = self;
                }
                else {
                    let string = "\(name)"
                    let nsString = string as NSString

                    let paragraphStyle = NSMutableParagraphStyle()

                    let fullAttributedString = NSAttributedString(string:string, attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                        NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                    cell.lblTitle.attributedText = fullAttributedString;

                    let rangeMY = nsString.range(of: name)

                    let ppLinkAttributes: [String: Any] = [
                        NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                        NSAttributedString.Key.underlineStyle.rawValue: false,
                    ]

                    cell.lblTitle.linkAttributes = ppLinkAttributes
                    cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                    cell.lblTitle.textColor = UIColor.black;
                    cell.lblTitle.delegate = self;
                }
            }
            else {
                let string = "\(name) shared \(shared_person_name) 's post"
                let nsString = string as NSString

                let paragraphStyle = NSMutableParagraphStyle()

                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                ])
                cell.lblTitle.attributedText = fullAttributedString;

                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: shared_person_name)

                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]

                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: shared_username, with: rangeTC)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
            }

            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            cell.btnLikeCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllLikeTxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btncommentcount.addTarget(self, action: #selector(NewsfeedViewController.btnAllCommenttxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentVideoCell.addTarget(self, action: #selector(NewsfeedViewController.btnCommenttxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btnLikeVideoCell.addTarget(self, action: #selector(NewsfeedViewController.btnLiketxtcellAction), for: UIControl.Event.touchUpInside)
            cell.btnVideoMenu.addTarget(self, action: #selector(NewsfeedViewController.btnMenuAction), for: UIControl.Event.touchUpInside)
            cell.btnVideoprofile.addTarget(self, action: #selector(NewsfeedViewController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.btndislike.addTarget(self, action: #selector(NewsfeedViewController.btndislikeTxtAction), for: UIControl.Event.touchUpInside)
            cell.btndislikeCount.addTarget(self, action: #selector(NewsfeedViewController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
            
            return cell
//            let cell = tblFeed.dequeueReusableCell(withIdentifier: "VideocellTimeline", for: indexPath) as! VideocellTimeline
////            cell.arrvideo = arrFeed[indexPath.row]
//            print("video_poster:",arrFeed[indexPath.row].video_poster)
//            print("images:",arrFeed[indexPath.row].images)
//            arrImages = arrFeed[indexPath.row].images
//            for item in arrImages {
//
//                cell.configureCell(imageUrl: arrFeed[indexPath.row].video_poster, description: "", videoUrl: item)
//            }
////            cell.configureCell(imageUrl:arrFeed[indexPath.row].video_poster , description: "image", videoUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
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
//                    ])
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
//                    ])
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
//                    ])
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
//                ])
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
//            cell.btnLikeCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllLikeTxtCellAction), for: UIControl.Event.touchUpInside)
//            cell.btncommentcount.addTarget(self, action: #selector(NewsfeedViewController.btnAllCommenttxtCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnCommentVideoCell.addTarget(self, action: #selector(NewsfeedViewController.btnCommenttxtCellAction), for: UIControl.Event.touchUpInside)
//            cell.btnLikeVideoCell.addTarget(self, action: #selector(NewsfeedViewController.btnLiketxtcellAction), for: UIControl.Event.touchUpInside)
//            cell.btnVideoMenu.addTarget(self, action: #selector(NewsfeedViewController.btnMenuAction), for: UIControl.Event.touchUpInside)
//            cell.btnVideoprofile.addTarget(self, action: #selector(NewsfeedViewController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
//            cell.btndislike.addTarget(self, action: #selector(NewsfeedViewController.btndislikeTxtAction), for: UIControl.Event.touchUpInside)
//            cell.btndislikeCount.addTarget(self, action: #selector(NewsfeedViewController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
//
//            return cell
        case "text":
             let cell = tblFeed.dequeueReusableCell(withIdentifier: "TxtcellTimeline", for: indexPath) as! TxtcellTimeline
            cell.arrText = arrFeed[indexPath.row]
            let name = arrFeed[indexPath.row].users_name
            let selectedUsername = arrFeed[indexPath.row].username
            cell.lblDesc.handleHashtagTap { hashtag in
                self.hashtagpost = hashtag
                self.getHashtagPost()
            }
             
             arrUserTag = arrFeed[indexPath.row].users_tagged
             let shared_username = arrFeed[indexPath.row].shared_username
             let shared_person_name = arrFeed[indexPath.row].shared_person_name
            if shared_person_name.count == 0 {
             if arrUserTag.count == 1 {
                let strName = arrUserTag[0].name
                tagFirstUsername = arrUserTag[0].username
                
                let string = "\(name) with \(strName)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: strName)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
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
                
                let countOther = arrUserTag.count - 1
                let strCount = String(countOther)
                let FinalCount = strCount + " others."
                
                let strTC = strName
                let strPP = FinalCount
                
                let string = "\(name) with \(strTC) and \(strPP)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: strTC)
                let rangePP = nsString.range(of: strPP)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                let ppActiveLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.activeLinkAttributes = ppActiveLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                cell.lblTitle.addLink(toAddress: ["Others":arrUserTag], with: rangePP)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
             }
             else {
                let string = "\(name)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
             }
             }
            else {
                let string = "\(name) shared \(shared_person_name) 's post"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: shared_person_name)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: shared_username, with: rangeTC)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
             }
             
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            cell.btnLikeCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllLikeTxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllCommenttxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommenttxtCell.addTarget(self, action: #selector(NewsfeedViewController.btnCommenttxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btnLiketxtCell.addTarget(self, action: #selector(NewsfeedViewController.btnLiketxtcellAction), for: UIControl.Event.touchUpInside)
            cell.btntxtMenu.addTarget(self, action: #selector(NewsfeedViewController.btnMenuAction), for: UIControl.Event.touchUpInside)
             cell.btntxtProfile.addTarget(self, action: #selector(NewsfeedViewController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
             cell.btndislike.addTarget(self, action: #selector(NewsfeedViewController.btndislikeTxtAction), for: UIControl.Event.touchUpInside)
             cell.btnDislikeCount.addTarget(self, action: #selector(NewsfeedViewController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
            
            return cell
        case "url":
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "YoutubeVideoPlaycell", for: indexPath) as! YoutubeVideoPlaycell
            cell.arrYoutube = arrFeed[indexPath.row]
            let name = arrFeed[indexPath.row].users_name
            let selectedUsername = arrFeed[indexPath.row].username
            cell.lblDesc.handleHashtagTap { hashtag in
                self.hashtagpost = hashtag
                self.getHashtagPost()
            }
            
            arrUserTag = arrFeed[indexPath.row].users_tagged
            let shared_username = arrFeed[indexPath.row].shared_username
            let shared_person_name = arrFeed[indexPath.row].shared_person_name
            if shared_person_name.count == 0 {
            if arrUserTag.count == 1 {
                let strName = arrUserTag[0].name
                tagFirstUsername = arrUserTag[0].username
                
                let string = "\(name) with \(strName)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: strName)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
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
                
                let countOther = arrUserTag.count - 1
                let strCount = String(countOther)
                let FinalCount = strCount + " others."
                
                let strTC = strName
                let strPP = FinalCount
                
                let string = "\(name) with \(strTC) and \(strPP)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: strTC)
                let rangePP = nsString.range(of: strPP)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                let ppActiveLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.activeLinkAttributes = ppActiveLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                cell.lblTitle.addLink(toAddress: ["Others":arrUserTag], with: rangePP)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
            }
            else {
                let string = "\(name)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
            }
            }
            else {
                let string = "\(name) shared \(shared_person_name) 's post"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: shared_person_name)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: shared_username, with: rangeTC)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
            }
            
            cell.btnLikeCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllLikeVideoCellAction), for: UIControl.Event.touchUpInside)
            cell.btncommentcount.addTarget(self, action: #selector(NewsfeedViewController.btnAllCommentVideoCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentVideoCell.addTarget(self, action: #selector(NewsfeedViewController.btnCommentVideoCellAction), for: UIControl.Event.touchUpInside)
            cell.btnLikeVideoCell.addTarget(self, action: #selector(NewsfeedViewController.btnLikevideocellAction), for: UIControl.Event.touchUpInside)
            cell.btnVideoMenu.addTarget(self, action: #selector(NewsfeedViewController.btnMenuAction), for: UIControl.Event.touchUpInside)
            cell.btnVideoprofile.addTarget(self, action: #selector(NewsfeedViewController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.btndislike.addTarget(self, action: #selector(NewsfeedViewController.btndislikeVideoAction), for: UIControl.Event.touchUpInside)
            cell.btndislikeCount.addTarget(self, action: #selector(NewsfeedViewController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
            
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            return cell
        case "meta":
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "MetacellTimeline", for: indexPath) as! MetacellTimeline
            cell.viewMeta.layer.cornerRadius = 5
            cell.viewTop.constant = 0
            cell.lbltop.constant = 0
            cell.arrMeta = arrFeed[indexPath.row]
            let name = arrFeed[indexPath.row].users_name
            let selectedUsername = arrFeed[indexPath.row].username
            arrUserTag = arrFeed[indexPath.row].users_tagged
            let shared_username = arrFeed[indexPath.row].shared_username
            let shared_person_name = arrFeed[indexPath.row].shared_person_name
            if shared_person_name.count == 0 {
            if arrUserTag.count == 1 {
                let strName = arrUserTag[0].name
                tagFirstUsername = arrUserTag[0].username
                
                let string = "\(name) with \(strName)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: strName)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
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
                
                let countOther = arrUserTag.count - 1
                let strCount = String(countOther)
                let FinalCount = strCount + " others."
                let strTC = strName
                let strPP = FinalCount
                
                let string = "\(name) with \(strTC) and \(strPP)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: strTC)
                let rangePP = nsString.range(of: strPP)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                let ppActiveLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.activeLinkAttributes = ppActiveLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: tagFirstUsername, with: rangeTC)
                cell.lblTitle.addLink(toAddress: ["Others":arrUserTag], with: rangePP)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
            }
            else {
                let string = "\(name)"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
            }
            }
            else {
                let string = "\(name) shared \(shared_person_name) 's post"
                let nsString = string as NSString
                
                let paragraphStyle = NSMutableParagraphStyle()
                
                let fullAttributedString = NSAttributedString(string:string, attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
                    ])
                cell.lblTitle.attributedText = fullAttributedString;
                
                let rangeMY = nsString.range(of: name)
                let rangeTC = nsString.range(of: shared_person_name)
                
                let MyLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                
                let ppLinkAttributes: [String: Any] = [
                    NSAttributedString.Key.foregroundColor.rawValue: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1).cgColor,
                    NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
                cell.lblTitle.activeLinkAttributes = MyLinkAttributes
                cell.lblTitle.linkAttributes = ppLinkAttributes
                cell.lblTitle.addLink(toPhoneNumber: selectedUsername, with: rangeMY)
                cell.lblTitle.addLink(toPhoneNumber: shared_username, with: rangeTC)
                cell.lblTitle.textColor = UIColor.black;
                cell.lblTitle.delegate = self;
            }
            
            cell.btnLikeCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllLikeMetaCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllCommentMetaCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentMetaCell.addTarget(self, action: #selector(NewsfeedViewController.btnCommentMetaCellAction), for: UIControl.Event.touchUpInside)
            cell.viewMeta.clipsToBounds = true
            cell.btnMetaClick.addTarget(self, action: #selector(NewsfeedViewController.btnMetaAction), for: .touchUpInside)
            cell.btnMetaMenu.addTarget(self, action: #selector(NewsfeedViewController.btnMenuAction), for: UIControl.Event.touchUpInside)
            cell.btnLikeMetaCell.addTarget(self, action: #selector(NewsfeedViewController.btnLikeMetacellAction), for: UIControl.Event.touchUpInside)
            cell.btnMetaProfile.addTarget(self, action: #selector(NewsfeedViewController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.btndislike.addTarget(self, action: #selector(NewsfeedViewController.btndislikeMetaAction), for: UIControl.Event.touchUpInside)
            cell.btndislikeCount.addTarget(self, action: #selector(NewsfeedViewController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
           
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            return cell
        
        default:
            print("jekil")
        }
         return UITableViewCell() 
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
        
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }
    }
    
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tblFeed)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tblFeed, appEnteredFromBackground: true)
    }
    
    func imageChangedAtCell(_ cell: ImgcellTimeline, image: String?) {
        let cellFrame = cell.frame.size
        url = URL(string: image!)
        cell.imgPost.sd_setImage(with: url, placeholderImage:UIImage(named: "Placeholder") , options: [], completed: { (theImage, error, cache, url) in
            UIView.performWithoutAnimation {
                if self.FirstTime == ""{
                    self.FirstTime = "ok"
                    self.tblFeed.beginUpdates()
                    cell.imgpostHeight.constant = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
                    self.tblFeed.endUpdates()
                }
                else{
                    cell.imgpostHeight.constant = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
                }
                
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        if offset > height - scrollView.contentSize.height {
           if !isNewDataLoading {
               spinner = UIActivityIndicatorView(style: .gray)
               spinner.startAnimating()
               spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblFeed.bounds.width, height: CGFloat(44))
               let lastIndexPath = tblFeed.lastIndexpath()
               lastIndex_id = arrFeed[lastIndexPath.row].id
               timeline_last_first_id = lastIndex_id
               timeline_Type_top_bottom = "Bottom"
//               getFeed(strPage: "\(pageCount)")
               self.tblFeed.tableFooterView = spinner
               self.tblFeed.tableFooterView?.isHidden = false
               isNewDataLoading = true
           }
        }
    }

    

    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == "action://TC" {
        }
        else if url.absoluteString == "action://PP" {
        }
        else {
        }
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        let myname = loggdenUser.value(forKey: USERNAME)as! String
        if myname == phoneNumber {
            currentTabBar?.setIndex(4)
        }
        else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "navigationLoaderpageredirection")as! navigationLoaderpageredirection
            obj.strUser = phoneNumber
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithAddress addressComponents: [AnyHashable : Any]!) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "TagPeopleTistController")as! TagPeopleTistController
        obj.arrgetTag = addressComponents
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func getAspectRatioAccordingToiPhones(cellImageFrame:CGSize,downloadedImage: UIImage)->CGFloat {
        let widthOffset = downloadedImage.size.width - cellImageFrame.width
        let widthOffsetPercentage = (widthOffset*100)/downloadedImage.size.width
        let heightOffset = (widthOffsetPercentage * downloadedImage.size.height)/100
        let effectiveHeight = downloadedImage.size.height - heightOffset
        return(effectiveHeight)
    }
    // MARK: Optional function for resize of image
    func resizeHighImage(image:UIImage)->UIImage {
        let size = image.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    
    
   
    //MARK: ______________ Meats Data
    
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error)
        }).resume()
    }
    
    func downloadImage(_ url: URL, imageView: UIImageView){
       // print("Download Started")
       // print("lastPathComponent: " + url.lastPathComponent)
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async(execute: {
                guard let data = data , error == nil else { return }
                //print(response?.suggestedFilename ?? "")
               // print("Download Finished")
                imageView.image = UIImage(data: data)
            })
        }
    }
    
   
    @objc func openAction(_ sender: UIButton) {
        print("openAction")
        arrSingaleImg.removeAll()
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! ImgcellTimeline
            let images = arrFeed[indexPath.row].images
            for item in images {
                let source_url = item
                arrSingaleImg.append(source_url)
                let tkImageVC = TKImageShowing()
               // tkImageVC.tblFeedDashboard = "tblFeedDashboard"
                tkImageVC.animatedView  = cellfeed.imgPost
               // tkImageVC.arrTimeline = arrFeed[indexPath.row]
                //  tkImageVC.currentIndex = indexPath.row
                tkImageVC.images = arrSingaleImg.toTKImageSource()
                //self.present(tkImageVC, animated: true, completion: nil)
                let naviget: UINavigationController = UINavigationController(rootViewController: tkImageVC)
                self.present(naviget, animated: true, completion: nil)
            }
        }
        
        

//       let videoURL = URL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
//        let player = AVPlayer(url: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        self.view.layer.addSublayer(playerLayer)
//        player.play()
    }
    
    
    @objc func btnImgPassAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "MultiplaePhotoViewControllerList")as! MultiplaePhotoViewControllerList
            let arrMultiImage = arrFeed[indexPath.row].images
            let tkImageVC = TKImageShowing()
          //  tkImageVC.animatedView  = arrMultiImage[indexPath.row].count
           // tkImageVC.currentIndex = indexPath.row
            tkImageVC.images = arrMultiImage.toTKImageSource()
            let naviget: UINavigationController = UINavigationController(rootViewController: tkImageVC)
            self.present(naviget, animated: true, completion: nil)
        }
    }
    
    
    
    @objc func btnWebviewAction(_ sender : UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            let strLink = arrFeed[indexPath.row].location
            guard let url = URL(string: strLink) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    
    @objc func btnMuteAction(_ sender : UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! VideocellTimeline
            if muteBool == true {
                cellfeed.btnmute.isSelected = true
                muteBool = false
                cellfeed.videoLayer.player?.isMuted = true
            }
            else {
                cellfeed.btnmute.isSelected = false
                muteBool = true
                cellfeed.videoLayer.player?.isMuted = false
            }
        }
    }
    
    
    @objc func btndislikeCountAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            post_Id = arrFeed[indexPath.row].id
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DislikeViewController") as! DislikeViewController
            obj.post_id = post_Id
            self.navigationController?.pushViewController(obj, animated: false)
        }
    }
    
    
    //MARK: - Like And Comment Action
    
    //Mark: - FirstImg
    
    @objc func btnImgLikeAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            post_Id = arrFeed[indexPath.row].id
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
            obj.post_id = post_Id
            self.navigationController?.pushViewController(obj, animated: false)
        }
    }
    
    @objc func btnCommentAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            post_Id = arrFeed[indexPath.row].id
//            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
//            obj.postDetail_id = self.post_Id
//            //self.navigationController?.pushViewController(obj, animated: true)
//            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
//            self.present(naviget, animated: true, completion: nil)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment") as! DetailsPostandComment
            obj.postId = post_Id
            obj.passappDel = "passappDel"
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
            self.present(naviget, animated: true, completion: nil)
            
            
            
        } 
    }
    
    @objc func btnCommentPostAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
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
    
    @objc func btnLikeImgcellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
                audioPlayer.play()
            } catch {
                // couldn't load file :(
            }
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! ImgcellTimeline
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.tblFeed.endUpdates()
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                } else {
                    button.isSelected = true
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnImgLike.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func btnshareImgAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! ImgcellTimeline
            post_Id = arrFeed[indexPath.row].id
            let userType = arrFeed[indexPath.row].users_type
            if userType == "user" {
                let parameters = ["post_id":post_Id] as [String : Any]
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept" : ACCEPT,
                                            "Authorization":BEARERTOKEN]
                wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
                    if sucess {
                        let shareSucess = response?.success
                        let message = response?.message
                        if shareSucess! {
                            if message == "successfully shared" {
                                self.arrFeed = self.arrFeed.map{
                                    var mutableBook = $0
                                    if $0.id == self.post_Id {
                                        mutableBook.is_users_shared = 1
                                    }
                                    return mutableBook
                                }
                                //cellfeed.btnShareimgCell.setTitle("Unshare", for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                            else {
                                self.arrFeed = self.arrFeed.map{
                                    var mutableBook = $0
                                    if $0.id == self.post_Id {
                                        mutableBook.is_users_shared = 0
                                    }
                                    return mutableBook
                                }
                               // cellfeed.btnShareimgCell.setTitle("Share", for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @objc func btnImgProfileClickAction(_ sender: UIButton) {
//        if let indexPath = self.tblFeed.indexPathForView(sender) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//            let username = loggdenUser.value(forKey: USERNAME)as! String
//            let selectedUsername = arrFeed[indexPath.row].username
//            if selectedUsername == username {
//                currentTabBar?.setIndex(4)
//            }
//            else {
//                let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
//                obj.strUserName = selectedUsername
//                self.navigationController?.pushViewController(obj, animated: true)
//            }
//        }
    }
    
    
    @objc func btndislikeAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
                    audioPlayer.play()
                } catch {
                    // couldn't load file :(
                }
                let cellfeed = tblFeed.cellForRow(at: indexPath) as! ImgcellTimeline
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
                                    let likeCount = response?.dislikecount
                                    let strLikeTotal = likeCount! + " Dislike"
                                    cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
                                    self.tblFeed.beginUpdates()
                                    self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                    self.tblFeed.endUpdates()
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
                                    let likeCount = response?.dislikecount
                                    let strLikeTotal = likeCount! + " Dislike"
                                    cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
                                    self.tblFeed.beginUpdates()
                                    self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                    self.tblFeed.endUpdates()
                                }
                            }
                        }
                    } else {
                        button.isSelected = true
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
                                    let likeCount = response?.dislikecount
                                    let strLikeTotal = likeCount! + " Dislike"
                                    cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
                                    self.tblFeed.beginUpdates()
                                    self.tblFeed.endUpdates()
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
                                    let likeCount = response?.dislikecount
                                    let strLikeTotal = likeCount! + " Dislike"
                                    cellfeed.dislikeCount.setTitle(strLikeTotal, for: .normal)
                                    self.tblFeed.beginUpdates()
                                    self.tblFeed.endUpdates()
                                }
                            }
                        }
                    }
                }
            }
    }
    
    
    @objc func btndislikeMetaAction(_ sender: UIButton) {
         if let indexPath = self.tblFeed.indexPathForView(sender) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
                audioPlayer.play()
            } catch {
                // couldn't load file :(
            }
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MetacellTimeline
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.tblFeed.endUpdates()
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                } else {
                    button.isSelected = true
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func btndislikeVideoAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
                audioPlayer.play()
            } catch {
                // couldn't load file :(
            }
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! YoutubeVideoPlaycell
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.tblFeed.endUpdates()
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                } else {
                    button.isSelected = true
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btndislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func btndislikeTxtAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
                audioPlayer.play()
            } catch {
                // couldn't load file :(
            }
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! TxtcellTimeline
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.tblFeed.endUpdates()
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                } else {
                    button.isSelected = true
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func btndislikeMultiAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
                audioPlayer.play()
            } catch {
                // couldn't load file :(
            }
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MultiImgcellTimeline
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.tblFeed.endUpdates()
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                } else {
                    button.isSelected = true
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let likeCount = response?.dislikecount
                                let strLikeTotal = likeCount! + " Dislike"
                                cellfeed.btnDislikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    //MARK: - Second Text
    @objc func btnAllLikeTxtCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            post_Id = arrFeed[indexPath.row].id
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
            obj.post_id = post_Id
            self.navigationController?.pushViewController(obj, animated: false)
        }
    }
    
    @objc func btnAllCommenttxtCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
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
    
    @objc func btnCommenttxtCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
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
    
    @objc func btnLiketxtcellAction(_ sender: UIButton) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
            audioPlayer.play()
        } catch {
            // couldn't load file :(
        }
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! TxtcellTimeline
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
                else
                {
                    button.isSelected = true
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func btnshareTxtAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! TxtcellTimeline
            post_Id = arrFeed[indexPath.row].id
            let userType = arrFeed[indexPath.row].users_type
            if userType == "user" {
                let parameters = ["post_id":post_Id] as [String : Any]
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept" : ACCEPT,
                                            "Authorization":BEARERTOKEN]
                wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
                    if sucess {
                        let shareSucess = response?.success
                        if shareSucess! {
                            self.arrFeed = self.arrFeed.map{
                                var mutableBook = $0
                                if $0.id == self.post_Id {
                                    mutableBook.is_users_shared = 1
                                }
                                return mutableBook
                            }
                           // cellfeed.btnSharetxtCell.setTitle("Unshare", for: .normal)
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                        else {
                            self.arrFeed = self.arrFeed.map{
                                var mutableBook = $0
                                if $0.id == self.post_Id {
                                    mutableBook.is_users_shared = 0
                                }
                                return mutableBook
                            }
                            //cellfeed.btnSharetxtCell.setTitle("Share", for: .normal)
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Multi Image
    @objc func btnAllLikeMultiCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            post_Id = arrFeed[indexPath.row].id
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
            obj.post_id = post_Id
            self.navigationController?.pushViewController(obj, animated: false)
        }
    }
    
    @objc func btnAllCommentMultiCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
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
    
    @objc func btnCommentMultiCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
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
    
    @objc func btnLikeMulticellAction(_ sender: UIButton) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
            audioPlayer.play()
        } catch {
            // couldn't load file :(
        }
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MultiImgcellTimeline
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
                else {
                    button.isSelected = true
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func btnshareMultiAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MultiImgcellTimeline
            post_Id = arrFeed[indexPath.row].id
            let userType = arrFeed[indexPath.row].users_type
            if userType == "user" {
                let parameters = ["post_id":post_Id] as [String : Any]
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept" : ACCEPT,
                                            "Authorization":BEARERTOKEN]
                wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
                    if sucess {
                        let shareSucess = response?.success
                        if shareSucess! {
                            self.arrFeed = self.arrFeed.map{
                                var mutableBook = $0
                                if $0.id == self.post_Id {
                                    mutableBook.is_users_shared = 1
                                }
                                return mutableBook
                            }
                           // cellfeed.btnshareMultiCell.setTitle("Unshare", for: .normal)
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                        else {
                            self.arrFeed = self.arrFeed.map{
                                var mutableBook = $0
                                if $0.id == self.post_Id {
                                    mutableBook.is_users_shared = 0
                                }
                                return mutableBook
                            }
                            //cellfeed.btnshareMultiCell.setTitle("Share", for: .normal)
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Video
    @objc func btnAllLikeVideoCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            post_Id = arrFeed[indexPath.row].id
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
            obj.post_id = post_Id
            self.navigationController?.pushViewController(obj, animated: false)
        }
    }
    
    @objc func btnAllCommentVideoCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
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
    
    @objc func btnCommentVideoCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
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
    
    @objc func btnLikevideocellAction(_ sender: UIButton) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
            audioPlayer.play()
        } catch {
            // couldn't load file :(
        }
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! YoutubeVideoPlaycell
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
                else {
                    button.isSelected = true
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func btnsharevideoAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! YoutubeVideoPlaycell
            post_Id = arrFeed[indexPath.row].id
            let userType = arrFeed[indexPath.row].users_type
            if userType == "user" {
                let parameters = ["post_id":post_Id] as [String : Any]
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept" : ACCEPT,
                                            "Authorization":BEARERTOKEN]
                wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
                    if sucess {
                        let shareSucess = response?.success
                        if shareSucess! {
                            self.arrFeed = self.arrFeed.map{
                                var mutableBook = $0
                                if $0.id == self.post_Id {
                                    mutableBook.is_users_shared = 1
                                }
                                return mutableBook
                            }
                            //cellfeed.btnshareVideoCell.setTitle("Unshare", for: .normal)
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                        else {
                            self.arrFeed = self.arrFeed.map{
                                var mutableBook = $0
                                if $0.id == self.post_Id {
                                    mutableBook.is_users_shared = 0
                                }
                                return mutableBook
                            }
                            //cellfeed.btnshareVideoCell.setTitle("Share", for: .normal)
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Meta
    @objc func btnAllLikeMetaCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            post_Id = arrFeed[indexPath.row].id
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "LikeViewController") as! LikeViewController
            obj.post_id = post_Id
            self.navigationController?.pushViewController(obj, animated: false)
        }
    }
    
    @objc func btnAllCommentMetaCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
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
    
    @objc func btnCommentMetaCellAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
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
    
    @objc func btnLikeMetacellAction(_ sender: UIButton) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pianoSound as URL)
            audioPlayer.play()
        } catch {
            // couldn't load file :(
        }
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MetacellTimeline
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
                else {
                    button.isSelected = true
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
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
                                let strLikeTotal = likeCount! + " Like"
                                cellfeed.btnLikeCount.setTitle(strLikeTotal, for: .normal)
                                self.tblFeed.beginUpdates()
                                self.tblFeed.endUpdates()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func btnsharemetaAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! MetacellTimeline
            post_Id = arrFeed[indexPath.row].id
            let userType = arrFeed[indexPath.row].users_type
            if userType == "user" {
                let parameters = ["post_id":post_Id] as [String : Any]
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept" : ACCEPT,
                                            "Authorization":BEARERTOKEN]
                wc.callSimplewebservice(url: SHAREPOST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: SharePostResponseModel?) in
                    if sucess {
                        let shareSucess = response?.success
                        if shareSucess! {
                            self.arrFeed = self.arrFeed.map{
                                var mutableBook = $0
                                if $0.id == self.post_Id {
                                    mutableBook.is_users_shared = 1
                                }
                                return mutableBook
                            }
                            //cellfeed.btnShareMetaCell.setTitle("Unshare", for: .normal)
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                        else {
                            self.arrFeed = self.arrFeed.map{
                                var mutableBook = $0
                                if $0.id == self.post_Id {
                                    mutableBook.is_users_shared = 0
                                }
                                return mutableBook
                            }
                            //cellfeed.btnShareMetaCell.setTitle("Share", for: .normal)
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                    }
                }
            }
        }
    }

    
    
    //MARK: - Btn Meta Action
    @objc func btnMetaAction(_ sender: UIButton) {
         if let indexPath = self.tblFeed.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            let Metas = arrFeed[indexPath.row].description
            guard let url = URL(string: Metas) else { return }
            UIApplication.shared.open(url)
        }
    }
    
   
    //MARK: ------ btnMenuAction
    
    @objc func btnMenuAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
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
                                    self.tblFeed.beginUpdates()
                                    self.tblFeed.endUpdates()
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
                                    self.tblFeed.beginUpdates()
                                    self.tblFeed.endUpdates()
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
                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
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
                                    self.tblFeed.beginUpdates()
                                    self.tblFeed.endUpdates()
                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                        print("did dissmiss")
                                    }
                                }
                                else {
                                    self.tblFeed.beginUpdates()
                                    self.tblFeed.endUpdates()
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
                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
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
                                    self.tblFeed.beginUpdates()
                                    self.tblFeed.endUpdates()
                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                        print("did dissmiss")
                                    }
                                }
                                else {
                                    self.tblFeed.beginUpdates()
                                    self.tblFeed.endUpdates()
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
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
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
                                        AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                            print("did dissmiss")
                                        }
                                    }
                                    else {
                                        self.tblFeed.beginUpdates()
                                        self.tblFeed.endUpdates()
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
                                    AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                        print("did dissmiss")
                                    }
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PostCreat"), object: nil)
                                    self.tblFeed.scrollToTop()
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
}

//MARK: - collectionview method
extension NewsfeedViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrMultiImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
            let source_url = arrMultiImage[indexPath.row]
            url = URL(string: source_url)
            cell.imageView.sd_setImage(with: url, completed: nil)
            
            if arrMultiImage.count >= 7 {
                if selectedIndex == indexPath.row {
                    cell.transView.isHidden = false
                    let countvalue = arrMultiImage.count - 6
                    let strString = String(countvalue)
                    cell.lblCount.text = "+ " + strString
                } else {
                    cell.transView.isHidden = true
                }
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
        let tkImageVC = TKImageShowing()
        tkImageVC.animatedView  = cell!.imageView
        tkImageVC.currentIndex = indexPath.row
        tkImageVC.images = arrMultiImage.toTKImageSource()
        let naviget: UINavigationController = UINavigationController(rootViewController: tkImageVC)
        naviget.navigationController?.navigationBar.barTintColor = UIColor.black
        naviget.navigationController?.navigationBar.isTranslucent = false
        self.present(naviget, animated: true, completion: nil)
    }
}

extension NewsfeedViewController: SquareFlowLayoutDelegate {
    func shouldExpandItem(at indexPath: IndexPath) -> Bool {
        if arrMultiImage.count == 5 {
            return self.layoutValues[indexPath.row] == .normal
        }
        return self.layoutValues[indexPath.row] == .expanded
    }
}


extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font!])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
   }
}

extension UITableView {
    
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let center = view.center
        
        //The center of the view is a better point to use, but we can only use it if the view has a superview
        guard let superview = view.superview else {
            //The view we were passed does not have a valid superview.
            //Use the view's bounds.origin and convert from the view's coordinate system
            let origin = self.convert(view.bounds.origin, from: view)
            let indexPath = self.indexPathForRow(at: origin)
            return indexPath
        }
        let viewCenter = self.convert(center, from: superview)
        let indexPath = self.indexPathForRow(at: viewCenter)
        return indexPath
    }
}


////MARK: *************** Extension Date ***************

extension Date {
    func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
}


extension Set {
    
    @discardableResult mutating func insert(_ newMembers: [Set.Element]) -> [(inserted: Bool, memberAfterInsert: Set.Element)] {
        var returnArray: [(inserted: Bool, memberAfterInsert: Set.Element)] = []
        newMembers.forEach { (member) in
            returnArray.append(self.insert(member))
        }
        return returnArray
    }
}

extension UITableView {
    func lastIndexpath() -> IndexPath {
        let section = max(numberOfSections - 1, 0)
        let row = max(numberOfRows(inSection: section) - 1, 0)
        return IndexPath(row: row, section: section)
    }
}

extension UITableView{
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToTop(_ animated: Bool = true) {
        let indexPath = IndexPath(row: 0, section: 0)
        if hasRowAtIndexPath(indexPath: indexPath) {
            scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}


class ImageLoader {
    
    private static let cache = NSCache<NSString, NSData>()
    
    class func image(for url: URL, completionHandler: @escaping(_ image: UIImage?) -> ()) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
            if let data = self.cache.object(forKey: url.absoluteString as NSString) {
                DispatchQueue.main.async { completionHandler(UIImage(data: data as Data)) }
                return
            }
            
            guard let data = NSData(contentsOf: url) else {
                DispatchQueue.main.async { completionHandler(nil) }
                return
            }
            
            self.cache.setObject(data, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async { completionHandler(UIImage(data: data as Data)) }
        }
    }
    
}



//loggdenUser.removeObject(forKey: STORETIMELINE)
//if (loggdenUser.value(forKey: STORETIMELINE) != nil) {
//    decodedData = loggdenUser.value(forKey: STORETIMELINE) as! [Data]
//    print(decodedData)
//    for i in 0..<decodedData.count
//    {
//        let decoder = JSONDecoder()
//        let decoded = try? decoder.decode(MyTimelineList.self, from: decodedData[i])
//        arrFeed.append(decoded!)
//        tblFeed.reloadData()
//        loaderView.isHidden = true
//        activity.stopAnimating()
//    }
//}
//else {
//    getfirstTime()
//}
