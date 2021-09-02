//
//  previewPlayerViewController.swift
//  FriendzPoint
//
//  Created by Anques on 21/06/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Player
import Alamofire
import GSPlayer
import DSGradientProgressView
import ProgressHUD

class previewPlayerViewController: UIViewController, PlayerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var url:URL?
    fileprivate var player = Player()
    var slctVideoUrl: URL?
    
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var progressView: DSGradientProgressView!
    @IBOutlet weak var btnPlayImg: UIImageView!
    
    //Effect View
    @IBOutlet weak var effect_Vw: UIView!
    @IBOutlet weak var effect_CollVw: UICollectionView!
    
    @IBOutlet weak var hideView: UIView!
    var strSelectedEffect = ""
    var filterSelcted = 100
    var thumImg: UIImage?
    var filterNames = ["Luminance","Chrome","Fade","Instant","Noir","Process","Tonal","Transfer","SepiaTone","ColorClamp","ColorInvert","ColorMonochrome","SpotLight","ColorPosterize","BoxBlur","DiscBlur","GaussianBlur","MaskedVariableBlur","MedianFilter","MotionBlur","NoiseReduction"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        effect_CollVw.register(UINib(nibName: OptiConstant().CEffectCell, bundle: Bundle.main), forCellWithReuseIdentifier: OptiConstant().CEffectCell)
        playerSetup()
    }
    
    func playerSetup(){
        
        btnPlayImg.isHidden = true
        
        playerView.contentMode = .scaleAspectFill
        self.thumImg = OptiVideoEditor().generateThumbnail(path: url!)
        playerView.play(for: url!)
//        slctVideoUrl = url!
        playerView.stateDidChanged = { state in
            switch state {
            case .none:
                print("none")
            case .error(let error):
                
                print("error - \(error.localizedDescription)")
                self.progressView.wait()
                self.progressView.isHidden = false

            case .loading:
                print("loading")
                self.progressView.wait()
                self.progressView.isHidden = false
            case .paused(let playing, let buffering):
                print("paused - progress \(Int(playing * 100))% buffering \(Int(buffering * 100))%")
                self.progressView.signal()
                self.progressView.isHidden = true
            case .playing:
                self.btnPlayImg.isHidden = true
                self.progressView.isHidden = true
                
                print("playing")
            }
        }
        
        print("video Pause Reason: ",playerView.pausedReason )
        
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        print("pressed")
    }
    @IBAction func btnNext(_ sender: Any) {
        print("next pressed")
        playerView.pause(reason: .hidden)
//                saveVideo(withURL: url!)
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReelPostVC") as! ReelPostVC
        vc.VideoUrl = url
        vc.modalPresentationStyle = .overFullScreen
        UserDefaults.standard.set("Public", forKey: "privOpt")
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.playerView.play(for: url!)
        self.playerView.resume()
    }
    override func viewDidDisappear(_ animated: Bool) {
//        self.player.stop()
        playerView.pause(reason: .hidden)

    }
    
    func playerReady(_ player: Player) {
        print("playerReady")
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
    
//    internal func saveVideo(withURL url: URL) {
//        let  sv = HomeViewController.displaySpinner(onView: self.view)
//
//        let imageData:NSData = NSData.init(contentsOf: url)!
//
//        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//        if(UserDefaults.standard.string(forKey: "sid") == nil || UserDefaults.standard.string(forKey: "sid") == ""){
//
//            UserDefaults.standard.set("null", forKey: "sid")
//        }
//
//        let url : String = self.appDelegate.baseUrl!+self.appDelegate.uploadVideo!
//
//        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"videobase64":["file_data":strBase64],"sound_id":"null","description":"xyz","privacy_type":"Public","allow_comments":"true","allow_duet":"1","video_id":"009988"]
//
//        print(url)
//        print(parameter!)
//        let headers: HTTPHeaders = [
//            "api-key": "4444-3333-2222-1111"
//
//        ]
//
//        AF.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
//
//            respones in
//
//            switch respones.result {
//            case .success( let value):
//
//                let json  = value
//
//                HomeViewController.removeSpinner(spinner: sv)
//                print("json: ",json)
//                let dic = json as! NSDictionary
//                let code = dic["code"] as! NSString
//                if(code == "200"){
//
//                    //                                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
//                    //                                // terminaing app in background
//                    //                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//                    //exit(EXIT_SUCCESS)
//                    print("Dict: ",dic)
//                    self.dismiss(animated:true, completion: nil)
//                    // })
//
//                }else{
//
//
//                }
//
//            case .failure(let error):
//                HomeViewController.removeSpinner(spinner: sv)
//                print(error)
//            }
//        })
//
//    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
//        player.stop()
        playerView.pause(reason: .hidden)
        
    }
    
}

