//
//  ReelsVC.swift
//  FriendzPoint
//
//  Created by Anques on 17/06/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import GSPlayer
import Alamofire
import SDWebImage
import AVFoundation
import Lottie

class ReelsVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var btnReelit: UIButton!{
        didSet{
            let image = UIImage(named: "RFeelit")?.withRenderingMode(.alwaysTemplate)
            btnReelit.setImage(image, for: .normal)
            btnReelit.tintColor = UIColor.white
        }
    }
    
    var heartAnimationView : AnimationView?
    var heartAnimationView1 : AnimationView?
    
    @IBOutlet weak var mainTableView: UITableView!
    //    @IBOutlet weak var ReelCollection: UICollectionView!
    var items = [URL]()
//    var items: [URL] = [
//        URL(string: "http:vfx.mtime.cn/Video/2019/06/29/mp4/190629004821240734.mp4")!,
//        URL(string: "http:vfx.mtime.cn/Video/2019/06/27/mp4/190627231412433967.mp4")!,
//        URL(string: "http:vfx.mtime.cn/Video/2019/06/25/mp4/190625091024931282.mp4")!,
//        URL(string: "http:vfx.mtime.cn/Video/2019/06/16/mp4/190616155507259516.mp4")!,
//        URL(string: "http:vfx.mtime.cn/Video/2019/06/15/mp4/190615103827358781.mp4")!,
//        URL(string: "http:vfx.mtime.cn/Video/2019/06/05/mp4/190605101703931259.mp4")!,
//        URL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")!,
//    ]

    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReelsVC")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    var wc = Webservice.init()
    
    var videoURL = ""
    var videosMainArr : ReelsShowRelatedVideosResponseModel?
    var isFollowing = false
    var pageindex = 0
    var FlagReel = 0
    var BackFlag = 0
    var discoverVideoArr = [videoMainMVC]()
    
    var VId = String()
    var CheckSoundFlag = 0
    
    var SoundArrMain : SoundMsg?
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true

//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
        
        if discoverVideoArr.isEmpty == false || BackFlag == 1{
            btnReelit.setImage(UIImage(named: "Backarrowv2"), for: .normal)
        }
        
//        if self.SoundArrMain.isEmpty == false{
//            
//        }
        
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.isPagingEnabled = true
        mainTableView.contentInsetAdjustmentBehavior = .never
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.prefetchDataSource = self
        mainTableView.snp.makeConstraints({ make in
            make.edges.equalTo(self.view)//equalToSuperview()
        })
        //         feedCV.layoutIfNeeded()
