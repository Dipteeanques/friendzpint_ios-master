//
//  LoaderView.swift
//  WhatsInFood
//
//  Created by Anques Technolabs on 08/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    @IBOutlet weak var uperView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
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
        let nib = UINib(nibName: "LoaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        self.uperView.layer.cornerRadius = 5
        self.uperView.clipsToBounds = true
        self.activity.startAnimating()
    }
}
