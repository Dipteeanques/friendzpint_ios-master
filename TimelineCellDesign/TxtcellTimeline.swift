//
//  TxtcellTimeline.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 27/07/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import ActiveLabel
import TTTAttributedLabel

class TxtcellTimeline: UITableViewCell {

    @IBOutlet weak var btndislike: UIButton!
    @IBOutlet weak var btnDislikeCount: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btntxtProfile: UIButton!
    @IBOutlet weak var lblDesc: ActiveLabel!
    @IBOutlet weak var imgProfile: UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 25
            imgProfile.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnCommentCount: UIButton!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var btntxtMenu: UIButton!
    @IBOutlet weak var btnLiketxtCell: UIButton!
    @IBOutlet weak var btnCommenttxtCell: UIButton!
    @IBOutlet weak var btnSharetxtCell: UIButton!
    @IBOutlet weak var lblTitle: TTTAttributedLabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        lblDesc.text = nil
        lblLocation.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var url: URL?
    var arrText: MyTimelineList?{
        didSet {
            
            //MARK: - Profile
            let avatar = arrText!.users_avatar
            url = URL(string: avatar)
            imgProfile.sd_setImage(with: url, completed: nil)
            
            //MARK: - Like
            let is_liked = arrText!.is_liked
            if is_liked == 1 {
                btnLiketxtCell.isSelected = true
            }
            else {
                btnLiketxtCell.isSelected = false
            }
            
            //MARK: - Dislike
            let is_disliked = arrText!.is_disliked
            if is_disliked == 1 {
                btndislike.isSelected = true
            }
            else {
                btndislike.isSelected = false
            }
            
            //MARK: - Location
            let strLocation = arrText!.location
            if strLocation.count == 0 {
            }
            else {
                lblLocation.text = "at " + strLocation
            }
            
            //MARK: like
            let totalLike = arrText!.users_liked_count
            let strLikeTotal = String(totalLike) + " Like"
            btnLikeCount.setTitle(strLikeTotal, for: .normal)
            
            //MARK: - Dislike
            let totaldislike = arrText!.users_disliked_count
            let strDislikeTotal = String(totaldislike) + " Dislike"
            btnDislikeCount.setTitle(strDislikeTotal, for: .normal)
            
            //MARK: - Comment
            let totalComment = arrText!.comments_count
            let strCommentTotal = String(totalComment) + " Comment"
            btnCommentCount.setTitle(strCommentTotal, for: .normal)
            
            //MARK: - Date
            let postDate = arrText!.created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            lblTime.text = datavala
            
            //MARK: - Discription
            let strdescription = arrText!.description
            lblDesc.text = strdescription.decodeEmoji
            lblDesc.enabledTypes = [.mention, .hashtag, .url]
            lblDesc.hashtagColor = .black
            lblDesc.hashtagSelectedColor = .blue
        }
    }
    
    
}
