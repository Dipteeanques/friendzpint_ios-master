//
//  FeedtblCell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 14/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import AVKit
import ActiveLabel

class GrouptblCell: UITableViewCell,ASAutoPlayVideoLayerContainer {
    
    @IBOutlet weak var btnMute: UIButton!
    @IBOutlet var shotImageView: UIImageView!
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
    
    @IBOutlet weak var btnImgPost: UIButton!
    @IBOutlet weak var imgpostheight: NSLayoutConstraint!
    @IBOutlet weak var btnMetaClick: UIButton!
    @IBOutlet weak var lblmetaDescription: UILabel!
    @IBOutlet weak var lblmetaTitle: UILabel!
    @IBOutlet weak var imgMetalogo: UIImageView!
    @IBOutlet weak var meatView: UIView!
    @IBOutlet weak var videoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backViewMultiImg: UIView!
    @IBOutlet weak var collectionheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewMultipaleimage: UICollectionView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lblDetails: ActiveLabel!
    @IBOutlet weak var lblOnlytxt: ActiveLabel!
    @IBOutlet weak var lblMultiimgTxt: ActiveLabel!
    @IBOutlet weak var lblVideotxt: ActiveLabel!
    
    
    //MARK: - Only Single Image
    @IBOutlet weak var btnImgLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnpostComment: UIButton!
    @IBOutlet weak var btnLikeImgCell: UIButton!
    @IBOutlet weak var btnShareimgCell: UIButton!
    @IBOutlet weak var lblSingaleImgDate: UILabel!
    @IBOutlet weak var imgSingalepro: UIImageView!
    @IBOutlet weak var lblSingaleTitle: UILabel!
    
    //MARK: - TetxValue
    @IBOutlet weak var btnLiketxtCell: UIButton!
    @IBOutlet weak var btnCommenttxtCell: UIButton!
    @IBOutlet weak var btnSharetxtCell: UIButton!
    @IBOutlet weak var btnallLikeTxtCell: UIButton!
    @IBOutlet weak var btnAllCommenttxtCell: UIButton!
    @IBOutlet weak var lblTxtdate: UILabel!
    @IBOutlet weak var imgTxtPro: UIImageView!
    @IBOutlet weak var lblTxtTitle: UILabel!
    @IBOutlet weak var lblSingaleTotalLike: UILabel!
    @IBOutlet weak var lblSingaleComment: UILabel!
    
    //MARK: - multiImg
    
    @IBOutlet weak var btnallLikeMulticell: UIButton!
    @IBOutlet weak var btnAllCommentmulticell: UIButton!
    @IBOutlet weak var btnshareMultiCell: UIButton!
    @IBOutlet weak var btnCommentMulticell: UIButton!
    @IBOutlet weak var btnLikeMulticell: UIButton!
    @IBOutlet weak var lblMultiImgDate: UILabel!
    @IBOutlet weak var imgMultiPro: UIImageView!
    @IBOutlet weak var lblMultiTitle: UILabel!
    @IBOutlet weak var lblMultiLike: UILabel!
    @IBOutlet weak var lblMultiComment: UILabel!
    
    //MARK: - video
    
    @IBOutlet weak var btnallLikeVideocell: UIButton!
    @IBOutlet weak var btnAllcommentVideoCell: UIButton!
    @IBOutlet weak var btnshareVideoCell: UIButton!
    @IBOutlet weak var btnCommentVideoCell: UIButton!
    @IBOutlet weak var btnLikeVideoCell: UIButton!
    @IBOutlet weak var lblVideoDate: UILabel!
    @IBOutlet weak var imgVideoPro: UIImageView!
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var lblVideoLike: UILabel!
    @IBOutlet weak var lblVideoComment: UILabel!
    
    //MARK: - Meta Data
    
    @IBOutlet weak var btnAllLikeMetaCell: UIButton!
    @IBOutlet weak var btnAllCommentMetaCell: UIButton!
    @IBOutlet weak var btnShareMetaCell: UIButton!
    @IBOutlet weak var btnCommentMetaCell: UIButton!
    @IBOutlet weak var btnLikeMetaCell: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgmetaPro: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMetaLike: UILabel!
    @IBOutlet weak var lblMetaComment: UILabel!
    
    //MARK: - Menu Button
    @IBOutlet weak var btnSingaleImageMenu: UIButton!
    @IBOutlet weak var btntxtMenu: UIButton!
    @IBOutlet weak var btnMultiImgmenu: UIButton!
    @IBOutlet weak var btnVideoMenu: UIButton!
    @IBOutlet weak var btnMetaMenu: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GrouptblCell.Videopause), name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        
    }
    
    @objc func Videopause(_ notification: NSNotification) {
        videoLayer.player?.pause()
    }
    
    
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
        
        self.shotImageView.imageURL = imageUrl
        self.videoURL = videoUrl
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        shotImageView.layer.addSublayer(videoLayer)
        selectionStyle = .none
        if let videoURL = videoURL {
            ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin: CGFloat = 0
        let width: CGFloat = bounds.size.width - horizontalMargin * 2
        let height: CGFloat = (width * 0.9).rounded(.up)
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
    
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                backView.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                backView.addConstraint(aspectConstraint!)
            }
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    func setCustomImage(image : UIImage) {
        
        let aspect = image.size.width / image.size.height
        
        let constraint = NSLayoutConstraint(item: imgPost!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imgPost, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = UILayoutPriority(rawValue: 999)
        
        aspectConstraint = constraint
        
        imgPost.image = image
    }
}
