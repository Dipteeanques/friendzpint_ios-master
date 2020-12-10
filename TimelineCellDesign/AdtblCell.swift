//
//  AdtblCell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 26/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import PSHTMLView


class AdtblCell: UITableViewCell {

    @IBOutlet weak var htmlView : PSHTMLView!
    @IBOutlet weak var btnClickWeb: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func gethtml(strHtml: String) {
         htmlView.html = strHtml
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }   
}