//        ReelCollection.isPagingEnabled = true
//        ReelCollection.setCollectionViewLayout(layout, animated: true)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataNotification(notification:)), name: NSNotification.Name(rawValue: "reloadVidDetails"), object: nil)
        
        NotificationCenter.default.addObserver(self,selector:#selector(self.appEnteredFromBackground),name:NSNotification.Name.NSExtensionHostWillEnterForeground, object: nil)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        mainTableView.addSubview(refreshControl)
    }
    
    
    @objc func refresh(sender:AnyObject) {
        self.videosMainArr = nil
        GetReels(starting_point: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }
    
    @IBAction func btnReelitAction(_ sender: Any) {
        if discoverVideoArr.isEmpty == false || BackFlag == 1{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        }
        
//        override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//
//        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetReels(starting_point: 0)
    }
//    @objc func reloadDataNotification(notification: Notification) {
//        if (notification.userInfo?["err"] as? String) != nil {
//                    print("reloadVid Details Noti")
//
//        }else{
//            GetReels()
//        }
//    }
    
    func GetReels(starting_point: Int){
        let user_id = UserDefaults.standard.value(forKey: "TimeLine_id")
        let parameters = ["device_id": "0",
                          "starting_point":starting_point,
                          "user_id":user_id ?? 0 ] as [String : Any]
        print("parameters: ",parameters)
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        print("headers: ",headers)
        print("SHOWRELATEDVIDEOS: ",SHOWRELATEDVIDEOS)
        wc.callSimplewebservice(url: SHOWRELATEDVIDEOS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: ReelsShowRelatedVideosResponseModel?) in
            print("response:",response?.code)
            print(response)
            if sucess {
                
                //                self.transparentView.backgroundColor = .clear//UIColor.black.withAlphaComponent(0.5)
                //                self.imgLogo.isHidden = false
                let sucessMy = response?.code
                if sucessMy == 200{
                    print("hello success..",self.videosMainArr?.msg.count)
                    if self.videosMainArr?.msg.count == 0 || self.videosMainArr?.msg.count == nil{
                        self.videosMainArr = response
                        self.mainTableView.reloadData()
                    }
                    else{
                        if self.FlagReel == 1{
                            if (self.videosMainArr?.msg.count)! > 0{
                                self.videosMainArr?.msg.append(contentsOf: response!.msg)
                                
                              
                            }
                            self.FlagReel = 0
                            self.mainTableView.reloadData()
                        }
                    }
                    
                    
                }
                else {
                    
                }
            }
            else {
                print(response)
            }
        }
        
    }
    @objc func SoundVideos(sender : UITapGestureRecognizer) {
        print("SoundTag: ",sender.view!.tag)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SoundViewController")as! SoundViewController
        
        if CheckSoundFlag == 1{
            obj.user_id = self.SoundArrMain?.User.id ?? ""
            obj.sound_id = self.SoundArrMain?.Sound.id ?? ""
            obj.Sound_name = self.SoundArrMain?.Sound.name ?? ""
            obj.Sound_description = self.SoundArrMain?.Video.description ?? ""
            obj.Sound_audio = self.SoundArrMain?.Sound.audio ?? ""
            obj.Sound_thum = self.SoundArrMain?.Video.thum ?? ""
        }
        else{
            obj.user_id = self.videosMainArr?.msg[sender.view!.tag].User.id ?? ""
            obj.sound_id = self.videosMainArr?.msg[sender.view!.tag].Sound.id ?? ""
            obj.Sound_name = self.videosMainArr?.msg[sender.view!.tag].Sound.name ?? ""
            obj.Sound_description = self.videosMainArr?.msg[sender.view!.tag].Video.description ?? ""
            obj.Sound_audio = self.videosMainArr?.msg[sender.view!.tag].Sound.audio ?? ""
            obj.Sound_thum = self.videosMainArr?.msg[sender.view!.tag].Video.thum ?? ""
        }

//        obj.videosMainArrSound = self.videosMainArr
        obj.modalPresentationStyle = .fullScreen
        self.present(obj, animated: false, completion: nil)
    }
    
    @objc func userProfile(sender : UITapGestureRecognizer) {
    
        var username = String()
        var Fuser_idstr = String()
        if CheckSoundFlag == 1{
            username = self.SoundArrMain?.User.username ?? ""
            Fuser_idstr = self.SoundArrMain?.User.id ?? ""
        }
        else{
            username = self.videosMainArr?.msg[sender.view!.tag].User.username ?? ""
            Fuser_idstr = self.videosMainArr?.msg[sender.view!.tag].User.id ?? ""
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "navigationLoaderpageredirection")as! navigationLoaderpageredirection
        obj.strUser = username
        Fuser_id = Fuser_idstr
        CheckTab = 1
        obj.modalPresentationStyle = .fullScreen
        self.present(obj, animated: false, completion: nil)
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnReelCameraAction(_ sender: Any) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "CreateReelsVC")as! CreateReelsVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//        Flag = 0
//        obj.GroupTimeline_Id = gtime_id
//        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        obj.modalPresentationStyle = .overFullScreen
        self.present(obj, animated: true, completion: nil)
    }
    
    @IBAction func btnShareAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShareViewContoller") as! ShareViewContoller
        
        if CheckSoundFlag == 1{
            vc.videoID = (self.SoundArrMain?.Video.id)!
            vc.objToShare.removeAll()
            vc.objToShare.append((self.SoundArrMain?.Video.video)!)
            vc.currentVideoUrl = (self.SoundArrMain?.Video.video)!
        }
        else{
            vc.videoID = (self.videosMainArr?.msg[sender.tag].Video.id)!
            vc.objToShare.removeAll()
            vc.objToShare.append((self.videosMainArr?.msg[sender.tag].Video.video)!)
            vc.currentVideoUrl = (self.videosMainArr?.msg[sender.tag].Video.video)!
        }

        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func btnShowmoreComment(_ sender: UIButton) {
//        DisplayViewMain.isHidden = true
//        mainTableView.isScrollEnabled = false

        if let indexPath = self.mainTableView.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseReels"), object: nil)
           
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewControllers")as! CommentsViewControllers
            
            if CheckSoundFlag == 1{
                obj.postId = Int(self.SoundArrMain?.Video.id ?? "0")!
            }
            else{
                obj.postId = Int(self.videosMainArr?.msg[indexPath.row].Video.id ?? "0")!
            }
            
            
            //self.navigationController?.pushViewController(obj, animated: true)
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
            obj.CHECKTYPE = "Reel"
//            obj.passappDel = "passappDel"
           // self.present(naviget, animated: true, completion: nil)
//            self.navigationController?.pushViewController(obj, animated: false)
            obj.modalPresentationStyle = .overFullScreen
            self.present(naviget, animated: false, completion: nil)
        }
    }
    
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
        
        if let indexPath = self.mainTableView.indexPathForView(sender) {
            let user_id = UserDefaults.standard.value(forKey: "TimeLine_id")
            let cellfeed = mainTableView.cellForRow(at: indexPath) as! ReelsTableviewCell
            var arrFeed = self.videosMainArr?.msg[indexPath.row].Video
            let post_Id = arrFeed?.id
            let like_count = arrFeed?.like_count ?? 0
            let parameters = ["video_id":post_Id ?? 0,
                              "user_id": user_id ?? 0] as [String : Any]
            let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            if let button = sender as? UIButton {
                if button.isSelected {
                    button.isSelected = false
                
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        cellfeed.btnLike.transform = cellfeed.btnLike.transform.scaledBy(x: 0.7, y: 0.7)
                        cellfeed.btnLike.setImage(UIImage(named: "Rlineheart"), for: .normal)
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.1, animations: {
                            cellfeed.btnLike.transform = CGAffineTransform.identity
                        })
                    })
                    
                    wc.callSimplewebservice(url: LIKEVIDEO + "?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: LikeVideoResponseModel?) in
                        if sucess {
                            if response!.msg.VideoLike.message == "like" {
                                arrFeed = arrFeed.map{
                                    var mutableBook = $0
                                    if $0.id == post_Id {
                                        mutableBook.like = 1
                                        mutableBook.like_count = like_count + 1
                                    }
                                    return mutableBook
                                }
                                let likeCount = like_count + 1//response?.likecount

                                cellfeed.lblLike.text = String(likeCount)

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    //                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                    self.mainTableView.endUpdates()


                                }
                            }
                            else {
                                arrFeed = arrFeed.map{
                                    var mutableBook = $0
                                    if $0.id == post_Id {
                                        mutableBook.like = 0
                                        mutableBook.like_count = like_count - 1
                                    }
                                    return mutableBook
                                }
//                                let likeCount = response?.likecount
                               
                                cellfeed.lblLike.text = String(like_count - 1)
                             
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
                        let image = UIImage(named: "Rheart")?.withRenderingMode(.alwaysTemplate)
                        cellfeed.btnLike.setImage(image, for: .normal)
                        cellfeed.btnLike.tintColor = UIColor(red: 0.93, green: 0.29, blue: 0.34, alpha: 1.00)//UIColor.red
                        
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.1, animations: {
                            cellfeed.btnLike.transform = CGAffineTransform.identity
                        })
                    })
                    
                    wc.callSimplewebservice(url: LIKEVIDEO + "?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: LikeVideoResponseModel?) in
                        if sucess {
                            if response!.msg.VideoLike.message == "like" {
                                arrFeed = arrFeed.map{
                                    var mutableBook = $0
                                    if $0.id == post_Id {
                                        mutableBook.like = 1
                                        mutableBook.like_count = like_count + 1
                                    }
                                    return mutableBook
                                }
                                //let likeCount = response?.likecount
                                
                                cellfeed.lblLike.text = String(like_count + 1)
                               
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    //                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                            }
                            else {
                                arrFeed = arrFeed.map{
                                    var mutableBook = $0
                                    if $0.id == post_Id {
                                        mutableBook.like = 0
                                        mutableBook.like_count = like_count - 1
                                    }
                                    return mutableBook
                                }
                                let likeCount = like_count - 1

                                cellfeed.lblLike.text = String(likeCount)

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

    @objc func btnLikeTapped(sender : UIButton) {
        // Do what you want

        print("btn like : \(sender.tag)")
        if let indexPath = self.mainTableView.indexPathForView(sender) {

            let cell = mainTableView.cellForRow(at: indexPath) as! ReelsTableviewCell
            
            let userID = UserDefaults.standard.string(forKey: "TimeLine_id")

            var arrFeed = self.videosMainArr?.msg[indexPath.row].Video
            print("LikeC",self.videosMainArr?.msg[indexPath.row].Video.like)
            let post_Id = self.videosMainArr?.msg[indexPath.row].Video.id
            let like_count = self.videosMainArr?.msg[indexPath.row].Video.like_count ?? 0
            let parameters = ["video_id":post_Id ?? 0,
                              "user_id": userID ?? 0] as [String : Any]
            let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            
            if userID != "" && userID != nil{
                if cell.isLiked == false{
                    cell.like()
                    self.videosMainArr?.msg[indexPath.row].Video.like = 1
                    self.videosMainArr?.msg[indexPath.row].Video.like_count = like_count + 1
                   // self.likeVideo(uid:userID!)
                   // self.getVideoDetails(ip: currentVidIP)
                    cell.btnLike.setImage(UIImage(named: "Rheart"), for: .normal)
                    wc.callSimplewebservice(url: LIKEVIDEO + "?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: LikeVideoResponseModel?) in
                        if sucess {
                            if response!.msg.VideoLike.message == "like" {
                                arrFeed = arrFeed.map{
                                    var mutableBook = $0
                                    if $0.id == post_Id {
                                        self.videosMainArr?.msg[indexPath.row].Video.like = 1
                                        self.videosMainArr?.msg[indexPath.row].Video.like_count = like_count + 1
                                        mutableBook.like = 1
                                        mutableBook.like_count = like_count + 1
                                    }
                                    return mutableBook
                                }
                                //let likeCount = response?.likecount
                                
                                cell.lblLike.text = String(like_count + 1)
                               
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    //                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                            }
                            else {
                                arrFeed = arrFeed.map{
                                    var mutableBook = $0
                                    if $0.id == post_Id {
                                        self.videosMainArr?.msg[indexPath.row].Video.like = 0
                                        self.videosMainArr?.msg[indexPath.row].Video.like_count = like_count - 1
                                        mutableBook.like = 0
                                        mutableBook.like_count = like_count - 1
                                    }
                                    return mutableBook
                                }
                                let likeCount = like_count - 1

                                cell.lblLike.text = String(likeCount)

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    //                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                            }
                            
                        }
                    }
                }else{
                    cell.unlike()
                    self.videosMainArr?.msg[indexPath.row].Video.like = 0
                    self.videosMainArr?.msg[indexPath.row].Video.like_count = like_count - 1
                    cell.btnLike.setImage(UIImage(named: "Rlineheart"), for: .normal)
                   // self.likeVideo(uid:userID!)
                   // self.getVideoDetails(ip: currentVidIP)
                    
                    wc.callSimplewebservice(url: LIKEVIDEO + "?type=ios", parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: LikeVideoResponseModel?) in
                        if sucess {
                            if response!.msg.VideoLike.message == "like" {
                                arrFeed = arrFeed.map{
                                    var mutableBook = $0
                                    if $0.id == post_Id {
                                        self.videosMainArr?.msg[indexPath.row].Video.like = 1
                                        self.videosMainArr?.msg[indexPath.row].Video.like_count = like_count + 1
                                        mutableBook.like = 1
                                        mutableBook.like_count = like_count + 1
                                    }
                                    return mutableBook
                                }
                                //let likeCount = response?.likecount
                                
                                cell.lblLike.text = String(like_count + 1)
                               
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    //                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                            }
                            else {
                                arrFeed = arrFeed.map{
                                    var mutableBook = $0
                                    if $0.id == post_Id {
                                        self.videosMainArr?.msg[indexPath.row].Video.like = 0
                                        self.videosMainArr?.msg[indexPath.row].Video.like_count = like_count - 1
                                        mutableBook.like = 0
                                        mutableBook.like_count = like_count - 1
                                    }
                                    return mutableBook
                                }
                                let likeCount = like_count - 1

                                cell.lblLike.text = String(likeCount)

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    //                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                            }
                            
                        }
                    }
                }
            }else{

              //  loginScreenAppear()
            }
        }
            
//        let cell = self.mainTableView.cellForItem(at: IndexPath(row: sender.view!.tag, section: 0)) as? ReelsTableviewCell




    }
}

extension ReelsVC:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if let cell = cell as? ReelsCell {
////            cell.pause()
//        }
//    }
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate { check() }
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////        check()
//        pausePlayeVideos()
//    }
    
//    func pausePlayeVideos(){
////        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(col\)
//    }
//
//    @objc func appEnteredFromBackground() {
////        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: mainTableView, appEnteredFromBackground: true)
//    }
//
//    func check() {
////        checkPreload()
////        checkPlay()
//    }
    
//    func checkPreload() {
//        guard let lastRow = ReelCollection.indexPathsForVisibleItems.last?.row else { return }
//
//        let urls = items
//            .suffix(from: min(lastRow + 1, items.count))
//            .prefix(2)
//
//        print("itrems url: ",urls)
//        VideoPreloadManager.shared.set(waiting: Array(urls))
//
//        //        VideoPlayer.preloadByteCount = 1024 * 1024 // = 1M
//
//
//    }
//
//    func checkPlay() {
//        let visibleCells = ReelCollection.visibleCells.compactMap { $0 as? ReelsCell }
//
//        guard visibleCells.count > 0 else { return }
//
//        let visibleFrame = CGRect(x: 0, y: ReelCollection.contentOffset.y, width: ReelCollection.bounds.width, height: ReelCollection.bounds.height)
//
//        let visibleCell = visibleCells
//            .filter { visibleFrame.intersection($0.frame).height >= $0.frame.height / 2 }
//            .first
//
////        visibleCell?.play()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width:self.view.width , height: self.view.height)
////        return CGSize(width:collectionView.layer.bounds.width , height: collectionView.layer.bounds.height)
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
////        if let cell = cell as? ReelsCell {
////            cell.play()
//////            cell.lblLike.text =
////        }
//        let vidObj = self.videosMainArr?.msg[indexPath.row].Video
////        videoID = vidObj.videoID
////        videoURL = vidObj.videoURL
////
////        currentVidIP = indexPath
//
////        getVideoDetails(ip: indexPath)
//
//        if let cell = cell as? ReelsCell {
////            cell.play()
////            cell.lblLike.text =
//        }
////        print("videoID: \(videoID), videoURL: \(videoURL)")
//
//        print("index@row: ",indexPath.row)
////        if indexPath.row == videosMainArr.count - 4{
////
////            self.startPoint+=1
////            print("StartPoint: ",startPoint)
////
////            if isFollowing == true{
////                self.getFollowingVideos(startPoint: "\(self.startPoint)")
////            }else if userVideoArr.isEmpty == false || discoverVideoArr.isEmpty == false{
////
////            }else{
////                self.getAllVideos(startPoint: "\(self.startPoint)")
////            }
////
////            print("index@row: ",indexPath.row)
////
////        }
//
//    }
//
}
extension ReelsVC: UITableViewDelegate,UITableViewDataSource,UITableViewDataSourcePrefetching{
    
    func tableView(_ tableView: UITableView,   prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func like(){
        heartAnimationView?.isHidden = false
        heartAnimationView?.backgroundColor = .clear
        heartAnimationView = .init(name: "like")
        //                heartAnimationView?.frame = btnLike.frame
        heartAnimationView?.animationSpeed = 1
        //        heartAnimationView?.loopMode = .loop
//        heartAnimationView?.sizeToFit()
        heartAnimationView?.frame = CGRect(x: (self.view.frame.width - 200) / 2, y: (self.view.frame.height - 200) / 2, width: 200, height: 200)
        self.view.addSubview(heartAnimationView!)

        heartAnimationView?.snp.makeConstraints({ (mkr) in
            mkr.center.equalTo(self.view)
        })

        heartAnimationView?.play(fromFrame: 13, toFrame: 60, loopMode: .none, completion: { (bol) in
            //            self.heartAnimationView?.play(toFrame: 23)
            self.heartAnimationView?.removeFromSuperview()
            self.heartAnimationView?.isHidden = true
        })
      
        
    }
    
    
    func unlike(){
//        heartAnimationView?.backgroundColor = .clear
//
//        heartAnimationView?.play(fromFrame: 60, toFrame: 13, loopMode: .none, completion: { (bol) in
//            self.heartAnimationView?.removeFromSuperview()
//        })
      
        heartAnimationView1?.isHidden = false
        heartAnimationView1?.backgroundColor = .clear
        heartAnimationView1 = .init(name: "unlike3")
        //                heartAnimationView?.frame = btnLike.frame
        heartAnimationView1?.animationSpeed = 1
        //        heartAnimationView?.loopMode = .loop
//        heartAnimationView?.sizeToFit()
        heartAnimationView1?.frame = CGRect(x: (self.view.frame.width - 200) / 2, y: (self.view.frame.height - 200) / 2, width: 200, height: 200)
        self.view.addSubview(heartAnimationView1!)

        heartAnimationView1?.snp.makeConstraints({ (mkr) in
            mkr.center.equalTo(self.view)
        })

        heartAnimationView1?.play(fromFrame: 13, toFrame: 60, loopMode: .none, completion: { (bol) in
            //            self.heartAnimationView?.play(toFrame: 23)
            self.heartAnimationView1?.removeFromSuperview()
            self.heartAnimationView1?.isHidden = true
        })
    }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer){
        print("doubletapped")
        let vidObj = self.videosMainArr?.msg[gesture.view!.tag].Video
        if vidObj?.like == 1{
            unlike()
            print("Unlike")
        }
        else{
            print("Like")
            like()
        }
       
        btnLikeTapped(sender: gesture.view as! UIButton)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CheckSoundFlag == 1{
            return 1
        }
        else{
            return self.videosMainArr?.msg.count ?? 0
        }
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Click")
//    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReelsTableviewCell
        
//        cell.btnReelitAction()
//        cell.configureCell(imageUrl: "", description: "", videoUrl:"")
       // removePlayer(tableView: mainTableView)
        let gestureBtnuser = UITapGestureRecognizer(target: self, action:  #selector(self.userProfile(sender:)))
        cell.userImg.tag = indexPath.row
        cell.userImg.isUserInteractionEnabled = true
        cell.userImg.addGestureRecognizer(gestureBtnuser)
        
        let gestureBtnSound = UITapGestureRecognizer(target: self, action:  #selector(self.SoundVideos(sender:)))
        cell.playerCD.tag = indexPath.row
        cell.playerCD.isUserInteractionEnabled = true
        cell.playerCD.addGestureRecognizer(gestureBtnSound)
        
        cell.btnComment.tag = indexPath.row
        cell.btnComment.addTarget(self, action: #selector(btnShowmoreComment(_:)), for: .touchUpInside)
        
        cell.btnShare.tag = indexPath.row
        cell.btnShare.addTarget(self, action: #selector(btnShareAction(_:)), for: .touchUpInside)
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(btnLikeTapped(sender:)), for: .touchUpInside)
//        if self.videosMainArr?.msg.isEmpty == false{
//            //            cell.btnFollow.isHidden = true
//            cell.userImg.isUserInteractionEnabled = false
//
//        }else{
//            //            cell.btnFollow.isHidden = false
//            cell.userImg.isUserInteractionEnabled = true
//        }
        
        if isFollowing == true{
            //            cell.btnFollow.isHidden = true
        }else{
            //            cell.btnFollow.isHidden = false
        }
        
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGR.delegate = self
        doubleTapGR.numberOfTapsRequired = 2
        cell.btnMute.addGestureRecognizer(doubleTapGR)
        
        let SingleTapGR = UITapGestureRecognizer(target: cell, action: #selector(cell.handleSingleTap(_:)))
//        SingleTapGR.delegate = self
        SingleTapGR.numberOfTapsRequired = 1
        cell.btnMute.addGestureRecognizer(SingleTapGR)
        
        if CheckSoundFlag == 1{
            let vidObj = self.SoundArrMain?.Video
            //self.videosMainArr.msg.Videos[indexPath.row]
            let vidString = AppUtility?.detectURL(ipString: vidObj?.video ?? "" )
           let vidURL = URL(string: vidString!)
           //        print("vidURL: ",vidURL)
           self.items.append(vidURL!)
           
            let vidDesc = vidObj?.description
            let commentCount = vidObj?.comment_count
            let likeCount = vidObj?.like_count
           
           let soundName = self.SoundArrMain?.Sound.name
           
            let userImgPath = AppUtility?.detectURL(ipString: self.SoundArrMain?.User.profile_pic ?? "" )//vidObj.userProfile_pic
           let userImgUrl = URL(string: userImgPath!)
           let userName = self.SoundArrMain?.User.username
           
   //        if self.videosMainArr?.msg[indexPath.row].User.verified == false{
   //            cell.verifiedUserImg.isHidden = true
   //        }
           
            let duetVidID = vidObj?.duet_video_id
           if duetVidID != "0"{
               //            cell.playerView.contentMode = .scaleAspectFit
           }else{
               //            cell.playerView.contentMode = .scaleAspectFill
           }
           print("CommentCount: ",commentCount)
           //        cell.set(url: vidURL!)
           
            if vidObj?.like == 1{
               cell.btnLike.setImage(UIImage(named: "Rheart"), for: .normal)
               cell.isLiked = true
           }
           else{
               cell.btnLike.setImage(UIImage(named: "Rlineheart"), for: .normal)
               cell.isLiked = false
           }
           cell.lblShare.text = "Share"
            cell.configureCell(imageUrl: "", description: "Video", videoUrl: vidObj?.video )
            
            let trimmedString = vidDesc?.trimmingCharacters(in: .whitespacesAndNewlines)
            cell.lblDesc.text = trimmedString
            cell.lblComment.text = String(commentCount ?? 0)
            cell.lblLike.text = String(likeCount ?? 0)
            cell.userName.text = "@\(String(describing: userName) )"
//            cell.musicName.tag = indexPath.row
//            cell.musicName.type = .continuous
//            cell.musicName.animationCurve = .easeIn
            cell.musicName.text = soundName
//            cell.musicName.leadingBuffer = 5.0
//            cell.musicName.trailingBuffer = 25.0
            
            cell.userImg.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "user"))
            
//            if self.SoundArrMain[indexPath.row].User.button == "following"{
//                //            cell.btnFollow.setTitle("UnFollow", for: .normal)
//            }else{
//                //            cell.btnFollow.setTitle("Follow", for: .normal)
//            }
        }
        else{
            let vidObj = self.videosMainArr?.msg[indexPath.row].Video
            //self.videosMainArr.msg.Videos[indexPath.row]
           let vidString = AppUtility?.detectURL(ipString: vidObj?.video ?? "")
           let vidURL = URL(string: vidString!)
           //        print("vidURL: ",vidURL)
           self.items.append(vidURL!)
           
           let vidDesc = vidObj?.description
           let commentCount = vidObj?.comment_count
           let likeCount = vidObj?.like_count
           
           let soundName = self.videosMainArr?.msg[indexPath.row].Sound.name
           
           let userImgPath = AppUtility?.detectURL(ipString: self.videosMainArr?.msg[indexPath.row].User.profile_pic ?? "")//vidObj.userProfile_pic
           let userImgUrl = URL(string: userImgPath!)
           let userName = self.videosMainArr?.msg[indexPath.row].User.username
           
   //        if self.videosMainArr?.msg[indexPath.row].User.verified == false{
   //            cell.verifiedUserImg.isHidden = true
   //        }
           
           let duetVidID = vidObj?.duet_video_id
           if duetVidID != "0"{
               //            cell.playerView.contentMode = .scaleAspectFit
           }else{
               //            cell.playerView.contentMode = .scaleAspectFill
           }
           print("CommentCount: ",commentCount)
           //        cell.set(url: vidURL!)
           
           if vidObj?.like == 1{
               cell.btnLike.setImage(UIImage(named: "Rheart"), for: .normal)
               cell.isLiked = true
           }
           else{
               cell.btnLike.setImage(UIImage(named: "Rlineheart"), for: .normal)
               cell.isLiked = false
           }
           cell.lblShare.text = "Share"
            cell.configureCell(imageUrl: "", description: "Video", videoUrl: vidObj?.video ?? "")
            
            
            let trimmedString = vidDesc?.trimmingCharacters(in: .whitespacesAndNewlines)
            cell.lblDesc.text = trimmedString
            cell.lblComment.text = String(commentCount!)
            cell.lblLike.text = String(likeCount!)
            cell.userName.text = "@\(userName ?? "")"
//            cell.musicName.tag = indexPath.row
//            cell.musicName.type = .continuous
//            cell.musicName.animationCurve = .easeIn
            cell.musicName.text = soundName
//            cell.musicName.leadingBuffer = 5.0
//            cell.musicName.trailingBuffer = 25.0
            
            
            cell.userImg.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "user"))
            
            if self.videosMainArr?.msg[indexPath.row].User.button == "following"{
                //            cell.btnFollow.setTitle("UnFollow", for: .normal)
            }else{
                //            cell.btnFollow.setTitle("Follow", for: .normal)
            }
        }
       
        
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videoplay"), object: nil)
//        self.mainTableView.reloadRows(at: [indexPath], with: .none)
       
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReelsTableviewCell
//        cell.configureCell(imageUrl: "", description: "Video", videoUrl:  "")
//        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
//            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
//        }
//    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, videoCell.videoURL != nil {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        removePlayer(tableView: mainTableView)
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        if !decelerate {
        
            pausePlayeVideos()
          
            
        }
        print("indexV:")
        pausePlayeVideos()
//        removePlayer(tableView: mainTableView)
//        pausePlayeVideos()
        let index = mainTableView.indexPathsForVisibleRows
        for index1 in index ?? [] {
            print("count:",self.videosMainArr?.msg.count)
          
//            if index1.row == 0 {
//                print("indexV:",index?.last)
//            }
            if ((index1.row + 1) == self.videosMainArr?.msg.count){
                FlagReel = 1
                pageindex = pageindex + 1
                GetReels(starting_point: pageindex)
            }
        }
    }
    
    func removePlayer(tableView: UITableView){
            let visisbleCells = tableView.visibleCells
            var maxHeight: CGFloat = 0.0
            for cellView in visisbleCells {
                guard let containerCell = cellView as? ASAutoPlayVideoLayerContainer,
                    let videoCellURL = containerCell.videoURL else {
                        continue
                }
                let height = containerCell.visibleVideoHeight()
                if maxHeight < height {
                    maxHeight = height
                }
//                pauseRemoveLayer(layer: containerCell.videoLayer, url: videoCellURL, layerHeight: height)
                ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: containerCell)
            }
        }
    
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: mainTableView)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: mainTableView, appEnteredFromBackground: true)
    }
}

