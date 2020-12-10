//
//  tblPostCell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 29/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class tblPostCell: UITableViewCell {

    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var collectionheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewMultipaleimage: UICollectionView!
    @IBOutlet weak var btnplay: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                imgPost.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                imgPost.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    func setCustomImage(image : UIImage) {
        
        let aspect = image.size.width / image.size.height
        
        let constraint = NSLayoutConstraint(item: imgPost!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imgPost, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = UILayoutPriority(rawValue: 999)
        
        aspectConstraint = constraint
        
        imgPost.image = image
    }

}
