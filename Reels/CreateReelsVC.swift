//
//  CreateReelsVC.swift
//  FriendzPoint
//
//  Created by Anques on 18/06/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import CoreAnimator
import NextLevel
import AVFoundation
import CoreAnimator
import SnapKit
import Photos
//import Player
import GTProgressBar
import MarqueeLabel
import EFInternetIndicator
import KYShutterButton

class CreateReelsVC: UIViewController {

   // var internetConnectionIndicator: InternetViewIndicator?

//    MARK:- OUTLETS
    
    @IBOutlet weak var btnRecordAni: KYShutterButton!
    
    @IBOutlet weak var progressViewOutlet: UIView!
     @IBOutlet weak var masterViewOutlet: UIView!
    
    @IBOutlet weak var previewDoneBtnsViewOutlet: UIView!
    @IBOutlet weak var uploadViewOutlet: UIView!
    
//    @IBOutlet weak var videoViewOutlet: UIView!
    
    @IBOutlet weak var soundsViewOutlet: UIView!
    @IBOutlet weak var soundsLabel: MarqueeLabel!
    
    @IBOutlet weak var flipViewOutlet: UIView!
//    @IBOutlet weak var speedViewOutlet: UIView!
//    @IBOutlet weak var filterViewOutlet: UIView!
//    @IBOutlet weak var beautyViewOutlet: UIView!
//    @IBOutlet weak var timerViewOutlet: UIView!
    @IBOutlet weak var flashViewOutlet: UIView!
    
    @IBOutlet weak var btnViewAni: UIView!
    
    @IBOutlet weak var recordViewOutlet: UIView!
    
    @IBOutlet weak var flipIconImgView: UIImageView!
//    @IBOutlet weak var speedIconImgView: UIImageView!
//    @IBOutlet weak var filterIconImgView: UIImageView!
//    @IBOutlet weak var beautyIconImgView: UIImageView!
//    @IBOutlet weak var timerIconImgView: UIImageView!
    @IBOutlet weak var flashIconImgView: UIImageView!
    
    @IBOutlet weak var recordIconImgView: UIImageView!
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var btnDoneOutlet: UIButton!
    
    internal var closeButton: UIButton?
    
    @IBOutlet weak var btn2XOutlet: UIButton!
    
    @IBOutlet weak var btn1XOutlet: UIButton!
    
    @IBOutlet weak var btn7XOutlet: UIButton!
    
    @IBOutlet weak var btn5XOutlet: UIButton!
    
    @IBOutlet weak var viewSpeed: UIView!
    @IBOutlet weak var btnSpeed: UIButton!
    
    //    @IBOutlet weak var masterViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var masterCenterYconstraint: NSLayoutConstraint!
    
    @IBOutlet weak var galleryView: UIView!
//    @IBOutlet weak var timeLineView: UIView!
    internal var longPressGestureRecognizer: UILongPressGestureRecognizer?
    internal var photoTapGestureRecognizer: UITapGestureRecognizer?
    internal var focusTapGestureRecognizer: UITapGestureRecognizer?
    internal var flipDoubleTapGestureRecognizer: UITapGestureRecognizer?
    internal var singleTapRecord: UITapGestureRecognizer?
    
    @IBOutlet weak var speedControlView: UIView!{
        didSet{
            speedControlView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            speedControlView.layer.cornerRadius = 6.0
            speedControlView.clipsToBounds = true
        }
    }
    
    internal var metadataObjectViews: [UIView]?
    
    internal var _panStartPoint: CGPoint = .zero
    internal var _panStartZoom: CGFloat = 0.0
    
    internal var focusView: FocusIndicatorView?
    
    internal var previewView: UIView?
    
    var audioPlayer : AVAudioPlayer?
    
    var speedToggleState = 1
    var flashToggleState = 1
    
    var camType = "back"
//    fileprivate var player = Player()
    
    var videoLengthSec = 15.0
    
     @IBOutlet weak var progressBar: GTProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.navigationBar.isHidden = false
        
        UserDefaults.standard.set("", forKey: "url")
        self.progressBar.progress = 0
//        loadAudio()
        btnDoneOutlet.isHidden = true
//        self.startMonitoringInternet()
        
//        UserDefaults.standard.set("nil", forKey: "url")
        
        previewDoneBtnsViewOutlet.isHidden = true
        uploadViewOutlet.isHidden = true
        
        previewDoneBtnsViewOutlet.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        devicesChecks()
        tapGesturesToViews()
        configCapSession()
//        previewPlayerSetup()
        
