//
//  SettingsCell.swift
//  FriendzPoint
//
//  Created by Anques on 22/01/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class SettingsCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: GradientView1!
    {
        didSet{
            mainView.layer.cornerRadius = 10.0
            mainView.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var roundView: UIView!{
        didSet{
            roundView.layer.cornerRadius = roundView.frame.height/2
            roundView.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var lblBottom: NSLayoutConstraint!
    @IBOutlet weak var roundViewHeight: NSLayoutConstraint!
}
