//
//  ChatViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 13/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var tblChatlist: UITableView!
    
    var arrFriends = ["Mayur Godhani","Jekil Dabhoya","Dipak kukadiya","Maulik Bhuva","Manna kathiriya","Piyush Prajapati"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension ChatViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenulist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMenu.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(101)as! UIImageView
        let lblName = cell.viewWithTag(102)as! UILabel
        img.image = (self.arrMenulist[indexPath.row]as AnyObject).value(forKey: "img") as? UIImage
        lblName.text = (self.arrMenulist[indexPath.row]as AnyObject).value(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}
