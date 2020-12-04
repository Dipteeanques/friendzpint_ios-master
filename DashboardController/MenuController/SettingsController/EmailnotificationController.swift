//
//  EmailnotificationController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 31/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class EmailnotificationController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnsave: UIButton!
    
    //MARK: - Variable
    var arrNotiEmail = ["When someone follows me","When someone likes my post","When someone share my post","When someone comments my post","When someone likes my comment","When someone replies to my comment","When someone joins my group","When someone likes my page"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDeafult()
    }
    
    func setDeafult() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.headerView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerView.layer.addSublayer(gradientLayer)
        headerView.addSubview(btnBack)
        headerView.addSubview(lblTitle)
        
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
        }
        btnsave.layer.cornerRadius = 5
        btnsave.clipsToBounds = true
      
    }
    
    
    //MARK: - Btn Action
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

//MARK: - Tableview Method
extension EmailnotificationController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotiEmail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lbltitle = cell.viewWithTag(101)as! UILabel
        lbltitle.text = arrNotiEmail[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
