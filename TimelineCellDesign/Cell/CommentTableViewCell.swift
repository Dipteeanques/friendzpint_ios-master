//
//  CommentTableViewCell.swift
//  FriendzPoint
//
//  Created by Anques on 12/01/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.layer.cornerRadius = imgProfile.frame.height/2
            imgProfile.clipsToBounds = true
            imgProfile.layer.borderWidth = 1
            imgProfile.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var btnChat: UIButton!
//    {
//        didSet{
//            let image = UIImage(named: "chat1")?.withRenderingMode(.alwaysTemplate)
//            btnChat.setImage(image, for: .normal)
//            btnChat.tintColor = UIColor.black
//        }
//    }
    
    @IBOutlet weak var btnLike: UIButton!
//    {
//        didSet{
//            let image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
//            btnLike.setImage(image, for: .normal)
//            btnLike.tintColor = UIColor.black
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