        speedControlView.isHidden = true
//        MARK:- AFTER JK ZOOM
        
//        NextLevel.shared.videoZoomFactor = .infinity
        NextLevel.shared.focusMode = .continuousAutoFocus
        self.focusView = FocusIndicatorView(frame: .zero)

//        self.player.view.snp.makeConstraints({ (make) in
//            make.center.equalTo(self.masterViewOutlet)
//            make.width.height.equalTo(self.masterViewOutlet)
//        })
    }
    
    @IBAction func cross(_ sender: Any) {
        
        if progressBar.progress <= 0.0{
            self.dismiss(animated: true, completion: nil)
        }else{
            actionSheetFunc()
        }
        
    }
    
    
    @IBAction func didTapButton(_ sender: KYShutterButton) {
        
        print("btn tapped")
        switch sender.buttonState {
        case .normal:
            sender.buttonState = .recording
            crossBtn.isHidden = true
            btnDoneOutlet.isHidden = true
            startCapture()
        case .recording:
            sender.buttonState = .normal
            crossBtn.isHidden = false
            btnDoneOutlet.isHidden = false
            pauseCapture()
        }
    }
    
    //    MARK:- GESTURES ON VIEWS
    private func tapGesturesToViews(){
        let flipViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.flipViewAction))
        self.flipViewOutlet.addGestureRecognizer(flipViewgesture)
        
        let galleryViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.UploadGallery(sender:)))
        self.galleryView.addGestureRecognizer(galleryViewgesture)
        
        //            let speedViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.speedViewAction))
        //            self.speedViewOutlet.addGestureRecognizer(speedViewgesture)
        //
        //            let filterViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.filterViewAction))
        //            self.filterViewOutlet.addGestureRecognizer(filterViewgesture)
        //
        //            let beautyViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.beautyViewAction))
        //            self.beautyViewOutlet.addGestureRecognizer(beautyViewgesture)
        //
        //            let timerViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.timerViewAction))
        //            self.timerViewOutlet.addGestureRecognizer(timerViewgesture)
        
        let flashViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.flashViewAction))
        self.flashViewOutlet.addGestureRecognizer(flashViewgesture)
        
        let recordViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.recordViewAction))
        self.recordViewOutlet.addGestureRecognizer(recordViewgesture)
        
        soundsViewOutlet.isUserInteractionEnabled = true
        let soundsViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.soundsViewAction))
        self.soundsViewOutlet.addGestureRecognizer(soundsViewgesture)
        
        //        MARK:- LONG PRESS GESTURE SETUP 12SEP Backup
        //        self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureRecognizer(_:)))
        //        if let recordButton = self.recordViewOutlet,
        //            let longPressGestureRecognizer = self.longPressGestureRecognizer {
        //            recordButton.isUserInteractionEnabled = true
        //            recordButton.sizeToFit()
        //
        //            longPressGestureRecognizer.delegate = self
        //            longPressGestureRecognizer.minimumPressDuration = 0.05
        //            longPressGestureRecognizer.allowableMovement = 1.0
        //            recordButton.addGestureRecognizer(longPressGestureRecognizer)
        //        }
        
        self.focusTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFocusTapGestureRecognizer(_:)))
        if let focusTapGestureRecognizer = self.focusTapGestureRecognizer {
            focusTapGestureRecognizer.delegate = self
            focusTapGestureRecognizer.numberOfTapsRequired = 1
            masterViewOutlet.addGestureRecognizer(focusTapGestureRecognizer)
        }
        
        ////        MARK:- SINGLE TAP GESTURE SETUP
        //        self.singleTapRecord = UITapGestureRecognizer(target: self, action: #selector(singleTapRecordFunc(_:)))
        //        if let singleTapRecord1 = self.singleTapRecord {
        //            singleTapRecord1.delegate = self
        //            singleTapRecord1.numberOfTapsRequired = 1
        //            recordViewOutlet.addGestureRecognizer(singleTapRecord1)
        //
        //        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadAudio), name: NSNotification.Name(rawValue: "loadAudio"), object: nil)
        
        
    }
        /*
        @objc func loadAudioNotification(notification: Notification) {
            if (notification.userInfo?["err"] as? String) != nil {
                print("error: ")
            }else{

                switch self.btnRecordAni.buttonState {
                case .recording:
                    self.btnRecordAni.buttonState = .normal
                    self.crossBtn.isHidden = false
                    self.btnDoneOutlet.isHidden = false
                    
                default:
                    break
                }
                //            self.endCapture()
                self.progressBar.animateTo(progress: CGFloat(0.0))
                let session = NextLevel.shared.session
                session?.reset()
                session?.removeAllClips()
                self.loadAudio()
                
                self.soundsViewOutlet.isUserInteractionEnabled = true
                print("startOver pressed")

            }

            
        }
        
        */
    
    @IBAction func btnSpeedAction(_ sender: Any) {
        speedControlView.isHidden = false
        viewSpeed.isHidden = true
    }
    
    @IBAction func btn2XAction(_ sender: Any) {
        NextLevel.shared.videoConfiguration.timescale = 2
        btnSpeed.setImage(UIImage(named: "2X"), for: .normal)
        speedControlView.isHidden = true
        viewSpeed.isHidden = false
    }
    
    @IBAction func btn1XAction(_ sender: Any) {
        NextLevel.shared.videoConfiguration.timescale = 1
        btnSpeed.setImage(UIImage(named: "1X"), for: .normal)
        speedControlView.isHidden = true
        viewSpeed.isHidden = false
    }
    
    @IBAction func btn7XAction(_ sender: Any) {
        NextLevel.shared.videoConfiguration.timescale = 7
        btnSpeed.setImage(UIImage(named: "7X"), for: .normal)
        speedControlView.isHidden = true
        viewSpeed.isHidden = false
    }
    
    @IBAction func btn5XAction(_ sender: Any) {
        NextLevel.shared.videoConfiguration.timescale = 5
        btnSpeed.setImage(UIImage(named: "5X"), for: .normal)
        speedControlView.isHidden = true
        viewSpeed.isHidden = false
    }
    
    //    MARK:- UIVIEWS ACTIONS
    @objc func flipViewAction(sender : UITapGestureRecognizer) {
        print("flipView tapped")
        generalBtnAni(viewName: flipIconImgView)
        let animator = CoreAnimator(view: flipIconImgView)
        animator.rotate(angle: 180).animate(t: 0.5)
        
        //        self.metadataObjectViews = nil
        if let metadataObjectViews = metadataObjectViews {
            for view in metadataObjectViews {
                view.removeFromSuperview()
            }
            self.metadataObjectViews = nil
        }
        
        NextLevel.shared.flipCaptureDevicePosition()
        
    }
    
    @objc func UploadGallery(sender : UITapGestureRecognizer){
        let obj = storyboard?.instantiateViewController(withIdentifier: "NewPostVC")as! NewPostVC
        Flag = 0
        //        obj.GroupTimeline_Id = gtime_id
        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        naviget.modalPresentationStyle = .overFullScreen
        self.present(naviget, animated: true, completion: nil)
    }
    
