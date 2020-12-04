//
//  tblNotiCell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 30/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblNotiCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
