//
//  MultiplaePhotoViewControllerList.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 12/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import TKImageShowing
import SDWebImage

class MultiplaePhotoViewControllerList: UIViewController,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var tblPhotos: UITableView!
    @IBOutlet weak var grediantView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    var url: URL?
    
    var arrImages = [String]()
    
    var index = Int()
    var dicValue = NSDictionary()
    var mySetVala = Bool()
    var arrMultipale = [String]()
    var arrOnlyImg = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDefault()
        
        //arrOnlyImg = self.arrMultipale.value(forKey: "images")as! NSArray
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        lblTitle.text = "Jekil's photos"
    }
    
    func setDefault() {
        NotificationCenter.default.addObserver(self, selector: #selector(MultiplaePhotoViewControllerList.commentNotification), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MultiplaePhotoViewControllerList.BackNotification), name: NSNotification.Name(rawValue: "notificationBack"), object: nil)
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.grediantView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        grediantView.layer.addSublayer(gradientLayer)
        grediantView.addSubview(btnback)
        grediantView.addSubview(lblTitle)
        
        
        if UIScreen.main.bounds.width == 320 {
            
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: grediantView.bounds.origin.x, y: grediantView.bounds.origin.y, width: 414, height: grediantView.bounds.size.height)
        }
    }
    
    @objc func commentNotification(_ notification: NSNotification) {
        dicValue = notification.object as! NSDictionary
        let obj = storyboard?.instantiateViewController(withIdentifier: "CommentsViewControllers")as! CommentsViewControllers
        obj.strCommentImage = "strCommentImage"
        obj.dicImg = dicValue
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @objc func BackNotification(_ notification: NSNotification) {
        index = dicValue.value(forKey: "index") as! Int
        let tkImageVC = TKImageShowing()
        tkImageVC.currentIndex = index
        tkImageVC.images = arrImages.toTKImageSource()
        present(tkImageVC, animated: true, completion: nil)
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCategory() {

        let popoverContent = storyboard?.instantiateViewController(withIdentifier: "CommentsViewControllers")as? CommentsViewControllers
        popoverContent!.strCommentImage = "strCommentImage"
        popoverContent!.dicImg = dicValue

        let nav = UINavigationController(rootViewController: popoverContent!)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent!.preferredContentSize = CGSize(width: 300, height: 300)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 100, y: 100, width: 0, height: 0)

        self.present(nav, animated: true, completion: nil)

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

extension MultiplaePhotoViewControllerList: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMultipale.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = tblPhotos.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            return cell
//        }
//        else {
            let cell = tblPhotos.dequeueReusableCell(withIdentifier: "imgcell", for: indexPath)as! tblMultiCellphoto
            var cellFrame = cell.frame.size
            cellFrame.height =  cellFrame.height - 15
            cellFrame.width =  cellFrame.width - 15
            cell.btnOpen.addTarget(self, action: #selector(MultiplaePhotoViewControllerList.openAction), for: UIControl.Event.touchUpInside)
            let source_url = arrMultipale[indexPath.row]
            arrImages.append(source_url)
            url = URL(string: source_url)
            cell.imgMulti.sd_setImage(with: url, placeholderImage: nil, options: [], completed: { (theImage, error, cache, url) in
//                cell.heightConstraint.constant = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
            })
            return cell
        //}
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func openAction(_ sender: UIButton) {
        if let indexPath = self.tblPhotos.indexPathForView(sender) {
            let cellfeed = tblPhotos.cellForRow(at: indexPath) as! tblMultiCellphoto
            let tkImageVC = TKImageShowing()
            tkImageVC.animatedView  = cellfeed.imgMulti
            tkImageVC.currentIndex = indexPath.row
            tkImageVC.images = arrImages.toTKImageSource()
            let naviget: UINavigationController = UINavigationController(rootViewController: tkImageVC)
            self.present(naviget, animated: true, completion: nil)
            //self.present(tkImageVC, animated: true, completion: nil)
        }
    }
    
    func getAspectRatioAccordingToiPhones(cellImageFrame:CGSize,downloadedImage: UIImage)->CGFloat {
        let widthOffset = downloadedImage.size.width - cellImageFrame.width
        let widthOffsetPercentage = (widthOffset*100)/downloadedImage.size.width
        let heightOffset = (widthOffsetPercentage * downloadedImage.size.height)/100
        let effectiveHeight = downloadedImage.size.height - heightOffset
        return(effectiveHeight)
    }
    
    // MARK: Optional function for resize of image
    func resizeHighImage(image:UIImage)->UIImage {
        let size = image.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