//
//        @objc func speedViewAction(sender : UITapGestureRecognizer) {
//            print("speedView tapped")
//            generalBtnAni(viewName: speedIconImgView)
//            if speedToggleState == 1 {
//                speedToggleState = 2
//                speedIconImgView.image = #imageLiteral(resourceName: "speedOffIcon")
//            } else {
//
//                speedToggleState = 1
//                speedIconImgView.image = #imageLiteral(resourceName: "speedOnIcon")
//            }
//
//
//    //        self.endCapture()
//
//        }
//
//        @objc func filterViewAction(sender : UITapGestureRecognizer) {
//            print("filterView tapped")
//            generalBtnAni(viewName: filterIconImgView)
//        }
//
//        @objc func beautyViewAction(sender : UITapGestureRecognizer) {
//            print("beautyView tapped")
//            generalBtnAni(viewName: beautyIconImgView)
//        }
//
//        @objc func timerViewAction(sender : UITapGestureRecognizer) {
//            print("timerView tapped")
//            generalBtnAni(viewName: timerIconImgView)
//        }
//
        @objc func flashViewAction(sender : UITapGestureRecognizer) {
            print("flashView tapped")

            generalBtnAni(viewName: flashIconImgView)
            

            if flashToggleState == 1 {
                flashToggleState = 2
                flashIconImgView.image = #imageLiteral(resourceName: "flash")
                
    //            NextLevel.shared.flashMode = .on
                NextLevel.shared.flashMode = .on
                // Set torchMode
                NextLevel.shared.torchMode = .on
    //            NextLevel.shared.
                

            } else {
            
                flashToggleState = 1
                flashIconImgView.image = #imageLiteral(resourceName: "flashoff")
                NextLevel.shared.flashMode = .off
                NextLevel.shared.torchMode = .off
                
            }
            
        }
        
        @objc func recordViewAction(sender : UITapGestureRecognizer) {
            print("recordView tapped")
            
            UIView.animate(withDuration: 0.6,
            animations: {
                self.recordIconImgView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.recordIconImgView.layer.cornerRadius = 6
            },
            completion: { _ in
                print("done")
            })
        }
        
    //    MARK:- SELECT AUDIO ACTION
        @objc func soundsViewAction(sender : UITapGestureRecognizer) {
            print("sounds view tapped")

            let vc = storyboard?.instantiateViewController(withIdentifier: "soundsViewController") as! soundsViewController
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            
        }
        
    //    MARK:- ANIMATION
        
        func generalBtnAni(viewName:UIImageView)
        {
            UIView.animate(withDuration: 0.2,
            animations: {
                viewName.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                viewName.layer.cornerRadius = 6
            },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    viewName.transform = CGAffineTransform.identity
//                    let nextLevel = NextLevel.shared
//                    NextLevel.shared.videoConfiguration.timescale = 8
                }
            })

        }
        
        
        func soundsMarqueeFunc(){
            
        }
        
    //    MARK:- DEVICE CHECKS
        func devicesChecks(){
            if DeviceType.iPhoneWithHomeButton{
                
                print("view height ",view.frame.height)

                
//                masterViewHeightConstraint.constant = self.view.frame.height/6.5
//                masterCenterYconstraint.constant = self.view.frame.height/30
                masterViewOutlet.layoutIfNeeded()
                masterViewOutlet.layer.cornerRadius = 500

                UIApplication.shared.isStatusBarHidden = true

            }
            
        
        }
        
    //    MARK:- CONFIGURE CAPture SESSION NEXTLEVEL
        
        func configCapSession(){

            self.previewView = UIView(frame: UIScreen.main.bounds)
    //        let screenBounds = masterViewOutlet.bounds
    //        self.previewView = UIView(frame: screenBounds)
            
            print("masterViewOutlet view height", masterViewOutlet.frame.height)
            if let previewView = self.previewView {
                previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                previewView.backgroundColor = UIColor.black
                previewView.layer.cornerRadius = 10
                NextLevel.shared.previewLayer.frame = previewView.bounds
                NextLevel.shared.focusMode = .continuousAutoFocus
                previewView.layer.addSublayer(NextLevel.shared.previewLayer)
                view.insertSubview(previewView, belowSubview: masterViewOutlet)
    //            view.addSubview(previewView)
                self.previewView?.snp.makeConstraints({ (make) in
                    make.center.equalTo(self.masterViewOutlet)
                    make.width.height.equalTo(self.masterViewOutlet)
                })
                
                print("preview view height", previewView.frame.height)
            }

            let nextLevel = NextLevel.shared
            nextLevel.delegate = self
            nextLevel.deviceDelegate = self
            nextLevel.flashDelegate = self
            nextLevel.videoDelegate = self
            nextLevel.photoDelegate = self
            nextLevel.metadataObjectsDelegate = self
                   
           // video configuration
           nextLevel.videoConfiguration.preset = AVCaptureSession.Preset.hd1280x720
           nextLevel.videoConfiguration.bitRate = 5500000
           nextLevel.videoConfiguration.maxKeyFrameInterval = 30
           nextLevel.videoConfiguration.profileLevel = AVVideoProfileLevelH264HighAutoLevel
           
        NextLevel.shared.videoConfiguration.maximumCaptureDuration = CMTimeMakeWithSeconds(videoLengthSec, preferredTimescale: 600)
           
           // audio configuration
           nextLevel.audioConfiguration.bitRate = 96000
            
           // metadata objects configuration
           nextLevel.metadataObjectTypes = [AVMetadataObject.ObjectType.face, AVMetadataObject.ObjectType.qr]
        }
    //    MARK:- VIEWWILL APPEAR
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    //        player.asset = nil

            print("reelviewWillAppearCall")
    //        self.btnDoneOutlet.isHidden = true
    //        soundsViewOutlet.isUserInteractionEnabled = true
            NextLevel.shared.enableAudioInputDevice()
            configCapSession()
    //        cameraAudioPermission()
    //        self.loadAudio()
            devicesChecks()
            cameraAudioPermission()
