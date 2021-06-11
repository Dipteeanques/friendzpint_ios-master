//
//  commentCell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 20/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class commentCell: UITableViewCell {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var btnSeemore: UIButton!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var imgreplyprofile: UIImageView!
    @IBOutlet weak var viewSecondBack: UIView!
    @IBOutlet weak var lblreplyname: UILabel!
    @IBOutlet weak var lblReply: UILabel!
    @IBOutlet weak var lblTimeHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
