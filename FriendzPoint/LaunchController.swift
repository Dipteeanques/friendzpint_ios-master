//
//  LaunchController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 10/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class LaunchController: UIViewController {

    @IBOutlet weak var Activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

      Activity.startAnimating()
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
