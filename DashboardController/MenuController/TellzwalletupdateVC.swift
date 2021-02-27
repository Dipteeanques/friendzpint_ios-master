//
//  TellzwalletupdateVC.swift
//  FriendzPoint
//
//  Created by Anques on 05/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import UIDropDown

class TellzwalletupdateVC: UIViewController {

    @IBOutlet weak var paymentview: CardView!
    
    @IBOutlet weak var drop: UIView!
    var drop1: UIDropDown!
    @IBOutlet weak var transperentview: UIView!{
        didSet{
            transperentview.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            transperentview.isOpaque = false
        }
    }
    
    @IBOutlet weak var convertcoinView: UIView!
    @IBOutlet weak var txt_convertcoin: UITextField!
    
    @IBOutlet weak var btn_continue: UIButton!
    
    @IBOutlet weak var txt_point: UITextField!
    
    var checkwithdraw = ""
    
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var txtNumberCustom: UITextField!
    @IBOutlet weak var viewBgCustom: UIView!
    
    @IBOutlet weak var gridentView: UIView!
    
    @IBOutlet weak var btnWithdraw: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnback: UIButton!
    
    var amount = String()
    
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
    
    
    @IBOutlet weak var viewbankdetail: CardView!
    @IBOutlet weak var txt_selecttype: UITextField!
    @IBOutlet weak var txt_accountnumber: UITextField!
    @IBOutlet weak var txt_beneficiaryname: UITextField!
    @IBOutlet weak var txt_bankname: UITextField!
    @IBOutlet weak var txt_ifsccode: UITextField!
    @IBOutlet weak var btn_bankdetialcontinue: UIButton!
    
    
    var number: String?
    var wc = Webservice.init()
    var otp: String?
    var typestr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTabBar?.setBar(hidden: true, animated: false)
       
