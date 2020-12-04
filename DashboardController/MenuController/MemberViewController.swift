//
//  MemberViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 23/06/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class MemberViewController: UIViewController {

    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var lblActiveDate: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var viewExpiry: UIView!
    @IBOutlet weak var viewActive: UIView!
    @IBOutlet weak var viewCurrent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    
    var arrPlan = [["type":"BASIC","Price":"10 For 30 days"],["type":"STANDARD","Price":"499 For 180 days"],["type":"BASIC","Price":"10 For 30 days"]]
    
    var planData = [DatumAds]()
    var wc = Webservice.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getActivePlan()
        getPlan()
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
        header.addSubview(lblTitle)
        
        if UIScreen.main.bounds.width == 320 {
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 414, height: header.bounds.size.height)
        }
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
        
        viewCurrent.layer.borderWidth = 1
        viewCurrent.layer.borderColor = UIColor.blue.cgColor
        viewCurrent.layer.cornerRadius = 8
        viewCurrent.clipsToBounds = true
        
        viewActive.layer.borderWidth = 1
        viewActive.layer.borderColor = UIColor.blue.cgColor
        viewActive.layer.cornerRadius = 8
        viewActive.clipsToBounds = true
        
        viewExpiry.layer.borderWidth = 1
        viewExpiry.layer.borderColor = UIColor.blue.cgColor
        viewExpiry.layer.cornerRadius = 8
        viewExpiry.clipsToBounds = true
    }
    
    func getActivePlan() {
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN,"Xapi": XAPI]
        wc.callGETSimplewebservice(url: ActivePlan, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response: ActivePlanResponsModel?) in
            print(response)
            if success {
                let suc = response?.success
                if suc == true {
                    let data = response?.data
                    self.lblPlan.text = data?.name
                    self.lblActiveDate.text = data?.activationDate
                    self.lblExpiryDate.text = data?.expiryDate
                }
            }
        }
    }
    
    func getPlan() {
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callGETSimplewebservice(url: Advertise, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response: AdvertiseResponsModel?) in
            print(response)
            if success {
                let suc = response?.success
                if suc == true {
                    self.planData = response!.data
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
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

extension MemberViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = planData[indexPath.row]
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblMemberCell
        cell.lblTitle.text = data.packageName
        let price = data.price
        let disc = " For " + String(data.days) + " days"
        let finalstring = String(price) + disc
        cell.backView.addSubview(cell.lblTitle)
        cell.backView.addSubview(cell.lblPrice)
        cell.backView.addSubview(cell.btnBuy)
        cell.lblPrice.text = rupee + finalstring
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
}


class tblMemberCell: UITableViewCell {
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnBuy: UIButton! {
        didSet {
            btnBuy.layer.cornerRadius = btnBuy.bounds.height / 2
            btnBuy.clipsToBounds = true
        }
    }
    @IBOutlet weak var backView: GradientView! {
        didSet {
            backView.layer.cornerRadius = 10
            backView.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
}


@IBDesignable
open class GradientView: UIView {
    @IBInspectable
    public var startColor = UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor {
        didSet {
            gradientLayer.colors = [startColor, endColor]
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var endColor = UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor {
        didSet {
            gradientLayer.colors = [startColor, endColor]
            setNeedsDisplay()
        }
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [self.startColor, self.endColor]
        return gradientLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 1)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(gradientLayer, at: 1)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
