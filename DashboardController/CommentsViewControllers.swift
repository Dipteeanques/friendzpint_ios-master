//
//  CommentsViewControllers.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 04/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import TKImageShowing
import Alamofire

class CommentsViewControllers: UIViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var foundView: LargeFound!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var footerBoxView: UIView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var tbComment: UITableView!
    @IBOutlet weak var txtCommentBox: UITextField!
    
    var arrComments = [["Comment":"A simple iOS Swift-4 project demonst how to implement collapsible table section jay hind bhayo gujarat india badha loko","Type":"1"],["Comment":"How are you","Type":"1"],["Comment":"I m Fine and good","Type":"2"],["Comment":"ok Baby","Type":"2"],["Comment":"How are you","Type":"1"]]
    
    var strCommentImage = String()
    var dicImg = NSDictionary()
    var index = Int()
    var arrImage = [TKImageSource?]()
    var postId = Int()
    var arrCommented = [CommentList]()
    var arrArticleComment = [ArticleCommentDatamain]()
    var arrReelsComment = [ReelsCommentMsg]()
    var arrParentComment = [ParentCommentList]()
    var parent_ID = Int()
    var wc = Webservice.init()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var url: URL?
    var replay = String()
    var indexPath = IndexPath()
    var sendParent: CommentList?
    var getChaild: ParentCommentList?
    var CHECKTYPE = String()
    //MARK: For Article
    var article_id = Int()
    var flagCmt = 0
    
    
   // " A simple iOS Swift-4 project demonst how to implement collapsible table section jay hind bhayo gujarat india badha loko","How are you"
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView.isHidden = false
        activity.startAnimating()
        setDeafult()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if strCommentImage == "strCommentImage" {
            self.navigationController?.navigationBar.isHidden = true
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if strCommentImage == "strCommentImage" {
            self.navigationController?.navigationBar.isHidden = true
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setDeafult() {
        currentTabBar?.setBar(hidden: true, animated: false)
        let profile = loggdenUser.value(forKey: PROFILE)as! String
        url = URL(string: profile)
        imgProfile.sd_setImage(with: url, completed: nil)
        if CHECKTYPE == "ART"{
            getArticleComment()
        }
        else if CHECKTYPE == "Reel"{
            getReelsComment()
        }
        else{
            getComment()
        }
        
       
        pageCount = 1
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.headerview.bounds
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        headerview.layer.addSublayer(gradientLayer)
//        headerview.addSubview(btnback)
//        headerview.addSubview(lblTitle)
//
        tbComment.sectionHeaderHeight = UITableView.automaticDimension;
        tbComment.estimatedSectionHeaderHeight = 100;
        
//        if UIScreen.main.bounds.width == 414 {
//            gradientLayer.frame = CGRect(x: headerview.bounds.origin.x, y: headerview.bounds.origin.y, width: 414, height: headerview.bounds.size.height)
//        }
//        else if UIScreen.main.bounds.height == 812 {
//            // txtviewHeightConstraint.constant = 400
//        }
//        else if UIScreen.main.bounds.width == 320 {
//            //txtviewHeightConstraint.constant = 190
//        }
        footerBoxView.layer.cornerRadius = 5
        footerBoxView.clipsToBounds = true
        footerBoxView.layer.borderWidth = 1.0
        footerBoxView.layer.borderColor = UIColor.gray.cgColor
        
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
    }
    
    func getComment() {
        let parameters = ["post_id": postId] as [String : Any]
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
                    if self.arrCommented.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                        self.tbComment.reloadData()
                    }
                    
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
                else{
                    self.foundView.isHidden = false
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
            }
            else{
                self.foundView.isHidden = false
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
            }
//            if self.arrCommented.count == 0 {
//                self.foundView.isHidden = false
//            }
//            else {
//                self.foundView.isHidden = true
//                self.tbComment.reloadData()
//            }
//            self.loaderView.isHidden = true
//            self.activity.stopAnimating()
        }
    }
    
    func getReelsComment() {
        let userID = UserDefaults.standard.string(forKey: "TimeLine_id")
        let parameters = ["video_id": postId, "user_id":userID ?? "0"] as [String : Any]
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: SHOWVIDEOCOMMENT, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ReelsCommentResponseModel?) in
            if sucess {
                let sucessMy = response?.code
                print("sucessMy:  ",sucessMy)
                print("Reelcomment: ",response)
                if sucessMy == 200 {
                    let data = response?.msg
                    let arr_dict = data
                    self.arrReelsComment = arr_dict!
                    if self.arrReelsComment.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                        self.tbComment.reloadData()
                    }
                    
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
                else{
                    self.foundView.isHidden = false
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
            }
            else{
                self.foundView.isHidden = false
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
            }
//            if self.arrCommented.count == 0 {
//                self.foundView.isHidden = false
//            }
//            else {
//                self.foundView.isHidden = true
//                self.tbComment.reloadData()
//            }
//            self.loaderView.isHidden = true
//            self.activity.stopAnimating()
        }
    }
    
    func getArticleComment() {
        let parameters = ["article_id": postId] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: LISTARTICLECOMMENT, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ArticleCommentModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict = data?.data
                    self.arrArticleComment = arr_dict!
                    if self.arrArticleComment.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                        self.tbComment.reloadData()
                    }
                    
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
                else{
                    self.foundView.isHidden = false
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
            }
            else{
                self.foundView.isHidden = false
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
            }
