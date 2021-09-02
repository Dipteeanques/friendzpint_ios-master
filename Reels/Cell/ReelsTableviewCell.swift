//
//  ReelsTableviewCell.swift
//  FriendzPoint
//
//  Created by Anques on 01/07/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import MarqueeLabel
import Lottie
import AVFoundation

class ReelsTableviewCell: UITableViewCell , ASAutoPlayVideoLayerContainer{
    
    @IBOutlet weak var imgShadow: UIImageView!
//    @IBOutlet weak var btnLike: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var imgMusicNote: UIImageView!{
        didSet{
            imgMusicNote.image = imgMusicNote.image?.withRenderingMode(.alwaysTemplate)
            imgMusicNote.tintColor = UIColor.white
        }
    }
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnComment: UIButton!
    
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var playerCD: UIImageView!
    @IBOutlet weak var imgMute: UIImageView!{
        didSet{
            imgMute.layer.cornerRadius = imgMute.frame.height/2
            imgMute.clipsToBounds = true
            imgMute.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userImg: UIImageView!{
        didSet{
            userImg.layer.cornerRadius = userImg.frame.height/2
            userImg.clipsToBounds = true
        }
    }
    @IBOutlet weak var verifiedUserImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var musicName: MarqueeLabel!
    @IBOutlet weak var btnMute: UIButton!
    
    //MARK: For Video Player

    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    var btnClick = UIButton()
    //MARK:
    var isLiked = false
    var heartAnimationView : AnimationView?

    override func awakeFromNib() {
        super.awakeFromNib()
//        imgMute.isHidden = true
//        UIView.animate(withDuration: 12.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
//            self.musicName.center = CGPoint(x: 0 - self.musicName.bounds.width, y: self.musicName.center.y)
//                   }, completion:  { _ in })
 
//        musicName.type = .continuous
//        musicName.animationCurve = .easeInOut
        videoLayer.backgroundColor = UIColor.black.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill//resizeAspect//resize
        imgShadow.layer.addSublayer(videoLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(Videopause(_:)), name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(Videoplay(_:)), name: NSNotification.Name(rawValue: "Videoplay"), object: nil)
        
//        btnClick.frame = CGRect(x: imgShadow.frame.origin.x, y: imgShadow.frame.origin.y, width: imgShadow.frame.width, height: imgShadow.frame.height)
//        videoLayer.addSublayer(btnClick.layer)
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
//
//           // Configure Tap Gesture Recognizer
//           tapGestureRecognizer.numberOfTapsRequired = 1
//
//           // Add Tap Gesture Recognizer
//        imgShadow.addGestureRecognizer(tapGestureRecognizer)
//        btnClick.addTarget(self, action: #selector(btnReelitAction(_:)), for: .allTouchEvents)
        
    }

   func btnReelitAction() {
        print("did tap view")
    }
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        print("did tap view", sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func handleSingleTap(_ gesture: UITapGestureRecognizer){//@IBAction func btnMuteAction(_ sender: Any) {
        imgMute.isHidden = false
            // ASVideoPlayerController
        if videoLayer.player?.isMuted == true{
            print("Unmute")
            imgMute.image = UIImage(named: "Unmute")
            videoLayer.player?.isMuted = false
        }
        else{
            print("Mute")
            imgMute.image = UIImage(named: "Mute")
            videoLayer.player?.isMuted = true
        }
        
      
        imgMute.alpha = 1.0
        // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            // Animate the alpha value of your imageView from 1.0 to 0.0 here
            self.imgMute.alpha = 0.0
        }) { finished in
            // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
            self.imgMute.isHidden = true
        }
        
    }
    
    func CheckStatus(url : String){
        print("videoURL: ",url)
        if url != nil{
            let fileUrl = URL(string: url ?? "")!
            let asset = AVURLAsset(url: fileUrl)
            let requestedKeys = ["playable"]
            asset.loadValuesAsynchronously(forKeys: requestedKeys) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                /**
                 Need to check whether asset loaded successfully, if not successful then don't create
                 AVPlayer and AVPlayerItem and return without caching the videocontainer,
                 so that, the assets can be tried to be downloaded again when need be.
                 */
                var error: NSError? = nil
                let status = asset.statusOfValue(forKey: "playable", error: &error)
                switch status {
                case .loaded:
                    print("loaded")
                    //                                self.btnPlayImg.isHidden = true
                    //                                self.progressView.isHidden = true
                    self?.playerCD.startRotating()
                    
                    print("playing")
                    break
                    
                case .loading:
                    print("loading")
                    //                            self.progressView.wait()
                    //                            self.progressView.isHidden = false
                    break
                    
                case .unknown:
                    break
                case .failed, .cancelled:
                    print("Failed to load asset successfully")
                    //                                print("paused - progress \(Int(playing * 100))% buffering \(Int(buffering * 100))%")
                    //                                self.progressView.signal()
                    //                                self.progressView.isHidden = true
                    self?.playerCD.stopRotating()
                    return
                default:
                    //                                print("paused - progress \(Int(playing * 100))% buffering \(Int(buffering * 100))%")
                    //                                self.progressView.signal()
                    //                                self.progressView.isHidden = true
                    self?.playerCD.stopRotating()
                    print("Unkown state of asset")
                    return
                }
            }
        }
        
        
        
    }
    
    //MARK: For Video
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
//        self.descriptionLabel.text = description
//        self.shotImageView.imageURL = imageUrl
//        if let videoCell = ReelsTableviewCell.self as? ASAutoPlayVideoLayerContainer, videoCell.videoURL != nil {
//            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
//        }
        self.videoURL = nil
        self.videoURL = videoUrl
