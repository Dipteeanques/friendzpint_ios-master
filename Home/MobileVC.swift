//
//  MobileVC.swift
//  FriendzPoint
//
//  Created by Anques on 22/02/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class MobileVC: UIViewController {
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    
    @IBOutlet weak var btn: UIButton!{
        didSet{
            btn.layer.cornerRadius = btn.frame.height/2
            btn.clipsToBounds = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        setStatusBar1(backgroundColor: .black)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "OtpVC")as! OtpVC//TellzmeWalletViewController
        obj.modalPresentationStyle = .fullScreen
        self.present(obj, animated: false, completion: nil)//pushViewController(obj, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
