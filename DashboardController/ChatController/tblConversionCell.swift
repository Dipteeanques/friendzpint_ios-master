//
//  tblConversionCell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 08/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblConversionCell: UITableViewCell {

    
    @IBOutlet weak var lblrecivetextTime: UILabel!
    @IBOutlet weak var lblrecivetxt: UILabel!
    @IBOutlet weak var viewRecive: UIView!
    @IBOutlet weak var lblsendertxtTime: UILabel!
    @IBOutlet weak var viewSendertxt: UIView!
    @IBOutlet weak var lblSender: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