//            self.startMonitoringInternet()
            self.crossBtn.isHidden = false
            self.btnDoneOutlet.isHidden = false
            
            switch btnRecordAni.buttonState {
            case .recording:
                btnRecordAni.buttonState = .normal
                progressBar.animateTo(progress: 0.0)
                self.crossBtn.isHidden = false
                self.btnDoneOutlet.isHidden = false
            default:
                break
            }
            
            loadAudio()
        }
        
    //    MARK:- LOAD AUDIO
    @objc func loadAudio(){

            if let url = UserDefaults.standard.string(forKey: "url"), let audioUrl = URL(string: url) {
                
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                
                print("destinationUrl: ",destinationUrl)

                audioPlayer?.rate = 1.0;

                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                    print("loaded audio file")
                    //                let nextLevel = NextLevel()
                    //                nextLevel.disableAudioInputDevice()
                    
                    
                    let soundName = UserDefaults.standard.string(forKey: "selectedSongName")
                    
                    soundsLabel.text = soundName
                    soundsLabel.type = .continuous
                    
                } catch {
                    // couldn't load file :(
                    print("CouldNot load audio file")
                }
     
                print("audioPlayer?.duration:- ",audioPlayer?.duration)
                
            }
        }
        
    //MARK:- VIEW DISAPPEAR
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            print("ReelsviewWillDisappear")
            audioPlayer?.pause()
    //        audioPlayer.stop()
            NextLevel.shared.stop()
    //        NextLevel.shared.pause()
        }
        
        
        func cameraAudioPermission(){
            
            if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                do {
                    try NextLevel.shared.start()
                } catch {
                    print("NextLevel, failed to start camera session")
                }
            } else {
                NextLevel.requestAuthorization(forMediaType: AVMediaType.video) { (mediaType, status) in
                    print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                    if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                        NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                        do {
                            let nextLevel = NextLevel.shared
                            try nextLevel.start()
                        } catch {
                            print("NextLevel, failed to start camera session")
                        }
                    } else if status == .notAuthorized {
                        // gracefully handle when audio/video is not authorized
                        print("NextLevel doesn't have authorization for audio or video")
                    }
                }
                NextLevel.requestAuthorization(forMediaType: AVMediaType.audio) { (mediaType, status) in
                    print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                    if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                        NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                        do {
                            let nextLevel = NextLevel.shared
                            try nextLevel.start()
                        } catch {
                            print("NextLevel, failed to start camera session")
                        }
                    } else if status == .notAuthorized {
                        // gracefully handle when audio/video is not authorized
                        print("NextLevel doesn't have authorization for audio or video")
                    }
                }
            }
        }
        
    //    MARK:- BUTTON DONE
        @IBAction func btnDone(_ sender: Any) {
            sessionDoneFunc()
        }
        
    //    func sessionDoneFunc(){
    //        //        let nlS =
    //            if let session = NextLevel.shared.session {
    //
    //                //..
    //
    //                let ncClips = session.clips
    //
    ////                print("session.clips",ncClips[0].url)
    //                // undo
    //    //            session.removeLastClip()
    //
    //                // various editing operations can be done using the NextLevelSession methods
    //
    //                // export
    //                session.mergeClips(usingPreset: AVAssetExportPresetHighestQuality, completionHandler: { (url: URL?, error: Error?) in
    //                    if let _ = url {
    //                        print("urlseesion",url!)
    ////                            NextLevel.shared.previewLayer.isHidden = true
    ////                            self.player.url = url
    ////                             self.player.playFromBeginning()
    ////                            self.player.playbackLoops = true
    //
    //                        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "previewPlayerVC") as! previewPlayerViewController
    //                        vc.url = url
    //                        vc.modalPresentationStyle = .fullScreen
    //                        self.present(vc, animated: true, completion: nil)
    //                        //
    //                    } else if let _ = error {
    //                        //
    //                        print("err",error)
    //                    }
    //                 })
    //
    //            }
    //
    ////        self.endCapture()
    //    }

        func sessionDoneFunc() {
            
          guard let session = NextLevel.shared.session else {
            return
          }

          session.mergeClips(usingPreset: AVAssetExportPresetMediumQuality) { [weak self] (url, error) in
    //        self?.hideLoading()

            guard let strongSelf = self, let url = url, error == nil else {
    //          self?.showAlert(with: error)
//                self?.showToast(message: error as? String ?? "", font: .systemFont(ofSize: 12))
              return
            }
            self?.audioPlayer?.stop()
            let vc =  self?.storyboard?.instantiateViewController(withIdentifier: "previewPlayerViewController") as! previewPlayerViewController
            vc.url = url
            vc.modalPresentationStyle = .overFullScreen
            self?.present(vc, animated: true, completion: nil)
          }
        }

}

