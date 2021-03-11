//
//  HomeVCCell.swift
//  FriendzPoint
//
//  Created by Anques on 12/02/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import FSPagerView
import AVFoundation
import ActiveLabel
import TTTAttributedLabel

class HomeVCCell: UITableViewCell,ASAutoPlayVideoLayerContainer {
    
//    @IBOutlet weak var lblDetailHeight: NSLayoutConstraint!
//    @IBOutlet weak var viewtopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblDetails: ActiveLabel!
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

//    @IBOutlet weak var btnTimerLeading: NSLayoutConstraint!
    @IBOutlet weak var btnStatusWidth: NSLayoutConstraint!
    @IBOutlet weak var likeViewHeight: NSLayoutConstraint!
    var arrFeed1 = [MyTimelineList]()
    @IBOutlet weak var imageviewBackground: UIImageView!
    @IBOutlet weak var imageview: UIImageView!
    
//    @IBOutlet weak var bottomVIew: UIView!
//    {
//        didSet{
////            bottomVIew.backgroundColor = .white
////            bottomVIew.clipsToBounds = true
////            bottomVIew.layer.cornerRadius = 15
////            bottomVIew.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
////            bottomVIew.backgroundColor = UIColor.black.withAlphaComponent(0.30)
//
//            bottomVIew.layer.shadowOpacity = 0.5
////            bottomVIew.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
////            bottomVIew.layer.shadowRadius = 15.0
//            bottomVIew.layer.shadowOffset = CGSize(width: 0, height: 3)
//            bottomVIew.layer.shadowColor = UIColor.black.cgColor
//
//        }
//    }
    
