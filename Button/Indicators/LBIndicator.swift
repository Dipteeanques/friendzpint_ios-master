//
//  LBIndicator.swift
//  FriendzPoint
//
//  Created by Anques on 26/02/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//


import UIKit

open class LBIndicator: UIView, IndicatorProtocol {
    open var isAnimating: Bool = false
    open var radius: CGFloat = 18.0
    open var color: UIColor = .lightGray
    
    public convenience init(radius: CGFloat = 18.0, color: UIColor = .gray) {
        self.init()
        self.radius = radius
        self.color = color
    }
    
    open func startAnimating() {
        guard !isAnimating else { return }
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setupAnimation(in: self.layer, size: CGSize(width: 2*radius, height: 2*radius))
    }
    
    open func stopAnimating() {
        guard isAnimating else { return }
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    open func setupAnimation(in layer: CALayer, size: CGSize) {
        fatalError("Need to be implemented")
    }
}
