//
//  searchHashtagsTableViewCell.swift
//  FriendzPoint
//
//  Created by Anques on 13/07/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class searchHashtagsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    @IBOutlet weak var btnFav: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
