//
//  soundsCollectionViewCell.swift
//  FriendzPoint
//
//  Created by Anques on 02/07/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class soundsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var soundName : UILabel!
    @IBOutlet weak var soundDesc : UILabel!
    @IBOutlet weak var duration : UILabel!
    
    @IBOutlet weak var soundImg : UIImageView!
    @IBOutlet weak var playImg : UIImageView!
    
    @IBOutlet weak var btnFav : UIButton!
    @IBOutlet weak var btnSelect : UIButton!
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnSelectTrailing: NSLayoutConstraint!
}
