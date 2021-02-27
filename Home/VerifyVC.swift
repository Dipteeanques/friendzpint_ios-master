//
//  VerifyVC.swift
//  FriendzPoint
//
//  Created by Anques on 22/02/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import KWVerificationCodeView
import Alamofire

class VerifyVC: UIViewController {

    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btn: UIButton!{
        didSet{
            btn.layer.cornerRadius = btn.frame.height/2
            btn.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblDid: UILabel!
    @IBOutlet weak var verificationVIew: KWVerificationCodeView!
    @IBOutlet weak var lblMsg: UILabel!
    
    var wc = Webservice.init()
    var number = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        setStatusBar1(backgroundColor: .black)
    }
    

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnVerify(_ sender: Any) {
        otpVerify(strOTP: verificationVIew.getVerificationCode(), strNumber: self.number )
    }
    
  
    func otpVerify(strOTP: String, strNumber: String) {
        let email = loggdenUser.value(forKey: EMAIL)
        let parameters = ["mobile_number":strNumber,"otp":strOTP,"email":email]
        let headers: HTTPHeaders = ["Accept" : ACCEPT]
        wc.callSimplewebservice(url: tellzverify_otp, parameters: parameters as [String : Any], headers: headers, fromView: self.view, isLoading: true) { (success, response: WalletLoginTokenResponsModel?) in
            if success {
                let suc = response?.success
                if suc == true {
                    let obj = response?.data
                    let mobnumber = obj?.mobileNumber
                    let token = obj?.token
                    loggdenUser.set(mobnumber, forKey: mobNumberWallet)
                    loggdenUser.set(token, forKey: walletToken)
                    loggdenUser.set(true, forKey: walletLoginTellz)
//                    self.viewInner.isHidden = true
//                    self.viewOtp.isHidden = true
////                    self.Getwallet()
//                    if self.checkwithdraw == "true"{
//                        self.paymentview.isHidden = false
//                        self.transperentview.isHidden = false
//                    }
//                    else{
                        self.NavigateWalletMain()
//                    }
                    
                }
            }
        }
    }
}
