//
//  newDiscoverBannerCollectionViewCell.swift
//  FriendzPoint
//
//  Created by Anques on 13/07/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class newDiscoverBannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var img: CustomImageView!
    @IBOutlet weak var lbltitle: UILabel!
}



//MARK: CustomImageView
@IBDesignable class CustomImageView: UIImageView {
    
    
    
    @IBInspectable var cornarRadius:CGFloat = 0.0 {
        
        didSet {
            layer.cornerRadius = cornarRadius
        }
        
    }
    
    @IBInspectable var isCircle:Bool = false {
        
        didSet {
            if isCircle {
                layer.cornerRadius  = self.frame.size.width/2
            }else{
                layer.cornerRadius = cornarRadius
            }
        }
        
    }
    
    @IBInspectable var borderWidth1:CGFloat = 0.0 {
        
        didSet {
            layer.borderWidth = borderWidth1
            layer.borderColor = borderColor1.cgColor
        }
        
    }
    
    @IBInspectable var borderColor1:UIColor = UIColor.lightGray {
        
        didSet {
            layer.borderColor = borderColor1.cgColor
            if borderWidth1 == 0 {borderWidth1 = 1.0}
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 5.0 {
        
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    
    @IBInspectable var isCompulsory: Bool = false {
        didSet{
            
        }
    }
    
    @IBInspectable var errorMessage: String = "" {
        didSet{
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isCircle {
            layer.cornerRadius  = self.frame.size.width/2
        }else{
            layer.cornerRadius = cornarRadius
        }
    }
}

