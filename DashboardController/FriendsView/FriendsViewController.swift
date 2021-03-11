//
//  FriendsViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 13/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Photos
import DKPhotoGallery
import DKImagePickerController
import Alamofire

class FriendsViewController: UIViewController {
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendsViewController")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var collectionSuggested: UICollectionView!
    @IBOutlet weak var foundView: LargeFound!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var tblFriend: UITableView!
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
    @IBOutlet weak var img_logo: UIImageView!
    
    var arrFriends = ["Mayur Godhani","Jekil Dabhoya","Dipak kukadiya","Maulik Bhuva","Manna kathiriya","Piyush Prajapati","Mayur Godhani","Jekil Dabhoya","Dipak kukadiya","Maulik Bhuva","Manna kathiriya","Piyush Prajapati"]
    
    var arrFollow = [FriendDetailsResponse]()
    var url: URL?
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var wc = Webservice.init()
    var assets: [DKAsset]?
    var arrSuggeted = [suggetedList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FriendsViewController.FriendsRequest), name: NSNotification.Name(rawValue: "FriendsRequest"), object: nil)
        setDefault()
    }
    
     @objc func FriendsRequest(_ notification: NSNotification) {
        tblFriend.scrollToTop()
        friendRequest()
        getsuggestedPeople()
    }

    func setDefault() {
        self.loaderView.isHidden = false
        self.activity.startAnimating()
        friendRequest(strPage: "1")
        pageCount = 1
        self.navigationController?.navigationBar.isHidden = true
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
        gridentView.addSubview(img_logo)
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
            self.lblbadge.badge(text: String(count))
        }
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
            if count == 0{
                currentTabBar!.setBadgeText(nil, atIndex: 3)
            }
            else{
                currentTabBar!.setBadgeText(String(count), atIndex: 3)
            }
        }
        
        if UIScreen.main.bounds.width == 320 {
            
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: gridentView.bounds.size.height)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.BadgeCleare), name: NSNotification.Name(rawValue: "BadgeCleare"), object: nil)
        
        getsuggestedPeople()
    }
    
    @objc func BadgeCleare(_ notification: NSNotification) {
        self.lblbadge.badge(text: nil)
    }
    
    func getsuggestedPeople() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        print(headers)
        
        wc.callGETSimplewebservice(url: FINDSUGGESTEDUSERS, parameters: [:], headers: headers, fromView: self.view, isLoading: false) { (sucess, response: suggestedFriendResponsMode?) in
            if sucess {
                print("response:",response)
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict = data?.data
                    self.arrSuggeted = arr_dict!
                    if self.arrSuggeted.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                    self.collectionSuggested.reloadData()
                    
                }
            }
        }
    }
    
    func friendRequest() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: FOLLOWREQUEST, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendRequesResponseModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict = data?.data
                    self.arrFollow = arr_dict!
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrFollow.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
            }
            self.spinner.stopAnimating()
            self.tblFriend.tableFooterView?.isHidden = true
            self.loaderView.isHidden = true
            self.activity.stopAnimating()
            if self.arrFollow.count == 0 {
                self.foundView.isHidden = false
            }
            else {
                self.foundView.isHidden = true
            }
        }
     }
    
    func friendRequest(strPage : String) {
        let parameters = ["page" : strPage]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
         wc.callSimplewebservice(url: FOLLOWREQUEST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendRequesResponseModel?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrFollow.append(arr_dict![i])
                        self.tblFriend.beginUpdates()
                        self.tblFriend.insertRows(at: [
                            NSIndexPath(row: self.arrFollow.count-1, section: 0) as IndexPath], with: .fade)
                        self.tblFriend.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblFriend.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrFollow.count == 0 {
                           self.foundView.isHidden = false
                        }
                        else {
                           self.foundView.isHidden = true
                        }
                    }
                }
                else {
                    self.spinner.stopAnimating()
                    self.tblFriend.tableFooterView?.isHidden = true
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrFollow.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
            }
            self.spinner.stopAnimating()
            self.tblFriend.tableFooterView?.isHidden = true
            self.loaderView.isHidden = true
            self.activity.stopAnimating()
            if self.arrFollow.count == 0 {
                self.foundView.isHidden = false
            }
            else {
                self.foundView.isHidden = true
            }
        }
    }
    
    func AddFriends(timeVala_id: String) {
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
                    print(follow)
                }
            }
        }
    }
    
    func FollowUnfollow(timeVala_id: String) {
        let parameters = ["timeline_id" : timeVala_id]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: FOLLOW, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendsResponsModel?) in
            if sucess {
                let suc = response?.success
                if suc! {
//                    if response?.followed == true{
//                        self.btnFriends.setTitle("Unfollow", for: .normal)
//                    }
//                    else{
//                        self.btnFriends.setTitle("Follow", for: .normal)
//                    }
                    
//                    let data = response?.data
//                    let follow = data?.followrequest
//                    if follow! {
//                        self.btnFriends.setTitle("Requested", for: .normal)
//                    }
//                    else {
////                        self.btnFriends.setTitle("Add Friends", for: .normal)
//                        self.btnFriends.setTitle("Follow", for: .normal)
//                    }
                }
            }
        }
    }
    
    //MARK: - Btn Action
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseAllButton"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController")as! SearchViewController
        self.navigationController?.pushViewController(obj, animated: false)
        
    }
    
    @IBAction func btnCameraAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseAllButton"), object: nil)
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseAllButton"), object: nil)
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