extension previewPlayerViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: EffectCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: OptiConstant().CEffectCell, for: indexPath) as! EffectCollectionCell
        cell.lbl_effectName.text = filterNames[indexPath.row]
        if let convertImage = thumImg {
            cell.effect_Imgvw.image = OptiVideoEditor().convertImageToBW(filterName: CIFilterNames[indexPath.row], image: convertImage)
        }
        cell.effect_Imgvw.layer.borderWidth = 2
        
        if self.filterSelcted == indexPath.row {
            cell.effect_Imgvw.layer.borderColor = UIColor.white.cgColor
        } else {
            cell.effect_Imgvw.layer.borderColor = UIColor.clear.cgColor
        }
        cell.effect_Imgvw.layer.cornerRadius = 12
        cell.effect_Imgvw.layer.masksToBounds = true
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let orientation = UIApplication.shared.statusBarOrientation
        if(orientation == .landscapeLeft || orientation == .landscapeRight)
        {
            return CGSize(width: effect_CollVw.frame.width / 4.0, height: effect_CollVw.frame.height)
        } else {
            return CGSize(width: effect_CollVw.frame.width / 2.8, height: effect_CollVw.frame.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

extension previewPlayerViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ProgressHUD.show()
        hideView.isHidden = false
                //effect view
                if effect_Vw.isHidden == false {
                    self.filterSelcted = indexPath.row
                    self.strSelectedEffect = CIFilterNames[indexPath.row]
                    self.effect_CollVw.reloadData()
                }
           
        if effect_Vw.isHidden ==  false {
//            self.avplayer.pause()
            playerView.pause()
            if let videourl = url {
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],animations: {
//                    self.vw_function.frame = CGRect(x: self.menu_Vw.frame.origin.x, y: (self.menu_Vw.frame.origin.y + self.menu_Vw.bounds.height) + 360 , width: self.menu_Vw.bounds.width, height: self.menu_Vw.bounds.height)
//                    self.vw_function.layoutIfNeeded()
                }, completion: nil)
                if strSelectedEffect.count > 0 {
//                    self.progressvw_back.isHidden = false
//                    self.progress_Vw.progress = 0.1
//                    self.setTimer()
                    
//                    if self.slctVideoUrl != nil{
//                        OptiVideoEditor().deleteFile(self.slctVideoUrl!)
//                    }
//
                   
                    print("strSelectedEffect: " ,strSelectedEffect)
                    OptiVideoEditor().addfiltertoVideo(strfiltername: strSelectedEffect, strUrl: videourl, success: { (url) in
                        DispatchQueue.main.async {
//                            let saveBarBtnItm = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveActionforEditedVideo))
//                            self.navigationItem.rightBarButtonItem  = saveBarBtnItm
//                            self.progress_Vw.progress = 1.0
                           print("Furl: ",url)
                            
                            self.playerView.play(for: url)
                            self.slctVideoUrl = url
                            self.url = url
//                            self.addVideoPlayer(videoUrl: url, to: self.video_vw)
//                            self.progressvw_back.isHidden = true
                            ProgressHUD.dismiss()
                            self.hideView.isHidden = true
                        }
                    }) { (error) in
                        DispatchQueue.main.async {
//                            OptiToast.showNegativeMessage(message: error ?? "")
//                            self.progressvw_back.isHidden = true
                            ProgressHUD.dismiss()
                            self.hideView.isHidden = true
                        }
                    }
                }
            }
            
        }
    }
}
