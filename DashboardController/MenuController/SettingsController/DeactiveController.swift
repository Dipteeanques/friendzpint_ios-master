//
//  DeactiveController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 01/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class DeactiveController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDeactive: UIButton!
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTabBar?.setBar(hidden: true, animated: false)
        setDeafult()
    }
    
    func setDeafult() {
//        let gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = self.headerView.bounds
//
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        headerView.layer.addSublayer(gradientLayer)
//        headerView.addSubview(btnBack)
//        headerView.addSubview(lblTitle)
//
//        if UIScreen.main.bounds.width == 414 {
//            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
//        }
        btnDeactive.layer.cornerRadius = 5
        btnDeactive.clipsToBounds = true
        
    }
    
    func deActiveAccount() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        AF.request(DEACTIVEACCOUNT, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
            let dic = response.value as! NSDictionary
            let success = dic.value(forKey: "success")as! Bool
            let strMSG = dic.value(forKey: "message")as! String
            if success {
                self.appDel.gotoSignupController()
            }
            else {
                let uiAlert = UIAlertController(title: "FriendzPoint", message: strMSG, preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }))
            }
        }
    }
    
    //MARK: - Btn Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDeActiveAction(_ sender: UIButton) {
        deActiveAccount()
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
