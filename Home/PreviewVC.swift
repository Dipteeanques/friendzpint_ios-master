//
//  PreviewVC.swift
//  FriendzPoint
//
//  Created by Anques on 13/02/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import FSPagerView
import AVFoundation

class PreviewVC: UIViewController,ASAutoPlayVideoLayerContainer,UIScrollViewDelegate{

    @IBOutlet weak var imageviewBackground: UIImageView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var shotImageView: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
        }
    }
    
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
            btnBack.setImage(image, for: .normal)
            btnBack.tintColor = UIColor.white
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var countView: UIView!{
        didSet{
            countView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            countView.layer.cornerRadius = countView.frame.height/2
            countView.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblPageCount: UILabel!
    
    @IBOutlet weak var PlayView: UIView!{
        didSet{
            PlayView.layer.cornerRadius = PlayView.frame.height/2
            PlayView.clipsToBounds = true
            PlayView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
    
    
    @IBOutlet weak var btnTime: UIButton!
    
    @IBOutlet weak var sliderplay: UISlider!
    
    var images = [String]()
    
    var type = String()
    var source_url = String()
    var video_poster = String()
    
    //MARK: For Video Player
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
//        scrollView.removeFromSuperview()
//        imageview.removeFromSuperview()
//        navigationController?.setStatusBar(backgroundColor: .black)'
//        modalPresentationCapturesStatusBarAppearance = false
//        setStatusBar1(backgroundColor: .black)
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1

        
       
        
//            let seconds : Float64 = CMTimeGetSeconds(duration)
        
        scrollView.delegate = self
        scrollView.frame = CGRect(x: self.pagerView.frame.origin.x, y: self.pagerView.frame.origin.y, width: self.pagerView.frame.width, height: self.pagerView.frame.height)

        imageview.frame = CGRect(x: self.pagerView.frame.origin.x, y: self.pagerView.frame.origin.y, width: self.pagerView.frame.width, height: self.pagerView.frame.height)
        self.scrollView.addSubview(imageview)
        imageview.contentMode = .scaleAspectFit
        self.pagerView.addSubview(scrollView)
  
//        print("currentTabBar?.tabBarHeight: ß",currentTabBar?.tabBarHeight)
//        currentTabBar?.tabBarHeight = 0
//        currentTabBar?.setBar(hidden: true, animated: false)
//        currentTabBar?.hidesBottomBarWhenPushed = true
//        currentTabBar?.tabBarController?.tabBar.isHidden = true
//        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationBar.barStyle = .black
        
//        tabBarController?.tabBar.isHidden = true
        shotImageView.imageURL = nil
        videoLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        shotImageView.layer.cornerRadius = 5
        shotImageView.backgroundColor = UIColor.black//UIColor.gray.withAlphaComponent(0.7)
        shotImageView.clipsToBounds = true
        shotImageView.layer.borderColor = UIColor.black.cgColor//UIColor.gray.withAlphaComponent(0.3).cgColor
        shotImageView.layer.borderWidth = 0.5
        videoLayer.backgroundColor = UIColor.black.cgColor//UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect//AVLayerVideoGravity.resizeAspect
        shotImageView.layer.addSublayer(videoLayer)
       
        blurImage(img: imageviewBackground)
        pagerView.addSubview(countView)
        pagerView.delegate = self
        pagerView.dataSource = self
        
        pagerView.addSubview(btnBack)
        pagerView.addSubview(imgLogo)
        pagerView.addSubview(PlayView)
        
        setDefault()
        self.navigationController?.navigationBar.isHidden = true
        

//        setStatusBar1(backgroundColor: .black)
    }
    
    
    @IBAction func btnPlayPause(_ sender: UIButton) {
        if videoLayer.player?.rate == 0
        {
            videoLayer.player!.play()
            //playButton!.setImage(UIImage(named: "player_control_pause_50px.png"), forState: UIControlState.Normal)
//            sender.setTitle("Pause", for: UIControl.State.normal)
            sender.setImage(UIImage(named: "Pause"), for: .normal)
        } else {
            videoLayer.player!.pause()
            //playButton!.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
//            sender.setTitle("Play", for: UIControl.State.normal)
            sender.setImage(UIImage(named: "Play"), for: .normal)
        }
    }
    
    @IBAction func btnMute(_ sender: UIButton) {
        
        if videoLayer.player?.isMuted == true{
//            sender.setTitle("unmute", for: UIControl.State.normal)
            sender.setImage(UIImage(named: "Unmute"), for: .normal)
            videoLayer.player?.isMuted = false
        }
        else{
//            sender.setTitle("mute", for: UIControl.State.normal)
            sender.setImage(UIImage(named: "Mute"), for: .normal)
            videoLayer.player?.isMuted = true
        }
        
        
    }
    //    override func viewWillAppear(_ animated: Bool) {
////        navigationController?.setStatusBar(backgroundColor: .black)
//            //Change status bar color
//        setStatusBar1(backgroundColor: .black)
//        navigationController?.setStatusBar(backgroundColor: .black)
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setNeedsStatusBarAppearanceUpdate()
//    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        .lightContent
//    }

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageview
    }
    

    func setDefault(){
        switch type {
        case "image":
//
            PlayView.isHidden = true
//                cell.btnclick.isHidden = false
            countView.isHidden = true
//                cell.pagerView.isHidden = true
//                cell.pageControl.isHidden = true
            scrollView.isHidden = false
            imageview.isHidden = false
            imageviewBackground.isHidden = false
            shotImageView.isHidden = true
//                cell.btn_play.isHidden = true
//                cell.imageview.contentMode = .scaleAspectFit
           images = []
            pagerView.reloadData()

            
              imageviewBackground.kf.setImage(with: URL(string: source_url),placeholder:UIImage(named: "Placeholder"))
//                    blurImage(img: cell.imageviewBackground)
                
               imageview.kf.setImage(with: URL(string: source_url),placeholder:UIImage(named: "Placeholder"))
           
            
        
            break

        case "multi_image" :

            PlayView.isHidden = true
          countView.isHidden = false
            scrollView.isHidden = true
//                cell.pageControl.isHidden = true
//                cell.pagerView.isHidden = false
           shotImageView.isHidden = true
          imageview.isHidden = true
           imageviewBackground.isHidden = false
//                cell.btn_play.isHidden = true
//                cell.countView.isHidden = false
//           images = arrFeed[indexPath.row].images
//                cell.pageControl.numberOfPages = arrFeed[indexPath.row].images.count
           lblPageCount.text = "1" + "/" + String(images.count)
//                cell.btnclick.isHidden = true
           pagerView.reloadData()
            break

        case "video":
            PlayView.isHidden = false
            timer1 = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)

            images = []
            pagerView.reloadData()
//                cell.btnclick.isHidden = false
//                cell.pagerView.isHidden = true
//                cell.pageControl.isHidden = true
            scrollView.isHidden = true
          imageview.isHidden = true
          imageviewBackground.isHidden = false
//                cell.btn_play.isHidden = false
        countView.isHidden = true
            shotImageView.isHidden = false
//                cell.imageview.contentMode = .scaleToFill
//                cell.imageview.layer.cornerRadius = 5
//                cell.imageview.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
//                cell.imageview.clipsToBounds = true
//                cell.imageview.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
//                cell.imageview.layer.borderWidth = 0.5
//                cell.videoLayer.backgroundColor = UIColor.black.cgColor
//                cell.videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                cell.imageview.layer.addSublayer(cell.videoLayer)
//                cell.selectionStyle = .none
            
//            let asset = AVURLAsset(url: URL(string: source_url)!)
//            let durationInSeconds = asset.duration.seconds
//            print("durationInSeconds: ",durationInSeconds)
               configureCell(imageUrl:video_poster, description: "Video", videoUrl:source_url)
//            let duration = videoLayer.player?.currentItem?.asset.duration.seconds
//            print("duration: ",duration)
            
           
              //  lblcurrentText.text = self.stringFromTimeInterval(interval: seconds)
            
            
            sliderplay.minimumValue = 0
                    
                    
            let duration : CMTime = (videoLayer.player?.currentItem?.asset.duration)!
            let seconds1 : Float64 = CMTimeGetSeconds(duration)
                    
            sliderplay.maximumValue = Float(seconds1)
            sliderplay.isContinuous = true
//            sliderplay.tintColor = UIColor.green
//
            sliderplay.addTarget(self, action: #selector(self.handlePlayheadSliderTouchBegin), for: .touchDown)
            sliderplay.addTarget(self, action:    #selector(self.handlePlayheadSliderTouchEnd), for: .touchUpInside)
            sliderplay.addTarget(self, action: #selector(self.handlePlayheadSliderTouchEnd), for: .touchUpOutside)
            sliderplay.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)
            

            
            break
        default:
            break
        }
    }
    
    @objc func updateSlider() {
        let duration1 : CMTime = (videoLayer.player?.currentTime())!
            let seconds : Float64 = CMTimeGetSeconds(duration1)

        btnTime.setTitle(self.stringFromTimeInterval(interval: seconds))
        
//        let duration : CMTime = (videoLayer.player?.currentItem!.asset.duration)!
//        let seconds1 : Float64 = CMTimeGetSeconds(duration) * Double(sliderplay.value)
//     //   var newCurrentTime: TimeInterval = sender.value * CMTimeGetSeconds(currentPlayer.currentItem.duration)
//    //lblcurrentText.text = self.stringFromTimeInterval(interval: seconds)
//        btnTime.setTitle(self.stringFromTimeInterval(interval: seconds1))
//
//        let second : Int64 = Int64(sliderplay.value)
//             let targetTime:CMTime = CMTimeMake(value: second, timescale: 1)
             
        sliderplay.value = Float(seconds)
//        videoLayer.player?.seek(to: targetTime)
//
//             if  videoLayer.player!.rate == 0
//             {
////                videoLayer.player?.play()
//             }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {

        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func handlePlayheadSliderTouchBegin(_ sender: UISlider) {
        videoLayer.player?.pause()
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider){

        let duration : CMTime = (videoLayer.player?.currentItem!.asset.duration)!
        let seconds : Float64 = CMTimeGetSeconds(duration) * Double(playbackSlider.value)
     //   var newCurrentTime: TimeInterval = sender.value * CMTimeGetSeconds(currentPlayer.currentItem.duration)
    //lblcurrentText.text = self.stringFromTimeInterval(interval: seconds)
        btnTime.setTitle(self.stringFromTimeInterval(interval: seconds))
        
        let second : Int64 = Int64(sliderplay.value)
             let targetTime:CMTime = CMTimeMake(value: second, timescale: 1)
             
        videoLayer.player?.seek(to: targetTime)
             
             if  videoLayer.player!.rate == 0
             {
                videoLayer.player?.play()
             }
       }
    
    
    
    @IBAction func handlePlayheadSliderTouchEnd(_ sender: UISlider) {

        let duration : CMTime = (videoLayer.player?.currentItem!.asset.duration)!
        let newCurrentTime: TimeInterval = Double(sender.value) * CMTimeGetSeconds(duration)
        let seekToTime: CMTime = CMTimeMakeWithSeconds(newCurrentTime, preferredTimescale: 600)
        videoLayer.player?.seek(to: seekToTime)
   }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBackAction(_ sender: Any) {
       // self.navigationController?.popViewController(animated: true)
        timer1.invalidate()
        ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: videoLayer, url: self.videoURL ?? "")
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension PreviewVC{
    //MARK: For Video
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
//        self.descriptionLabel.text = description
        self.shotImageView.imageURL = imageUrl
        self.videoURL = videoUrl
        ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: videoLayer, url: videoURL ?? "")
    }

    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.view?.superview?.convert(shotImageView.frame, from: shotImageView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = view?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
}

extension PreviewVC: FSPagerViewDataSource,FSPagerViewDelegate{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        //        cell.imageView?.image = UIImage(named: self.images[index])
        cell.imageView?.kf.setImage(with: URL(string: self.images[index]),placeholder:UIImage(named: "Placeholder"))
        imageviewBackground.kf.setImage(with: URL(string:images[0]),placeholder:UIImage(named: "Placeholder"))
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        //        cell.textLabel?.text = index.description+index.description
        return cell
    }
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        self.pageControl.currentPage = targetIndex
        imageviewBackground.kf.setImage(with: URL(string:images[targetIndex]),placeholder:UIImage(named: "Placeholder"))
        lblPageCount.text = String(targetIndex+1) + "/" + String(images.count)
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
//        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    
    
}


//extension UIViewController{
//    func setStatusBar1(backgroundColor: UIColor) {
//        let statusBarFrame: CGRect
//        if #available(iOS 13.0, *) {
//            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
//        } else {
//            statusBarFrame = UIApplication.shared.statusBarFrame
//        }
//        let statusBarView = UIView(frame: statusBarFrame)
//        statusBarView.backgroundColor = UIColor.white//backgroundColor
//        view.addSubview(statusBarView)
//    }
//}
