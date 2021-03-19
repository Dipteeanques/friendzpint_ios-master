//
//  DiscoverEventCell.swift
//  FriendzPoint
//
//  Created by Anques on 18/03/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class DiscoverEventCell: UITableViewCell {

    @IBOutlet weak var imgevent: UIImageView!
    
    @IBOutlet weak var imgeventgoing: UILabel!
    @IBOutlet weak var imgeventlocation: UILabel!
    @IBOutlet weak var imgeventname: UILabel!
    @IBOutlet weak var imgeventdate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
