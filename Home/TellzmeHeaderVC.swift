//
//  TellzmeHeaderVC.swift
//  FriendzPoint
//
//  Created by Anques on 22/02/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class TellzmeHeaderVC: UIViewController {
    
    
    @IBOutlet weak var lblWithdrawBalance: UILabel!
    @IBOutlet weak var lblTotalBalance: UILabel!
    @IBOutlet weak var lblCoinRedeem: UILabel!
    @IBOutlet weak var lblTotalCoin: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    var wc = Webservice.init()
    
    var colorSets = [[UIColor(red: 0.22, green: 0.94, blue: 0.49, alpha: 1.00),UIColor(red: 0.07, green: 0.60, blue: 0.56, alpha: 1.00)]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setStatusBar1(backgroundColor: .black)
        // Do any additional setup after loading the view.
//        createGradientLayer(view: view1, index: 0)
        Getwallet()
    }
    
    @IBAction func btnCovertCoin(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "WithdrawVC")as! WithdrawVC//TellzmeWalletViewController
        obj.checkwithdraw = "convert"
        self.modalPresentationStyle = .fullScreen
//        self.navigationController?.present(obj, animated: false, completion: nil)//pushViewController(obj, animated: true)
        self.present(obj, animated: false, completion: nil)
    }
    
    
    @IBAction func btnWithdraw(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "WithdrawVC")as! WithdrawVC//TellzmeWalletViewController
        obj.checkwithdraw = "true"
        self.modalPresentationStyle = .fullScreen
       // self.navigationController?.pushViewController(obj, animated: true)
        self.present(obj, animated: false, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
                    self.lblTotalCoin.text =  String(COINSTOTAL!)//"COINS TOTAL" +
                    let redeem = data?.redeemCoin
                    let balance = data?.balance
                    let withdraw = data?.totalWithdrawBalance
                    self.lblCoinRedeem.text =  String(redeem!)//"COINS REDEEMED " +
                    self.lblTotalBalance.text =  String(balance!) //"BALANCE " +
                    self.lblWithdrawBalance.text =  String(withdraw!) //"WITHDRAW BALANCE " +
                }
            }
        }
    }
    
    func createGradientLayer(view: UIView,index: Int) {
//        let collectionViewSize = collectionMenu.frame.size.width - 30
        let arrAngle = [304]
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view1.bounds//CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: 109)
        gradientLayer.colors = colorSets[0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.apply(angle: Double(arrAngle[0]))
        view.layer.insertSublayer(gradientLayer, at: 0)
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
