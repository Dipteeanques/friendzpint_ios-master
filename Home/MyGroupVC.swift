//
//  MyGroupVC.swift
//  FriendzPoint
//
//  Created by Anques on 30/01/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class MyGroupVC: UIViewController {
    
    let arrGroupIcon = [
        "https://i.pinimg.com/originals/52/c6/65/52c665df0515dd447eb92544374cf543.jpg",
        "https://wallpapercave.com/wp/wp2153319.jpg",
        "https://wallpapercave.com/wp/wp1812462.jpg",
        "https://i.pinimg.com/236x/b7/87/a0/b787a04ff0379708d5af03c4bf4edc69.jpg",
        "https://www.hdwallpapersfreedownload.com/uploads/large/cartoons/doraemon-nobita-wallpaper-hd.jpg",
        "https://images-na.ssl-images-amazon.com/images/I/81agPMtdIlL._AC_SL1500_.jpg"]
    let arrGroupName = [
        "Tom and Jerry Group",
        "Doraemon Group",
        "Sinchan Group",
        "Nobita Group",
        "Doraemon and its Friends Group",
        "Pikachu Group"]
    
    @IBOutlet weak var tblMyGroup: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // navigationController?.setStatusBar(backgroundColor: .white)
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
            if count == 0{
                currentTabBar!.setBadgeText(nil, atIndex: 3)
            }
            else{
                currentTabBar!.setBadgeText(String(count), atIndex: 3)
            }
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCreateAction(_ sender: Any) {
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

extension MyGroupVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGroupIcon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyGroupCell
        cell.imgGroupIcon.kf.setImage(with: URL(string: arrGroupIcon[indexPath.row]),placeholder:UIImage(named: "Placeholder"))
        cell.lblGroupName.text = arrGroupName[indexPath.row]
        return cell
    }
    
    
}
