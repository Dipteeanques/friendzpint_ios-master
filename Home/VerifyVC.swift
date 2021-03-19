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
    
    @IBOutlet weak var btnresend: UIButton!
    @IBOutlet weak var lblDid: UILabel!
    @IBOutlet weak var verificationVIew: KWVerificationCodeView!
    @IBOutlet weak var lblMsg: UILabel!
    
    var wc = Webservice.init()
    var number = String()
    var mobileNumber = String()
    var check = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(number)
        print(mobileNumber)
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        //setStatusBar1(backgroundColor: .black)
        self.lblMsg.text = "Enter the OTP sent to +91 " + mobileNumber
    }
    
    @IBAction func btnResendOtp(_ sender: Any) {
        NumberVerify(strNumber: mobileNumber)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnVerify(_ sender: Any) {
        btnresend.isEnabled = false
        otpVerify(strOTP: verificationVIew.getVerificationCode(), strNumber: self.number )
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
                    self.btnresend.isEnabled = true
                }
            }
        }
    }
    
  
    func otpVerify(strOTP: String, strNumber: String) {
        let email = loggdenUser.value(forKey: EMAIL)
        let parameters = ["mobile_number":strNumber,"otp":strOTP,"email":email]
        print(parameters)
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
                   
                    
                    if self.check == "ok"{
                        self.dismiss(animated: false, completion: nil)
                    }
                    else{
                        FlagBack = 1
                        loggdenUser.set(true, forKey: walletLoginTellz)
                        self.NavigateWalletMain()
                    }
                    
                        
//                    }
                    
                }
            }
        }
    }
}


var FlagBack = 0
