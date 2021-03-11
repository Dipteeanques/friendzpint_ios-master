//
//  TellzmeWalletViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 23/06/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import MXSegmentedPager
import Alamofire

class TellzmeWalletViewController: MXSegmentedPagerController,UITextFieldDelegate {

    @IBOutlet weak var lblRedeemcoin: UILabel!
    @IBOutlet weak var lblWithdraw: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblCoin: UILabel!
    
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var txtNumberCustom: UITextField!
    @IBOutlet weak var viewBgCustom: UIView!
    @IBOutlet weak var btnUpdate: UIButton!{
        didSet {
            btnUpdate.layer.cornerRadius = 5
            btnUpdate.clipsToBounds = true
        }
    }
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnWithdraw: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var header: UIView!
    
    
    @IBOutlet weak var innerviewheight: NSLayoutConstraint!
    
    @IBOutlet weak var view_height: NSLayoutConstraint!
    var number: String?
    var wc = Webservice.init()
    var otp: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        setDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func Getwallet() {
        let token = loggdenUser.value(forKey: walletToken)as! String
        let BEARERTOKEN = BEARER + token
        
        let headers: HTTPHeaders = ["Accept" : ACCEPT,
        "Authorization":BEARERTOKEN]
        wc.callGETSimplewebservice(url: mywallet, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response: MywalletResponsModel?) in
            print(response)
            if success {
                let suc = response?.success
                if suc == true {
                    let data = response?.data
                    let COINSTOTAL = data?.totalCoin
                    self.lblCoin.text = "COINS TOTAL  " + String(COINSTOTAL!)
                    let redeem = data?.redeemCoin
                    let balance = data?.balance
                    let withdraw = data?.totalWithdrawBalance
                    self.lblRedeemcoin.text = "COINS TOTAL  " + String(redeem!)
                    self.lblBalance.text = "COINS TOTAL  " + String(balance!)
                    self.lblWithdraw.text = "COINS TOTAL  " + String(withdraw!)
                }
            }
        }
    }
    
    
    func setDefault() {
//        headerView.isHidden = true
        let isLogin = loggdenUser.bool(forKey: walletLoginTellz)
        print(isLogin)

        segmentedPager.backgroundColor = .white
        // Parallax Header
//        segmentedPager.parallaxHeader.view = headerView
        if isLogin {
            viewInner.isHidden = true
//            segmentedPager.parallaxHeader.height = 500
            Getwallet()
        }
        else {
            viewInner.isHidden = false
//            segmentedPager.parallaxHeader.height = 800
        }
//        segmentedPager.parallaxHeader.mode = .fill
//
//        segmentedPager.parallaxHeader.minimumHeight = 0
        
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 150
        segmentedPager.parallaxHeader.minimumHeight = view.safeAreaInsets.top
        
        // Segmented Control customization
        segmentedPager.segmentedControl.indicator.linePosition = .bottom
        segmentedPager.segmentedControl.backgroundColor = .white
        //segmentedPager.segmentedControl.
        segmentedPager.segmentedControl.textColor = UIColor(red: 73/255, green: 100/255, blue: 134/255, alpha: 1)
        segmentedPager.segmentedControl.font = UIFont.systemFont(ofSize: 14)
        segmentedPager.segmentedControl.selectedTextColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            // segmentedPager.segmentedControl.animation = .
        segmentedPager.segmentedControl.indicatorColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
        segmentedPager.segmentedControl.indicatorHeight = 1.5
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.header.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        header.layer.addSublayer(gradientLayer)
        header.addSubview(btnback)
        header.addSubview(lbltitle)
        header.addSubview(btnWithdraw)
        
        innerView.layer.borderWidth = 1
        innerView.layer.borderColor = UIColor.lightGray.cgColor
        innerView.layer.cornerRadius = 5
        innerView.clipsToBounds = true
//
//        if UIScreen.main.bounds.width == 320 {
//            view_height.constant = 66
//            segmentedPager.parallaxHeader.height = 147
//            segmentedPager.parallaxHeader.minimumHeight = 66
//            gradientLayer.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 414, height: 66)
//
//        } else if UIScreen.main.bounds.width == 414 {
////            innerviewheight.constant = 150
////            gradientLayer.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 414, height: header.bounds.size.height)
//            segmentedPager.parallaxHeader.height = 180
//            segmentedPager.parallaxHeader.minimumHeight = 90
//            gradientLayer.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 414, height: header.bounds.size.height)
//        }
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
    
    override func viewSafeAreaInsetsDidChange() {
        segmentedPager.parallaxHeader.minimumHeight = view.safeAreaInsets.top
    }
    
    func otpVerify(strOTP: String, strNumber: String) {
        let parameters = ["mobile_number":strNumber,"otp":strOTP]
        let headers: HTTPHeaders = ["Accept" : ACCEPT]
        wc.callSimplewebservice(url: tellzverify_otp, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (success, response: WalletLoginTokenResponsModel?) in
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
                    self.segmentedPager.parallaxHeader.height = 300
                    self.Getwallet()
                }
            }
        }
    }
    
    
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func NumberVerify(strNumber: String) {
       let parameters = ["mobile_number":strNumber]
       let headers: HTTPHeaders = ["Accept" : ACCEPT]
        wc.callSimplewebservice(url: tellZLogin, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (success, response: WalletLoginResponsModel?) in
            if success {
                let suc = response?.success
                if suc == true {
                    let obj = response?.data
                    self.otp = obj?.otp
                    self.number = obj?.mobileNumber
                    self.viewOtp.isHidden = false
                }
            }
        }
    }
    
    func alertMatch() {
        let uiAlert = UIAlertController(title: "FriendzPoint", message: "OTP Dose't match", preferredStyle: UIAlertController.Style.alert)
        self.present(uiAlert, animated: true, completion: nil)
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            self.dismiss(animated: true, completion: nil)
        }))
    }
    
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        self.otpVerify(strOTP: txtOTP.text!, strNumber: self.number!)
    }
    @IBAction func btnCancelAction(_ sender: UIButton) {
        viewBgCustom.isHidden = true
    }
    @IBAction func btnUpdateAction(_ sender: UIButton) {
        self.NumberVerify(strNumber: txtNumberCustom.text!)
        viewBgCustom.isHidden = true
    }
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnWthrawAction(_ sender: UIButton) {
        let isLogin = loggdenUser.bool(forKey: walletLoginTellz)
        if isLogin {
           viewBgCustom.isHidden = true
            let obj = storyboard?.instantiateViewController(withIdentifier: "MoneyWithdrawController")as! MoneyWithdrawController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else {
            viewBgCustom.isHidden = false
        }
    }
    @IBAction func updateAction(_ sender: UIButton) {
        viewBgCustom.isHidden = false
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
