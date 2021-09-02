//
//  newDiscoverTableViewCell.swift
//  FriendzPoint
//
//  Created by Anques on 13/07/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import SDWebImage

class newDiscoverTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {


    
    var arrData = ["night3","night2","night3","night3","night2","night3"]
    @IBOutlet weak var discoverCollectionView: UICollectionView!
    
    @IBOutlet weak var hashName : UILabel!
    @IBOutlet weak var hashNameSub : UILabel!
    
    var videosObj = [videoMainMVC]()
    
    
    //MARK:- Outlets
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("videosObjR: ",videosObj)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK:- SetupView
    
    func setupView(){
        
    }
    
    //MARK:- Switch Action
    
    //MARK:- Button Action
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    
    //MARK: CollectionView.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videosObj.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"newDiscoverCVC" , for: indexPath) as! newDiscoverCollectionViewCell
        
        let vidObj = videosObj[indexPath.row]
//        cell.img.sd_setImage(with: URL(string:vidObj.videoGIF), placeholderImage: UIImage(named: "videoPlaceholder"))
        
        let gifURL : String = (AppUtility?.detectURL(ipString: vidObj.videoTHUM))!
//        let imageURL = UIImage.gifImageWithURL(gifURL)
//        cell.img.image = imageURL
        
        cell.img.sd_setIndicatorStyle(.gray)
        cell.img.sd_setImage(with: URL(string:(gifURL)), placeholderImage: UIImage(named:"videoPlaceholder"))

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          
          return CGSize(width: self.discoverCollectionView.frame.size.width/4, height: 130)

      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let rootViewController = UIApplication.topViewController() {
            let storyMain = UIStoryboard(name: "Main", bundle: nil)
            let vc =  storyMain.instantiateViewController(withIdentifier: "ReelsVC") as! ReelsVC
            vc.discoverVideoArr = videosObj
//            vc.indexAt = indexPath
//            vc.hidesBottomBarWhenPushed = true
            vc.modalPresentationStyle = .overFullScreen
            rootViewController.present(vc, animated: false, completion: nil)//navigationController?.pushViewController(vc, animated: true)
        }
        print("videosObj.count",videosObj.count)
        print(indexPath.row)
        
    }
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
    //MARK: Location
    
    //MARK: Google Maps
    
    //MARK:- View Life Cycle End here...

}


extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
