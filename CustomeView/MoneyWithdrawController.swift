//
//  MoneyWithdrawController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 18/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class MoneyWithdrawController: UIViewController {
    
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtIFSCcode: UITextField!
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var header: UIView!
    
    var amount = ""
    var withdraw_mode = ""
    var withdraw_details = ""
    
    let wc = Webservice.init()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setDefault()
        // Do any additional setup after loading the view.
    }
    
    func setDefault() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.header.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        header.layer.addSublayer(gradientLayer)
        header.addSubview(btnback)
        header.addSubview(lbltitle)
        
        if UIScreen.main.bounds.width == 320 {
            
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 414, height: header.bounds.size.height)
        }
        
        btnOne.setImage(#imageLiteral(resourceName: "CheckBox"), for: .normal)
        withdraw_mode = "PAYTM"
        txtNumber.placeholder = "Enter paytm number"
        txtIFSCcode.isHidden = true
    }
    
    func payment(amount: String,withdraw_mode: String,withdraw_details: String) {
        let token = loggdenUser.value(forKey: walletToken)as! String
        let BEARERTOKEN = BEARER + token
        
        let headers: HTTPHeaders = ["Accept" : ACCEPT,
        "Authorization":BEARERTOKEN]
        
        let parameters = ["amount":amount,"withdraw_mode":withdraw_mode,"withdraw_details":withdraw_details]
        
         wc.callSimplewebservice(url: tellzverify_otp, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (success, response: MoneyWithdrawResponsemodel?) in
            if success {
                let suc = response?.success
                if suc == true {
                    let uiAlert = UIAlertController(title: "FriendzPoint", message: response?.message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        
                        self.dismiss(animated: true, completion: nil)
                    }))
                }
                else {
                    let uiAlert = UIAlertController(title: "FriendzPoint", message: response?.message, preferredStyle: UIAlertController.Style.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        
                        self.dismiss(animated: true, completion: nil)
                    }))
                }
            }
        }
    }
    
    @IBAction func btnOneAction(_ sender: UIButton) {
        btnOne.setImage(#imageLiteral(resourceName: "CheckBox"), for: .normal)
        withdraw_mode = "PAYTM"
        txtNumber.placeholder = "Enter paytm number"
        txtIFSCcode.isHidden = true
        btnTwo.setImage(#imageLiteral(resourceName: "Box"), for: .normal)
    }
    @IBAction func btnTwoAction(_ sender: UIButton) {
        btnOne.setImage(#imageLiteral(resourceName: "Box"), for: .normal)
        withdraw_mode = "BANK"
        txtNumber.placeholder = "Enter bank account number"
        txtIFSCcode.isHidden = false
        btnTwo.setImage(#imageLiteral(resourceName: "CheckBox"), for: .normal)
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        payment(amount: txtAmount.text!, withdraw_mode: withdraw_mode, withdraw_details: withdraw_details)
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
