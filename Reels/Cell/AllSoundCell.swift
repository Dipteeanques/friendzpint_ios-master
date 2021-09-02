//
//  AllSoundCell.swift
//  FriendzPoint
//
//  Created by Anques on 23/06/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class AllSoundCell: UITableViewCell {

    @IBOutlet weak var imgSound: UIImageView!{
        didSet{
            imgSound.layer.cornerRadius = 10.0
            imgSound.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnSelect : UIButton!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var lblMusicTitle: UILabel!
    @IBOutlet weak var lblMusicSignerName: UILabel!
    @IBOutlet weak var lblMusicTime: UILabel!
    @IBOutlet weak var btnLike: UIButton!{
        didSet{
            btnLike.backgroundColor = UIColor.white.withAlphaComponent(0.10)
            btnLike.layer.cornerRadius = 5.0
            btnLike.clipsToBounds = true
        }
    }
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