//        DispatchQueue.main.async {
//            self.CheckStatus()
//        }
//        CheckStatus(url: videoUrl ?? "")
//        ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: videoLayer, url: videoURL ?? "")
        self.playerCD.startRotating()
    }
    
    @objc func Videopause(_ notification: NSNotification) {
//        videoLayer.player?.pause()
        
        ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: videoLayer, url: self.videoURL ?? "")
    }
    
    @objc func Videoplay(_ notification: NSNotification) {
//        videoLayer.player?.pause()
        
        ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: videoLayer, url: videoURL ?? "")
        self.playerCD.startRotating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin: CGFloat = 20
        let width: CGFloat = bounds.size.width// - horizontalMargin * 2
        let height: CGFloat = bounds.size.height//(width * 0.9).rounded(.up)
//        videoLayer.frame = CGRect(x: 0, y: 0, width: shotImageView.frame.size.width, height: shotImageView.frame.size.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(imgShadow.frame, from: imgShadow)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    
    //MARK: Like Anitmation
    func like(){
//        heartAnimationView?.backgroundColor = .clear
//        heartAnimationView = .init(name: "lottieHeart")
//        //                heartAnimationView?.frame = btnLike.frame
//        heartAnimationView?.animationSpeed = 1
//        //        heartAnimationView?.loopMode = .loop
//        heartAnimationView?.sizeToFit()
//        btnLike.addSubview(heartAnimationView!)
//
//        heartAnimationView?.snp.makeConstraints({ (mkr) in
//            mkr.center.equalTo(btnLike)
//        })
//
//        heartAnimationView?.play(fromFrame: 13, toFrame: 60, loopMode: .none, completion: { (bol) in
//            //            self.heartAnimationView?.play(toFrame: 23)
//        })
        btnLike.setImage(UIImage(named: "Rheart"), for: .normal)
        isLiked = true
        
    }
    func unlike(){
//        heartAnimationView?.backgroundColor = .clear
//
//        heartAnimationView?.play(fromFrame: 60, toFrame: 13, loopMode: .none, completion: { (bol) in
//            self.heartAnimationView?.removeFromSuperview()
//        })
        btnLike.setImage(UIImage(named: "Rlineheart"), for: .normal)
        isLiked = false
        
    }
}