// MARK: - library

extension CreateReelsVC {
    
    internal func albumAssetCollection(withTitle title: String) -> PHAssetCollection? {
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        let options = PHFetchOptions()
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if result.count > 0 {
            return result.firstObject
        }
        return nil
    }
    
}

// MARK: - capture

extension CreateReelsVC {
    
    internal func startCapture() {
        flipViewOutlet.isHidden = true
        flashViewOutlet.isHidden = true
        speedControlView.isHidden = true
        self.btnSpeed.isHidden = true
        
        audioPlayer?.play()
        print("audioPlayer?.currentTime:- ",audioPlayer?.currentTime)
        
//        NextLevel.shared.automaticallyConfiguresApplicationAudioSession = true
        self.photoTapGestureRecognizer?.isEnabled = false
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
            self.recordIconImgView?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (completed: Bool) in
        }
        NextLevel.shared.record()
        self.uploadViewOutlet.isHidden = true
        self.previewDoneBtnsViewOutlet.isHidden = false
    }
    
    internal func pauseCapture() {
        flipViewOutlet.isHidden = false
        flashViewOutlet.isHidden = false
       // speedControlView.isHidden = false
        self.btnSpeed.isHidden = false
        
        self.audioPlayer?.pause()
        NextLevel.shared.pause()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.recordIconImgView?.transform = .identity

//            var arrAudioTimes = [String]()
//
//            let timeBreak = "\(self.audioPlayer!.currentTime)"
//            arrAudioTimes.append(timeBreak)
            
        }) { (completed: Bool) in
            
        }

    }
    
    internal func endCapture() {
        self.photoTapGestureRecognizer?.isEnabled = true
        self.audioPlayer?.stop()
        
        if let session = NextLevel.shared.session {

            if session.clips.count > 1 {
                session.mergeClips(usingPreset: AVAssetExportPresetHighestQuality, completionHandler: { (url: URL?, error: Error?) in
                    if let url = url {
                        
                        self.saveVideo(withURL: url)
                    } else if let _ = error {
                        print("failed to merge clips at the end of capture \(String(describing: error))")
                    }
                })
            } else if let lastClipUrl = session.lastClipUrl {
                self.saveVideo(withURL: lastClipUrl)
            } else if session.currentClipHasStarted {
                session.endClip(completionHandler: { (clip, error) in
                    if error == nil {
                        self.saveVideo(withURL: (clip?.url)!)
                    } else {
                        print("Error saving video: \(error?.localizedDescription ?? "")")
                    }
                })
            } else {
                // prompt that the video has been saved
                let alertController = UIAlertController(title: "Video Capture", message: "Not enough video captured!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        
        }
        
    }
    
    internal func authorizePhotoLibaryIfNecessary() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .restricted:
            fallthrough
        case .denied:
            let alertController = UIAlertController(title: "Oh no!", message: "Access denied.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    
                } else {
                    
                }
            })
            break
        case .authorized:
            break
        @unknown default:
            fatalError("unknown authorization type")
        }
    }
    
}


// MARK: - media utilities

extension CreateReelsVC {
    
