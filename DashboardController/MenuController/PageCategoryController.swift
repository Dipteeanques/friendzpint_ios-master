//
//  PageCategoryController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 05/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class PageCategoryController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var tblCategory: UITableView!
    
    var wc = Webservice.init()
    var arrCategory = [CategoryData]()
    var selected = [CategoryData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetCtegory()
        setDeafult()
        
    }
    func setDeafult() {
        loaderView.isHidden = false
        activity.startAnimating()
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.headerview.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerview.layer.addSublayer(gradientLayer)
        headerview.addSubview(btnback)
        headerview.addSubview(lblName)
        
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerview.bounds.origin.x, y: headerview.bounds.origin.y, width: 414, height: headerview.bounds.size.height)
        }
    }
    
    func GetCtegory() {
       
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callGETSimplewebservice(url: PAGE_CATEGORY, parameters: [:], headers: headers, fromView: self.view, isLoading: false) { (sucess, response:PagecategoryResponseModel?) in
            if sucess {
                self.arrCategory = response!.data
                self.tblCategory.reloadData()
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
            }
        }
    }

    @IBAction func btnbackAction(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
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

extension PageCategoryController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCategory.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrCategory[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = [arrCategory[indexPath.row]]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categorySelected"), object: selected)
         self.navigationController?.popViewController(animated: true)
    }
}
