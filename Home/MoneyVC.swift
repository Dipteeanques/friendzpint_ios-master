//
//  MoneyVC.swift
//  FriendzPoint
//
//  Created by Anques on 11/03/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import UIDropDown

class MoneyVC: UIViewController {
    
    
    @IBOutlet weak var viewbankdetail: UIView!
    @IBOutlet weak var txt_selecttype: UITextField!
    @IBOutlet weak var txt_accountnumber: UITextField!
    @IBOutlet weak var txt_beneficiaryname: UITextField!
    @IBOutlet weak var txt_bankname: UITextField!
    @IBOutlet weak var txt_ifsccode: UITextField!
    @IBOutlet weak var btn_bankdetialcontinue: UIButton!
    var wc = Webservice.init()
    var typestr = ""
    
    var strtPoint =  String()
    
    var drop1: UIDropDown!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setDefault()
    }
    

    func setDefault() {
        txt_selecttype.isHidden = true
        print("width123:", txt_selecttype.frame.size.width)
        drop1 = UIDropDown(frame: CGRect(x: txt_selecttype.frame.origin.x, y: txt_selecttype.frame.origin.y, width:250, height: txt_selecttype.frame.size.height))//txt_selecttype.frame.size.width
//        drop1.center = CGPoint(x: self.txt_selecttype.frame.midX, y: self.txt_selecttype.frame.midY)
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
                     parameters = ["withdraw_details":withdraw_detailsP,"withdraw_mode":typestr,"amount":strtPoint] as [String : Any]
        }
        else{
                     parameters = ["withdraw_details":withdraw_details,"withdraw_mode":typestr,"amount":strtPoint] as [String : Any]
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
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
