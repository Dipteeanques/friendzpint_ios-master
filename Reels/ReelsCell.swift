//
//  ReelsCell.swift
//  FriendzPoint
//
//  Created by Anques on 17/06/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import GSPlayer
import MarqueeLabel
import Lottie
import AVFoundation

class ReelsCell: UICollectionViewCell, ASAutoPlayVideoLayerContainer {
    
    @IBOutlet weak var playerView: VideoPlayerView!
    
    
    @IBOutlet weak var imgShadow: UIImageView!
    @IBOutlet weak var btnLike: UIImageView!
    @IBOutlet weak var btnShare: UIImageView!
    @IBOutlet weak var btnComment: UIImageView!
    
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var playerCD: UIImageView!
    
    @IBOutlet weak var txtDesc: UILabel!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var verifiedUserImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var musicName: MarqueeLabel!
    
    @IBOutlet weak var optionsStackView: UIStackView!
    
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    private var url: URL!
    
    var heartAnimationView : AnimationView?
    
    var isLiked = false
    var timer : Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
//        btnPlayImg.isHidden = true
        
        videoLayer.backgroundColor = UIColor.black.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill//resizeAspect//resize
        imgShadow.layer.addSublayer(videoLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.VideopauseReels(_:)), name: NSNotification.Name(rawValue: "VideopauseReels"), object: nil)
        
//        playerView.contentMode = .scaleAspectFill
        
//        let status = videoLayer.player?.status
//        print("playerstatus: ",status)
        
//        ASVideoPlayerController.sharedVideoPlayer.observeValue(forKeyPath: "status", of: <#T##Any?#>, change: <#T##[NSKeyValueChangeKey : Any]?#>, context: <#T##UnsafeMutableRawPointer?#>)
//        videoLayer.player?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        userImg.makeRounded()
//        playerView.stateDidChanged = { state in
//            switch state {
//            case .none:
//                print("none")
//            case .error(let error):
//
//                print("error - \(error.localizedDescription)")
////                self.progressView.wait()
////                self.progressView.isHidden = false
//
//                NotificationCenter.default.post(name: Notification.Name("errInPlay"), object: nil, userInfo: ["err":error.localizedDescription])
//
//            case .loading:
//                print("loading")
////                self.progressView.wait()
////                self.progressView.isHidden = false
//            case .paused(let playing, let buffering):
//                print("paused - progress \(Int(playing * 100))% buffering \(Int(buffering * 100))%")
////                self.progressView.signal()
////                self.progressView.isHidden = true
//                self.playerCD.stopRotating()
//            case .playing:
////                self.btnPlayImg.isHidden = true
////                self.progressView.isHidden = true
//                self.playerCD.startRotating()
//
//                print("playing")
//            }
//        }
        
       
        
//        print("video Pause Reason: ",playerView.pausedReason )
       
//        timer = Timer.scheduledTimer(timeInterval: 1.0,
//                                     target: self,
//                                     selector: #selector(CheckStatus),
//                                     userInfo: nil,
//                                     repeats: true)
//        CheckStatus()
        
    }
    
    func CheckStatus(){
        print("videoURL: ",videoURL)
        if videoURL != ""{
            let fileUrl = URL(string: videoURL ?? "")!
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
    
    
    func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer) {
        
       if object is AVPlayerItem {
           switch keyPath {
           case "playbackBufferEmpty":
            print("playbackBufferEmpty")
            break
                  // Show loader

           case "playbackLikelyToKeepUp":
            print("playbackLikelyToKeepUp")
            break
                   // Hide loader

           case "playbackBufferFull": break
            print("playbackBufferFull")
                   // Hide loader
           case .none:
            print("none")
            break
           case .some(_):
            print("some")
            break
           }
       }
   }
    
//    func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer) {
//        if keyPath == "status" {
//            print("videoStatus: ",videoLayer.player?.status)
//        }
//    }
    
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
//        self.descriptionLabel.text = description
//        self.shotImageView.imageURL = imageUrl
        self.videoURL = videoUrl
        
        print("URL: ",self.videoURL ?? "")
        ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: videoLayer, url: videoURL ?? "")
        
       
    }
    
    @objc func VideopauseReels(_ notification: NSNotification) {
//        videoLayer.player?.pause()
        
        ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: videoLayer, url: self.videoURL ?? "")
        
        print("ReelsScreenVideoPause")
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
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(playerView.frame, from: playerView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        playerView.isHidden = true
    }
    
////    func set(url: URL) {
////        self.url = url
////        print("url: ",url)
////    }
////
////    func play() {
////        print("playFunction: ",url!)
////        playerView.play(for: url!)
////        playerView.isHidden = false
////    }
//
//    func pause() {
//        playerView.pause(reason: .hidden)
//    }

    func like(){
        heartAnimationView?.backgroundColor = .clear
        heartAnimationView = .init(name: "lottieHeart")
        //                heartAnimationView?.frame = btnLike.frame
        heartAnimationView?.animationSpeed = 1
        //        heartAnimationView?.loopMode = .loop
        heartAnimationView?.sizeToFit()
        btnLike.addSubview(heartAnimationView!)
        
        heartAnimationView?.snp.makeConstraints({ (mkr) in
            mkr.center.equalTo(btnLike)
        })
        
        heartAnimationView?.play(fromFrame: 13, toFrame: 60, loopMode: .none, completion: { (bol) in
            //            self.heartAnimationView?.play(toFrame: 23)
        })
        isLiked = true
        
    }
    func unlike(){
        heartAnimationView?.backgroundColor = .clear
        
        heartAnimationView?.play(fromFrame: 60, toFrame: 13, loopMode: .none, completion: { (bol) in
            self.heartAnimationView?.removeFromSuperview()
        })
        isLiked = false
        
    }
    
    func alreadyLiked(){
        
        heartAnimationView?.removeFromSuperview()
        heartAnimationView?.backgroundColor = .clear
        heartAnimationView = .init(name: "lottieHeart")
        //        heartAnimationView?.frame = btnLike.frame
        
        //        heartAnimationView?.loopMode = .loop
        heartAnimationView?.sizeToFit()
        btnLike.addSubview(heartAnimationView!)
        
        heartAnimationView?.snp.makeConstraints({ (mkr) in
            mkr.center.equalTo(btnLike)
        })
        //self.heartAnimationView?.removeFromSuperview()
        self.heartAnimationView?.currentFrame = 60
        isLiked = true
        
    }
    
}


extension UIImageView {
    
    func makeRounded() {
        
        //        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        //        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
extension UIView {
    func startRotating(duration: Double = 3) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(M_PI * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
    
}
