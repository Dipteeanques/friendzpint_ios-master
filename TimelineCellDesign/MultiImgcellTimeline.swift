//
//  MultiImgcellTimeline.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 27/07/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import ActiveLabel
import TTTAttributedLabel

class MultiImgcellTimeline: UITableViewCell {
    
  
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var imgtopconstraint: NSLayoutConstraint!
    @IBOutlet weak var lbltop: NSLayoutConstraint!
    @IBOutlet weak var btnMultiimgProfile: UIButton!
    @IBOutlet weak var btnMultiImagePass: UIButton!
    @IBOutlet weak var btndislike: UIButton!
    @IBOutlet weak var btnDislikeCount: UIButton!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionImage: UICollectionView!
    @IBOutlet weak var btnCommentCount: UIButton!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var lblDescrip: ActiveLabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgProfile: UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 25
            imgProfile.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnMultiImgmenu: UIButton!
    @IBOutlet weak var btnshareMultiCell: UIButton!
    @IBOutlet weak var btnCommentMulticell: UIButton!
    @IBOutlet weak var btnLikeMulticell: UIButton!
    @IBOutlet weak var lblTitle: TTTAttributedLabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblDescrip.text = nil
        lblLocation.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var url: URL?
    var arrMultiImage: MyTimelineList? {
        didSet {
            
            //MARK: - Profile
            let avatar = arrMultiImage!.users_avatar
            url = URL(string: avatar)
            imgProfile.sd_setImage(with: url, completed: nil)
            
            //MARK: - Like
            let is_liked = arrMultiImage!.is_liked
            if is_liked == 1 {
                btnLikeMulticell.isSelected = true
            }
            else {
                btnLikeMulticell.isSelected = false
            }
            
            //MARK: - Dislike
            let is_disliked = arrMultiImage!.is_disliked
            if is_disliked == 1 {
                btndislike.isSelected = true
            }
            else {
                btndislike.isSelected = false
            }
            
            //MARK: - Location
            let strLocation = arrMultiImage!.location
            if strLocation.count == 0 {
            }
            else {
                lblLocation.text = "at " + strLocation
            }
            
            //MARK: - LikeCount
            let totalLike = arrMultiImage!.users_liked_count
            let strLikeTotal = String(totalLike) + " Like"
            btnLikeCount.setTitle(strLikeTotal, for: .normal)
            
            //MARK: - DislikeCount
            let totaldislike = arrMultiImage!.users_disliked_count
            let strDislikeTotal = String(totaldislike) + " Dislike"
            btnDislikeCount.setTitle(strDislikeTotal, for: .normal)
            
            //MARK: - CommentCount
            let totalComment = arrMultiImage!.comments_count
            let strCommentTotal = String(totalComment) + " Comment"
            btnCommentCount.setTitle(strCommentTotal, for: .normal)
            
            //MARK: - Date
            let postDate = arrMultiImage!.created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            lblTime.text = datavala
            
            //MARK: - Description
            let strdescription = arrMultiImage!.description
            if strdescription.count == 0 {
                lbltop.constant = 0
                imgtopconstraint.constant = 0
            }
            else {
                lbltop.constant = 8
                imgtopconstraint.constant = 8
                lblDescrip.text = strdescription.decodeEmoji
                lblDescrip.enabledTypes = [.mention, .hashtag, .url]
                lblDescrip.hashtagColor = .black
                lblDescrip.hashtagSelectedColor = .blue
            }
        }
    }
    
    
}