        setDefault()
        if checkwithdraw == "true"{

            transperentview.isHidden = false
            paymentview.isHidden = false
//                viewOtp.isHidden = true
//                viewBgCustom.isHidden = false
            
        }
        else if checkwithdraw == "convert"{
            transperentview.isHidden = false
            convertcoinView.isHidden = false
        }
        else{
            viewInner.isHidden = false
            transperentview.isHidden = true
        }
        
    }
    
    func setDefault() {
        transperentview.isHidden = true
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.gridentView.bounds
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        if #available(iOS 13, *){
//
//        }
//        else{
////            UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
//            UIApplication.shared.statusBarView?.layer.addSublayer(gradientLayer)
//        }
//
//        gridentView.layer.addSublayer(gradientLayer)
//        gridentView.addSubview(btnback)
//        gridentView.addSubview(btnWithdraw)
//        gridentView.addSubview(lbltitle)
        txt_selecttype.isHidden = true
        print("width123:", txt_selecttype.frame.size.width)
        drop1 = UIDropDown(frame: CGRect(x: txt_selecttype.frame.origin.x, y: txt_selecttype.frame.origin.y, width:315, height: txt_selecttype.frame.size.height))
        drop1.center = CGPoint(x: self.txt_selecttype.frame.midX, y: self.txt_selecttype.frame.midY)
        drop1.placeholder = "Select Payment type"
        drop1.options = ["BANK", "PAYTM"]
        drop1.didSelect { (option, index) in
            self.typestr = option//"You just select \(option) at index: \(index)"
            print("You just select: \(option) at index: \(index)")
            if self.typestr == "PAYTM"{
                self.txt_accountnumber.placeholder = "Paytm Phone Number"
                self.txt_beneficiaryname.isEnabled = false
                self.txt_bankname.isEnabled = false
                self.txt_ifsccode.isEnabled = false
            }
            else{
                self.txt_accountnumber.placeholder = "Account Number"
                self.txt_beneficiaryname.isEnabled = true
                self.txt_bankname.isEnabled = true
                self.txt_ifsccode.isEnabled = true
            }
        }
        self.viewbankdetail.addSubview(drop1)
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnWthrawAction(_ sender: UIButton) {
        let isLogin = loggdenUser.bool(forKey: walletLoginTellz)
        if isLogin {
            transperentview.isHidden = false
            paymentview.isHidden = false
        }
        else {
            transperentview.isHidden = false
            viewOtp.isHidden = true
            viewBgCustom.isHidden = false
        }
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        viewOtp.isHidden = true
        transperentview.isHidden = false
        viewBgCustom.isHidden = false
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        transperentview.isHidden = true
    }
    @IBAction func btnUpdateAction(_ sender: UIButton) {
        if txtNumberCustom.text?.isEmpty == true{
            showalert(tlt: "", msg: "Please enter your number!")
        }
        else{
            self.NumberVerify(strNumber: "91"+txtNumberCustom.text!)
            transperentview.isHidden = false
        }

        
    }
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if txtOTP.text?.isEmpty == true{
            showalert(tlt: "", msg: "Please enter OTP!")
        }
        else{
            if checkwithdraw == "true"{
                if self.otp == txtOTP.text{
                    viewOtp.isHidden = true
                    transperentview.isHidden = false
                    paymentview.isHidden = true
                    viewbankdetail.isHidden = false
                }
            }
            else{
                self.otpVerify(strOTP: txtOTP.text!, strNumber: self.number!)
            }
        }
        
    }
       
    func NumberVerify(strNumber: String) {
        let email = loggdenUser.value(forKey: EMAIL)
        let parameters = ["mobile_number":strNumber,"email":email]
       let headers: HTTPHeaders = ["Accept" : ACCEPT]
        wc.callSimplewebservice(url: tellZLogin, parameters: parameters as [String : Any], headers: headers, fromView: self.view, isLoading: true) { (success, response: WalletLoginResponsModel?) in
            if success {
                let suc = response?.success
                if suc == true {
                    let obj = response?.data
                    self.otp = obj?.otp
                    self.number = obj?.mobileNumber
                    loggdenUser.set(self.number, forKey: mobNumberWallet)
                    self.viewOtp.isHidden = false
                    self.viewBgCustom.isHidden = true
                    self.paymentview.isHidden = true
                
                }
            }
        }
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
                    self.viewInner.isHidden = true
                    self.viewOtp.isHidden = true
//                    self.Getwallet()
                    if self.checkwithdraw == "true"{
                        self.paymentview.isHidden = false
                        self.transperentview.isHidden = false
                    }
                    else{
                        self.NavigateWallet()
                    }
                    
                }
            }
        }
    }
    
    func Convert_coin_money() {
        let parameters = ["coin":txt_convertcoin.text ?? ""]
        let token = loggdenUser.value(forKey: walletToken)as! String
        let BEARERTOKEN = BEARER + token
        
        let headers: HTTPHeaders = ["Accept" : ACCEPT,
        "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: convert_coin_money, parameters: parameters as [String : Any], headers: headers, fromView: self.view, isLoading: true) { (success, response: MywalletResponsModel?) in
            if success {
                let suc = response?.success
                if suc == true {
//                    let obj = response?.data
//                    let mobnumber = obj?.mobileNumber
//                    let token = obj?.token
//                    loggdenUser.set(mobnumber, forKey: mobNumberWallet)
//                    loggdenUser.set(token, forKey: walletToken)
//                    loggdenUser.set(true, forKey: walletLoginTellz)
//                    self.viewInner.isHidden = true
//                    self.viewOtp.isHidden = true
//                    self.Getwallet()
                    self.NavigateWallet()
                }
            }
        }
    }
    
    func Getwallet() {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "TellzmeWalletVC")as! TellzmeWalletVC//TellzmeWalletViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btn_continue_action(_ sender: Any) {
        if txt_convertcoin.text?.isEmpty == true{
            showalert(tlt: "", msg: "Please enter number of coin")
        }
        else{
            Convert_coin_money()
        }
    }
    
    @IBAction func btn_dismiss(_ sender: Any) {
        transperentview.isHidden = true
        self.NavigateWallet()
    }
    
    
    @IBAction func btn_continue_withdraw(_ sender: Any) {
   
        if txt_point.text?.isEmpty == true{
            showalert(tlt: "", msg: "please enter point")
        }
        else{
            let mobile = loggdenUser.string(forKey: mobNumberWallet) ?? ""
            NumberVerify(strNumber: mobile)
        }
    }
    
    
    @IBAction func btn_bankdetailContinueAction(_ sender: Any) {
        if typestr == ""{
            showalert(tlt: "", msg: "Select Payment type")
        }
        else{
            if typestr == "PAYTM"{
               
                if txt_accountnumber.text?.isEmpty == true{
                    showalert(tlt: "", msg: "Enter Account Number")
                }
                else{
                    let dic = ["paytm_no":txt_accountnumber.text ?? ""]
                    print("dic:",dic)
                    WithdrawMoney(withdraw_details: dic, withdraw_detailsP: txt_accountnumber.text ?? "")
                }
            }
            else{
                if txt_accountnumber.text?.isEmpty == true{
                    showalert(tlt: "", msg: "Enter Account Number")
                }
                else{
                    if txt_beneficiaryname.text?.isEmpty == true{
                        showalert(tlt: "", msg: "Enter Beneficiary Name")
                    }
                    else{
                        if txt_bankname.text?.isEmpty == true{
                           showalert(tlt: "", msg: "Enter Bank Name")
                        }
                        else{
                            if txt_ifsccode.text?.isEmpty == true {
                                showalert(tlt: "", msg: "Enter IFSC Code")
                            }
                            else{
                                let dic = ["bank_name":txt_bankname.text ?? "",
                                           "beneficial_name":txt_beneficiaryname.text ?? "",
                                           "beneficial_acc_no":txt_accountnumber.text ?? "",
                                           "ifsc_code":txt_ifsccode.text ?? ""]
                                print("dic:",dic)
                                WithdrawMoney(withdraw_details: dic, withdraw_detailsP: "")
                            }
                        }
                    }
                }
            }

        }
    }
    
    
    func WithdrawMoney(withdraw_details:[String:Any],withdraw_detailsP:String) {
        var parameters = [String : Any]()
        if typestr == "PAYTM"{
                     parameters = ["withdraw_details":withdraw_detailsP,"withdraw_mode":typestr,"amount":txt_point.text ?? ""] as [String : Any]
        }
        else{
                     parameters = ["withdraw_details":withdraw_details,"withdraw_mode":typestr,"amount":txt_point.text ?? ""] as [String : Any]
        }

        let token = loggdenUser.value(forKey: walletToken)as! String
        let BEARERTOKEN = BEARER + token
        
        let headers: HTTPHeaders = ["Accept" : ACCEPT,
        "Authorization":BEARERTOKEN]
        print("headers:",headers)
        wc.callSimplewebservice(url: withdraw_money, parameters: parameters as [String : Any], headers: headers, fromView: self.view, isLoading: true) { (success, response: RootClassWallet?) in
            if success {
                let suc = response?.success
                if suc == true {
//                    let obj = response?.data
//                    let mobnumber = obj?.mobileNumber
//                    let token = obj?.token
//                    loggdenUser.set(mobnumber, forKey: mobNumberWallet)
//                    loggdenUser.set(token, forKey: walletToken)
//                    loggdenUser.set(true, forKey: walletLoginTellz)
//                    self.viewInner.isHidden = true
//                    self.viewOtp.isHidden = true
//                    self.Getwallet()
                    self.NavigateWallet()
                }
                else{
                    self.showalert(tlt: "", msg: response?.message ?? "")
                }
            }

        }
    }
    
}

extension UIViewController{
    func showalert(tlt:String, msg:String)  {
        let alert = UIAlertController(title:tlt, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