    internal func saveVideo(withURL url: URL) {
        PHPhotoLibrary.shared().performChanges({
            let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle)
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NextLevelAlbumTitle)
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }}, completionHandler: { (success1: Bool, error1: Error?) in
                if let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle) {
                    PHPhotoLibrary.shared().performChanges({
                        if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url) {
                            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                            let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                            assetCollectionChangeRequest?.addAssets(enumeration)
                        }
                    }, completionHandler: { (success2: Bool, error2: Error?) in
                    if success2 == true {
                        // prompt that the video has been saved
                        let alertController = UIAlertController(title: "Video Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        // prompt that the video has been saved
                        let alertController = UIAlertController(title: "Oops!", message: "Something failed!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }
        })
    }
    
    internal func savePhoto(photoImage: UIImage) {
        let NextLevelAlbumTitle = "NextLevel"
        
        PHPhotoLibrary.shared().performChanges({
            
            let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle)
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NextLevelAlbumTitle)
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }
            
        }, completionHandler: { (success1: Bool, error1: Error?) in
            
            if success1 == true {
                if let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle) {
                    PHPhotoLibrary.shared().performChanges({
                        let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                        let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                        let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                        assetCollectionChangeRequest?.addAssets(enumeration)
                    }, completionHandler: { (success2: Bool, error2: Error?) in
                        if success2 == true {
                            let alertController = UIAlertController(title: "Photo Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
            } else if let _ = error1 {
                print("failure capturing photo from video frame \(String(describing: error1))")
            }
            
        })
    }
    
    
}

// MARK: - UIGestureRecognizerDelegate

extension CreateReelsVC: UIGestureRecognizerDelegate {
    
    @objc internal func handleLongPressGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
//            btnRecordAni.buttonState = .recording
            self.startCapture()
            self._panStartPoint = gestureRecognizer.location(in: self.view)
            self._panStartZoom = CGFloat(NextLevel.shared.videoZoomFactor)
            break
        case .changed:
            let newPoint = gestureRecognizer.location(in: self.view)
            let scale = (self._panStartPoint.y / newPoint.y)
            let newZoom = (scale * self._panStartZoom)
            NextLevel.shared.videoZoomFactor = Float(newZoom)
            break
        case .ended:
            fallthrough
        case .cancelled:
            fallthrough
        case .failed:
            self.pauseCapture()
            fallthrough
        default:
            break
        }
    }
}

extension CreateReelsVC {
    
    internal func handlePhotoTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        // play system camera shutter sound
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
        NextLevel.shared.capturePhotoFromVideo()
    }
    
    @objc internal func handleFocusTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        let tapPoint = gestureRecognizer.location(in: self.previewView)
        
        if let focusView = self.focusView {
            var focusFrame = focusView.frame
            focusFrame.origin.x = CGFloat((tapPoint.x - (focusFrame.size.width * 0.5)).rounded())
            focusFrame.origin.y = CGFloat((tapPoint.y - (focusFrame.size.height * 0.5)).rounded())
            focusView.frame = focusFrame
            
            self.previewView?.addSubview(focusView)
//            focusView.startAnimation()
        }
        
        let adjustedPoint = NextLevel.shared.previewLayer.captureDevicePointConverted(fromLayerPoint: tapPoint)
        NextLevel.shared.focusExposeAndAdjustWhiteBalance(atAdjustedPoint: adjustedPoint)
    }
//    @objc internal func singleTapRecordFunc(_ gestureRecognizer: UIGestureRecognizer) {
//        print("btn tapped")
//        switch btnRecordAni.buttonState {
//        case .normal:
//            btnRecordAni.buttonState = .recording
//        case .recording:
//            btnRecordAni.buttonState = .normal
//        default:
//            break
//        }
//
//    }
    


// MARK:- ACTION SHEET FOR CROSS BUTTON
    func actionSheetFunc(){
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // create an action
        let startOver: UIAlertAction = UIAlertAction(title: "Start over", style: .default) { action -> Void in
            switch self.btnRecordAni.buttonState {
            case .recording:
                self.btnRecordAni.buttonState = .normal
                self.crossBtn.isHidden = false
                self.btnDoneOutlet.isHidden = false
                
            default:
                break
            }
//            self.endCapture()
            self.progressBar.animateTo(progress: CGFloat(0.0))
            let session = NextLevel.shared.session
            session?.reset()
            session?.removeAllClips()
            self.loadAudio()
            
            self.soundsViewOutlet.isUserInteractionEnabled = true
            print("startOver pressed")
        }

        let discard: UIAlertAction = UIAlertAction(title: "Discard", style: .default) { action -> Void in

            switch self.btnRecordAni.buttonState {
            case .recording:
                self.btnRecordAni.buttonState = .normal
                self.crossBtn.isHidden = false
                self.btnDoneOutlet.isHidden = false
                
            default:
                break
            }
            //            self.endCapture()
            self.progressBar.animateTo(progress: CGFloat(0.0))
            let session = NextLevel.shared.session
            session?.reset()
            session?.removeAllClips()
//            self.loadAudio()
            
            self.soundsViewOutlet.isUserInteractionEnabled = true
            print("Discard Action pressed")
            self.dismiss(animated: true, completion: nil)
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

        startOver.setValue(UIColor.red, forKey: "titleTextColor")      // add actions
        actionSheetController.addAction(startOver)
        actionSheetController.addAction(discard)
        actionSheetController.addAction(cancelAction)


        // present an actionSheet...
        // present(actionSheetController, animated: true, completion: nil)   // doesn't work for iPad

        actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad

        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
    }
    
    

    
    
}

