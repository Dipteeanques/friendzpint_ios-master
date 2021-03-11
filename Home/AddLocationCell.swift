//
//  AddLocationCell.swift
//  FriendzPoint
//
//  Created by Anques on 08/03/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class AddLocationCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var mainview: UIView!{
        didSet{
            mainview.layer.cornerRadius = 5.0
            mainview.clipsToBounds = true
            mainview.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)//UIColor.lightGray.withAlphaComponent(20.0)
        }
    }
    
}