extension FriendsViewController: UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFollow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFriend.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! FriendtblCell
        cell.imgProfile.layer.cornerRadius = 25
        cell.imgProfile.clipsToBounds = true
        cell.btnConfirm.layer.cornerRadius = 5
        cell.btnConfirm.clipsToBounds = true
        cell.btnDelete.layer.cornerRadius = 5
        cell.btnDelete.clipsToBounds = true
        let strimg = arrFollow[indexPath.row].avatar
        url = URL(string: strimg)
        cell.imgProfile.sd_setImage(with: url, completed: nil)
        cell.lblName.text = arrFollow[indexPath.row].name
        let postDate = arrFollow[indexPath.row].created_at
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: postDate)!
        let datavala = Date().offsetFrom(date: date)
        cell.lblDay.text = datavala
        cell.btnConfirm.addTarget(self, action: #selector(FriendsViewController.btnConfirmAction), for: UIControl.Event.touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(FriendsViewController.btnDeletection), for: UIControl.Event.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tblFriend {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblFriend.bounds.width, height: CGFloat(44))
                pageCount += 1
                print(pageCount)
                friendRequest(strPage: "\(pageCount)")
                self.tblFriend.tableFooterView = spinner
                self.tblFriend.tableFooterView?.isHidden = false
            }
        }
    }
    
    @objc func btnConfirmAction(_ sender: UIButton) {
        if let indexPath = self.tblFriend.indexPathForView(sender) {
            let user_Id = arrFollow[indexPath.row].id
            self.arrFollow.remove(at: indexPath.row)
            self.tblFriend.deleteRows(at: [indexPath], with: .fade)
            let parameters = ["user_id":user_Id] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
             wc.callSimplewebservice(url: FOLLOW_ACCEPT, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendsRequestAcceptResponseModel?) in
                if sucess {
                    let status = response?.status
                    if self.arrFollow.count == 1 {
                        print("jekil")
                    }
                    else {
                        self.friendRequest()
                    }
                }
            }
        }
    }
    
    @objc func btnDeletection(_ sender: UIButton) {
        if let indexPath = self.tblFriend.indexPathForView(sender) {
            let user_Id = arrFollow[indexPath.row].id
            self.arrFollow.remove(at: indexPath.row)
            self.tblFriend.deleteRows(at: [indexPath], with: .fade)
            let parameters = ["user_id":user_Id] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                           "Accept" : ACCEPT,
                           "Authorization":BEARERTOKEN]
            wc.callSimplewebservice(url: FOLLOW_REJECT, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FriendsRequestRejectedResponseModel?) in
                if sucess {
                    let status = response?.status
                    if self.arrFollow.count == 1 {
                        print("jekil")
                    }
                    else {
                        self.friendRequest()
                    }
//                    if status == "200" {
//                        self.friendRequest(strPage : "\(self.pageCount)")
//                    }
//                    else{
//                        self.friendRequest(strPage : "\(self.pageCount)")
//                    }
                }
            }
        }
    }
}

