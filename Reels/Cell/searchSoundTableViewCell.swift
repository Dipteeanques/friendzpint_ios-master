//
//  searchSoundTableViewCell.swift
//  FriendzPoint
//
//  Created by Anques on 13/07/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class searchSoundTableViewCell: UITableViewCell {

    @IBOutlet weak var soundImg: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnPlay: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadIndicator.color = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
