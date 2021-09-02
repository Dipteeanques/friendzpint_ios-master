//
//  ReelsProfileVC.swift
//  FriendzPoint
//
//  Created by Anques on 24/06/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class ReelsProfileVC: UIViewController {

    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnCamera: UIButton!{
        didSet{
            btnCamera.layer.cornerRadius = btnCamera.frame.height/2
            btnCamera.clipsToBounds = true
        }
    }
    @IBOutlet weak var userView: UIView!{
        didSet{
            userView.layer.cornerRadius = userView.frame.height/2
            userView.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
            imgUser.layer.cornerRadius = imgUser.frame.height/2
            imgUser.clipsToBounds = true
            imgUser.layer.borderWidth = 3
            imgUser.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var btnUserCamera: UIButton!{
        didSet{
            btnUserCamera.layer.cornerRadius = btnUserCamera.frame.height/2
            btnUserCamera.clipsToBounds = true
            btnUserCamera.layer.borderWidth = 1
            btnUserCamera.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBOutlet weak var btnEditProfile: UIButton!
//    {
//        didSet{
//            btnEditProfile.layer.cornerRadius = btnEditProfile.frame.height/2
//            btnEditProfile.clipsToBounds = true
//        }
//    }
//
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonShadow(btn: btnEditProfile)
        
    }
    
    func setButtonShadow(btn: UIButton){
        btn.backgroundColor = UIColor(red: 0.14, green: 0.41, blue: 1.00, alpha: 1.00)
        // Shadow Color and Radius
        btn.layer.shadowColor = UIColor.lightGray.cgColor//UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowRadius = 0.0
        btn.layer.masksToBounds = false
        btn.layer.cornerRadius = btnEditProfile.frame.height/2
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
   
    @IBAction func btnCameraAction(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "FeelitVideosVC") as! FeelitVideosVC
//
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func btnUserCameraAction(_ sender: Any) {
    }
    
    @IBAction func btnEditProfileAction(_ sender: Any) {
    }
}
