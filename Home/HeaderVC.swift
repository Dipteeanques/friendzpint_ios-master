//
//  HeaderVC.swift
//  FriendzPoint
//
//  Created by Anques on 04/02/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class HeaderVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentTabBar?.setBar(hidden: true, animated: false)
        lblTitle.text = strTitle
        navigationController?.setStatusBar(backgroundColor: .black)
    }
    

    @IBAction func btnBack(_ sender: Any) {
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


var strTitle = ""
