//
//  FriendsTableViewCell.swift
//  FriendzPoint
//
//  Created by Anques on 16/07/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
            imgUser.layer.cornerRadius = imgUser.frame.height/2
            imgUser.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
