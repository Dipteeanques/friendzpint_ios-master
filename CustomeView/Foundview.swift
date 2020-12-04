//
//  Foundview.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 20/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class Foundview: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Foundview", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
}
