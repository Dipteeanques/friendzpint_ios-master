//
//  PostViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 20/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//


import UIKit
import Photos
import DKPhotoGallery
import DKImagePickerController
import SquareFlowLayout
import AVKit
import Alamofire
import GooglePlaces
import GoogleMaps
import Emojimap

class PostViewController: UIViewController,GMSMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var txtWatchlive: UITextField!
    @IBOutlet weak var txtDescrption: UITextView!
    @IBOutlet weak var txtheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var footorView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btntag: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var emojiCollection: UICollectionView!
    @IBOutlet weak var viewEmo: UIView!
    @IBOutlet weak var emoviewHeight: NSLayoutConstraint!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var locationHeight: NSLayoutConstraint!
    
    enum CellType {
        case normal
        case expanded
    }
    
    var arrSelected = [TagList]()
    var assets: [DKAsset]?
    var assetsVideo: [DKAsset]?
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
    var MyProfile = String()
    var GroupTimeline_Id = Int()
    var TimelineAll = Int()
    var strLocation = String()
    var selectedBool = true
    var locationBool = true
    var youtube_video_id = String()
    var emoSelectedBool = true
    let mapping = EmojiMap()
    var arrEmoji = [String]()
    var arrselectedemo = [String]()
    var nameTag = [String]()
    var nameIdTag = [String]()
    var strTage_id = String()
    var videoUrlPath = ""
    var url_video: URL?
    
    private let layoutValues: [CellType] = [
        .expanded, .expanded, .normal,
        .normal, .normal,.normal, .normal, .normal,
        .normal, .normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.normal,.expanded]
    
     var tabController:AZTabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setStatusBar(backgroundColor: .black)
        activity.isHidden = true
        lblName.text = loggdenUser.value(forKey: NAMELOgin)as? String
        lblUserName.text = loggdenUser.value(forKey: NAMELOgin)as? String
        let profile = loggdenUser.value(forKey: PROFILE)as! String
        url = URL(string: profile)
        imgIcon.sd_setImage(with: url, completed: nil)
        setDeafult()
        print("arrImages:",arrImages)
        print("videoUrlPath:",videoUrlPath)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setStatusBar(backgroundColor: .black)
         self.navigationController?.navigationBar.isHidden = true
       
    }
    
    func updateAssetsVideo(assets: [DKAsset]) {
        print(assets)
        self.assets = assets
        if assets.count == 0 {
            print("null")
        }
        else if assets.count == 1 {
            self.boolSingale = true
            self.multibool = false
            self.tblView.reloadData()
            self.footorView.frame.size.height = 0
        } else {
            self.multibool = true
            self.boolSingale = false
            self.tblView.reloadData()
            self.footorView.frame.size.height = 0
        }
        
    }
    
    
    func openOnlyVideos() {
        let pickerController = DKImagePickerController()
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.updateAssetsVideo(assets: assets)
        }
        pickerController.showsCancelButton = true
        pickerController.assetType = .allVideos
       // pickerController.allowMultipleTypes = true
        pickerController.maxSelectableCount = 1
        //pickerController.select(assets: assets)
        self.present(pickerController, animated: true) {}
    }
    
    func openOnlyPhotos() {
        let pickerController = DKImagePickerController()
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.updateAssets(assets: assets)
        }
        pickerController.showsCancelButton = true
        pickerController.assetType = .allPhotos
       // pickerController.allowMultipleTypes = true
        pickerController.maxSelectableCount = 10
        //pickerController.select(assets: assets)
        self.present(pickerController, animated: true) {}
    }
    
    func ActionView() {
        let optionMenu = UIAlertController(title: "FriendzPoint", message: "", preferredStyle: .actionSheet)

        let saveAction = UIAlertAction(title: "Photo", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.openOnlyPhotos()
        })

        let deleteAction = UIAlertAction(title: "Video", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.openOnlyVideos()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func setDeafult() {
        if postSelected == "postSelected" {
            if assets!.count == 1 {
                self.boolSingale = true
                self.multibool = false
                self.tblView.reloadData()
                self.footorView.frame.size.height = 0
            } else {
                self.multibool = true
                self.boolSingale = false
                self.tblView.reloadData()
                self.footorView.frame.size.height = 0
            }
        }
        else {
            print("Nothing")
        }
       
        txtheightConstraint.constant = 0
        emoviewHeight.constant = 0
        locationHeight.constant = 0
       // lblUserName.text = loggdenUser.value(forKey: NAMELOgin) as! String
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
         NotificationCenter.default.addObserver(self,selector: #selector(selectedValueset),name: NSNotification.Name(rawValue: "SelectedFriendZlistInGroup"),object: nil)
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.HeaderView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        HeaderView.layer.addSublayer(gradientLayer)
        HeaderView.addSubview(btnback)
        HeaderView.addSubview(lblName)
        HeaderView.addSubview(btnPost)
        HeaderView.addSubview(activity)
        imgIcon.layer.cornerRadius = 25
        imgIcon.clipsToBounds = true
        
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: HeaderView.bounds.origin.x, y: HeaderView.bounds.origin.y, width: 414, height: HeaderView.bounds.size.height)
        }
        else if UIScreen.main.bounds.height == 812 {
           // txtviewHeightConstraint.constant = 400
        }
        else if UIScreen.main.bounds.width == 320 {
            //txtviewHeightConstraint.constant = 190
            bottomViewHeight.constant = 50
        }
        
        btnShare.layer.cornerRadius = 5
        btnShare.clipsToBounds = true
        btntag.layer.cornerRadius = 5
        btntag.clipsToBounds = true
        
        txtDescrption.text = "Write Something..."
        txtDescrption.textColor = UIColor.lightGray
        txtDescrption.delegate = self
        
        for match in mapping.getMatchesFor("sad dog apple elephant cartoon happy cloths Smileys & People Animals & Nature Food & Drink Activity Travel & Places Objects Symbols Flags Airplane Automobile Calendar Camping Compass Globe Showing Americas Globe Showing Asia-Australia Globe Showing Europe-Africa Flag: European Union Flag: United Nations Globe With Meridians Luggage Pushpin Round Pushpin Scroll Map of Japan Spiral Calendar Tear-Off Calendar") {
            let stremo = match.emoji
            arrEmoji.append(stremo)
        }
    }
    
    @objc func selectedValueset(_ notification: NSNotification) {
        arrSelected = notification.object as! [TagList]
        print("selected:",arrSelected)
        if arrSelected.count == 1 {
            let strName = arrSelected[0].name
            let strId = arrSelected[0].id
            self.strTage_id = String(strId)
            let attrString = NSAttributedString (
                string: " is with ",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            let name = NSAttributedString (
                string: strName,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1)])
            let attributedString = NSMutableAttributedString(string:lblName.text!)
            attributedString.append(attrString)
            attributedString.append(name)
            lblUserName.attributedText = attributedString
        }
        else {
            let strName = arrSelected[0].name
            for strNamegat in arrSelected {
                let name = strNamegat.name
                let id = strNamegat.id
                nameIdTag.append(String(id))
                nameTag.append(name)
                self.strTageName = nameTag.joined(separator: ",")
                self.strTage_id = nameIdTag.joined(separator: ",")
                print(self.strTageName)
                print(nameTag)
            }
            
            let attrString = NSAttributedString (
                string: " is with ",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            let andString = NSAttributedString (
                string: " and ",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            let name = NSAttributedString (
                string: strName,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1)])
            let countOther = arrSelected.count - 1
            let strCount = String(countOther)
            let FinalCount = strCount + " others."
            let finalother = NSAttributedString (
                string: FinalCount,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 42/255, green: 61/255, blue: 85/255, alpha: 1)])
            let attributedString = NSMutableAttributedString(string:lblName.text!)
            attributedString.append(attrString)
            attributedString.append(name)
            attributedString.append(andString)
            attributedString.append(finalother)
            lblUserName.attributedText = attributedString
        }
    }
    
    func videoUpload() {
        if GroupTimeline_Id == 0 {
            TimelineAll = loggdenUser.value(forKey: TimeLine_id)as! Int
        }
        else {
            TimelineAll = GroupTimeline_Id
        }
        btnPost.isHidden = true
        activity.isHidden = false
        activity.startAnimating()
        
        if txtDescrption.text == "Write Something..." {
            txtDescrption.text = " "
        }
        else {
            print("jekil")
        }
        
        if txtWatchlive.text!.isEmpty {
            print("jekil")
        }
        else {
            youtube_video_id = txtWatchlive.text!.youtubeID!
        }
        
        let parameters = ["description" : txtDescrption.text!.encodeEmoji,
                          "location": strLocation,
                          "timeline_id": TimelineAll,
                          "youtube_title": "",
                          "youtube_video_id": youtube_video_id,
                          "locatio":"",
                          "soundcloud_id": "",
                          "user_tags":strTage_id,
                          "soundcloud_title": "",
                          "post_images_upload_modified[]":""]as [String:Any]
        print("parameters: ",parameters)
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization": BEARERTOKEN]
        
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
                
                let timestamp = NSDate().timeIntervalSince1970
                // let url_video = URL(string: self.videoUrlPath)
                let urlvideopath = URL(fileURLWithPath: self.videoUrlPath)
                
                multiPart.append(urlvideopath, withName: "post_video_upload", fileName: "album_file\(timestamp).mp4", mimeType: "mp4")
                print(urlvideopath)
        },
            usingThreshold: UInt64.init(),to: CREATEPOST, method: .post , headers: headers)
            .responseJSON(completionHandler: { (response) in
                print(response)
                self.btnPost.isHidden = false
                self.activity.isHidden = true
                self.activity.stopAnimating()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PostCreat"), object: nil)
                self.dismiss(animated: true, completion: nil)
            })
    }
    
    
    func createPost() {
        if GroupTimeline_Id == 0 {
            TimelineAll = loggdenUser.value(forKey: TimeLine_id)as! Int
        }
        else {
            TimelineAll = GroupTimeline_Id
        }
        btnPost.isHidden = true
        activity.isHidden = false
        activity.startAnimating()
        
        if txtDescrption.text == "Write Something..." {
            txtDescrption.text = " "
        }
        else {
            print("jekil")
        }
        
        if txtWatchlive.text!.isEmpty {
            print("jekil")
        }
        else {
            youtube_video_id = txtWatchlive.text!.youtubeID!
        }
        
        let parameters = ["description" : txtDescrption.text!.encodeEmoji,
                          "location": strLocation,
                          "timeline_id": TimelineAll,
                          "youtube_title": "",
                          "youtube_video_id": youtube_video_id,
                          "locatio":"",
                          "soundcloud_id": "",
                          "user_tags":strTage_id,
                          "soundcloud_title": "",
                          "post_video_upload":""]as [String:Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization": BEARERTOKEN]

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
                    multiPart.append(imageData, withName: "post_images_upload_modified[\(index)]", fileName: "image[\(index)].jpg", mimeType: "image/jpeg")
                }
        },
            usingThreshold: UInt64.init(),to: CREATEPOST, method: .post , headers: headers)
            .responseJSON(completionHandler: { (response) in
                print(response)
                self.btnPost.isHidden = false
                self.activity.isHidden = true
                self.activity.stopAnimating()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PostCreat"), object: nil)
                self.dismiss(animated: true, completion: nil)
            })
        }
    
    
    
    @IBAction func btnPostAction(_ sender: UIButton) {
        if videoUrlPath.count == 0 {
            createPost()
        }
        else {
            videoUpload()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - MainButton Action
    
    @IBAction func btnMyAlburmAction(_ sender: UIButton) {
//        let pickerController = DKImagePickerController()
//
//        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//            print("assets:",assets)
//               self.updateAssets(assets: assets)
//        }
//        pickerController.showsCancelButton = true
//        pickerController.allowMultipleTypes = false
//        pickerController.maxSelectableCount = 10
//        self.present(pickerController, animated: true) {}
        ActionView()
    }
    
    @IBAction func BtnMyEmoAction(_ sender: UIButton) {
//        let obj = self.storyboard?.instantiateViewController(withIdentifier: "HowareyoufeelingController")as! HowareyoufeelingController
//        self.navigationController?.pushViewController(obj, animated: true)
        if emoSelectedBool == true {
            emoviewHeight.constant = 180
            emoSelectedBool = false
        }
        else {
            emoviewHeight.constant = 0
            emoSelectedBool = true
        }
    }
    @IBAction func btnMyLocotionAction(_ sender: UIButton) {
        if locationBool == true {
            locationHeight.constant = 40
            locationBool = false
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            self.present(acController, animated: true, completion: nil)
        }
        else {
            locationHeight.constant = 0
            locationBool = true
        }
    }
    @IBAction func btnWatchingvalaAction(_ sender: UIButton) {
        if selectedBool == true {
            txtheightConstraint.constant = 40
            selectedBool = false
        }
        else {
            txtheightConstraint.constant = 0
            selectedBool = true
        }
    }
    @IBAction func btnPartTextlocationAction(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnTagPopleAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChooseFriendViewController")as! ChooseFriendViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnGallaryAction(_ sender: UIButton) {
        ActionView()
        
    }
    
    @IBAction func btnEmojiAction(_ sender: UIButton) {
//        let obj = self.storyboard?.instantiateViewController(withIdentifier: "HowareyoufeelingController")as! HowareyoufeelingController
//        self.navigationController?.pushViewController(obj, animated: true)
        if emoSelectedBool == true {
            emoviewHeight.constant = 180
            emoSelectedBool = false
        }
        else {
            emoviewHeight.constant = 0
            emoSelectedBool = true
        }
    }
    @IBAction func btnLocationAction(_ sender: UIButton) {
        if locationBool == true {
            locationHeight.constant = 40
            locationBool = false
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            self.present(acController, animated: true, completion: nil)
        }
        else {
            locationHeight.constant = 0
            locationBool = true
        }
//        let acController = GMSAutocompleteViewController()
//        acController.delegate = self
//        self.present(acController, animated: true, completion: nil)
    }
    @IBAction func btnVideoAction(_ sender: UIButton) {
        if selectedBool == true {
            txtheightConstraint.constant = 40
            selectedBool = false
        }
        else {
            txtheightConstraint.constant = 0
            selectedBool = true
        }
    }
}

extension PostViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tblView.dequeueReusableCell(withIdentifier: "imgCell", for: indexPath)as! tblPostCell
            if boolSingale == true {
                let asset = self.assets![0]
                if asset.type == .photo {
                    asset.fetchOriginalImage(completeBlock: { (image, info) in
                        self.arrImages.append(image!)
                        cell.setCustomImage(image: image!)
                        cell.btnplay.isHidden = true
                        self.tblView.beginUpdates()
                        self.tblView.endUpdates()
                        self.footorView.isHidden = true
                        self.bottomView.isHidden = false
                        self.footorView.frame.size.height = 0
                    })
                }
                else {
                    asset.fetchOriginalImage(completeBlock: { (image, info) in
                        cell.setCustomImage(image: image!)
                        asset.fetchAVAsset { (avAsset, info) in
                            
                            if let urlAsset = avAsset as? AVURLAsset {
                                let audioPlayerItem = AVPlayerItem(url: NSURL(string: urlAsset.url.path)! as URL)
                                print(urlAsset.url.path)
                                self.videoUrlPath = urlAsset.url.path
                            }
                        }
                        cell.btnplay.isHidden = false
                        cell.btnplay.addTarget(self, action: #selector(PostViewController.btnPlayAction), for: UIControl.Event.touchUpInside)
                        self.tblView.beginUpdates()
                        self.tblView.endUpdates()
                        self.footorView.isHidden = true
                        self.bottomView.isHidden = false
                        self.footorView.frame.size.height = 0
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
             let cell = tblView.dequeueReusableCell(withIdentifier: "Multiimgcell", for: indexPath)as! tblPostCell
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
                self.footorView.isHidden = true
                self.bottomView.isHidden = false
                self.footorView.frame.size.height = 0
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
            self.footorView.frame.size.height = 0
        } else {
            self.multibool = true
            self.boolSingale = false
            self.tblView.reloadData()
            self.footorView.frame.size.height = 0
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

extension PostViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollection {
            return arrEmoji.count
        }
        return self.assets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == emojiCollection {
            let cell = emojiCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let lblImg = cell.viewWithTag(101)as! UILabel
            lblImg.text = arrEmoji[indexPath.row]
            return cell
        }
        else {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView == emojiCollection {
            let selected = arrEmoji[indexPath.row]
            arrselectedemo.append(selected)
            txtDescrption.text = arrselectedemo.joined(separator: " ")
        }
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




extension PostViewController: SquareFlowLayoutDelegate {
    func shouldExpandItem(at indexPath: IndexPath) -> Bool {
        
        if assets!.count == 5 {
            return self.layoutValues[indexPath.row] == .normal
        }
        else {
             return self.layoutValues[indexPath.row] == .expanded
        }
    }
}


extension PostViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtDescrption.textColor == UIColor.lightGray {
            txtDescrption.text = ""
            txtDescrption.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtDescrption.text == "" {
            
            txtDescrption.text = "Write Something..."
            txtDescrption.textColor = UIColor.lightGray
        }
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension PostViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? "null")")
        strLocation = place.formattedAddress!
        txtLocation.text = strLocation
        print("Place attributions: \(String(describing: place.attributions))")
        
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //        print("Error: \(error.description)")
        //  self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}


extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
}
