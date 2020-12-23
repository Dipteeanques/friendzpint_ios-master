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

class FriendsTimelineController: UIViewController,TTTAttributedLabelDelegate {
    
    enum CellType {
        case normal
        case expanded
    }
    
    var player: AVPlayer?
    var selectedIndex = Int()
    internal var TexttagTapHandler: ((String) -> ())?
    var strHashtag = String()
    var boolGlobalDisco = Bool()
    var muteBool = true
    var hashtagpost = String()
    
    @IBOutlet weak var tblFeed: UITableView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: Foundview!
    
    var strDetails = "Sophie louise hart is at maldives Sophie #jekilDabhoya louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives Sophie louise hart is at maldives"
    
    var arrImage = [#imageLiteral(resourceName: "LoginBackground"),#imageLiteral(resourceName: "Splash"),#imageLiteral(resourceName: "Login Logo"),#imageLiteral(resourceName: "LoginBackground"),#imageLiteral(resourceName: "Login Logo"),#imageLiteral(resourceName: "Splash"),#imageLiteral(resourceName: "Splash"),#imageLiteral(resourceName: "Splash"),#imageLiteral(resourceName: "Login Logo"),#imageLiteral(resourceName: "Login Logo"),#imageLiteral(resourceName: "Login Logo")]
    
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
    
    var arrSingaleImg = [String]()
    var url: URL?
    var index = Int()
    var dicValue = NSDictionary()
    var arrFeed = [MyTimelineList]()
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
    var encodeData = [Data]()
    var decodedData = [Data]()
    var timeline_last_first_id = Int()
    var timeline_Type_top_bottom = String()
    var lastIndex_id = Int()
    var strSaveUnsave = String()
    var strNotification = String()
    var pianoSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "blop", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    let textView = UITextView(frame: CGRect.zero)
    var nameTag = [String]()
    var userTag = [String]()
    var strName = String()
    var selectedUsername = String()
    var tagFirstUsername = String()
    var strTageName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(FriendsTimelineController.profileTimeline), name: NSNotification.Name(rawValue: "FriendsprofileTimeline"), object: nil)
    }
    
    
    func setDefault() {
       
        refreshControl.addTarget(self, action: #selector(FriendsTimelineController.refresh), for: UIControl.Event.valueChanged)
        tblFeed.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appEnteredFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TimelineViewCiontroller.notificationSingaleDashboardTimeline), name: NSNotification.Name(rawValue: "notificationSingaleDashboardTimeline"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TimelineViewCiontroller.notificationMyTimelineBackSingale), name: NSNotification.Name(rawValue: "notificationMyTimelineBackSingale"), object: nil)
        
        tblFeed.register(UINib(nibName: "ImgcellTimeline", bundle: nil), forCellReuseIdentifier: "ImgcellTimeline")
        tblFeed.register(UINib(nibName: "MultiImgcellTimeline", bundle: nil), forCellReuseIdentifier: "MultiImgcellTimeline")
        tblFeed.register(UINib(nibName: "TxtcellTimeline", bundle: nil), forCellReuseIdentifier: "TxtcellTimeline")
        tblFeed.register(UINib(nibName: "YoutubeVideoPlaycell", bundle: nil), forCellReuseIdentifier: "YoutubeVideoPlaycell")
        tblFeed.register(UINib(nibName: "MetacellTimeline", bundle: nil), forCellReuseIdentifier: "MetacellTimeline")
    }
    
   
    @objc func profileTimeline(_ notification: NSNotification) {
        strUserName = notification.object as! String
        self.loaderView.isHidden = false
        self.activity.startAnimating()
        setDefault()
        getFeed()
        pageCount = 1
    }
    
    @objc func refresh(sender:AnyObject) {
        timeline_last_first_id = arrFeed[0].id
        timeline_Type_top_bottom = "Top"
        getFeed(strPage: "1")
    }
    
    @objc func notificationSingaleDashboardTimeline(_ notification: NSNotification) {
        dicValue = notification.object as! NSDictionary
        let obj = storyboard?.instantiateViewController(withIdentifier: "CommentsViewControllers")as! CommentsViewControllers
        obj.strCommentImage = "strCommentImage"
        obj.dicImg = dicValue
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @objc func notificationMyTimelineBackSingale(_ notification: NSNotification) {
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
    
    func getFeed() {
        let parameters = ["timeline_last_post_id": timeline_last_first_id,
                          "timeline_type":timeline_Type_top_bottom,
            "username":strUserName] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: MYTIMELINELIST + "?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let arr_dict  = response?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrFeed.append(arr_dict![i])
                        self.tblFeed.beginUpdates()
                        self.tblFeed.insertRows(at: [
                            NSIndexPath(row: self.arrFeed.count-1, section: 0) as IndexPath], with: .fade)
                        self.spinner.stopAnimating()
                        self.tblFeed.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        self.tblFeed.endUpdates()
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
    
    func getFeed(strPage : String) {
        if timeline_Type_top_bottom == "Top" {
            let parameters = ["timeline_last_post_id": timeline_last_first_id,
                              "timeline_type":timeline_Type_top_bottom,
                "username":strUserName] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            wc.callSimplewebservice(url: MYTIMELINELIST + "?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in
                if sucess {
                    let sucessMy = response?.success
                    if sucessMy! {
                        var arr_dict  = response?.data
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
                            if self.arrFeed.count == 0 {
                                self.foundView.isHidden = false
                            }
                            else {
                                self.foundView.isHidden = true
                            }
                        }
                    }
                    else {
                        self.refreshControl.endRefreshing()
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
                    self.refreshControl.endRefreshing()
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
        else {
            let parameters = ["timeline_last_post_id": timeline_last_first_id,
                              "timeline_type":timeline_Type_top_bottom,
                "username":strUserName] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            wc.callSimplewebservice(url: MYTIMELINELIST + "?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: AllTimelineResponseModel?) in
                if sucess {
                    let sucessMy = response?.success
                    if sucessMy! {
                        let arr_dict  = response?.data
                        for i in 0..<arr_dict!.count
                        {
                            self.arrFeed.append(arr_dict![i])
                            self.tblFeed.beginUpdates()
                            self.tblFeed.insertRows(at: [
                                NSIndexPath(row: self.arrFeed.count-1, section: 0) as IndexPath], with: .fade)
                            self.spinner.stopAnimating()
                            self.tblFeed.tableFooterView?.isHidden = true
                            self.loaderView.isHidden = true
                            self.activity.stopAnimating()
                            self.tblFeed.endUpdates()
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
    
    func getHashtagPost() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "HashtagSearchTimelineController")as! HashtagSearchTimelineController
        obj.hashtagpost = hashtagpost
        self.navigationController?.pushViewController(obj, animated: false)
    }
}

//MARK: - tableview method
extension FriendsTimelineController: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let typeFeed = arrFeed[indexPath.row].type
        switch typeFeed {
        case "image":
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "ImgcellTimeline", for: indexPath) as! ImgcellTimeline
            cell.arrSingaleImage = arrFeed[indexPath.row]
            let cellFrame = cell.frame.size
            arrImages = arrFeed[indexPath.row].images
            for item in arrImages {
                let source_url = item
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
            cell.lblDetails.handleHashtagTap { hashtag in
                self.hashtagpost = hashtag
                self.getHashtagPost()
            }
            
            let selectedUsername = arrFeed[indexPath.row].username
            
            cell.btnSingaleImg.addTarget(self, action: #selector(FriendsTimelineController.openAction), for: UIControl.Event.touchUpInside)
            cell.btnSingaleImageMenu.addTarget(self, action: #selector(FriendsTimelineController.btnMenuAction), for: UIControl.Event.touchUpInside)
            cell.btnImgLike.addTarget(self, action: #selector(FriendsTimelineController.btnImgLikeAction), for: UIControl.Event.touchUpInside)
            cell.btnComment.addTarget(self, action: #selector(FriendsTimelineController.btnCommentAction), for: UIControl.Event.touchUpInside)
            cell.btnpostComment.addTarget(self, action: #selector(FriendsTimelineController.btnCommentPostAction), for: UIControl.Event.touchUpInside)
            cell.btnLikeImgCell.addTarget(self, action: #selector(FriendsTimelineController.btnLikeImgcellAction), for: UIControl.Event.touchUpInside)
            cell.btnProImgClick.addTarget(self, action: #selector(FriendsTimelineController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.dislike.addTarget(self, action: #selector(FriendsTimelineController.btndislikeAction), for: UIControl.Event.touchUpInside)
            cell.dislikeCount.addTarget(self, action: #selector(FriendsTimelineController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
            
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
            cell.lblDescrip.handleHashtagTap { hashtag in
                self.hashtagpost = hashtag
                self.getHashtagPost()
            }
            cell.btnLikeCount.addTarget(self, action: #selector(FriendsTimelineController.btnAllLikeMultiCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentCount.addTarget(self, action: #selector(FriendsTimelineController.btnAllCommentMultiCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentMulticell.addTarget(self, action: #selector(FriendsTimelineController.btnCommentMultiCellAction), for: UIControl.Event.touchUpInside)
            cell.btnLikeMulticell.addTarget(self, action: #selector(FriendsTimelineController.btnLikeMulticellAction), for: UIControl.Event.touchUpInside)
            cell.btnMultiImgmenu.addTarget(self, action: #selector(FriendsTimelineController.btnMenuAction), for: UIControl.Event.touchUpInside)
           
            cell.btnMultiImagePass.addTarget(self, action: #selector(FriendsTimelineController.btnImgPassAction), for: UIControl.Event.touchUpInside)
            cell.btnMultiimgProfile.addTarget(self, action: #selector(FriendsTimelineController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.btndislike.addTarget(self, action: #selector(FriendsTimelineController.btndislikeMultiAction), for: UIControl.Event.touchUpInside)
            cell.btnDislikeCount.addTarget(self, action: #selector(FriendsTimelineController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
            
           
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            return cell
            
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
            cell.btnLikeCount.addTarget(self, action: #selector(FriendsTimelineController.btnAllLikeTxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentCount.addTarget(self, action: #selector(FriendsTimelineController.btnAllCommenttxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommenttxtCell.addTarget(self, action: #selector(FriendsTimelineController.btnCommenttxtCellAction), for: UIControl.Event.touchUpInside)
            cell.btnLiketxtCell.addTarget(self, action: #selector(FriendsTimelineController.btnLiketxtcellAction), for: UIControl.Event.touchUpInside)
            cell.btntxtMenu.addTarget(self, action: #selector(FriendsTimelineController.btnMenuAction), for: UIControl.Event.touchUpInside)
            cell.btntxtProfile.addTarget(self, action: #selector(FriendsTimelineController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.btndislike.addTarget(self, action: #selector(FriendsTimelineController.btndislikeTxtAction), for: UIControl.Event.touchUpInside)
            cell.btnDislikeCount.addTarget(self, action: #selector(FriendsTimelineController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
            
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
            
            cell.btnLikeCount.addTarget(self, action: #selector(FriendsTimelineController.btnAllLikeVideoCellAction), for: UIControl.Event.touchUpInside)
            cell.btncommentcount.addTarget(self, action: #selector(FriendsTimelineController.btnAllCommentVideoCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentVideoCell.addTarget(self, action: #selector(FriendsTimelineController.btnCommentVideoCellAction), for: UIControl.Event.touchUpInside)
            cell.btnLikeVideoCell.addTarget(self, action: #selector(FriendsTimelineController.btnLikevideocellAction), for: UIControl.Event.touchUpInside)
            
            cell.btnVideoMenu.addTarget(self, action: #selector(FriendsTimelineController.btnMenuAction), for: UIControl.Event.touchUpInside)
          
            cell.btnVideoprofile.addTarget(self, action: #selector(FriendsTimelineController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.btndislike.addTarget(self, action: #selector(FriendsTimelineController.btndislikeVideoAction), for: UIControl.Event.touchUpInside)
            cell.btndislikeCount.addTarget(self, action: #selector(FriendsTimelineController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
            
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            return cell
        case "meta":
            let cell = tblFeed.dequeueReusableCell(withIdentifier: "MetacellTimeline", for: indexPath) as! MetacellTimeline
            cell.arrMeta = arrFeed[indexPath.row]
            cell.viewMeta.layer.cornerRadius = 5
            cell.viewTop.constant = 0
            cell.lbltop.constant = 0
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
            
            cell.btnLikeCount.addTarget(self, action: #selector(FriendsTimelineController.btnAllLikeMetaCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentCount.addTarget(self, action: #selector(FriendsTimelineController.btnAllCommentMetaCellAction), for: UIControl.Event.touchUpInside)
            cell.btnCommentMetaCell.addTarget(self, action: #selector(FriendsTimelineController.btnCommentMetaCellAction), for: UIControl.Event.touchUpInside)
            cell.viewMeta.clipsToBounds = true
            cell.btnMetaClick.addTarget(self, action: #selector(FriendsTimelineController.btnMetaAction), for: .touchUpInside)
            cell.btnMetaMenu.addTarget(self, action: #selector(FriendsTimelineController.btnMenuAction), for: UIControl.Event.touchUpInside)
            cell.btnLikeMetaCell.addTarget(self, action: #selector(FriendsTimelineController.btnLikeMetacellAction), for: UIControl.Event.touchUpInside)
            //cell.btnShareMetaCell.addTarget(self, action: #selector(FriendsTimelineController.btnsharemetaAction), for: UIControl.Event.touchUpInside)
            cell.btnMetaProfile.addTarget(self, action: #selector(FriendsTimelineController.btnImgProfileClickAction), for: UIControl.Event.touchUpInside)
            cell.btndislike.addTarget(self, action: #selector(FriendsTimelineController.btndislikeMetaAction), for: UIControl.Event.touchUpInside)
            cell.btndislikeCount.addTarget(self, action: #selector(FriendsTimelineController.btndislikeCountAction), for: UIControl.Event.touchUpInside)
            
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        lastIndex_id = arrFeed[indexPath.row].id
    }
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
        
        if scrollView == tblFeed {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblFeed.bounds.width, height: CGFloat(44))
                pageCount += 1
                print(pageCount)
                timeline_last_first_id = lastIndex_id
                timeline_Type_top_bottom = "Bottom"
                getFeed(strPage: "\(pageCount)")
                self.tblFeed.tableFooterView = spinner
                self.tblFeed.tableFooterView?.isHidden = false
            }
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
              //  tkImageVC.tblFeedDashboard = "tblFeedDashboard"
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
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "DetailsPostandComment")as! DetailsPostandComment
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

extension FriendsTimelineController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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

extension FriendsTimelineController: SquareFlowLayoutDelegate {
    func shouldExpandItem(at indexPath: IndexPath) -> Bool {
        if arrMultiImage.count == 5 {
            return self.layoutValues[indexPath.row] == .normal
        }
        return self.layoutValues[indexPath.row] == .expanded
    }
}


