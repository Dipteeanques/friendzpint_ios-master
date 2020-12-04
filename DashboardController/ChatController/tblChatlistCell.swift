//
//  tblChatlistCell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 22/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblChatlistCell: UITableViewCell {

    @IBOutlet weak var lblmsg: UILabel!
    @IBOutlet weak var lblSDate: UILabel!
    @IBOutlet weak var imgprofile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
