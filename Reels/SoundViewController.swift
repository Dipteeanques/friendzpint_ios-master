//
//  SoundViewController.swift
//  FriendzPoint
//
//  Created by Anques on 19/07/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import AVFoundation

class SoundViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var lblSoundTitle: UILabel!
    @IBOutlet weak var lblSoundDescription: UILabel!
    @IBOutlet weak var SoundCollectionView: UICollectionView!
    
    @IBOutlet weak var btnPlayOutlet: UIButton!
    @IBOutlet weak var imgVideo: UIImageView!
    var wc = Webservice.init()
    var noDataLabel = UILabel()
    var SoundArr : SoundResponseModel?
    var FlagReel = 0
    
    @IBOutlet weak var btnCreate: UIButton!{
        didSet{
            btnCreate.layer.cornerRadius = btnCreate.frame.height/2
            btnCreate.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnDownload: UIButton!{
        didSet{
            btnDownload.layer.cornerRadius = btnDownload.frame.height/2
            btnDownload.clipsToBounds = true
        }
    }
    
    var sound_id = String()
    var Sound_name = String()
    var Sound_description = String()
    var Sound_thum = String()
    var Sound_audio = String()
    var user_id = String()
    
    var PlayFlag = 0
//    var player = AVAudioPlayer()
    var player: AVPlayer!
//    var videosMainArrSound : ReelsShowRelatedVideosResponseModel?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        imgVideo.sd_setImage(with: URL(string: Sound_thum), placeholderImage: UIImage(named: "Placeholder"), options: [], completed: nil)
       
//        let url1 = NSURL(string: Sound_audio)
//        self.play(url: url1!)
        let url = URL.init(string: Sound_audio)
        player = AVPlayer.init(url: url!)
        
        if Sound_name == ""{
            lblSoundTitle.text = "original sound - "
        }
        else {
            lblSoundTitle.text = Sound_name
        }
        
        if Sound_description == ""{
            lblSoundDescription.text = "none"
        }
        else{
            lblSoundDescription.text = Sound_description
        }
        
       GetSounds(starting_point: 0)
    }
    
    @IBAction func btnCreateAction(_ sender: Any) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "CreateReelsVC")as! CreateReelsVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//        Flag = 0
//        obj.GroupTimeline_Id = gtime_id
//        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        obj.modalPresentationStyle = .overFullScreen
        self.present(obj, animated: true, completion: nil)
    }
    
    @IBAction func btnDownloadAction(_ sender: Any) {
        
        let url = NSURL(string: Sound_audio)
        print("the url = \(url!)")
        downloadFileFromURL(url: url!)
    }
    
    func downloadFileFromURL(url:NSURL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            //            self?.play(URL)
            print("response: ",response)
            print("error: ",error)
            DispatchQueue.main.async {
                self?.showalert(tlt: "Audio Saved", msg: "This sound is saved successfully")
            }
        })
        
        downloadTask.resume()
        
    }
    
    func NoData(){
        noDataLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: SoundCollectionView.bounds.size.width, height: SoundCollectionView.bounds.size.height))
        noDataLabel.text          = "No Data Found"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        SoundCollectionView.backgroundView  = noDataLabel
//        CollectionReels.separatorStyle  = .none
    }
    
    func GetSounds(starting_point: Int){
    
        let parameters = ["device_id": "0",
                          "starting_point":starting_point,
                          "user_id":user_id ,
                          "sound_id":sound_id] as [String : Any]
        print("parameters: ",parameters)
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        print("headers: ",headers)
        print("SHOWVIDEOAGAINSTSOUND: ",SHOWVIDEOAGAINSTSOUND)
        wc.callSimplewebservice(url: SHOWVIDEOAGAINSTSOUND, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: SoundResponseModel?) in
            print("response:",response?.code)
            print(response)
            if sucess {
                
                //                self.transparentView.backgroundColor = .clear//UIColor.black.withAlphaComponent(0.5)
                //                self.imgLogo.isHidden = false
                let sucessMy = response?.code
                if sucessMy == 200{
                    self.noDataLabel.isHidden = true
                    print("hello success..",self.SoundArr?.msg.count)
//                    if self.SoundArr?.msg.count == 0 || self.SoundArr?.msg.count == nil{
                        self.SoundArr = response
                        self.SoundCollectionView.reloadData()
//                    }
////                    else{
////                        if self.FlagReel == 1{
////                            if (self.SoundArr?.msg.count)! > 0{
//////                                self.SoundArr?.msg.append(contentsOf: response!.msg)
////
////
////                            }
////                            self.FlagReel = 0
////                            self.SoundCollectionView.reloadData()
////                        }
////                    }
                    
                    
                }
                else {
                    self.NoData()
                    self.noDataLabel.isHidden = false
                }
            }
            else {
                print(response)
                self.NoData()
                self.noDataLabel.isHidden = false
            }
        }
        
    }

    @IBAction func btnPlayAction(_ sender: Any) {
        if PlayFlag == 0{
            player.play()
            btnPlayOutlet.setImage(UIImage(named: "Pause"), for: .normal)
            PlayFlag = 1
        }
        else{
            player.pause()
            btnPlayOutlet.setImage(UIImage(named: "Play"), for: .normal)
            PlayFlag = 0
        }
    }
    