extension FriendsViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSuggeted.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let suggested = arrSuggeted[indexPath.row]
        let cell = collectionSuggested.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! suggestedCollectionCell
        cell.suggested = suggested
        cell.btnAdd.addTarget(self, action: #selector(FriendsViewController.btnSuggestedAction), for: .touchUpInside)
        return cell
    }
    
    @objc func btnSuggestedAction(_ sender: UIButton) {
        if let indexPath = self.collectionSuggested.indexPathForView(sender) {
            let cell = collectionSuggested.cellForItem(at: indexPath)as! suggestedCollectionCell
            let timelineid = arrSuggeted[indexPath.row].timeline_id
            if let button = sender as? UIButton {
                if button.isSelected {
                    button.isSelected = false
                    //AddFriends(timeVala_id: "\(timelineid)")
                    FollowUnfollow(timeVala_id: "\(timelineid)")
                    cell.btnAdd.layer.backgroundColor = UIColor(red: 5/255, green: 88/255, blue: 195/255, alpha: 1).cgColor
                }
                else {
                    button.isSelected = true
//                    AddFriends(timeVala_id: "\(timelineid)")
                    FollowUnfollow(timeVala_id: "\(timelineid)")
                    cell.btnAdd.layer.backgroundColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
                }
            }
        }
    }
}

extension UICollectionView {
    
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let center = view.center
        
        //The center of the view is a better point to use, but we can only use it if the view has a superview
        guard let superview = view.superview else {
            //The view we were passed does not have a valid superview.
            //Use the view's bounds.origin and convert from the view's coordinate system
            let origin = self.convert(view.bounds.origin, from: view)
            let indexPath = self.indexPathForItem(at: origin)
            return indexPath
        }
        let viewCenter = self.convert(center, from: superview)
        let indexPath = self.indexPathForItem(at: viewCenter)
        return indexPath
    }
}


////MARK: *************** Extension Date ***************
extension Date{
    
    
    func convertToString(validDateFormatter:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = validDateFormatter //"dd MMM yyyy" //yyyy-mm-dd hh:mm
        //return dateFormatter.stringFromDate(self)
        return dateFormatter.string(from: self as Date)
        
    }
    
    func yearsFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Year, fromDate: date, toDate: self, options: []).year
        //        let calendar = NSCalendar.current
        
        //        let components = Calendar.current.dateComponents([.year], from: date, to: self as Date)
        
        return Calendar.current.dateComponents([.year], from: date, to: self).year!
        
    }
    func monthsFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Month, fromDate: date, toDate: self, options: []).month
        return Calendar.current.dateComponents([.month], from: date as Date, to: self).month!
    }
    func weeksFrom(date:Date) -> Int{
        //return NSCalendar.currentCalendar.components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear!
    }
    func daysFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Day, fromDate: date, toDate: self, options: []).day
        return Calendar.current.dateComponents([.day], from: date, to: self).day!
    }
    func hoursFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Hour, fromDate: date, toDate: self, options: []).hour
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour!
    }
    func minutesFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Minute, fromDate: date, toDate: self, options: []).minute
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute!
    }
    func secondsFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Second, fromDate: date, toDate: self, options: []).second
        return Calendar.current.dateComponents([.second], from: date, to: self).second!
    }
    func offsetFrom(date:Date) -> String
    {
        if yearsFrom(date: date) > 0 {
            return "\(yearsFrom(date: date))y"
        }
        if monthsFrom(date: date) > 0 {
            return "\(monthsFrom(date: date))M"
        }
        if weeksFrom(date: date) > 0{
            return "\(weeksFrom(date: date))w"
        }
        if daysFrom(date: date) > 0 {
            return "\(daysFrom(date: date))d"
        }
        if hoursFrom(date: date) > 0 {
            return "\(hoursFrom(date: date))h"
        }
        if minutesFrom(date: date) > 0 {
            return "\(minutesFrom(date: date))m"
        }
        if secondsFrom(date: date) > 0 {
            return "\(secondsFrom(date: date))s"
        }
        return ""
    }
}


class suggestedCollectionCell: UICollectionViewCell {
    @IBOutlet weak var btnAdd: UIButton!{
        didSet {
            btnAdd.layer.cornerRadius = 5
            btnAdd.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var url: URL?
    var suggested: suggetedList? {
        didSet {
            let strImg = suggested?.avatar
            url = URL(string: strImg!)
            imgProfile.sd_setImage(with: url, completed: nil)
            lblName.text = suggested?.name
        }
    }
    
    override func prepareForReuse() {
        imgProfile.image = nil
        lblName.text = nil
        btnAdd.setNeedsFocusUpdate()
    }
}