    @IBOutlet weak var img1: UIImageView!{
        didSet{
            img1.layer.cornerRadius = img1.frame.height/2
            img1.clipsToBounds = true
            img1.layer.borderWidth = 1
            img1.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var img2: UIImageView!{
        didSet{
            img2.layer.cornerRadius = img2.frame.height/2
            img2.clipsToBounds = true
            img2.layer.borderWidth = 1
            img2.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var img3: UIImageView!{
        didSet{
            img3.layer.cornerRadius = img3.frame.height/2
            img3.clipsToBounds = true
            img3.layer.borderWidth = 1
            img3.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var img4: UIImageView!{
        didSet{
            img4.layer.cornerRadius = img4.frame.height/2
            img4.clipsToBounds = true
            img4.layer.borderWidth = 1
            img4.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    
    @IBOutlet weak var lbldetailsBottom: NSLayoutConstraint!
    @IBOutlet weak var btnmoreHeight: NSLayoutConstraint!
    @IBOutlet weak var lblLikeDescription: UILabel!
    
    @IBOutlet weak var profileView: shadowView!
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.clipsToBounds = true
            imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        }
    }
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet var btnStatus: UIButton!
    {
        didSet{
//            btnStatus.layer.cornerRadius = btnStatus.frame.height/2
//            btnStatus.clipsToBounds = true
//            btnStatus.indicator = LineSpinFadeLoader(color: .black)
            btnStatus.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    //MARK: For Button
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var btnDisLike: UIButton!
    
    @IBOutlet weak var btnChat: UIButton!
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnMenu: UIButton!
    
//    @IBOutlet weak var btnLocationWidth: NSLayoutConstraint!
    
    
//    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth1: NSLayoutConstraint!
    @IBOutlet weak var imgWidth2: NSLayoutConstraint!
    @IBOutlet weak var imgWidth3: NSLayoutConstraint!
    @IBOutlet weak var imgWidth4: NSLayoutConstraint!
    
    @IBOutlet weak var viewpeople: UIView!
    @IBOutlet weak var ButtonView: UIView!
    
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
        }
    }
    @IBOutlet weak var btnmore: UIButton!
    
    @IBOutlet weak var lblTag: ActiveLabel!
    @IBOutlet weak var countView: UIView!{
        didSet{
            countView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            countView.layer.cornerRadius = countView.frame.height/2
            countView.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblTimeLeading: NSLayoutConstraint!
    @IBOutlet weak var lblPageCount: UILabel!
    var images = [String]()
    
    @IBOutlet weak var dotView: UIView!{
        didSet{
            dotView.layer.cornerRadius = dotView.frame.height/2
            dotView.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblDetailsTop: NSLayoutConstraint!
    @IBOutlet weak var shotImageView: UIImageView!
     
    @IBOutlet weak var lblDetailHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnClick: UIButton!
    
    @IBOutlet weak var lblTagBottom: NSLayoutConstraint!
    
    @IBOutlet weak var btnProfileClick: UIButton!
    @IBOutlet weak var btnUserNameClick: UIButton!
    
    @IBOutlet weak var btnLikeClick: UIButton!
    
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblDislikeCount: UILabel!
    
    var shadowimg = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(Videopause(_:)), name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        shotImageView.layer.cornerRadius = 5
        shotImageView.backgroundColor = UIColor.black//UIColor.gray.withAlphaComponent(0.7)
        shotImageView.clipsToBounds = true
        shotImageView.layer.borderColor = UIColor.black.cgColor//UIColor.gray.withAlphaComponent(0.3).cgColor
        shotImageView.layer.borderWidth = 0.5
        videoLayer.backgroundColor = UIColor.black.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect//resize
        shotImageView.layer.addSublayer(videoLayer)
        selectionStyle = .none
        blurImage(img: imageviewBackground)
        pagerView.addSubview(countView)
        pagerView.delegate = self
        pagerView.dataSource = self
        
        shadowimg.frame = CGRect(x: 0, y: 0, width: imageview.frame.width, height: imageview.frame.height)
//        shadowimg.contentMode = .scaleAspectFill
        shadowimg.image = UIImage(named: "shadowimg")
        pagerView.addSubview(shadowimg)
        shadowimg.contentMode = .center
        
//        ButtonView.addSubview(btnMenu)
        pagerView.addSubview(btnClick)
        pagerView.addSubview(ButtonView)
        pagerView.addSubview(viewpeople)
//        pagerView.addSubview(btnMenu)
        pagerView.addSubview(btnmore)
        pagerView.addSubview(profileView)
        pagerView.addSubview(btnUserNameClick)
        pagerView.addSubview(btnStatus)
        pagerView.addSubview(lblUserName)
        pagerView.addSubview(lblDetails)
        pagerView.addSubview(lblTag)
    }
    func blurImage(img:UIImageView){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = img.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        img.addSubview(blurEffectView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: For Video
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
//        self.descriptionLabel.text = description
        self.shotImageView.imageURL = imageUrl
        self.videoURL = videoUrl
        ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: videoLayer, url: videoURL ?? "")
    }

    override func prepareForReuse() {
        shotImageView.imageURL = nil
        super.prepareForReuse()
    }
    
    @objc func Videopause(_ notification: NSNotification) {
//        videoLayer.player?.pause()
        
        ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: videoLayer, url: self.videoURL ?? "")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin: CGFloat = 20
        let width: CGFloat = bounds.size.width - horizontalMargin * 2
        let height: CGFloat = (width * 0.9).rounded(.up)
        videoLayer.frame = CGRect(x: 0, y: 0, width: shotImageView.frame.size.width, height: shotImageView.frame.size.height)
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(shotImageView.frame, from: shotImageView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
}


extension HomeVCCell: FSPagerViewDataSource,FSPagerViewDelegate{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        //        cell.imageView?.image = UIImage(named: self.images[index])
        cell.imageView?.kf.setImage(with: URL(string: self.images[index]),placeholder:UIImage(named: "Placeholder"))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        //        cell.textLabel?.text = index.description+index.description
        return cell
    }
    // MARK:- FSPagerView Delegate
    
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        pagerView.deselectItem(at: index, animated: true)
//        pagerView.scrollToItem(at: index, animated: true)
//        print("PageTag: ",pagerView.tag)
//        print("images: ",images)
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let obj = storyboard.instantiateViewController(withIdentifier: "PreviewVC")as! PreviewVC
//        let naviget = UINavigationController()// = UINavigationController(rootViewController: obj)
//        obj.images = images
//        obj.type = "multi_image"
//        naviget.pushViewController(obj, animated: true)
//        
//        
//    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        self.pageControl.currentPage = targetIndex
        lblPageCount.text = String(targetIndex+1) + "/" + String(images.count)
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
//        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    
    
}
