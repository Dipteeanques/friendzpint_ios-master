//
//  FriendtblCell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 21/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class FriendtblCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
