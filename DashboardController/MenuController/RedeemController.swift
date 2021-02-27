//
//  RedeemController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 08/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
class RedeemController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewfound: UIView!
    
    var wc = Webservice.init()
    var arrList = [DatumRedeem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        myRedeem()
        // Do any additional setup after loading the view.
    }
    
    
    func myRedeem() {
        print("walletToken:",loggdenUser.value(forKey: walletToken) ?? "")
        if loggdenUser.value(forKey: walletToken) != nil {
            let token = loggdenUser.value(forKey: walletToken)as! String
            let BEARERTOKEN = BEARER + token
            
            let headers: HTTPHeaders = ["Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callGETSimplewebservice(url: myredeems, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response: RedeemwalletResponsModel?) in
                print("response: ",response)
                if success {
                    let suc = response?.success
                    if suc == true {
                        let data = response?.data
                        self.arrList = data!.data
                        if self.arrList.count == 0 {
                            self.viewfound.isHidden = false
                        }
                        else {
                            self.viewfound.isHidden = true
                        }
                        self.tblView.reloadData()
                    }
                }
            }
        }
        else {
            print("jekil")
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

extension RedeemController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrList[indexPath.row]
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! redeemCell
        cell.lbltitle.text = data.title
        let type = data.status
        let coin = data.coin
        
        if type == "credit" {
            cell.lblPrice.text = "+" + String(coin) + " Pts"
            cell.lblPrice.textColor = UIColor(red: 0.00, green: 0.50, blue: 0.00, alpha: 1.00)//UIColor.green
//            cell.img.image = #imageLiteral(resourceName: "W2")
            //gradientGreen(profileImageView: cell, shanghaiImage: cell.img)
            cell.img.isHidden = false
            cell.img2.isHidden = true
            cell.imgCash.image = UIImage(named: "cash1")
        }
        else {
            cell.lblPrice.text = "-" + String(coin) + " Pts"
            cell.lblPrice.textColor = UIColor(red: 0.95, green: 0.07, blue: 0.07, alpha: 1.00)//UIColor.red
//            cell.img.image = #imageLiteral(resourceName: "W1")
//            gradientRed(profileImageView: cell, shanghaiImage: cell.img)
           // gradientGreen(profileImageView: cell, shanghaiImage: cell.img)
            cell.img.isHidden = true
            cell.img2.isHidden = false
            cell.imgCash.image = UIImage(named: "cash2")
        }
        
        cell.lblDic.text = data.date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func gradientGreen(profileImageView: UIView, shanghaiImage: UIImageView){
        let view = UIView(frame: profileImageView.frame)

        let gradient = CAGradientLayer()

        gradient.frame = view.bounds

        gradient.colors = [UIColor(red: 0.11, green: 0.59, blue: 0.42, alpha: 1.00).cgColor, UIColor(red: 0.58, green: 0.98, blue: 0.73, alpha: 1.00).cgColor]

        gradient.locations = [0.0, 1.0]

        view.layer.insertSublayer(gradient, at: 0)

        shanghaiImage.addSubview(view)

        shanghaiImage.bringSubviewToFront(view)
    }
    
    func gradientRed(profileImageView: UIView, shanghaiImage: UIImageView){
        let view = UIView(frame: profileImageView.frame)

        let gradient = CAGradientLayer()

        gradient.frame = view.bounds

        gradient.colors = [UIColor(red: 0.59, green: 0.11, blue: 0.11, alpha: 1.00).cgColor, UIColor(red: 0.98, green: 0.58, blue: 0.58, alpha: 1.00).cgColor]

        gradient.locations = [0.0, 1.0]

        view.layer.insertSublayer(gradient, at: 0)

        shanghaiImage.addSubview(view)

        shanghaiImage.bringSubviewToFront(view)
    }
    
}


class redeemCell: UITableViewCell {
    
    @IBOutlet weak var imgCash: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDic: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var img: UIImageView!{
        didSet{
            img.layer.cornerRadius = img.layer.frame.height/2
            img.clipsToBounds = true
        }
    }
    @IBOutlet weak var img2: GradientView2!{
        didSet{
            img2.layer.cornerRadius = img.layer.frame.height/2
            img2.clipsToBounds = true
        }
    }
}
