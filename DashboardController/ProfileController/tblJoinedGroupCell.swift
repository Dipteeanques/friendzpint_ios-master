//
//  tblJoinedGroupCell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 24/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblJoinedGroupCell: UITableViewCell {

    @IBOutlet weak var imgGroup: UIImageView!
    @IBOutlet weak var lblpublic: UILabel!
    @IBOutlet weak var lblGroupname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
