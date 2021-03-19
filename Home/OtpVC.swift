//
//  OtpVC.swift
//  FriendzPoint
//
//  Created by Anques on 22/02/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class OtpVC: UIViewController {

    
    @IBOutlet weak var txtMobile: UITextField!
    var wc = Webservice.init()
    @IBOutlet weak var btn: UIButton!{
        didSet{
            btn.layer.cornerRadius = btn.frame.height/2
            btn.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblMsg: UILabel!
    
    var number: String?
    var otp: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        //setStatusBar1(backgroundColor: .black)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnGetOtp(_ sender: Any) {
        NumberVerify(strNumber: txtMobile.text ?? "")
        
    }

    
    func NumberVerify(strNumber: String) {
        let email = loggdenUser.value(forKey: EMAIL)
        let parameters = ["mobile_number":"91" + strNumber,"email":email]
        print(parameters)
       let headers: HTTPHeaders = ["Accept" : ACCEPT]
        wc.callSimplewebservice(url: tellZLogin, parameters: parameters as [String : Any], headers: headers, fromView: self.view, isLoading: true) { (success, response: WalletLoginResponsModel?) in
            if success {
                let suc = response?.success
                if suc == true {
                    let obj = response?.data
                    self.otp = obj?.otp
                    self.number = obj?.mobileNumber
                    loggdenUser.set(self.number, forKey: mobNumberWallet)
//                    self.viewOtp.isHidden = false
//                    self.viewBgCustom.isHidden = true
//                    self.paymentview.isHidden = true
                    let obj1 = self.storyboard?.instantiateViewController(withIdentifier: "VerifyVC")as! VerifyVC//TellzmeWalletViewController
                    print(strNumber)
                    obj1.mobileNumber = strNumber//obj?.mobileNumber ?? ""
                    obj1.number = self.number ?? ""
                    obj1.modalPresentationStyle = .fullScreen
                    self.present(obj1, animated: false, completion: nil)//pushViewController(obj1, animated: true)
                
                }
            }
        }
    }

}
