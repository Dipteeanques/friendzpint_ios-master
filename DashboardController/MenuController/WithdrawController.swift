//
//  WithdrawController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 08/07/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class WithdrawController: UIViewController {

    @IBOutlet weak var viewFound: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    var wc = Webservice.init()
    var arrList = [DatumWithdrwHistory]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        WithdrawHistory()
        // Do any additional setup after loading the view.
    }
    
    func WithdrawHistory() {
        if loggdenUser.value(forKey: walletToken) != nil {
            let token = loggdenUser.value(forKey: walletToken)as! String
            let BEARERTOKEN = BEARER + token
            
            let headers: HTTPHeaders = ["Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callGETSimplewebservice(url: withdraw_history, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response: WithdrawHistoryResponsModel?) in
                if success {
                    let suc = response?.success
                    if suc == true {
                        let data = response?.data
                        self.arrList = data!.data
                        if self.arrList.count == 0 {
                            self.viewFound.isHidden = false
                        }
                        else {
                            self.viewFound.isHidden = true
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

extension WithdrawController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = arrList[indexPath.row]
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! withdrawtblCell
        cell.lblId.text = data.txnID
        cell.lblPrice.text = rupee + String(data.amount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}


class withdrawtblCell: UITableViewCell {
    
    @IBOutlet weak var lblDic: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var viewBg: UIView! {
        didSet {
            viewBg.layer.cornerRadius = viewBg.bounds.height / 2
            viewBg.clipsToBounds = true
        }
    }
}