// MARK: - NextLevelDelegate

extension CreateReelsVC: NextLevelDelegate {
    
    // permission
    func nextLevel(_ nextLevel: NextLevel, didUpdateAuthorizationStatus status: NextLevelAuthorizationStatus, forMediaType mediaType: AVMediaType) {
    }
    
    // configuration
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoConfiguration videoConfiguration: NextLevelVideoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didUpdateAudioConfiguration audioConfiguration: NextLevelAudioConfiguration) {
    }
    
    // session
    func nextLevelSessionWillStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionWillStart")
        
    }
    
    func nextLevelSessionDidStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStart")
    }
    
    func nextLevelSessionDidStop(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStop")
    }
    
    // interruption
    func nextLevelSessionWasInterrupted(_ nextLevel: NextLevel) {
    }
    
    func nextLevelSessionInterruptionEnded(_ nextLevel: NextLevel) {
    }
    
    // mode
    func nextLevelCaptureModeWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelCaptureModeDidChange(_ nextLevel: NextLevel) {
    }
    
}

extension CreateReelsVC: NextLevelPreviewDelegate {
    
    // preview
    func nextLevelWillStartPreview(_ nextLevel: NextLevel) {
        print("nextLevelWillStartPreview")
    }
    
    func nextLevelDidStopPreview(_ nextLevel: NextLevel) {
        print("nextLevelDidStopPreview")
    }
    
}

extension CreateReelsVC: NextLevelDeviceDelegate {
    
