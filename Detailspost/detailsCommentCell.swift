//
//  detailsCommentCell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 05/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class detailsCommentCell: UITableViewCell {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var viewBack: UIView!{
        didSet {
            viewBack.layer.cornerRadius = 5
            viewBack.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnSeemore: UIButton!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var imgProfile: UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 15
            imgProfile.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var imgreplyprofile: UIImageView!
    @IBOutlet weak var viewSecondBack: UIView!
    @IBOutlet weak var lblreplyname: UILabel!
    @IBOutlet weak var lblReply: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var url: URL?
    var arrCommentSet: CommentList? {
        didSet {
            
            let strComment = arrCommentSet!.description
            lblComment.text = strComment
            lblname.text = arrCommentSet!.user_name
            
            //MARK: - Date
            let postDate = arrCommentSet!.created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            lblTime.text = datavala
            
            //MARK: - see more
            let parent_comments_count = arrCommentSet!.parent_comments_count
            btnSeemore.isHidden = true
            if parent_comments_count == 0 {
                btnSeemore.isHidden = true
            }else {
                btnSeemore.isHidden = false
                let total = String(parent_comments_count) + " See More"
                btnSeemore.setTitle(total, for: .normal)
            }
            
            //MARK: - like
            let is_liked = arrCommentSet!.is_liked
            if is_liked == 1 {
                btnLike.setTitle("Liked", for: .normal)
            }
            else {
                btnLike.setTitle("Like", for: .normal)
            }
            
            //Image
            let strImage = arrCommentSet!.user_avatar
            url = URL(string: strImage)
            imgProfile.sd_setImage(with: url, completed: nil)
        }
    }
    

}
