//
//  TimezoneController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 21/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class TimezoneController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var tblTimezone: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnback: UIButton!
    
    var wc = Webservice.init()
    var arrTimeZone = [String]()
    var selectedTimezone = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDeafult()
    }
    
    func setDeafult() {
        loaderView.isHidden = false
        activity.startAnimating()
       getTimeZone()
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.headerView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerView.layer.addSublayer(gradientLayer)
        headerView.addSubview(btnback)
        headerView.addSubview(lblTitle)
        
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
        }
    }
    
    func getTimeZone() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        
        self.wc.callSimplewebservice(url: TIMEZONELIST, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (sucess, response: TimezoneResponsModel?) in
            if sucess {
                self.arrTimeZone = response!.data
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
                self.tblTimezone.reloadData()
            }
        }
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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

//MARK: - Tableview
extension TimezoneController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTimeZone.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblTimezone.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrTimeZone[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTimezone = arrTimeZone[indexPath.row]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Timezone"), object: selectedTimezone)
        dismiss(animated: true, completion: nil)
    }
}
