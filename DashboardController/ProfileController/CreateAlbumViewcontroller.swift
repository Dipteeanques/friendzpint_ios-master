//
//  CreateAlbumViewcontroller.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 08/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Photos
import DKPhotoGallery
import DKImagePickerController
import SquareFlowLayout
import AVKit
import Alamofire

class CreateAlbumViewcontroller: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnPhotoSelect: UIButton!
    @IBOutlet weak var txtViewAbout: UITextView!
    @IBOutlet weak var txtPrivacytype: SWComboxView!
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    var arrSelected = [TagList]()
    var assets: [DKAsset]?
    var boolSingale = Bool()
    var multibool = Bool()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var url: URL?
    var arrTag = [TagList]()
    var strTageName = String()
    var selectedIndex = Int()
    var arrImages = [UIImage]()
    var object = NSDictionary()
    var wc = Webservice.init()
    var uploadProfilePhoto: UploadParameterMode! = nil
    var postSelected = String()
    var strPrivacy = String()
    var Album_id = Int()
    
    
    enum CellType {
        case normal
        case expanded
    }
    
    private let layoutValues: [CellType] = [
        .expanded, .expanded, .normal,
        .normal, .normal,.normal, .normal, .normal,
        .normal, .normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.expanded]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDeafult()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCombox()
    }
    
    func setupCombox() {
        txtPrivacytype.dataSource = self
        txtPrivacytype.delegate = self
        //category.showMaxCount = 4
    }
    
    func setDeafult() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.headerView.bounds
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        headerView.layer.addSublayer(gradientLayer)
        headerView.addSubview(btnBack)
        headerView.addSubview(lblTitle)
        headerView.addSubview(btnDone)
        headerView.addSubview(activity)
