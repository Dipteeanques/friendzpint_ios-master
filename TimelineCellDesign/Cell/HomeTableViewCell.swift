//
//  HomeTableViewCell.swift
//  FriendzPoint
//
//  Created by Anques on 09/01/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Kingfisher
import FSPagerView
import AVFoundation

class HomeTableViewCell: UITableViewCell {
    
    var btnclick = UIButton()
    
    @IBOutlet weak var imglogo: UIImageView!
    @IBOutlet weak var btnLocationWidth: NSLayoutConstraint!
    
    @IBOutlet weak var btnCamera: UIButton!
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
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    //    @IBOutlet weak var bottomViewTop: NSLayoutConstraint!
    @IBOutlet weak var txtComment: UITextField!{
        didSet{
            txtComment.layer.cornerRadius = 5
            txtComment.clipsToBounds = true
            txtComment.layer.borderWidth = 1
            txtComment.layer.borderColor = UIColor.LableGrayTextColor.cgColor
        }
    }
    @IBOutlet weak var commentVIewMain: UIView!
    {
        didSet{
            //            commentVIewMain.backgroundColor = .white
            //            commentVIewMain.clipsToBounds = true
            //            commentVIewMain.layer.cornerRadius = 15
            //            commentVIewMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            commentVIewMain.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    @IBOutlet weak var lblLikeDescription: UILabel!
    
    @IBOutlet weak var profileView: shadowView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnStatus: UIButton!{
        didSet{
            btnStatus.layer.cornerRadius = btnStatus.frame.height/2
            btnStatus.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnShowmore: UIButton!
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    //    @IBOutlet weak var imgPost: UIImageView!
    //    @IBOutlet weak var imgPostHeight: NSLayoutConstraint!
    var images = [String]()
    
    @IBOutlet weak var bottomView: UIView!{
        didSet{
            bottomView.backgroundColor = .white
            bottomView.clipsToBounds = true
            bottomView.layer.cornerRadius = 15
            bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    var numberOfItems = Int()
    
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl!
    let cellId = "cell"
    
    @IBOutlet weak var tblComment: UITableView!{
        didSet{
            tblComment.backgroundColor = .white
            tblComment.clipsToBounds = true
            tblComment.layer.cornerRadius = 15
            tblComment.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    var bottomViewHeight = CGFloat()
    
    var playerView: VideoPlayerViewS!
    var imageview = UIImageView()
    var imageviewBackground = UIImageView()
    @IBOutlet weak var countView: UIView!{
        didSet{
            countView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            countView.layer.cornerRadius = countView.frame.height/2
            countView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var viewScroll: UIView!{
        didSet{
            viewScroll.backgroundColor = .white
            viewScroll.clipsToBounds = true
            viewScroll.layer.cornerRadius = 15
            viewScroll.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblPageCount: UILabel!
    //
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
    @IBOutlet weak var btnChat: UIButton!
    
    var shotImageView = UIImageView()
    
    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var btndislike: UIButton!
    @IBOutlet weak var btn_share: UIButton!
    @IBOutlet weak var btnmenu: UIButton!
    
    var DisplayView = UIView()
    var imageViewMain = UIImageView()
    
    var btnChatMain = UIButton()
    var btnLikePeople = UIButton()
    
    var transparentView = UIView()
    var animatedView = UIView()
    var lbl_coininfo = UILabel()
    
    @IBOutlet weak var viewThird: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pageControl.isHidden = true
        viewHeight.constant = ((80 * 10) + 50)//self.tblComment.contentSize.height
        playerView = VideoPlayerViewS(frame: self.contentView.frame)
        imageview.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        imageviewBackground.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height - 280)
        imageview.contentMode = .scaleAspectFit
        imageviewBackground.contentMode = .scaleAspectFill
        imageview.backgroundColor = .clear
        playerView.isHidden = true
        contentView.addSubview(imageviewBackground)
        contentView.sendSubviewToBack(imageviewBackground)
        imageviewBackground.addSubview(imageview)
        imageviewBackground.sendSubviewToBack(imageview)
        contentView.addSubview(playerView)
        contentView.sendSubviewToBack(playerView)
        
        transparentView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 50)
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        mainView.addSubview(transparentView)
        
        tblComment.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        tblComment.delegate = self
        tblComment.dataSource = self
        
//        setDefault()
        imgProfile.clipsToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        scrollView.delegate = self
        print("count:", self.images.count)
        pagerView.delegate = self
        pagerView.dataSource = self
        self.pageControl.numberOfPages = self.images.count
        self.pageControl.contentHorizontalAlignment = .left
        self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        shotImageView.frame = CGRect(x: 0, y: 0, width: pagerView.frame.size.width, height: pagerView.frame.size.height)
        
        pagerView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height - 280)
        shotImageView.backgroundColor = UIColor.black
        videoLayer.backgroundColor = UIColor.black.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        
        contentView.addSubview(shotImageView)
        contentView.sendSubviewToBack(shotImageView)
        
        btn_play.translatesAutoresizingMaskIntoConstraints = false
        btn_play.setImage(UIImage(named: "play"), for: .normal)
        
        imageview.addSubview(btn_play)
        btn_play.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btn_play.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn_play.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        btn_play.centerYAnchor.constraint(equalTo: self.imageview.centerYAnchor).isActive = true
        
        selectionStyle = .none
        
        blurImage(img: imageviewBackground)
        
        btnChatMain.frame = CGRect(x: 10, y: 0, width: 50, height: 50)
        btnChatMain.imageEdgeInsets = UIEdgeInsets(top: 15, left: 14, bottom: 15, right: 14)
//        btnChatMain.setImage(UIImage(named: "chat1")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        btnChatMain.tintColor = .white
        btnChatMain.setImage(UIImage(named: "chat2"), for: .normal)
        transparentView.addSubview(btnChatMain)
        transparentView.addSubview(btnCamera)
        transparentView.addSubview(imglogo)
        
        btnLikePeople.frame = CGRect(x: lblLikeDescription.frame.origin.x, y: lblLikeDescription.frame.origin.y, width: lblLikeDescription.frame.size.width, height: lblLikeDescription.frame.size.height)
        viewThird.addSubview(btnLikePeople)
        
        animatedView.frame = CGRect(x: 10, y:0, width: 70, height: 70)
        animatedView.layer.cornerRadius = animatedView.frame.height/2
        lbl_coininfo.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        lbl_coininfo.text = "123"
        lbl_coininfo.contentMode = .center
//        lbl_coininfo.numberOfLines = 0
//        lbl_coininfo.sizeToFit()
        animatedView.addSubview(lbl_coininfo)
        animatedView.clipsToBounds = true
        animatedView.backgroundColor = .red
//        bottomView.addSubview(animatedView)
        
    }
    
    
    func blurImage(img:UIImageView){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = img.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        img.addSubview(blurEffectView)
    }
    
    
    override func prepareForReuse() {
        shotImageView.imageURL = nil
        super.prepareForReuse()
    }
    
    @objc func Videopause(_ notification: NSNotification) {
        videoLayer.player?.pause()
    }
    
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
        print("imageUrl:",imageUrl!)
        print("videoUrl:",videoUrl!)
        
        self.shotImageView.imageURL = imageUrl
        
        imageviewBackground.kf.setImage(with: URL(string: imageUrl ?? ""),placeholder:UIImage(named: "Placeholder"))
        
        
        
        //        imageview.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height - 150)
        
        imageviewBackground.addSubview(shotImageView)
        //        self.videoURL = videoUrl
        //        shotImageView.layer.addSublayer(videoLayer)
        //        ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: videoLayer, url: videoURL ?? "")
        //        ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: videoLayer, url:videoURL ?? "")
    }
    
    @IBAction func btnVideoPlayAction(_ sender: Any) {
        print("click..")
        shotImageView.layer.addSublayer(videoLayer)
        if btn_play.imageView?.image == UIImage(named: "play"){
            btn_play.setImage(UIImage(named: "pause"), for: .normal)//play
            ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: videoLayer, url: videoURL ?? "")
        }
        else{
            btn_play.setImage(UIImage(named: "play"), for: .normal)
            ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: videoLayer, url:videoURL ?? "")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin: CGFloat = 0
        let width: CGFloat = bounds.size.width - horizontalMargin * 2
        let height: CGFloat = (width * 0.999).rounded(.up)
        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
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
    
    func setDefault() {
        //        let normalText =  " Wendy Lambert "
        
        let boldText  = "Liked by"
        
        let normalText1 =  " 200 people"
        
        //        let boldText1  = "and"
        
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        //        let attributedString = NSMutableAttributedString(string:normalText, attributes:attrs1)
        
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let attributedString1 = NSMutableAttributedString(string:normalText1, attributes:attrs2)
        
        let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor] as [NSAttributedString.Key : Any]
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        
        //        let boldString1 = NSMutableAttributedString(string: boldText1, attributes:attrs)
        
        //        boldString.append(attributedString)
        boldString.append(attributedString1)
        //        boldString.append(boldString1)
        lblLikeDescription.attributedText = boldString
    }
    
    
    
    @IBAction func btnClose(_ sender: Any) {
        self.commentVIewMain.isHidden = true
        btnclick.isHidden = false
        NotificationCenter.default.post(name: Notification.Name("scrollchange"), object: nil)
    }
    
    @IBAction func btnShowmoreComments(_ sender: Any) {
//        NotificationCenter.default.post(name: Notification.Name("scrollchange1"), object: nil)
//        self.commentVIewMain.isHidden = false
//        btnclick.isHidden = true
        
    }
    
    
    func viewShadow(outerView:UIView) {
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 1
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = outerView.frame.height/2
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: outerView.frame.height/2).cgPath
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(post: String){
        imageviewBackground.kf.setImage(with: URL(string: post),placeholder:UIImage(named: "Placeholder"))
        
        imageview.kf.setImage(with: URL(string: post),placeholder:UIImage(named: "Placeholder"))
        
        imageview.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height - 150)
        
        imageviewBackground.addSubview(imageview)
        print("imageheight:",self.contentView.frame.height - 200)
        btnclick.frame = CGRect(x: 0, y: 65, width: self.contentView.frame.width, height: self.contentView.frame.height - 215)
        //        btnclick.backgroundColor = .blue
        contentView.addSubview(btnclick)
        //        }
        
    }
    
    func getAspectRatioAccordingToiPhones(cellImageFrame:CGSize,downloadedImage: UIImage)->CGFloat {
        let widthOffset = downloadedImage.size.width - cellImageFrame.width
        let widthOffsetPercentage = (widthOffset*100)/downloadedImage.size.width
        let heightOffset = (widthOffsetPercentage * downloadedImage.size.height)/100
        let effectiveHeight = downloadedImage.size.height - heightOffset
        //        print("callSize:",effectiveHeight)
        return(effectiveHeight)
    }
    
    
    //MARK: camera button
    
    @IBAction func btnCameraAction(_ sender: Any) {
        
    }
    
}


extension HomeTableViewCell: FSPagerViewDataSource,FSPagerViewDelegate{
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
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
        lblPageCount.text = String(targetIndex+1) + "/" + String(images.count)
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    
    
}

extension HomeTableViewCell: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if scrollView == self.scrollView{
            
            if(scrollView.contentOffset.y > 0)
            {
                // react to dragging down
                
                print("down")
            } else
            {
                // react to dragging up
                print("up")
                if scrollView.contentOffset.y <= -150 {
                    
                    DispatchQueue.main.async {
                        self.commentVIewMain.isHidden = true
                        NotificationCenter.default.post(name: Notification.Name("scrollchange"), object: nil)
                    }
                }
            }
        }
        
        
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
            case .down:
                print("Swiped down")
                UIView.animate(withDuration: 1.0, delay: 0, options: [.curveLinear],
                               animations: {
                                self.commentVIewMain.frame = CGRect(x: 0, y: (Int(self.contentView.frame.height)), width: Int(self.contentView.frame.width), height: 0)
                                
                               }, completion:  { finished in
                                print("Napkins opened!")
                                self.commentVIewMain.isHidden = true
                                NotificationCenter.default.post(name: Notification.Name("scrollchange"), object: nil)
                               })
            case .left:
                print("Swiped left")
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
}

