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

class postDetailsConteroller: UIViewController,UIPopoverPresentationControllerDelegate,TTTAttributedLabelDelegate,PSHTMLViewDelegate {//UIWebViewDelegate,
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
    
//    class func instance()->UIViewController{
//        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsfeedViewController")
//        let nav = UINavigationController(rootViewController: colorController)
//        nav.navigationBar.isTranslucent = false
//        return nav
//    }
//
    
    enum CellType {
        case normal
        case expanded
    }
    
    //MARK: - VARIABLE
    var selectedIndex = Int()
    internal var TexttagTapHandler: ((String) -> ())?
    @IBOutlet weak var foundView: LargeFound!
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
    
    @IBOutlet weak var tbComment: UITableView!
    
    private let layoutValues: [CellType] = [
        .expanded, .expanded, .normal,
        .normal, .normal,.normal, .normal, .normal,
        .normal, .normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.expanded]
    var assets: [DKAsset]?
    let shotTableViewCellIdentifier = "ShotTableViewCell"
    let loadingCellTableViewCellCellIdentifier = "LoadingCellTableViewCell"
    let videos = [
        "https://v.pinimg.com/videos/720p/d5/15/78/d51578c69d36c93c6e20144e9f887c73.mp4",
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
    var muteBool = true
    var ActivityIndi = UIActivityIndicatorView()
    var arrFeed = [MyTimelineList]()
    var timelinead = [MyTimelineList]()
    var arrUserTag = [userTagpeopelListResponse]()
    var arrResults = [SearchDataResoponseModel]()
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
    var arrPostLiked = [LikesetRespons]()
    var arrPostDislked = [LikesetRespons]()
    var timeline_last_first_id = Int()
    var timeline_Type_top_bottom = String()
    var lastIndex_id = Int()
    var arrSession = NSMutableArray()
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
    var postDetail_id = Int()
    var usernamepost = String()
    var passappDel = String()
    
    
    //MARK: - Comment
    var strCommentImage = String()
    var dicImg = NSDictionary()
    var arrImage = [TKImageSource?]()
    var postId = Int()
    var arrCommented = [CommentList]()
    var arrParentComment = [ParentCommentList]()
    var parent_ID = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblFeed.rowHeight = UITableView.automaticDimension
        tblFeed.estimatedRowHeight = UITableView.automaticDimension
        getfirstTime()
        loaderView.isHidden = false
        activity.startAnimating()
        getComment(strPage : "1")
        setDefault()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    internal func webViewDidFinishLoad(_ webView: WKWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
    }
   
    func setDefault() {
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        tblFeed.register(UINib(nibName: "ImgcellTimeline", bundle: nil), forCellReuseIdentifier: "ImgcellTimeline")
        tblFeed.register(UINib(nibName: "MultiImgcellTimeline", bundle: nil), forCellReuseIdentifier: "MultiImgcellTimeline")
        tblFeed.register(UINib(nibName: "TxtcellTimeline", bundle: nil), forCellReuseIdentifier: "TxtcellTimeline")
        tblFeed.register(UINib(nibName: "YoutubeVideoPlaycell", bundle: nil), forCellReuseIdentifier: "YoutubeVideoPlaycell")
        tblFeed.register(UINib(nibName: "MetacellTimeline", bundle: nil), forCellReuseIdentifier: "MetacellTimeline")
//        if UIScreen.main.bounds.width == 320 {
//            bottomConstraint.constant = -5
//            trailingconstraint.constant = 10
//        }
        
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appEnteredFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.notificationSingaleDashboard), name: NSNotification.Name(rawValue: "notificationSingaleDashboard"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.notificationMyFeedBackSingale), name: NSNotification.Name(rawValue: "notificationMyFeedBackSingale"), object: nil)
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
            self.lblbadge.badge(text: String(count))
        }        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gridentView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gridentView.layer.addSublayer(gradientLayer)
        gridentView.addSubview(btncamera)
        gridentView.addSubview(btnNotification)
        gridentView.addSubview(lblSearch)
        gridentView.addSubview(lblbadge)
        
        if UIScreen.main.bounds.width == 320 {
            
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: gridentView.bounds.size.height)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.BadgeCleare), name: NSNotification.Name(rawValue: "BadgeCleare"), object: nil)
    }
    
    @objc func BadgeCleare(_ notification: NSNotification) {
        self.lblbadge.badge(text: nil)
    }
    @objc func TimelineReload(_ notification: NSNotification) {
        tblFeed.scrollToTop()
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
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func getfirstTime() {
        let parameters = ["post_id": postDetail_id] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: POSTBYID, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: selectedPostDetails?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let arr_dict = response?.data
                    self.arrFeed.append(arr_dict!)
                    self.tblFeed.reloadData()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
            }
        }
    }
    
    
    func getComment(strPage : String) {
        let parameters = ["post_id": postDetail_id,
                          "page":strPage] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: TIMELINE_COMMENTS, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: TimelineCommentResponseModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict = data?.data
                    self.arrCommented = arr_dict!
                    self.tbComment.reloadData()
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
        if passappDel == "passappDel" {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            loggdenUser.removeObject(forKey: POSTDETAILS)
            self.navigationController?.popViewController(animated: true)
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
extension postDetailsConteroller: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbComment {
            return arrCommented.count
        }
        return arrFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbComment {
            let cell = tbComment.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)as! commentCell
            cell.imgProfile.layer.cornerRadius = 15
            cell.imgProfile.clipsToBounds = true
            cell.viewBack.layer.cornerRadius = 5
            cell.viewBack.clipsToBounds = true
            let strComment = arrCommented[indexPath.section].description
            cell.lblComment.text = strComment
            cell.lblname.text = arrCommented[indexPath.section].user_name
            cell.btnReply.addTarget(self, action: #selector(CommentsViewControllers.btnreplayAction), for: UIControl.Event.touchUpInside)
            cell.btnReply.isHidden = true
            cell.btnLike.addTarget(self, action: #selector(CommentsViewControllers.btnLikeAction), for: UIControl.Event.touchUpInside)
            cell.btnSeemore.addTarget(self, action: #selector(CommentsViewControllers.btnseemoreAction), for: UIControl.Event.touchUpInside)
            let postDate = arrCommented[indexPath.section].created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblTime.text = datavala
            let parent_comments_count = arrCommented[indexPath.section].parent_comments_count
            cell.btnSeemore.isHidden = true
            let strImage = arrCommented[indexPath.section].user_avatar
            url = URL(string: strImage)
            cell.imgProfile.sd_setImage(with: url, completed: nil)
            return cell
        }
        
        let typeFeed = arrFeed[indexPath.row].type
        switch typeFeed {
        case "image":
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "ImgcellTimeline", for: indexPath) as! ImgcellTimeline
            cell.imageProfile.layer.cornerRadius = 25
            cell.imageProfile.clipsToBounds = true
            let cellFrame = cell.frame.size
            let is_liked = arrFeed[indexPath.row].is_liked
            if is_liked == 1 {
                cell.btnLikeImgCell.isSelected = true
            }
            else {
                cell.btnLikeImgCell.isSelected = false
            }
            
            let is_disliked = arrFeed[indexPath.row].is_disliked
            if is_disliked == 1 {
                cell.dislike.isSelected = true
            }
            else {
                cell.dislike.isSelected = false
            }
            let strLocation = arrFeed[indexPath.row].location
            if strLocation.count == 0 {
                print("hello")
            }
            else {
                cell.lblLocation.text = "at " + arrFeed[indexPath.row].location
            }
            let postDate = arrFeed[indexPath.row].created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblSingaleImgDate.text = datavala
            let totalLike = arrFeed[indexPath.row].users_liked_count
            let strLikeTotal = String(totalLike) + " Like"
            cell.btnImgLike.setTitle(strLikeTotal, for: .normal)
            let totaldislike = arrFeed[indexPath.row].users_disliked_count
            let strDislikeTotal = String(totaldislike) + " Dislike"
            cell.dislikeCount.setTitle(strDislikeTotal, for: .normal)
            let totalComment = arrFeed[indexPath.row].comments_count
            let strCommentTotal = String(totalComment) + " Comment"
            cell.btnComment.setTitle(strCommentTotal, for: .normal)
            let strdescription = arrFeed[indexPath.row].description
            if strdescription.count == 0 {
                cell.lbltop.constant = 0
                cell.imgtopconstraint.constant = 0
            }
            else {
                cell.lbltop.constant = 8
                cell.imgtopconstraint.constant = 8
            }
            arrImages = arrFeed[indexPath.row].images
            for item in arrImages {
                let source_url = item
                // cell.setImagestring(strImg: source_url)
                
                url = URL(string: source_url)
                cell.imgPost.sd_setImage(with: url, placeholderImage: nil, options: [], completed: { (theImage, error, cache, url) in
                    
                    cell.setNeedsLayout()
                    cell.imgpostHeight?.constant = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
                    UIView.performWithoutAnimation {
                        self.tblFeed.beginUpdates()
                        self.tblFeed.endUpdates()
                    }
                })
                break
            }
            let name = arrFeed[indexPath.row].users_name
            let avatar = arrFeed[indexPath.row].users_avatar
            url = URL(string: avatar)
            cell.imageProfile.sd_setImage(with: url, completed: nil)
            cell.lblDetails.text = strdescription
            cell.lblDetails.enabledTypes = [.mention, .hashtag, .url]
            cell.lblDetails.hashtagColor = .black
            cell.lblDetails.hashtagSelectedColor = .blue
            cell.lblDetails.handleHashtagTap { hashtag in
                self.hashtagpost = hashtag
                self.getHashtagPost()
            }
            
            let selectedUsername = arrFeed[indexPath.row].username
            cell.lblDetails.numberOfLines = 5
            let lenght = cell.lblDetails.text?.count
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
            
            let readmoreFont = UIFont.systemFont(ofSize: 14)
            let readmoreFontColor = UIColor.blue
            if lenght! >= 200 {
                DispatchQueue.main.async {
                    cell.lblDetails.addTrailing(with: "... ", moreText: "See More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                    let customType = ActiveType.custom(pattern: "... See More")
                    cell.lblDetails.enabledTypes = [.mention, .hashtag, .url,customType]
                    cell.lblDetails.customColor[customType] = UIColor.lightGray
                    cell.lblDetails.text = cell.lblDetails.text
                    cell.lblDetails.handleCustomTap(for: customType) { element in
                        cell.lblDetails.text = strdescription
                        cell.lblDetails.numberOfLines = 0
                        UIView.performWithoutAnimation {
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                    }
                }
            }
            return cell
        case "multi_image" :
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "MultiImgcellTimeline", for: indexPath) as! MultiImgcellTimeline
            cell.imgProfile.layer.cornerRadius = 25
            cell.imgProfile.clipsToBounds = true
            cell.collectionImage.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
            cell.collectionImage.delegate = self
            cell.collectionImage.dataSource = self
            cell.collectionImage.tag = 1001
            cell.collectionImage.layoutIfNeeded()
            cell.collectionImage.reloadData()
            self.arrMultiVala.add(self.arrFeed[indexPath.row])
            let is_liked = arrFeed[indexPath.row].is_liked
            if is_liked == 1 {
                cell.btnLikeMulticell.isSelected = true
            }
            else {
                cell.btnLikeMulticell.isSelected = false
            }
            
            let is_disliked = arrFeed[indexPath.row].is_disliked
            if is_disliked == 1 {
                cell.btndislike.isSelected = true
            }
            else {
                cell.btndislike.isSelected = false
            }
            let strLocation = arrFeed[indexPath.row].location
            if strLocation.count == 0 {
                print("hello")
            }
            else {
                cell.lblLocation.text = "at " + arrFeed[indexPath.row].location
            }
            let totalLike = arrFeed[indexPath.row].users_liked_count
            let strLikeTotal = String(totalLike) + " Like"
            cell.btnLikeCount.setTitle(strLikeTotal, for: .normal)
            let totaldislike = arrFeed[indexPath.row].users_disliked_count
            let strDislikeTotal = String(totaldislike) + " Dislike"
            cell.btnDislikeCount.setTitle(strDislikeTotal, for: .normal)
            let totalComment = arrFeed[indexPath.row].comments_count
            let strCommentTotal = String(totalComment) + " Comment"
            cell.btnCommentCount.setTitle(strCommentTotal, for: .normal)
            let name = arrFeed[indexPath.row].users_name
            let avatar = arrFeed[indexPath.row].users_avatar
            url = URL(string: avatar)
            cell.imgProfile.sd_setImage(with: url, completed: nil)
            let postDate = arrFeed[indexPath.row].created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblTime.text = datavala
            let strdescription = arrFeed[indexPath.row].description
            if strdescription.count == 0 {
                cell.lbltop.constant = 0
                cell.imgtopconstraint.constant = 0
            }
            else {
                cell.lbltop.constant = 8
                cell.imgtopconstraint.constant = 8
            }
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
            
            cell.lblDescrip.text = strdescription
            cell.lblDescrip.enabledTypes = [.mention, .hashtag, .url]
            cell.lblDescrip.hashtagColor = .black
            cell.lblDescrip.hashtagSelectedColor = .blue
            cell.lblDescrip.handleHashtagTap { hashtag in
                self.hashtagpost = hashtag
                self.getHashtagPost()
            }
            cell.lblDescrip.numberOfLines = 5
            cell.btnLikeCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllLikeMultiCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllCommentMultiCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentMulticell.addTarget(self, action: #selector(NewsfeedViewController.btnCommentMultiCellAction), for: UIControl.Event.touchUpInside)
            cell.btnLikeMulticell.addTarget(self, action: #selector(NewsfeedViewController.btnLikeMulticellAction), for: UIControl.Event.touchUpInside)
            cell.btnMultiImgmenu.addTarget(self, action: #selector(NewsfeedViewController.btnMenuAction), for: UIControl.Event.touchUpInside)
           // cell.btnshareMultiCell.addTarget(self, action: #selector(NewsfeedViewController.btnshareMultiAction), for: UIControl.Event.touchUpInside)
            cell.btnMultiImagePass.addTarget(self, action: #selector(NewsfeedViewController.btnImgPassAction), for: UIControl.Event.touchUpInside)
            cell.btnMultiimgProfile.addTarget(self, action: #selector(NewsfeedViewController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.btndislike.addTarget(self, action: #selector(NewsfeedViewController.btndislikeMultiAction), for: UIControl.Event.touchUpInside)
            cell.btnDislikeCount.addTarget(self, action: #selector(NewsfeedViewController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
            
            let lenght = cell.lblDescrip.text?.count
            let readmoreFont = UIFont.systemFont(ofSize: 14)
            let readmoreFontColor = UIColor.blue
            
            if lenght! >= 200 {
                DispatchQueue.main.async {
                    cell.lblDescrip.addTrailing(with: "... ", moreText: "See More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                    let customType = ActiveType.custom(pattern: "... See More")
                    cell.lblDescrip.enabledTypes = [.mention, .hashtag, .url,customType]
                    cell.lblDescrip.customColor[customType] = UIColor.lightGray
                    cell.lblDescrip.text = cell.lblDescrip.text
                    cell.lblDescrip.handleCustomTap(for: customType) { element in
                        cell.lblDescrip.text = strdescription
                        cell.lblDescrip.numberOfLines = 0
                        UIView.performWithoutAnimation {
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                    }
                }
            }
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            return cell
            
        case "text":
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "TxtcellTimeline", for: indexPath) as! TxtcellTimeline
            cell.imgProfile.layer.cornerRadius = 25
            cell.imgProfile.clipsToBounds = true
            let is_liked = arrFeed[indexPath.row].is_liked
            if is_liked == 1 {
                cell.btnLiketxtCell.isSelected = true
            }
            else {
                cell.btnLiketxtCell.isSelected = false
            }
            
            let is_disliked = arrFeed[indexPath.row].is_disliked
            if is_disliked == 1 {
                cell.btndislike.isSelected = true
            }
            else {
                cell.btndislike.isSelected = false
            }
            let strLocation = arrFeed[indexPath.row].location
            if strLocation.count == 0 {
                print("hello")
            }
            else {
                cell.lblLocation.text = "at " + arrFeed[indexPath.row].location
            }
            let totalLike = arrFeed[indexPath.row].users_liked_count
            let strLikeTotal = String(totalLike) + " Like"
            cell.btnLikeCount.setTitle(strLikeTotal, for: .normal)
            let totaldislike = arrFeed[indexPath.row].users_disliked_count
            let strDislikeTotal = String(totaldislike) + " Dislike"
            cell.btnDislikeCount.setTitle(strDislikeTotal, for: .normal)
            let totalComment = arrFeed[indexPath.row].comments_count
            let strCommentTotal = String(totalComment) + " Comment"
            cell.btnCommentCount.setTitle(strCommentTotal, for: .normal)
            let name = arrFeed[indexPath.row].users_name
            let selectedUsername = arrFeed[indexPath.row].username
            let avatar = arrFeed[indexPath.row].users_avatar
            url = URL(string: avatar)
            cell.imgProfile.sd_setImage(with: url, completed: nil)
            cell.lblTitle.text = name
            let postDate = arrFeed[indexPath.row].created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblTime.text = datavala
            let strdescription = arrFeed[indexPath.row].description
            cell.lblDesc.text = strdescription
            cell.lblDesc.enabledTypes = [.mention, .hashtag, .url]
            cell.lblDesc.hashtagColor = .black
            cell.lblDesc.hashtagSelectedColor = .blue
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
            cell.lblDesc.numberOfLines = 5
            cell.btnLikeCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllLikeTxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentCount.addTarget(self, action: #selector(NewsfeedViewController.btnAllCommenttxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommenttxtCell.addTarget(self, action: #selector(NewsfeedViewController.btnCommenttxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btnLiketxtCell.addTarget(self, action: #selector(NewsfeedViewController.btnLiketxtcellAction), for: UIControl.Event.touchUpInside)
            cell.btntxtMenu.addTarget(self, action: #selector(NewsfeedViewController.btnMenuAction), for: UIControl.Event.touchUpInside)
            cell.btntxtProfile.addTarget(self, action: #selector(NewsfeedViewController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.btndislike.addTarget(self, action: #selector(NewsfeedViewController.btndislikeTxtAction), for: UIControl.Event.touchUpInside)
            cell.btnDislikeCount.addTarget(self, action: #selector(NewsfeedViewController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
            
            let lenght = cell.lblDesc.text?.count
            let readmoreFont = UIFont.systemFont(ofSize: 14)
            let readmoreFontColor = UIColor.blue
            
            if lenght! >= 200 {
                DispatchQueue.main.async {
                    cell.lblDesc.addTrailing(with: "... ", moreText: "See More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                    let customType = ActiveType.custom(pattern: "... See More")
                    cell.lblDesc.enabledTypes = [.mention, .hashtag, .url,customType]
                    cell.lblDesc.customColor[customType] = UIColor.lightGray
                    cell.lblDesc.text = cell.lblDesc.text
                    cell.lblDesc.handleCustomTap(for: customType) { element in
                        cell.lblDesc.text = strdescription
                        cell.lblDesc.numberOfLines = 0
                        UIView.performWithoutAnimation {
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                    }
                }
            }
            
            return cell
        case "url":
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "YoutubeVideoPlaycell", for: indexPath) as! YoutubeVideoPlaycell
            let youtube_video_id = arrFeed[indexPath.row].youtube_video_id
            let strdescription = arrFeed[indexPath.row].description
            if strdescription.count == 0 {
                cell.lblTop.constant = 0
                cell.plyerviewTop.constant = 0
            }
            else {
                cell.lblTop.constant = 8
                cell.plyerviewTop.constant = 8
            }
            //            let youTubePath = "https://www.youtube.com/embed/\(youtube_video_id)"
            //            print(youTubePath)
            //            cell.configureCell(imageUrl: youTubePath, description: "Image", videoUrl: youTubePath)
            cell.Youtube(youtube_id : youtube_video_id)
            cell.imgProfile.layer.cornerRadius = 25
            cell.imgProfile.clipsToBounds = true
            let is_liked = arrFeed[indexPath.row].is_liked
            if is_liked == 1 {
                cell.btnLikeVideoCell.isSelected = true
            }
            else {
                cell.btnLikeVideoCell.isSelected = false
            }
            
            let is_disliked = arrFeed[indexPath.row].is_disliked
            if is_disliked == 1 {
                cell.btndislike.isSelected = true
            }
            else {
                cell.btndislike.isSelected = false
            }
            let strLocation = arrFeed[indexPath.row].location
            if strLocation.count == 0 {
                print("hello")
            }
            else {
                cell.lblLocation.text = "at " + arrFeed[indexPath.row].location
            }
            let totalLike = arrFeed[indexPath.row].users_liked_count
            let strLikeTotal = String(totalLike) + " Like"
            cell.btnLikeCount.setTitle(strLikeTotal, for: .normal)
            let totaldislike = arrFeed[indexPath.row].users_disliked_count
            let strDislikeTotal = String(totaldislike) + " Dislike"
            cell.btndislikeCount.setTitle(strDislikeTotal, for: .normal)
            let totalComment = arrFeed[indexPath.row].comments_count
            let strCommentTotal = String(totalComment) + " Comment"
            cell.btncommentcount.setTitle(strCommentTotal, for: .normal)
            let avatar = arrFeed[indexPath.row].users_avatar
            url = URL(string: avatar)
            cell.imgProfile.sd_setImage(with: url, completed: nil)
            let name = arrFeed[indexPath.row].users_name
            let selectedUsername = arrFeed[indexPath.row].username
            //cell.lblTitle.text = arrFeed[indexPath.row].users_name
            let postDate = arrFeed[indexPath.row].created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblTime.text = datavala
            cell.lblDesc.text = strdescription
            cell.lblDesc.enabledTypes = [.mention, .hashtag, .url]
            cell.lblDesc.hashtagColor = .black
            cell.lblDesc.hashtagSelectedColor = .blue
            cell.lblDesc.handleHashtagTap { hashtag in
                self.hashtagpost = hashtag
                self.getHashtagPost()
            }
            cell.lblDesc.numberOfLines = 5
            
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
            
            let lenght = cell.lblDesc.text?.count
            let readmoreFont = UIFont.systemFont(ofSize: 14)
            let readmoreFontColor = UIColor.blue
            
            if lenght! >= 200 {
                DispatchQueue.main.async {
                    cell.lblDesc.addTrailing(with: "... ", moreText: "See More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
                    let customType = ActiveType.custom(pattern: "... See More")
                    cell.lblDesc.enabledTypes = [.mention, .hashtag, .url,customType]
                    cell.lblDesc.customColor[customType] = UIColor.lightGray
                    cell.lblDesc.text = cell.lblDesc.text
                    cell.lblDesc.handleCustomTap(for: customType) { element in
                        cell.lblDesc.text = strdescription
                        cell.lblDesc.numberOfLines = 0
                        UIView.performWithoutAnimation {
                            self.tblFeed.beginUpdates()
                            self.tblFeed.endUpdates()
                        }
                    }
                }
            }
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            return cell
        case "meta":
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "MetacellTimeline", for: indexPath) as! MetacellTimeline
            cell.imgProfile.layer.cornerRadius = 25
            cell.imgProfile.clipsToBounds = true
            cell.viewMeta.layer.cornerRadius = 5
            cell.viewTop.constant = 0
            cell.lbltop.constant = 0
            
            let is_liked = arrFeed[indexPath.row].is_liked
            if is_liked == 1 {
                cell.btnLikeMetaCell.isSelected = true
            }
            else {
                cell.btnLikeMetaCell.isSelected = false
            }
            
            let is_disliked = arrFeed[indexPath.row].is_disliked
            if is_disliked == 1 {
                cell.btndislike.isSelected = true
            }
            else {
                cell.btndislike.isSelected = false
            }
            let strLocation = arrFeed[indexPath.row].location
            if strLocation.count == 0 {
                print("hello")
            }
            else {
                cell.lblLocation.text = "at " + arrFeed[indexPath.row].location
            }
            let totalLike = arrFeed[indexPath.row].users_liked_count
            let strLikeTotal = String(totalLike) + " Like"
            cell.btnLikeCount.setTitle(strLikeTotal, for: .normal)
            let totaldislike = arrFeed[indexPath.row].users_disliked_count
            let strDislikeTotal = String(totaldislike) + " Dislike"
            cell.btndislikeCount.setTitle(strDislikeTotal, for: .normal)
            let totalComment = arrFeed[indexPath.row].comments_count
            let strCommentTotal = String(totalComment) + " Comment"
            cell.btnCommentCount.setTitle(strCommentTotal, for: .normal)
            let avatar = arrFeed[indexPath.row].users_avatar
            url = URL(string: avatar)
            cell.imgProfile.sd_setImage(with: url, completed: nil)
            //  cell.lblTitle.text = arrFeed[indexPath.row].users_name
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
            
            let postDate = arrFeed[indexPath.row].created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblTime.text = datavala
            let Metas = arrFeed[indexPath.row].description
            if let url = URL(string: Metas) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                url.fetchPageInfo({ (title, description, previewImage) -> Void in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    if description == nil {
                        cell.lblDescMeta.isHidden = true
                    }
                    else {
                        cell.lblDescMeta.isHidden = false
                        cell.lblDescMeta.text = description
                    }
                    
                    if title == nil {
                        cell.lblMetaTitle.isHidden = true
                    }
                    else {
                        cell.lblMetaTitle.isHidden = false
                        cell.lblMetaTitle.text = title
                    }
                    
                    if let imageUrl = previewImage {
                        self.downloadImage(URL(string: imageUrl)!, imageView: cell.imgMeta)
                    }
                    
                }, failure: { (errorMessage) -> Void in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    print(errorMessage)
                })
            } else {
                print("Invalid URL!")
            }
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            return cell
        default:
            print("hello")
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        lastIndex_id = arrFeed[indexPath.row].id
//    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
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
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == "action://TC" {
            print("TC click",url.absoluteString)
        }
        else if url.absoluteString == "action://PP" {
            print("PP click")
        }
        else {
            print(url)
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
    
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tblFeed)
        
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tblFeed, appEnteredFromBackground: true)
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
        print("Download Started")
        print("lastPathComponent: " + url.lastPathComponent)
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async(execute: {
                guard let data = data , error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                imageView.image = UIImage(data: data)
            })
        }
    }
    
    
    @objc func openAction(_ sender: UIButton) {
        arrSingaleImg.removeAll()
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            let cellfeed = tblFeed.cellForRow(at: indexPath) as! ImgcellTimeline
            let images = arrFeed[indexPath.row].images
            for item in images {
                let source_url = item
                arrSingaleImg.append(source_url)
                let tkImageVC = TKImageShowing()
                //tkImageVC.tblFeedDashboard = "tblFeedDashboard"
                tkImageVC.animatedView  = cellfeed.imgPost
                // tkImageVC.arrTimeline = arrFeed[indexPath.row]
                //  tkImageVC.currentIndex = indexPath.row
                tkImageVC.images = arrSingaleImg.toTKImageSource()
                //self.present(tkImageVC, animated: true, completion: nil)
                let naviget: UINavigationController = UINavigationController(rootViewController: tkImageVC)
                self.present(naviget, animated: true, completion: nil)
            }
        }
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
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
            obj.postDetail_id = self.post_Id
            //self.navigationController?.pushViewController(obj, animated: true)
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
            obj.passappDel = "passappDel"
            self.present(naviget, animated: true, completion: nil)
        }
    }
    
    @objc func btnCommentPostAction(_ sender: UIButton) {
        if let indexPath = self.tblFeed.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            post_Id = arrFeed[indexPath.row].id
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
            else {
                print("jekil")
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
                        print(response)
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
                        print(response)
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
                        print(response)
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
                        print(response)
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
                        print(response)
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
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
            else {
                print("jekil")
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
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
            else {
                print("jekil")
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
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
            else {
                print("jekil")
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
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
            else {
                print("jekil")
            }
        }
    }
    
    
    
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
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
                                        self.arrFeed.remove(at: indexPath.row)
                                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
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
                                        self.arrFeed.remove(at: indexPath.row)
                                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
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
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
                                        self.arrFeed.remove(at: indexPath.row)
                                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
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
                                        self.arrFeed.remove(at: indexPath.row)
                                        self.tblFeed.deleteRows(at: [indexPath], with: .fade)
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
                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "postDetailsConteroller")as! postDetailsConteroller
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds"{
            if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                let margin:CGFloat = 8.0
                textView.frame = CGRect.init(x: rect.origin.x + margin, y: rect.origin.y + margin, width: rect.width - 2*margin, height: rect.height / 2)
                textView.bounds = CGRect.init(x: rect.origin.x + margin, y: rect.origin.y + margin, width: rect.width - 2*margin, height: rect.height / 2)
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

//MARK: - collectionview method
extension postDetailsConteroller: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
        
        //        let obj = self.storyboard?.instantiateViewController(withIdentifier: "MultiplaePhotoViewControllerList")as! MultiplaePhotoViewControllerList
        //        obj.arrMultipale = arrMultiImage
        //        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        //        self.present(naviget, animated: true, completion: nil)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
        let tkImageVC = TKImageShowing()
        tkImageVC.animatedView  = cell!.imageView
        tkImageVC.currentIndex = indexPath.row
        tkImageVC.images = arrMultiImage.toTKImageSource()
        let naviget: UINavigationController = UINavigationController(rootViewController: tkImageVC)
        self.present(naviget, animated: true, completion: nil)
        //self.present(tkImageVC, animated: true, completion: nil)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //            let padding: CGFloat = 1
    //            let collectionViewSize = collectionView.bounds.width - padding
    //            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    //    }
}

extension postDetailsConteroller: SquareFlowLayoutDelegate {
    func shouldExpandItem(at indexPath: IndexPath) -> Bool {
        if arrMultiImage.count == 5 {
            return self.layoutValues[indexPath.row] == .normal
        }
        return self.layoutValues[indexPath.row] == .expanded
    }
}