//            if self.arrCommented.count == 0 {
//                self.foundView.isHidden = false
//            }
//            else {
//                self.foundView.isHidden = true
//                self.tbComment.reloadData()
//            }
//            self.loaderView.isHidden = true
//            self.activity.stopAnimating()
        }
    }

    func getComment(strPage : String) {
        let parameters = ["post_id": postId,
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
                    for i in 0..<arr_dict!.count
                    {
                        self.arrCommented.append(arr_dict![i])
                        self.tbComment.beginUpdates()
                        self.tbComment.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        self.tbComment.endUpdates()
                        self.spinner.stopAnimating()
                        self.tbComment.tableFooterView?.isHidden = true
                    }
                }
            }
        }
    }
    
    func chaildComment() {
        let parameters = ["post_id": postId,
                          "parent_id": parent_ID] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: PARENT_TIMELINE_COMMENTS, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ParentCommentResponsModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    self.arrParentComment = (response?.data.data)!
                    //self.tbComment.beginUpdates()
                    self.arrCommented[self.indexPath.row].replyCommects = response!.data.data
                    self.tbComment.reloadData()
//                    self.tbComment.insertRows(at: [IndexPath(row: self.arrParentComment.count, section: self.arrCommented.count)], with: .fade)
//                    print(self.arrCommented)
//                    self.tbComment.endUpdates()
                }
            }
        }
    }
    
    
    func sendReelsComment(){
        let userID = UserDefaults.standard.string(forKey: "TimeLine_id")
        let parameters = ["video_id": postId,
                          "user_id":userID ?? "0",
                          "comment": txtCommentBox.text!] as [String : Any]
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: SENDREELSCOMMENT, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: SendReelsCommentResponseModel?) in
            if sucess {
                let sucessRes = response?.code
                if sucessRes == 200 {
                    self.flagCmt = 0
                    self.txtCommentBox.text = ""
                    self.getReelsComment()
                }
            }
        }
    }
    
    func sendArticleComment(){
        let parameters = ["article_id": postId,
                          "comment": txtCommentBox.text!] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: ADDARTICLECOMMENT, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ArticleLikeModel?) in
            if sucess {
                let sucessRes = response?.success
                if sucessRes! {
                    self.getArticleComment()
                }
            }
        }
    }
    
    func sendComment() {
        if replay == "replay" {
            let parameters = ["post_id": postId,
                              "description": txtCommentBox.text!,
                              "parent_comment_id":parent_ID] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callSimplewebservice(url: POSTCOMMENT, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ParentCommentListCommentResponseModel?) in
                if sucess {
                    let sucessRes = response?.success
                    if sucessRes! {
                        self.getChaild = response?.data
                        self.tbComment.reloadData()
                        self.txtCommentBox.text = nil
                        self.getComment()
                    }
                }
            }
        }
        else {
            let parameters = ["post_id": postId,
                              "description": txtCommentBox.text!,
                              "parent_comment_id":""] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callSimplewebservice(url: POSTCOMMENT, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: CreateCommentResponseModel?) in
                if sucess {
                    let sucessRes = response?.success
                    if sucessRes! {
                        self.sendParent = response?.data
                        self.arrCommented.append(self.sendParent!)
                        self.tbComment.reloadData()
                        self.txtCommentBox.text = nil
                        self.getComment()
                    }
                }
            }
        }
    }

    @IBAction func btnSEND(_ sender: UIButton) {
        view.endEditing(true)
        if CHECKTYPE == "ART"{
            sendArticleComment()
        }
        else if CHECKTYPE == "Reel"{
            sendReelsComment()
        }
        else{
            sendComment()
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        if strCommentImage == "strCommentImage" {
            arrImage = dicImg.value(forKey: "arr") as! [TKImageSource?]
            let strValue = dicImg.value(forKey: "my")as! String
            if arrImage.count == 1 {
                if strValue == "tblFeedDashboard" {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationMyFeedBackSingale"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
                else if strValue == "timlineValaImg" {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationMyTimelineBackSingale"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
                else if strValue == "GroupvalaImg" {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationMyGroupBackSingale"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationBack"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
        
        self.navigationController?.popViewController(animated: true)
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

extension CommentsViewControllers: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if CHECKTYPE == "ART"{
            return 1
        }
        else if CHECKTYPE == "Reel"{
            return self.arrReelsComment.count
        }
        else{
            return arrCommented.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if CHECKTYPE == "ART"{
            return arrArticleComment.count
        }
        else if CHECKTYPE == "Reel"{
            if self.arrReelsComment[section].VideoCommentReply.count > 0{
                if flagCmt == 0{
                    if self.arrReelsComment[section].VideoCommentReply.count > 2{
                        return 2
                    }
                    else{
                        return self.arrReelsComment[section].VideoCommentReply.count
                    }
                }
                else{
                    return self.arrReelsComment[section].VideoCommentReply.count
                }
                
            }
            return self.arrReelsComment[section].VideoCommentReply.count
            //            if let arrchaildComment = self.arrReelsComment[section].VideoCommentReply. {
            //              //  self.arrParentComment = arrchaildComment
            //                return arrchaildComment.count
            //            }
        }
        else{
            if let arrchaildComment = arrCommented[section].replyCommects {
                self.arrParentComment = arrchaildComment
                return arrchaildComment.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if CHECKTYPE == "ART"{
            print("Cell: ",arrArticleComment[indexPath.row].comment)
            let cell = tbComment.dequeueReusableCell(withIdentifier: "commentCell")as! commentCell
            cell.lblname.text = arrArticleComment[indexPath.row].created_by
            cell.imgProfile.layer.cornerRadius = 15
            cell.imgProfile.clipsToBounds = true
            let strImage = arrArticleComment[indexPath.row].profile
            url = URL(string: strImage)
            cell.imgProfile.sd_setImage(with: url, completed: nil)
            cell.lblComment.text = arrArticleComment[indexPath.row].comment
            cell.btnReply.isHidden = true
            cell.btnLike.isHidden = true
            cell.lblTime.isHidden = true
            cell.activity.isHidden = true
            cell.lblTimeHeight.constant = 0
            return cell
        }
        else if CHECKTYPE == "Reel"{
            let cell = tbComment.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath)as! commentCell
            cell.imgreplyprofile.layer.cornerRadius = 15
            cell.imgreplyprofile.clipsToBounds = true
            let strComment = self.arrReelsComment[indexPath.section].VideoCommentReply[indexPath.row].comment//.[indexPath.section]//.replyCommects![indexPath.row].description
            cell.lblReply.text = strComment
            cell.lblreplyname.text = self.arrReelsComment[indexPath.section].VideoCommentReply[indexPath.row].User.username
            let strImage = self.arrReelsComment[indexPath.section].VideoCommentReply[indexPath.row].User.profile_pic
            url = URL(string: strImage)
            cell.imgreplyprofile.sd_setImage(with: url, completed: nil)
            return cell
        }
        else{
            let cell = tbComment.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath)as! commentCell
            cell.imgreplyprofile.layer.cornerRadius = 15
            cell.imgreplyprofile.clipsToBounds = true
            let strComment = arrCommented[indexPath.section].replyCommects![indexPath.row].description
            cell.lblReply.text = strComment
            cell.lblreplyname.text = arrCommented[indexPath.section].replyCommects![indexPath.row].user_name
            let strImage = arrCommented[indexPath.section].replyCommects![indexPath.row].user_avatar
            url = URL(string: strImage)
            cell.imgreplyprofile.sd_setImage(with: url, completed: nil)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tbComment.dequeueReusableCell(withIdentifier: "commentCell")as! commentCell
        if CHECKTYPE == "ART"{
            //            print("Header: ",arrArticleComment[indexPath.row].comment)
            cell.isHidden = true
            cell.height = 0
            cell.btnReply.isHidden = true
            cell.btnLike.isHidden = true
            cell.lblTime.isHidden = true
            return cell
        }
        else if CHECKTYPE == "Reel"{
            let comment = self.arrReelsComment[section]
            let cell = tbComment.dequeueReusableCell(withIdentifier: "commentCell")as! commentCell
            cell.imgProfile.layer.cornerRadius = 15
            cell.imgProfile.clipsToBounds = true
            cell.viewBack.layer.cornerRadius = 5
            cell.viewBack.clipsToBounds = true
            let strComment = comment.VideoComment.comment
            cell.lblComment.text = strComment
            cell.lblname.text = comment.User.username
            cell.btnReply.addTarget(self, action: #selector(CommentsViewControllers.btnreplayAction), for: UIControl.Event.touchUpInside)
            cell.btnReply.isHidden = false
            cell.btnLike.addTarget(self, action: #selector(CommentsViewControllers.btnLikeAction), for: UIControl.Event.touchUpInside)
            cell.btnSeemore.addTarget(self, action: #selector(CommentsViewControllers.btnseemoreAction), for: UIControl.Event.touchUpInside)
            let postDate = comment.VideoComment.created
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblTime.text = datavala
            let parent_comments_count = comment.VideoCommentReply.count
            cell.btnSeemore.isHidden = true
            if parent_comments_count == 0 {
                cell.btnSeemore.isHidden = true
            }else {
                cell.btnSeemore.isHidden = false
                let total = String(parent_comments_count) + " See More"
                cell.btnSeemore.setTitle(total, for: .normal)
            }
            let strImage = comment.User.profile_pic
            url = URL(string: strImage)
            cell.imgProfile.sd_setImage(with: url, completed: nil)
            cell.btnSeemore.tag = section
            cell.btnReply.tag = section
            cell.activity.isHidden = true
            cell.btnReply.isHidden = true
            cell.btnLike.isHidden = true
            cell.lblTime.isHidden = true
            return cell
        }
        else{
            let comment = arrCommented[section]
            let cell = tbComment.dequeueReusableCell(withIdentifier: "commentCell")as! commentCell
            cell.imgProfile.layer.cornerRadius = 15
            cell.imgProfile.clipsToBounds = true
            cell.viewBack.layer.cornerRadius = 5
            cell.viewBack.clipsToBounds = true
            let strComment = comment.description
            cell.lblComment.text = strComment
            cell.lblname.text = comment.user_name
            cell.btnReply.addTarget(self, action: #selector(CommentsViewControllers.btnreplayAction), for: UIControl.Event.touchUpInside)
            cell.btnReply.isHidden = false
            cell.btnLike.addTarget(self, action: #selector(CommentsViewControllers.btnLikeAction), for: UIControl.Event.touchUpInside)
            cell.btnSeemore.addTarget(self, action: #selector(CommentsViewControllers.btnseemoreAction), for: UIControl.Event.touchUpInside)
            let postDate = comment.created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblTime.text = datavala
            let parent_comments_count = comment.parent_comments_count
            cell.btnSeemore.isHidden = true
            if parent_comments_count == 0 {
                cell.btnSeemore.isHidden = true
            }else {
                cell.btnSeemore.isHidden = false
                let total = String(parent_comments_count) + " See More"
                cell.btnSeemore.setTitle(total, for: .normal)
            }
            let strImage = comment.user_avatar
            url = URL(string: strImage)
            cell.imgProfile.sd_setImage(with: url, completed: nil)
            cell.btnSeemore.tag = section
            cell.btnReply.tag = section
            cell.activity.isHidden = true
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let lastRowIndex = tbComment.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            tbComment.scrollToBottom(animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if CHECKTYPE == "ART"{
            if arrCommented.count == 0{
                return 0
            }
            else{
                return UITableView.automaticDimension
            }
            
            
        }
        else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func reloadData(){
        tbComment.reloadData()
        DispatchQueue.main.async {
            let indexPath = NSIndexPath(row: self.arrCommented.count - 1, section: 0)
            self.tbComment.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if scrollView == tbComment
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                //                spinner = UIActivityIndicatorView(style: .gray)
                //                spinner.startAnimating()
                //                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tbComment.bounds.width, height: CGFloat(44))
                pageCount += 1
                print(pageCount)
                getComment(strPage: "\(pageCount)")
                //                self.tbComment.tableFooterView = spinner
                //                self.tbComment.tableFooterView?.isHidden = false
            }
        }
    }
    
    @objc func btnseemoreAction(_ sender: UIButton) {
        let tag = sender.tag
        indexPath = IndexPath(row: tag, section: 0)

      
        
        if CHECKTYPE == "Reel"{
            flagCmt = 1
            tbComment.reloadData()
        }
        else{
            postId = arrCommented[indexPath.row].post_id
            parent_ID = arrCommented[indexPath.row].id
            chaildComment()
        }
    }
    
    @objc func btnreplayAction(_ sender: UIButton) {
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        parent_ID = arrCommented[indexPath.row].id
        txtCommentBox.becomeFirstResponder()
        replay = "replay"
    }
    
    @objc func btnLikeAction(_ sender: UIButton) {
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        parent_ID = arrCommented[indexPath.row].id
        //            let cellfeed = tbComment.cellForRow(at: indexPath)as! commentCell
        let parameters = ["comment_id": parent_ID] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: LIKECOMMENT, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: commentLikeResponsModel?) in
            if sucess {
                if response!.liked {
                    let strLikeTotal = "Unlike"
                    //                        cellfeed.btnLike.setTitle(strLikeTotal, for: .normal)
                    sender.setTitle(strLikeTotal, for: .normal)
                    self.tbComment.beginUpdates()
                    self.tbComment.endUpdates()
                }
                else {
                    let strLikeTotal = "Like"
                    //                        cellfeed.btnLike.setTitle(strLikeTotal, for: .normal)
                    sender.setTitle(strLikeTotal, for: .normal)
                    self.tbComment.beginUpdates()
                    self.tbComment.endUpdates()
                }
            }
        }
    }
}


extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
        }
    }
}
