//
//  ArticleCell.swift
//  FriendzPoint
//
//  Created by Anques on 26/05/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
//import ActiveLabel

class ArticleCell: UITableViewCell {

    @IBOutlet weak var imgArticle: UIImageView!
    @IBOutlet weak var lblArticleTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnLike: UIButton!{
        didSet{
            let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
            btnLike.setImage(image, for: .normal)
            btnLike.tintColor = UIColor.gray
        }
    }
    
    @IBOutlet weak var btnLink: UIButton!
    @IBOutlet weak var btnSeemoreHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSeemore: UIButton!
    
    @IBOutlet weak var lblView: UILabel!
    @IBOutlet weak var btnView: UIButton!
    
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnCommentView: UIButton!{
        didSet{
            let image = UIImage(named: "chatcount")?.withRenderingMode(.alwaysTemplate)
            btnCommentView.setImage(image, for: .normal)
            btnCommentView.tintColor = UIColor.black
        }
    }
    
    
    @IBOutlet weak var btnlikeVIew: UIButton!{
        didSet{
            let image = UIImage(named: "likecount")?.withRenderingMode(.alwaysTemplate)
            btnlikeVIew.setImage(image, for: .normal)
            btnlikeVIew.tintColor = UIColor.black
        }
    }
    @IBOutlet weak var btnShare: UIButton!{
        didSet{
            let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            btnShare.setImage(image, for: .normal)
            btnShare.tintColor = UIColor.gray
        }
    }
    @IBOutlet weak var btnComment: UIButton!{
        didSet{
            let image = UIImage(named: "chat")?.withRenderingMode(.alwaysTemplate)
            btnComment.setImage(image, for: .normal)
            btnComment.tintColor = UIColor.gray
        }
    }
    
    @IBOutlet weak var lblCreatedBy: UILabel!
    
    @IBOutlet weak var lblCreatedAt: UILabel!
    
    
    @IBOutlet weak var btnPlay: UIButton!
    
    
    @IBOutlet weak var ViewEdit: UIView!
    
    @IBOutlet weak var btnEdit: UIButton!{
        didSet{
            btnEdit.layer.cornerRadius = btnEdit.frame.height/2
            btnEdit.clipsToBounds = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