//    func play(url:NSURL) {
//        print("playing \(url)")
//
//        do {
////           let url1 = URL(string: "https://friendzpoint.blob.core.windows.net/frp/uploads/shorts/audio/60b86321c28a7126.mp3")
//            player = try AVAudioPlayer(contentsOf: url as URL)
//            player.delegate = self
//            player.prepareToPlay()
//            player.volume = 1.0
//            player.play()
//        } catch let error as NSError {
//            //self.player = nil
//            print("playerError: ",error.localizedDescription)
//        } catch {
//            print("AVAudioPlayer init failed")
//        }
//
//    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension SoundViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SoundArr?.msg.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SoundCell
        
        cell.imgVideoThum.sd_setImage(with: URL(string: self.SoundArr?.msg[indexPath.row].Video.thum ?? ""), placeholderImage: UIImage(named: "Placeholder"), options: [], completed: nil)
        cell.btnVideoVIewCount.setTitle(self.SoundArr?.msg[indexPath.row].Video.view, for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let rootViewController = UIApplication.topViewController() {
            let storyMain = UIStoryboard(name: "Main", bundle: nil)
            let vc =  storyMain.instantiateViewController(withIdentifier: "ReelsVC") as! ReelsVC
//            vc.discoverVideoArr = videosObj
            vc.BackFlag = 1
//            vc.indexAt = indexPath
//            vc.hidesBottomBarWhenPushed = true
            vc.CheckSoundFlag = 1
            
//            let Vobj = self.SoundArr?.msg[indexPath.row].Video
//            let reelsv = ReelsVideo(id: Vobj.id, user_id: Vobj?.user_id, fb_id: Vobj?.fb_id, description: Vobj?.description, video: Vobj?.video, thum: Vobj?.thum, gif: Vobj?.gif, view: Vobj?.view, section: Vobj?.section, sound_id: Vobj?.sound_id, privacy_type: Vobj?.privacy_type, allow_comments: Vobj?.allow_comments, allow_duet: Vobj?.allow_duet, block: Vobj?.block, duet_video_id: Vobj?.duet_video_id, old_video_id: Vobj?.old_video_id, duration: Vobj?.duration, created: Vobj?.created, like: Vobj?.like, favourite: Vobj?.favourite, comment_count: Vobj?.comment_count, like_count: Vobj?.like_count)
//
//            let VSou = self.SoundArr?.msg[indexPath.row].Sound
//            let reelsS = ReelsSound(id: VSou?.id, audio: VSou?.audio, duration: VSou?.duration, name: VSou?.name, description: VSou?.description, thum: VSou?.thum, sound_section_id: VSou?.sound_section_id, uploaded_by: VSou?.uploaded_by, publish: VSou?.publish, created: VSou?.created, deleted_at: VSou?.deleted_at)
//
//            let Vuser = self.SoundArr?.msg[indexPath.row].User
//            let reelsUser = ReelsUser(id: Vuser?.id, timeline_id: Vuser?.timeline_id, email: Vuser?.email, contactno: Vuser?.contactno, wallet_token: Vuser?.wallet_token, verification_code: Vuser?.verification_code, verified: Vuser?.verification_code, remember_token: Vuser?.remember_token, username: Vuser?.username, password: Vuser?.password, balance: Vuser?.balance, birthday: Vuser?.birthday, city: Vuser?.city, country: Vuser?.country, designation: Vuser?.designation, hobbies: Vuser?.hobbies, interests: Vuser?.interests, custom_option1: "", custom_option2: "", custom_option3: "", custom_option4: "", gender: Vuser?.gender, active: Vuser?.active, last_logged: "", timezone: Vuser?.timezone, affiliate_id: Vuser?.affiliate_id, language: Vuser?.language, facebook_link: Vuser?.facebook_link, twitter_link: Vuser?.twitter_link, dribbble_link: Vuser?.dribbble_link, instagram_link: Vuser?.instagram_link, youtube_link: Vuser?.youtube_link, linkedin_link: Vuser?.linkedin_link, created_at: Vuser?.created_at, updated_at: Vuser?.updated_at, deleted_at: Vuser?.deleted_at, profile_pic: Vuser?.profile_pic, button:"")
            
          
            
            vc.VId = self.SoundArr?.msg[indexPath.row].Video.id ?? ""
            vc.SoundArrMain = self.SoundArr?.msg[indexPath.row]//(self.SoundArr?.msg)!
            vc.modalPresentationStyle = .overFullScreen
            rootViewController.present(vc, animated: false, completion: nil)//navigationController?.pushViewController(vc, animated: true)
        }
//        print("videosObj.count",videosObj.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let yourWidth = ((collectionView.bounds.width/3.0) - 2)
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
//        let index = SoundCollectionView.indexPathsForVisibleRows
//        for index1 in index ?? [] {
//            print("count:",self.SoundArr?.msg.count)
//            print("indexV:",index1.row)
////            if index1.row == 0 {
////                print("indexV:",index?.last)
////            }
//            if ((index1.row + 1) == self.videosMainArr?.msg.count){
//                FlagReel = 1
//                pageindex = pageindex + 1
//                GetReels(starting_point: pageindex)
//            }
//        }
    }
    
}
