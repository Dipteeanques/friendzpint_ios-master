//
//  WithdrawVC.swift
//  FriendzPoint
//
//  Created by Anques on 22/02/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class WithdrawVC: UIViewController {
    var wc = Webservice.init()
    var checkwithdraw = ""
    
    @IBOutlet weak var lblMsg: UITextField!
    @IBOutlet weak var btn: UIButton!{
        didSet{
            btn.layer.cornerRadius = btn.frame.height/2
            btn.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblinfo: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        //setStatusBar1(backgroundColor: .black)

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        if lblMsg.text?.isEmpty == true{
            showalert(tlt: "", msg: "Please enter number of coin")
        }
        else{
            
            if checkwithdraw == "true"{
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "MoneyVC")as! MoneyVC//TellzmeWalletViewController
                obj.strtPoint = lblMsg.text ?? ""
                obj.modalPresentationStyle = .fullScreen
               // self.navigationController?.pushViewController(obj, animated: true)
                self.present(obj, animated: false, completion: nil)
            }
            else{
                Convert_coin_money()
            }
            
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
//        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if checkwithdraw == "convert"{
            lblinfo.text = "Convert Coin"
            lblMsg.placeholder = "Please enter below number of coin"
        }
    }
    
    func Convert_coin_money() {
        let parameters = ["coin":lblMsg.text ?? ""]
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
                    self.NavigateWalletMain()
                }
            }
        }
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