    // position, orientation
    func nextLevelDevicePositionWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDevicePositionDidChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceOrientation deviceOrientation: NextLevelDeviceOrientation) {
    }
    
    // format
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceFormat deviceFormat: AVCaptureDevice.Format) {
    }
    
    // aperture
    func nextLevel(_ nextLevel: NextLevel, didChangeCleanAperture cleanAperture: CGRect) {
    }
    
    // lens
    func nextLevel(_ nextLevel: NextLevel, didChangeLensPosition lensPosition: Float) {
    }
    
    // focus, exposure, white balance
    func nextLevelWillStartFocus(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidStopFocus(_  nextLevel: NextLevel) {
        if let focusView = self.focusView {
            if focusView.superview != nil {
//                focusView.stopAnimation()
            }
        }
    }
    
    func nextLevelWillChangeExposure(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeExposure(_ nextLevel: NextLevel) {
        if let focusView = self.focusView {
            if focusView.superview != nil {
//                focusView.stopAnimation()
            }
        }
    }
    
    func nextLevelWillChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
}

// MARK: - NextLevelFlashDelegate

extension CreateReelsVC: NextLevelFlashAndTorchDelegate {
    
    func nextLevelDidChangeFlashMode(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeTorchMode(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashActiveChanged(_ nextLevel: NextLevel) {
        
        
    }
    
    func nextLevelTorchActiveChanged(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashAndTorchAvailabilityChanged(_ nextLevel: NextLevel) {
    }
    
}

// MARK: - NextLevelVideoDelegate

extension CreateReelsVC: NextLevelVideoDelegate {
    func nextLevel(_ nextLevel: NextLevel, willProcessFrame frame: AnyObject, timestamp: TimeInterval, onQueue queue: DispatchQueue) {
        "print"
    }
    
    
    // video zoom
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoZoomFactor videoZoomFactor: Float) {
    }
    
    // video frame processing
    func nextLevel(_ nextLevel: NextLevel, willProcessRawVideoSampleBuffer sampleBuffer: CMSampleBuffer, onQueue queue: DispatchQueue) {
    }
    
    @available(iOS 11.0, *)
    func nextLevel(_ nextLevel: NextLevel, willProcessFrame frame: AnyObject, pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, onQueue queue: DispatchQueue) {
    }
    
    // enabled by isCustomContextVideoRenderingEnabled
    func nextLevel(_ nextLevel: NextLevel, renderToCustomContextWithImageBuffer imageBuffer: CVPixelBuffer, onQueue queue: DispatchQueue) {
    }
    
    // video recording session
    func nextLevel(_ nextLevel: NextLevel, didSetupVideoInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSetupAudioInSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didStartClipInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteClip clip: NextLevelClip, inSession session: NextLevelSession){
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
        
        let currentProgress = (session.totalDuration.seconds / videoLengthSec).clamped(to: 0...1)
        self.progressBar.animateTo(progress: CGFloat(currentProgress)) {
            print("progress done at:- ",currentProgress)
//            self.progressBar.barFillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        if currentProgress == 1.0 {
            sessionDoneFunc()
        }
        
        if currentProgress > 0.0 {
            soundsViewOutlet.isUserInteractionEnabled = false
        }
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteSession session: NextLevelSession) {
        // called when a configuration time limit is specified
//        self.endCapture()
        sessionDoneFunc()
    }
    
    // video frame photo
    
    func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String : Any]?) {
        
        if let dictionary = photoDict,
            let photoData = dictionary[NextLevelPhotoJPEGKey] {
            
            PHPhotoLibrary.shared().performChanges({
                
                let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle)
                if albumAssetCollection == nil {
                    let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NextLevelAlbumTitle)
                    let _ = changeRequest.placeholderForCreatedAssetCollection
                }
                
            }, completionHandler: { (success1: Bool, error1: Error?) in
                
                if success1 == true {
                    if let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle) {
                        PHPhotoLibrary.shared().performChanges({
                            if let data = photoData as? Data,
                                let photoImage = UIImage(data: data) {
                                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                                let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                                let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                                assetCollectionChangeRequest?.addAssets(enumeration)
                            }
                        }, completionHandler: { (success2: Bool, error2: Error?) in
                            if success2 == true {
                                let alertController = UIAlertController(title: "Photo Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })
                    }
                } else if let _ = error1 {
                    print("failure capturing photo from video frame \(String(describing: error1))")
                }
                
            })
            
        }
        
    }
    
}

// MARK: - NextLevelPhotoDelegate

extension CreateReelsVC: NextLevelPhotoDelegate {
    
    // photo
    func nextLevel(_ nextLevel: NextLevel, willCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
        
        if let dictionary = photoDict,
            let photoData = dictionary[NextLevelPhotoJPEGKey] {
            
            PHPhotoLibrary.shared().performChanges({
                
                let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle)
                if albumAssetCollection == nil {
                    let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NextLevelAlbumTitle)
                    let _ = changeRequest.placeholderForCreatedAssetCollection
                }
                
            }, completionHandler: { (success1: Bool, error1: Error?) in
                
                if success1 == true {
                    if let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle) {
                        PHPhotoLibrary.shared().performChanges({
                            if let data = photoData as? Data,
                                let photoImage = UIImage(data: data) {
                                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                                let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                                let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                                assetCollectionChangeRequest?.addAssets(enumeration)
                            }
                        }, completionHandler: { (success2: Bool, error2: Error?) in
                            if success2 == true {
                                let alertController = UIAlertController(title: "Photo Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })
                    }
                } else if let _ = error1 {
                    print("failure capturing photo from video frame \(String(describing: error1))")
                }
                
            })
        }
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessRawPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevelDidCompletePhotoCapture(_ nextLevel: NextLevel) {
    }
    
    @available(iOS 11.0, *)
    func nextLevel(_ nextLevel: NextLevel, didFinishProcessingPhoto photo: AVCapturePhoto) {
    }
    
}

// MARK: - KVO

private var CameraViewControllerNextLevelCurrentDeviceObserverContext = "CameraViewControllerNextLevelCurrentDeviceObserverContext"

extension CreateReelsVC {
    
    internal func addKeyValueObservers() {
        self.addObserver(self, forKeyPath: "currentDevice", options: [.new], context: &CameraViewControllerNextLevelCurrentDeviceObserverContext)
    }
    
    internal func removeKeyValueObservers() {
        self.removeObserver(self, forKeyPath: "currentDevice")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &CameraViewControllerNextLevelCurrentDeviceObserverContext {
            //self.captureDeviceDidChange()
        }
    }
    
}

extension CreateReelsVC: NextLevelMetadataOutputObjectsDelegate {
    
    func metadataOutputObjects(_ nextLevel: NextLevel, didOutput metadataObjects: [AVMetadataObject]) {
        guard let previewView = self.previewView else {
            return
        }
        
        if let metadataObjectViews = metadataObjectViews {
            for view in metadataObjectViews {
                view.removeFromSuperview()
            }
            self.metadataObjectViews = nil
        }
        
        self.metadataObjectViews = metadataObjects.map { metadataObject in
            let view = UIView(frame: metadataObject.bounds)
            view.backgroundColor = UIColor.clear
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 1
            return view
        }
        
        if let metadataObjectViews = self.metadataObjectViews {
            for view in metadataObjectViews {
                previewView.addSubview(view)
            }
        }
    }
}


extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 175, y: self.view.frame.size.height*0.12, width: 350, height: 40))
        //    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.backgroundColor = #colorLiteral(red: 0.3129099309, green: 0.3177284598, blue: 0.3219906092, alpha: 0.8590539384)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 2;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
        //    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
        //        var height = 100;
        ////        toastLabel.frame = new CGRect(View.Frame.Left, view.Frame.Y - height , view.Superview.Frame.Right, height);
        //        toastLabel.frame = CGRect(x: toastLabel.frame.origin.x, y: self.view.frame.size.height-440, width: toastLabel.frame.width, height: toastLabel.frame.height)
        //
        //    }) { (comp) in
        //        sleep(2)
        //        toastLabel.removeFromSuperview()
        //    }
    }
    
}


extension UIImage {

    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
