//
//  HowareyoufeelingController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 27/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Emojimap

class HowareyoufeelingController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionFeeling: UICollectionView!
    
    let mapping = EmojiMap()
    var arrEmoji = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDeafult()
    }
    
    func setDeafult() {
        
        for match in mapping.getMatchesFor("sad dog apple elephant cartoon happy cloths Smileys & People Animals & Nature Food & Drink Activity Travel & Places Objects Symbols Flags Airplane Automobile Calendar Camping Compass Globe Showing Americas Globe Showing Asia-Australia Globe Showing Europe-Africa Flag: European Union Flag: United Nations Globe With Meridians Luggage Pushpin Round Pushpin Scroll Map of Japan Spiral Calendar Tear-Off Calendar") {
            let stremo = match.emoji
            arrEmoji.append(stremo)
        }
       
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
        else if UIScreen.main.bounds.height == 812 {
            // txtviewHeightConstraint.constant = 400
        }
        else if UIScreen.main.bounds.width == 320 {
            //txtviewHeightConstraint.constant = 190
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

extension HowareyoufeelingController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrEmoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionFeeling.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let lblImg = cell.viewWithTag(101)as! UILabel
        lblImg.text = arrEmoji[indexPath.row]
        return cell
    }
}


