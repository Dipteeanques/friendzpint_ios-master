//
//  AdmanagerViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 23/06/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit

class AdmanagerViewController: UIViewController {

    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefault()
        // Do any additional setup after loading the view.
    }
    
    func setDefault() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.header.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        header.layer.addSublayer(gradientLayer)
        header.addSubview(btnback)
        header.addSubview(lblTitle)
        header.addSubview(btnSetting)
        
        if UIScreen.main.bounds.width == 320 {
            
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 414, height: header.bounds.size.height)
        }
    }
    

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSettingAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "MemberViewController")as! MemberViewController
        self.navigationController?.pushViewController(obj, animated: true)
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


extension AdmanagerViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblAdmanagCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
}


class tblAdmanagCell: UITableViewCell {
    
    @IBOutlet weak var lblThird: UILabel!
    @IBOutlet weak var lblsecond: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView! {
        didSet {
            img.layer.cornerRadius = img.frame.width / 2
            img.clipsToBounds = true
        }
    }
}
