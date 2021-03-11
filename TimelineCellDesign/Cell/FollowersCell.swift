//
//  FollowersCell.swift
//  FriendzPoint
//
//  Created by Anques on 02/03/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class FollowersCell: UITableViewCell {

    @IBOutlet weak var imgFollower: UIImageView!{
        didSet{
            imgFollower.layer.cornerRadius = imgFollower.frame.height/2
            imgFollower.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblFollowerName: UILabel!
    @IBOutlet weak var btnFollowerStatus: UIButton!
    {
        didSet{
            btnFollowerStatus.layer.cornerRadius = btnFollowerStatus.frame.height/2
            btnFollowerStatus.clipsToBounds = true
            btnFollowerStatus.layer.borderColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 0.20).cgColor
            btnFollowerStatus.layer.borderWidth = 1.0
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
