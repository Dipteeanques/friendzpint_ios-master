//
//  MyGroupCell.swift
//  FriendzPoint
//
//  Created by Anques on 30/01/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class MyGroupCell: UITableViewCell {

    @IBOutlet weak var imgGroupIcon: UIImageView!{
        didSet{
            imgGroupIcon.layer.cornerRadius = 10
            imgGroupIcon.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var btnarrow: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
