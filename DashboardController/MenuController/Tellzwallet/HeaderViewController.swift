//
//  HeaderViewController.swift
//  FriendzPoint
//
//  Created by Anques on 07/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class HeaderViewController: UIViewController {
    

    
    @IBOutlet weak var lblRedeemcoin: UILabel!
    @IBOutlet weak var lblWithdraw: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblCoin: UILabel!

    @IBOutlet weak var viewmain: UIView!{
        didSet{
            viewmain.layer.cornerRadius = 5
            viewmain.clipsToBounds = true
            viewmain.layer.borderWidth = 1
            viewmain.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    @IBOutlet weak var btnWithdraw: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnback: UIButton!
    
    @IBOutlet weak var gridentView: UIView!{
        didSet{
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.gridentView.bounds
            gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            if #available(iOS 13, *){
                
            }
            else{
    //            UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
                UIApplication.shared.statusBarView?.layer.addSublayer(gradientLayer)
            }
            gridentView.layer.addSublayer(gradientLayer)
            gridentView.addSubview(btnback)
            gridentView.addSubview(btnWithdraw)
           
        }
    }
    
    @IBOutlet weak var btn_convertcoin: UIButton!{
        didSet {
            btn_convertcoin.layer.cornerRadius = 5
            btn_convertcoin.clipsToBounds = true
        }
    }
    
    
    var wc = Webservice.init()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        gridentView.addSubview(lbltitle)
        Getwallet()
    }
    
    
    
    func Getwallet() {
        let token = loggdenUser.value(forKey: walletToken)as! String
        let BEARERTOKEN = BEARER + token
        
        let headers: HTTPHeaders = ["Accept" : ACCEPT,
        "Authorization":BEARERTOKEN]
        print("headers:",headers)
        wc.callGETSimplewebservice(url: mywallet, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response: MywalletResponsModel?) in
            print(response)
            if success {
                let suc = response?.success
                if suc == true {
                    let data = response?.data
                    let COINSTOTAL = data?.totalCoin
                    self.lblCoin.text =  String(COINSTOTAL!)//"COINS TOTAL" +
                    let redeem = data?.redeemCoin
                    let balance = data?.balance
                    let withdraw = data?.totalWithdrawBalance
                    self.lblRedeemcoin.text =  String(redeem!)//"COINS REDEEMED " +
                    self.lblBalance.text =  String(balance!) //"BALANCE " +
                    self.lblWithdraw.text =  String(withdraw!) //"WITHDRAW BALANCE " +
                }
            }
        }
    }
    
    
    @IBAction func btn_convertcoin_Action(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "TellzwalletupdateVC")as! TellzwalletupdateVC//TellzmeWalletViewController
        obj.checkwithdraw = "convert"
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnWthrawAction(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "TellzwalletupdateVC")as! TellzwalletupdateVC//TellzmeWalletViewController
        obj.checkwithdraw = "true"
        self.navigationController?.pushViewController(obj, animated: true)
    }

}