//        if UIScreen.main.bounds.width == 414 {
//            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
//        }
        txtViewAbout.layer.borderWidth = 1
        txtViewAbout.layer.borderColor = UIColor.black.cgColor
        txtViewAbout.layer.cornerRadius = 5
        txtViewAbout.clipsToBounds = true
        
        btnPhotoSelect.layer.borderWidth = 1
        btnPhotoSelect.layer.borderColor = UIColor.blue.cgColor
        btnPhotoSelect.layer.cornerRadius = 5
        btnPhotoSelect.clipsToBounds = true
        activity.isHidden = true
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        strPrivacy = "private"
        
        if Album_id == 0 {
            print("jekil")
        }
        else {
            getedit()
        }
    }
    
    func getedit() {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username": username,
                          "id":Album_id] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: ALBUM_EDIT, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: getAlbumeditrespons?) in
            if sucess {
                let res = response?.success
                if res! {
                    let dict = response?.data
                    self.txtname.text = dict?.name
                    self.txtViewAbout.text = dict?.about
                    let privacy = dict!.privacy
                    if privacy == "private" {
                        self.strPrivacy = "private"
                         self.txtPrivacytype.defaultSelectedIndex = 0
                    }
                    else {
                        self.strPrivacy = "public"
                        self.txtPrivacytype.defaultSelectedIndex = 1
                    }
                }
            }
        }
    }
    
    
    func createAlbum() {
        if Album_id == 0 {
            btnDone.isHidden = true
            activity.isHidden = false
            activity.startAnimating()
            let username = loggdenUser.value(forKey: USERNAME)as! String
            let parameters = ["username" : username,
                              "name": txtname.text!,
                              "privacy": strPrivacy,
                              "about": txtViewAbout.text!]as [String:Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            AF.upload(
                multipartFormData: { multiPart in
                    for (key, value) in parameters {
                        if let temp = value as? String {
                            multiPart.append(temp.data(using: .utf8)!, withName: key)
                        }
                        if let temp = value as? Int {
                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                        }
                        if let temp = value as? NSArray {
                            temp.forEach({ element in
                                let keyObj = key + "[]"
                                if let string = element as? String {
                                    multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                } else
                                    if let num = element as? Int {
                                        let value = "\(num)"
                                        multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                }
                            })
                        }
                    }
                    for (index,image) in self.arrImages.enumerated() {
                        let image = image.resizeWithWidth(width: 800)!
                        let imageData:Data = image.jpegData(compressionQuality: 0.2)!
                        multiPart.append(imageData, withName: "album_photos[\(index)]", fileName: "image[\(index)].jpg", mimeType: "image/jpeg")
                    }
            },
                usingThreshold: UInt64.init(),to: ALBUM_CREATE, method: .post , headers: headers)
                .responseJSON(completionHandler: { (response) in
                    print(response)
                    
                    let resdect = response.value as! NSDictionary
                    let sucess = resdect.value(forKey: "success")as! Bool
                    let strMsg = resdect.value(forKey: "message")as! String
                    
                    if sucess == true {
                        self.btnDone.isHidden = false
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Photos"), object: nil)
                    }
                    else {
                        let uiAlert = UIAlertController(title: "FriendzPoint", message: strMsg, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                            self.btnDone.isHidden = false
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                        }))
                    }
                })
        }
        else {
            btnDone.isHidden = true
            activity.isHidden = false
            activity.startAnimating()
            let username = loggdenUser.value(forKey: USERNAME)as! String
            let parameters = ["username" : username,
                              "id":Album_id,
                              "name": txtname.text!,
                              "privacy": strPrivacy,
                              "about": txtViewAbout.text!]as [String:Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            AF.upload(
                multipartFormData: { multiPart in
                    for (key, value) in parameters {
                        if let temp = value as? String {
                            multiPart.append(temp.data(using: .utf8)!, withName: key)
                        }
                        if let temp = value as? Int {
                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                        }
                        if let temp = value as? NSArray {
                            temp.forEach({ element in
                                let keyObj = key + "[]"
                                if let string = element as? String {
                                    multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                } else
                                    if let num = element as? Int {
                                        let value = "\(num)"
                                        multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                }
                            })
                        }
                    }
                    for (index,image) in self.arrImages.enumerated() {
                        let image = image.resizeWithWidth(width: 800)!
                        let imageData:Data = image.jpegData(compressionQuality: 0.2)!
                        multiPart.append(imageData, withName: "album_photos[\(index)]", fileName: "image[\(index)].jpg", mimeType: "image/jpeg")
                    }
            },
                usingThreshold: UInt64.init(),to: ALBUM_EDITSAVE, method: .post , headers: headers)
                .responseJSON(completionHandler: { (response) in
                    print(response)
                    
                    let resdect = response.value as! NSDictionary
                    let sucess = resdect.value(forKey: "success")as! Bool
                    let strMsg = resdect.value(forKey: "message")as! String
                    
                    if sucess == true {
                        self.btnDone.isHidden = false
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.backTwo()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Photos"), object: nil)
                    }
                    else {
                        let uiAlert = UIAlertController(title: "FriendzPoint", message: strMsg, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                            self.btnDone.isHidden = false
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                        }))
                    }
                })
        }
    }
    
    func backTwo() {
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
    @IBAction func btnGallaryAction(_ sender: UIButton) {
        let pickerController = DKImagePickerController()
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.updateAssets(assets: assets)
        }
        pickerController.showsCancelButton = true
        pickerController.allowMultipleTypes = false
        pickerController.maxSelectableCount = 10
        self.present(pickerController, animated: true) {}
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        createAlbum()
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


extension CreateAlbumViewcontroller: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tblView.dequeueReusableCell(withIdentifier: "imgCell", for: indexPath)as! tblcellCreateAlbum
            if boolSingale == true {
                let asset = self.assets![0]
                if asset.type == .photo {
                    asset.fetchOriginalImage(completeBlock: { (image, info) in
                        self.arrImages.append(image!)
                        cell.setCustomImage(image: image!)
                        cell.btnplay.isHidden = true
                        self.tblView.beginUpdates()
                        self.tblView.endUpdates()
                        
                    })
                }
                else {
                    asset.fetchOriginalImage(completeBlock: { (image, info) in
                        cell.setCustomImage(image: image!)
                        cell.btnplay.isHidden = false
                        cell.btnplay.addTarget(self, action: #selector(PostViewController.btnPlayAction), for: UIControl.Event.touchUpInside)
                        self.tblView.beginUpdates()
                        self.tblView.endUpdates()
                        
                    })
                }
            }
            else {
                
            }
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            
            return cell
        }
        else {
            let cell = tblView.dequeueReusableCell(withIdentifier: "Multiimgcell", for: indexPath)as! tblcellCreateAlbum
            if multibool == true {
                cell.collectionViewMultipaleimage.delegate = self
                cell.collectionViewMultipaleimage.dataSource = self
                cell.collectionViewMultipaleimage.reloadData()
                cell.collectionViewMultipaleimage.tag = 1001
                cell.collectionViewMultipaleimage.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
                
                if assets!.count == 2 {
                    if UIScreen.main.bounds.width == 320 {
                        cell.collectionheightConstraint.constant = 160
                        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                        layout.minimumInteritemSpacing = 0
                        layout.minimumLineSpacing = 0
                        cell.collectionViewMultipaleimage.collectionViewLayout = layout
                    }
                    else if UIScreen.main.bounds.width == 414 {
                        cell.collectionheightConstraint.constant = 210
                        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                        layout.minimumInteritemSpacing = 0
                        layout.minimumLineSpacing = 0
                        cell.collectionViewMultipaleimage.collectionViewLayout = layout
                    }
                    else {
                        cell.collectionheightConstraint.constant = 190
                        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                        layout.minimumInteritemSpacing = 0
                        layout.minimumLineSpacing = 0
                        cell.collectionViewMultipaleimage.collectionViewLayout = layout
                    }
                }
                else if assets!.count == 3 {
                    if UIScreen.main.bounds.width == 320 {
                        cell.collectionheightConstraint.constant = 215
                        let flowLayout = SquareFlowLayout()
                        flowLayout.flowDelegate = self
                        cell.collectionViewMultipaleimage.collectionViewLayout = flowLayout
                    }
                    else if UIScreen.main.bounds.width == 414 {
                        cell.collectionheightConstraint.constant = 280
                        let flowLayout = SquareFlowLayout()
                        flowLayout.flowDelegate = self
                        cell.collectionViewMultipaleimage.collectionViewLayout = flowLayout
                    }
                    else {
                        cell.collectionheightConstraint.constant = 255
                        let flowLayout = SquareFlowLayout()
                        flowLayout.flowDelegate = self
                        cell.collectionViewMultipaleimage.collectionViewLayout = flowLayout
                    }
                }
                else if assets!.count == 4 {
                    if UIScreen.main.bounds.width == 320 {
                        cell.collectionheightConstraint.constant = 320
                        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                        layout.minimumInteritemSpacing = 0
                        layout.minimumLineSpacing = 0
                        cell.collectionViewMultipaleimage.collectionViewLayout = layout
                    }
                    else if UIScreen.main.bounds.width == 414 {
                        cell.collectionheightConstraint.constant = 420
                        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                        layout.minimumInteritemSpacing = 0
                        layout.minimumLineSpacing = 0
                        cell.collectionViewMultipaleimage.collectionViewLayout = layout
                    }
                    else {
                        cell.collectionheightConstraint.constant = 375
                        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
                        layout.minimumInteritemSpacing = 0
                        layout.minimumLineSpacing = 0
                        cell.collectionViewMultipaleimage.collectionViewLayout = layout
                    }
                }
                else if assets!.count == 5 {
                    if UIScreen.main.bounds.width == 320 {
                        let flowLayout = SquareFlowLayout()
                        flowLayout.flowDelegate = self
                        cell.collectionViewMultipaleimage.collectionViewLayout = flowLayout
                    } else if UIScreen.main.bounds.width == 414 {
                        cell.collectionheightConstraint.constant = 415
                        let flowLayout = SquareFlowLayout()
                        flowLayout.flowDelegate = self
                        cell.collectionViewMultipaleimage.collectionViewLayout = flowLayout
                    }
                    else {
                        cell.collectionheightConstraint.constant = 375
                        let flowLayout = SquareFlowLayout()
                        flowLayout.flowDelegate = self
                        cell.collectionViewMultipaleimage.collectionViewLayout = flowLayout
                    }
                }
                    
                else if assets!.count >= 6 {
                    if UIScreen.main.bounds.width == 320 {
                        selectedIndex = 5
                        let flowLayout = SquareFlowLayout()
                        flowLayout.flowDelegate = self
                        cell.collectionViewMultipaleimage.collectionViewLayout = flowLayout
                    }
                    else if UIScreen.main.bounds.width == 414 {
                        selectedIndex = 5
                        cell.collectionheightConstraint.constant = 415
                        let flowLayout = SquareFlowLayout()
                        flowLayout.flowDelegate = self
                        cell.collectionViewMultipaleimage.collectionViewLayout = flowLayout
                    }
                    else {
                        selectedIndex = 5
                        cell.collectionheightConstraint.constant = 375
                        let flowLayout = SquareFlowLayout()
                        flowLayout.flowDelegate = self
                        cell.collectionViewMultipaleimage.collectionViewLayout = flowLayout
                    }
                }
               
            }
            else {
                print("hello")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let asset = self.assets![0]
            if asset.type == .video {
                asset.fetchAVAsset { (avAsset, info) in
                    DispatchQueue.main.async(execute: { () in
                        self.playVideo(avAsset!)
                    })
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if boolSingale == true {
                return UITableView.automaticDimension
            }
            else {
                return 0
            }
        }
        else {
            if multibool == true {
                return UITableView.automaticDimension
            }
            else {
                return 0
            }
        }
    }
    
    func updateAssets(assets: [DKAsset]) {
        print(assets)
        self.assets = assets
        if assets.count == 0 {
            print("null")
        }
        else if assets.count == 1 {
            self.boolSingale = true
            self.multibool = false
            self.tblView.reloadData()
        } else {
            self.multibool = true
            self.boolSingale = false
            self.tblView.reloadData()
        }
    }
    
    func playVideo(_ asset: AVAsset) {
        let avPlayerItem = AVPlayerItem(asset: asset)
        
        let avPlayer = AVPlayer(playerItem: avPlayerItem)
        let player = AVPlayerViewController()
        player.player = avPlayer
        
        avPlayer.play()
        
        self.present(player, animated: true, completion: nil)
    }
    
    @objc func btnPlayAction(_ sender: UIButton) {
        if let indexPath = self.tblView.indexPathForView(sender) {
            let cellfeed = tblView.cellForRow(at: indexPath) as! tblPostCell
            let asset = self.assets![0]
            asset.fetchAVAsset { (avAsset, info) in
                DispatchQueue.main.async(execute: { () in
                    self.playVideo(avAsset!)
                })
            }
        }
        
    }
    
}

extension CreateAlbumViewcontroller: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let asset = self.assets![indexPath.row]
        asset.fetchOriginalImage(completeBlock: { (image, info) in
            self.arrImages.append(image!)
            cell.imageView.image = image
        })
        
        if assets!.count >= 7 {
            if selectedIndex == indexPath.row {
                cell.transView.isHidden = false
                let countvalue = assets!.count - 6
                let strString = String(countvalue)
                cell.lblCount.text = "+ " + strString
            } else {
                cell.transView.isHidden = true
            }
        }
        
        return cell
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let padding: CGFloat =  1
    //        let collectionViewSize = collectionView.frame.size.width - padding
    //        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    //
    //    }
    
    func imageArrayToNSData(array: [UIImage],boundary:String) -> NSData {
        let body = NSMutableData()
        var i = 0;
        for image in array{
            let filename = "image\(i).jpg"
            let data = image.jpegData(compressionQuality: 0.8)
            let mimetype = "image/jpeg"
            let key = "product_images"
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
            body.append(data!)
            body.append("\r\n".data(using: .utf8)!)
            i += 1
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
}




extension CreateAlbumViewcontroller: SquareFlowLayoutDelegate {
    func shouldExpandItem(at indexPath: IndexPath) -> Bool {
        
        if assets!.count == 5 {
            return self.layoutValues[indexPath.row] == .normal
        }
        else {
            return self.layoutValues[indexPath.row] == .expanded
        }
    }
}


extension CreateAlbumViewcontroller: UITextViewDelegate
{
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        
        if !txtViewAbout.text!.isEmpty && txtViewAbout.text! == "Write Something..."
        {
            txtViewAbout.text = ""
            txtViewAbout.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        
        if txtViewAbout.text.isEmpty
        {
            txtViewAbout.text = "Write Something..."
            txtViewAbout.textColor = UIColor.lightGray
        }
    }
}


//MARK: - Drop Down
extension CreateAlbumViewcontroller: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        return ["Private", "Public"]
    }
    
    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
        return SWComboxTextSelection()
        
    }
    
    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
}

extension CreateAlbumViewcontroller : SWComboxViewDelegate {
    //MARK: delegate
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
        print("index - \(index) selected - \(object)")
        if index == 0 {
            strPrivacy = "private"
        }
        else if index == 1 {
            strPrivacy = "public"
        }
    }
    
    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
        if isOpen {
            txtPrivacytype.onAndOffSelection()
            
        }
    }
}
