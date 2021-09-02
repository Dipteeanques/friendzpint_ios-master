//
//  soundsViewController.swift
//  FriendzPoint
//
//  Created by Anques on 21/06/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class soundsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var soundsTblView: UITableView!
    @IBOutlet weak var favSoundsTblView: UITableView!
    
//    var soundsDataArr = [[String:Any]]()
    
//    var favSoundDataArr = [[String:Any]]()//[soundsMVC]()
    
    var showsound : ShowSoundResponseModel?
    var favoritesound : FavoriteSoundResponseModel?
    
    struct soundSectionsStruct {
        let secID:String
        let secName:String
    }
//    var soundSecArr = [soundSectionsStruct]()
    
    var startingPoint = "0"
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    var wc = Webservice.init()
    
    @IBOutlet weak var btnDiscover: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    
    @IBOutlet weak var btnDiscoverBottomView: UIView!
    @IBOutlet weak var btnFavBottomView: UIView!
    
    var PlayFlag = 0
//    var player = AVAudioPlayer()
    var player: AVPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favSoundsTblView.delegate = self
        favSoundsTblView.dataSource = self
        
        soundsTblView.isHidden = false
        favSoundsTblView.isHidden = true
        
        btnFavBottomView.backgroundColor = .lightGray
        btnFav.setTitleColor(.lightGray, for: .normal)
        
        soundsTblView.delegate = self
        soundsTblView.dataSource = self
        //        soundsTblView.reloadData()
        
        setupView()
    
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dissmissControllerNoti(notification:)), name: Notification.Name("dismissController"), object: nil)
        
        GetDiscoverSound()
        GetFavoriteSound()
    }
    
    @objc
    func requestData() {
        print("requesting data")
        
        
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    @objc func dissmissControllerNoti(notification: Notification) {
        
        print("dissmissControllerNoti received")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 10.0, *) {
            soundsTblView.refreshControl = refresher
        } else {
            soundsTblView.addSubview(refresher)
        }
        
    }
    
    func GetFavoriteSound(){
        let user_id = UserDefaults.standard.value(forKey: "TimeLine_id")
        let parameters = ["starting_point":"1",
                          "user_id":user_id ?? 0 ] as [String : Any]
        print("parameters: ",parameters)
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        print("headers: ",headers)
        print("SHOWFAVORITESOUND: ",SHOWFAVORITESOUND)
        wc.callSimplewebservice(url: SHOWFAVORITESOUND, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: FavoriteSoundResponseModel?) in
            print("Favoriteresponse:",response)
//            print(response)
            if sucess {
                
                //                self.transparentView.backgroundColor = .clear//UIColor.black.withAlphaComponent(0.5)
                //                self.imgLogo.isHidden = false
                let sucessMy = response?.code
                if sucessMy == 200{
                    print("hello success..")
                    self.favoritesound = response
                    self.favSoundsTblView.reloadData()
                }
                else {
                    
                }
            }
            else {
                print(response)
            }
        }
        
    }
    

    
    func GetDiscoverSound(){
        let user_id = UserDefaults.standard.value(forKey: "TimeLine_id")
        let parameters = ["starting_point":"1",
                          "user_id":user_id ?? 0 ] as [String : Any]
        print("parameters: ",parameters)
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        print("headers: ",headers)
        print("SHOWSOUND: ",SHOWSOUND)
        wc.callSimplewebservice(url: SHOWSOUND, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: ShowSoundResponseModel?) in
            print("Discoverresponse:",response)
//            print(response)
            if sucess {
                
                //                self.transparentView.backgroundColor = .clear//UIColor.black.withAlphaComponent(0.5)
                //                self.imgLogo.isHidden = false
                let sucessMy = response?.code
                if sucessMy == 200{
                    print("hello success..")
                    self.showsound = response
                    self.soundsTblView.reloadData()
                }
                else {
                    
                }
            }
            else {
                print(response)
            }
        }
        
    }
    
    @IBAction func btnDiscoverAction(_ sender: Any) {
        
//        TPGAudioPlayer.sharedInstance().player.pause()
        

        
        //GetAllSounds()
        
        btnFavBottomView.backgroundColor = .lightGray
        btnFav.setTitleColor(.lightGray, for: .normal)
        
        
        btnDiscover.setTitleColor(.white, for: .normal)
        btnDiscoverBottomView.backgroundColor = .white
        
//        getFavSounds()
        soundsTblView.isHidden = false
        favSoundsTblView.isHidden = true
    }
    
    @IBAction func btnFavAction(_ sender: Any) {
        
//        TPGAudioPlayer.sharedInstance().player.pause()
        
        btnFavBottomView.backgroundColor = .white
        btnFav.setTitleColor(.white, for: .normal)
        
        
        btnDiscover.setTitleColor(.lightGray, for: .normal)
        btnDiscoverBottomView.backgroundColor = .lightGray
        
        soundsTblView.isHidden = true
        favSoundsTblView.isHidden = false
    }
    
    //MARK:- SetupView
    
    func setupView(){
        //   favTblheight.constant = CGFloat(favSoundDataArr.count * 80)
        //   tblheight.constant = CGFloat(soundsDataArr.count * 300 + 500)
        // self.view.layoutIfNeeded()
//        print("soundsDataArr.count * 300: ",soundsDataArr.count * 300)
        
    }
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("soundsDataArr.count: ",soundsDataArr.count)
//        print("favSoundDataArr:",favSoundDataArr)
//        print("soundsDataArr:",soundsDataArr)
        if tableView == favSoundsTblView{
            return self.favoritesound?.msg.count ?? 0//favSoundDataArr.count
        }else{
            return self.showsound?.msg.count ?? 0
        }
        
    }
    
    @objc func PlayAction(sender : UITapGestureRecognizer) {
        print(sender.view?.tag)
        
        let url = URL.init(string: (favoritesound?.msg[sender.view!.tag].Sound.audio)!)
        player = AVPlayer.init(url: url!)
        
//        if let indexPath = self.mainTableView.indexPathForView(sender) {
//            let user_id = UserDefaults.standard.value(forKey: "TimeLine_id")
//            let cellfeed = mainTableView.cellForRow(at: indexPath) as! FavoriteCell
//        }
            if PlayFlag == 0{
                player.play()
               // btnPlayOutlet.setImage(UIImage(named: "Pause"), for: .normal)
                PlayFlag = 1
            }
            else{
                player.pause()
                //btnPlayOutlet.setImage(UIImage(named: "Play"), for: .normal)
                PlayFlag = 0
            }
    }
    
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if tableView == favSoundsTblView{
//        let visiblePaths = favSoundsTblView.indexPathsForVisibleRows
//        for i in visiblePaths!  {
//            let visiblePaths = favSoundsTblView.indexPathsForVisibleRows
//            for i in visiblePaths!
//                let cell = favSoundsTblView.cellForRow(at: i) as? FavoriteCell
//
////                cell?.playImg.image = UIImage(named: "ic_play_icon")
////                cell?.btnSelect.isHidden = true
//            }
//
//        }
//    }
//
//}
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if tableView == favSoundsTblView{
//            let obj = favSoundDataArr[indexPath.row]
////            loadAudio(audioURL: (AppUtility?.detectURL(ipString: obj.audioURL))!, ip: indexPath)
//        }
//
//    }
    
//    func loadAudio(audioURL: String,ip:IndexPath) {
//        
//        let cell = favSoundsTblView.cellForRow(at: ip) as! FavoriteCell
//        
//        let kTestImage = "26"
//        
//        let dictionary: Dictionary <String, AnyObject> = SpringboardData.springboardDictionary(title: "audioP", artist: "audioP Artist", duration: Int (300.0), listScreenTitle: "audioP Screen Title", imagePath: Bundle.main.path(forResource: "Spinner-1s-200px", ofType: "gif")!)
//        
////        cell.playImg.isHidden = true
////        cell.loadIndicator.startAnimating()
//
//        TPGAudioPlayer.sharedInstance().playPauseMediaFile(audioUrl: URL(string: audioURL)! as NSURL, springboardInfo: dictionary, startTime: 0.0, completion: {(_ , stopTime) -> () in
//            //
////            cell.playImg.isHidden = false
////            cell.loadIndicator.stopAnimating()
//            //            self.hideLoadingIndicator()
//            //            self.setupSlider()
//            self.updatePlayButton(ip: ip)
//            
//            print("there",stopTime)
//        } )
//        
//        
//    }
 
 
    
//    func updatePlayButton(ip:IndexPath) {
//
//        let cell = favSoundsTblView.cellForRow(at: ip) as! FavoriteCell
//
//        let playPauseImage = (TPGAudioPlayer.sharedInstance().isPlaying ? UIImage(named: "ic_pause_icon") : UIImage(named: "ic_play_icon"))
//
////        cell.btnSelect.isHidden = TPGAudioPlayer.sharedInstance().isPlaying ? false : true
////        //        self.playButton.setImage(playPauseImage, for: UIControlState())
////        cell.playImg.image = playPauseImage
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == favSoundsTblView{
            let favSoundCell =  tableView.dequeueReusableCell(withIdentifier: "favSoundsTVC") as! FavoriteCell
            
           
            
            let gestureBtnuser = UITapGestureRecognizer(target: self, action:  #selector(self.PlayAction(sender:)))
            favSoundCell.imgPlay.tag = indexPath.row
            favSoundCell.imgPlay.isUserInteractionEnabled = true
            favSoundCell.imgPlay.addGestureRecognizer(gestureBtnuser)
            
            let favObj = favoritesound?.msg[indexPath.row].Sound
            favSoundCell.lblMusicTitle.text = favObj?.name
            favSoundCell.lblMusicSignerName.text = favObj?.description
            favSoundCell.lblMusicTime.text = favObj?.duration

//            favSoundCell.soundImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            favSoundCell.imgmusic.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: favObj!.thum))!), placeholderImage: UIImage(named:"noMusicIcon"))
//            if favObj.favourite == "1"{
//                favSoundCell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
//            }else{
//                favSoundCell.btnFav.setImage(UIImage(named:"btnFavEmpty"), for: .normal)
//            }

//            favSoundCell.btnFav.addTarget(self, action: #selector(soundsViewController.btnSoundFavAction(_:)), for:.touchUpInside)
//            favSoundCell.btnSelect.addTarget(self, action: #selector(soundsViewController.btnSelectAction(_:)), for:.touchUpInside)

//            favSoundCell.btnSelect.isHidden = true
            return favSoundCell
        }else{
            let soundCell =  tableView.dequeueReusableCell(withIdentifier: "soundsTVC") as! DiscoverCell
            soundCell.btnSeeAll.tag = indexPath.row
            soundCell.btnSeeAll.addTarget(self, action: #selector(btnALL(_:)), for: .touchUpInside)
            soundCell.soundsCollectionView.reloadData()

            let obj = self.showsound?.msg[indexPath.row]
            let secObj = obj?.SoundSection
            soundCell.lblTitle.text = secObj?.name
            soundCell.showsound = (self.showsound?.msg[indexPath.row].Sound)!//soundsDataArr[indexPath.row]["soundObj"] as! [soundsMVC]

//            soundCell.btnAll.addTarget(self, action: #selector(soundsViewController.btnAllAction(_:)), for:.touchUpInside)

            
            return soundCell
        }
        
    }
    
    //    MARK:- Btn fav sound Action
//        @objc func btnSoundFavAction(_ sender : UIButton) {
//            let buttonPosition = sender.convert(CGPoint.zero, to: self.favSoundsTblView)
//            let indexPath = self.favSoundsTblView.indexPathForRow(at: buttonPosition)
//            let cell = self.favSoundsTblView.cellForRow(at: indexPath!) as! FavoriteCell
//
////            let btnFavImg = cell.btnFav.currentImage
////
////            if btnFavImg == UIImage(named: "btnFavEmpty"){
////                cell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
////            }else{
////                cell.btnFav.setImage(UIImage(named: "btnFavEmpty"), for: .normal)
////            }
////
//            let obj = favSoundDataArr[indexPath!.row]
//
////            addFavSong(soundID: obj.id, btnFav: cell.btnFav)
//
//        }
        
    //    MARK:- Btn select Action
//    @objc func btnSelectAction(_ sender : UIButton) {
//        
//        TPGAudioPlayer.sharedInstance().player.pause()
//        AppUtility?.startLoader(view: self.view)
//        print("btnSelect Tapped")
//        let newObj = favSoundDataArr[sender.tag]
//        
//        UserDefaults.standard.set(newObj.audioURL, forKey: "url")
//        UserDefaults.standard.set(newObj.name, forKey: "selectedSongName")
//        
//        if let audioUrl = URL(string: newObj.audioURL) {
//            
//            // then lets create your document folder url
//            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            
//            // lets create your destination file url
//            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
//            print(destinationUrl)
//            
//            // to check if it exists before downloading it
//            if FileManager.default.fileExists(atPath: destinationUrl.path) {
//                print("The file already exists at path")
//                //                    self.goBack()
//                DispatchQueue.main.async {
//                    
//                    AppUtility?.stopLoader(view: self.view!)
////                    NotificationCenter.default.post(name: Notification.Name("dismissController"), object: nil)
//                    NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
//                    self.dismiss(animated: true, completion: nil)
//                    
//                }
//                
//                // if the file doesn't exist
//            } else {
//                
//                // you can use NSURLSession.sharedSession to download the data asynchronously
//                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
//                    guard let location = location, error == nil else { return }
//                    do {
//                        // after downloading your file you need to move it to your destination url
//                        try FileManager.default.moveItem(at: location, to: destinationUrl)
//                        print("File moved to documents folder @ loc: ",location)
//                        DispatchQueue.main.async {
//                            
//                            AppUtility?.stopLoader(view: self.view)
////                            NotificationCenter.default.post(name: Notification.Name("dismissController"), object: nil)
//                            NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                        
//                        
//                    } catch let error as NSError {
//                        print(error.localizedDescription)
//                        AppUtility?.stopLoader(view: self.view)
//                    }
//                    
//                }).resume()
//            }
//        }
//        
//    }
    
//    MARK:- BTN ALL ACTION
//    @objc func btnAllAction(_ sender : UIButton) {
//        let buttonPosition = sender.convert(CGPoint.zero, to: self.soundsTblView)
//        let indexPath = self.soundsTblView.indexPathForRow(at:buttonPosition)
//        let cell = self.soundsTblView.cellForRow(at: indexPath!) as! DiscoverCell
//
//        let obj = soundSecArr[indexPath!.row]
//
////        let vc = storyboard?.instantiateViewController(withIdentifier: "allSoundsVC") as! allSoundsViewController
////        vc.sectionID = obj.secID
////        vc.modalPresentationStyle = .fullScreen
////        present(vc, animated: true, completion: nil)
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("soundsDataArr.count: ",soundsDataArr.count*100)

        if tableView == favSoundsTblView{
            return UITableView.automaticDimension
        }
        else{
            return 180.0
        }
//
//        if tableView == soundsTblView{
//            let soundObj = soundsDataArr[indexPath.row]//["soundObj"] as! [soundsMVC]
//            for i in 0 ..< soundsDataArr.count{
//                if indexPath.row == i{
//                    if soundObj.count >= 3{
//                        return 320
//                    }else{
//                        print("soundObj.count*108: ",soundObj.count*130)
//                        return (CGFloat(soundObj.count*130))
//                    }
//                }
//            }
//        }
       
    }

    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnALL(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AllSoundViewController") as! AllSoundViewController
      
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}
