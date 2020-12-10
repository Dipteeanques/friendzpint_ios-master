//
//  VideocellTimeline.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 27/07/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import ActiveLabel
import AVFoundation
import AVKit
import TTTAttributedLabel

class VideocellTimeline: UITableViewCell {
    

    @IBOutlet weak var btndislike: UIButton!
    @IBOutlet weak var btndislikeCount: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnVideoprofile: UIButton!
    @IBOutlet weak var lblDesc: ActiveLabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btncommentcount: UIButton!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet var shotImageView: UIImageView!
    @IBOutlet weak var btnVideoMenu: UIButton!
    @IBOutlet weak var btnshareVideoCell: UIButton!
    @IBOutlet weak var btnCommentVideoCell: UIButton!
    @IBOutlet weak var btnLikeVideoCell: UIButton!
    @IBOutlet weak var btnmute: UIButton!
    @IBOutlet weak var lblTitle: TTTAttributedLabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnplaypause: UIButton!
    
    var url: URL?
    var type = String()
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //         NotificationCenter.default.addObserver(self, selector: #selector(VideocellTimeline.Videopause), name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let screenWidth = shotImageView.frame.size.width//screenRect.size.width
        let screenHeight = shotImageView.frame.size.height//screenRect.size.height
        shotImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        shotImageView.backgroundColor = UIColor.black
        videoLayer.backgroundColor = UIColor.black.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        selectionStyle = .none
        
    }
    
    override func prepareForReuse() {
        lblDesc.text = nil
        lblLocation.text = nil
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
        self.videoURL = videoUrl
        
        
    }
    
   
    @IBAction func btnVideoPlayAction(_ sender: Any) {
        shotImageView.layer.addSublayer(videoLayer)
        if btnplaypause.imageView?.image == UIImage(named: "play"){
            btnplaypause.setImage(UIImage(named: "pause"), for: .normal)//play
            ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: videoLayer, url: videoURL ?? "")
        }
        else{
            btnplaypause.setImage(UIImage(named: "play"), for: .normal)
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
    
    var arrvideo: MyTimelineList?{
        didSet {
            
            //MARK: - Profile
            let avatar = arrvideo!.users_avatar
            url = URL(string: avatar)
            imgProfile.sd_setImage(with: url, completed: nil)
            
            //MARK: - Like
            let is_liked = arrvideo!.is_liked
            if is_liked == 1 {
                btnLikeVideoCell.isSelected = true
            }
            else {
                btnLikeVideoCell.isSelected = false
            }
            
            //MARK: - Dislike
            let is_disliked = arrvideo!.is_disliked
            if is_disliked == 1 {
                btndislike.isSelected = true
            }
            else {
                btndislike.isSelected = false
            }
            
            //MARK: - Location
            let strLocation = arrvideo!.location
            if strLocation.count == 0 {
            }
            else {
                lblLocation.text = "at " + strLocation
            }
            
            //MARK: like
            let totalLike = arrvideo!.users_liked_count
            let strLikeTotal = String(totalLike) + " Like"
            btnLikeCount.setTitle(strLikeTotal, for: .normal)
            
            //MARK: - Dislike
            let totaldislike = arrvideo!.users_disliked_count
            let strDislikeTotal = String(totaldislike) + " Dislike"
            btndislikeCount.setTitle(strDislikeTotal, for: .normal)
            
            //MARK: - Comment
            let totalComment = arrvideo!.comments_count
            let strCommentTotal = String(totalComment) + " Comment"
            btncommentcount.setTitle(strCommentTotal, for: .normal)
            
            //MARK: - Date
            let postDate = arrvideo!.created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            lblTime.text = datavala
            
            //MARK: - Discription
            let strdescription = arrvideo!.description
            lblDesc.text = strdescription.decodeEmoji
            lblDesc.enabledTypes = [.mention, .hashtag, .url]
            lblDesc.hashtagColor = .black
            lblDesc.hashtagSelectedColor = .blue
            
            let arr = arrvideo?.images
//            print(arr)
//            for item in arr! {
//                configureCell(imageUrl: item, description: "", videoUrl: "https://v.pinimg.com/videos/720p/75/40/9a/75409a62e9fb61a10b706d8f0c94de9a.mp4")
//            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
