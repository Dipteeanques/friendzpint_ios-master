//
//  TellzmeWalletVC.swift
//  FriendzPoint
//
//  Created by Anques on 04/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import MXSegmentedPager
import Alamofire

class TellzmeWalletVC: MXSegmentedPagerController {


    @IBOutlet var headerview: UIView!
    @IBOutlet weak var gridentView: UIView!
    
    @IBOutlet weak var btnWithdraw: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnback: UIButton!
    
    @IBOutlet weak var viewInner: UIView!{
        didSet{
            viewInner.layer.cornerRadius = 5
            viewInner.clipsToBounds = true
            viewInner.layer.borderWidth = 1
            viewInner.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    @IBOutlet weak var btnUpdate: UIButton!{
        didSet {
            btnUpdate.layer.cornerRadius = 5
            btnUpdate.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefault()
    }
    
//    override func viewSafeAreaInsetsDidChange() {
//        segmentedPager.parallaxHeader.minimumHeight = view.safeAreaInsets.top
//    }
//    
    func setDefault() {
    
        
        // Parallax Header
        segmentedPager.parallaxHeader.view = headerview
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 200
        segmentedPager.parallaxHeader.minimumHeight = 0
        
        // Segmented Control customization
        segmentedPager.segmentedControl.indicator.linePosition = .bottom
        segmentedPager.segmentedControl.backgroundColor = .white
        //segmentedPager.segmentedControl.
        segmentedPager.segmentedControl.textColor = UIColor(red: 73/255, green: 100/255, blue: 134/255, alpha: 1)
        segmentedPager.segmentedControl.font = UIFont.systemFont(ofSize: 14)
        segmentedPager.segmentedControl.selectedTextColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
       // segmentedPager.segmentedControl.sel
        segmentedPager.segmentedControl.indicatorColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
        segmentedPager.segmentedControl.indicatorHeight = 1.5
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gridentView.bounds
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gridentView.layer.addSublayer(gradientLayer)
        gridentView.addSubview(btnback)
        gridentView.addSubview(btnWithdraw)
        gridentView.addSubview(lbltitle)
        
//        if UIScreen.main.bounds.width == 320 {
////            viewHeght.constant = 66
//            segmentedPager.parallaxHeader.height = 410
//            segmentedPager.parallaxHeader.minimumHeight = 66
//            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: 66)
//        }
//        else {
//            segmentedPager.parallaxHeader.height = 200
//            segmentedPager.parallaxHeader.minimumHeight = 90
//            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: gridentView.bounds.size.height)
//        }
      
    }

    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["REDEEM COINS", "WITHDRAW HISTORY"][index]
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("progress \(parallaxHeader.progress)")
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelect view: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
    }
}
