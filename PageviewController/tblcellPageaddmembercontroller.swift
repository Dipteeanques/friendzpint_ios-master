//
//  GroupAddMemberCell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 31/07/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblcellPageaddmembercontroller: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
