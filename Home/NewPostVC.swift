//
//  NewPostVC.swift
//  FriendzPoint
//
//  Created by Anques on 27/01/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import AVKit
import YPImagePicker

class NewPostVC: UIViewController,UITextViewDelegate {
    
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPostVC")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    var check = String()
    @IBOutlet weak var mainVIew: UIView!
    @IBOutlet weak var tblNewPost: UITableView!
    var selectedItems = [YPMediaItem]()
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    let arrPost = ["Tag People","Add Location"] //,"YouTube Link"
    let selectedImageV = UIImageView()
    
    @IBOutlet weak var imgNewPost: UIImageView!
    @IBOutlet weak var txtCaption: UITextView!
    
    @IBOutlet weak var gradientview: GradientView1!{
        didSet{
            gradientview.layer.cornerRadius = gradientview.frame.height/2
            gradientview.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnUpdate: UIButton!{
        didSet{
            btnUpdate.layer.cornerRadius = btnUpdate.frame.height/2
            btnUpdate.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblTagPeople: UILabel!
    @IBOutlet weak var lblAddLocation: UILabel!
    
    
    @IBOutlet weak var CollLocation: UICollectionView!
    
    
    //MARK: LOCATION
    var locationBool = true
    var strLocation = String()
    var arrSelected = [TagList]()
    var lblName = String()
    var strTage_id = String()
    var nameIdTag = [String]()
    var nameTag = [String]()
    var strTageName = String()
    var GroupTimeline_Id = Int()
    var TimelineAll = Int()
    var arrImages = [UIImage]()
    var videoUrlPath = ""
    
    var arrLocation = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mainVIew.isHidden = true
//        showPicker()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
       let arrLocation1 = loggdenUser.object(forKey: "AL")
        if arrLocation1 != nil{
            arrLocation = arrLocation1! as! [String]
        }
        
        
        let image = UIImage(named: "backr")?.withRenderingMode(.alwaysTemplate)
        btn1.setImage(image, for: .normal)
        btn1.tintColor = UIColor.lightGray
        
        btn2.setImage(image, for: .normal)
        btn2.tintColor = UIColor.lightGray
        
        self.navigationController?.navigationBar.isHidden = false
//        navigationController?.setStatusBar(backgroundColor: .black)
//        setStatusBar1(backgroundColor: .black)
        txtCaption.text = "Write a Caption"
        txtCaption.textColor = UIColor.lightGray
        txtCaption.delegate = self
//        imgNewPost.image = selectedImageV.image
//        self.encodeVideo(at: URL(fileURLWithPath: self.videoUrlPath), completionHandler: nil)
//        print("arrImages:",arrImages)
//        print("videoUrlPath:",videoUrlPath)
        
        lblName = (loggdenUser.value(forKey: NAMELOgin)as? String)!
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self,selector: #selector(selectedValueset),name: NSNotification.Name(rawValue: "SelectedFriendZlistInGroup"),object: nil)
//        
//        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
//            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
//            if count == 0{
//                currentTabBar!.setBadgeText(nil, atIndex: 3)
//            }
//            else{
//                currentTabBar!.setBadgeText(String(count), atIndex: 3)
//            }
//        }
        setUpNavBar()
    }
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.black
        self.navigationItem.title = "New post"

        //For back button in navigation bar
//        let backButton = UIBarButtonItem()
//        backButton.title = "Back"
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "dback"),
            style: .plain,
            target: self,
            action: #selector(popToPrevious)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Share",
            style: .plain,
            target: self,
            action: #selector(SharePost)
        )
        
//        navigationItem.backBarButtonItem = UIBarButtonItem(
//            title: "",
//            style: .plain,
//            target: self,
//            action: #selector(popToPrevious)
//        )
    }
    
    @objc private func SharePost(){
        loaderView.backgroundColor = .clear
        loaderView.isHidden = false
        indicatorView.startAnimating()
        
        if videoUrlPath.count == 0 {
            Flag = 0
            createPost()
            for (index,image) in self.arrImages.enumerated() {
                print(image)
                
            }
        }
        else {
            Flag = 0
            videoUpload()
        }
    }
    
    @objc private func popToPrevious() {
        // our custom stuff
//        navigationController?.popViewController(animated: true)
        
        if check == "camera" {
            Flag = 0
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: false, completion: nil)
        }
        Flag = 0
        currentTabBar?.setIndex(0)
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        edgesForExtendedLayout = []
        
        
    
         
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        mainVIew.isHidden = true
//        showPicker()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentTabBar?.setBar(hidden: true, animated: false)
        if Flag == 0{
            Flag = 1
            mainVIew.isHidden = true
            showPicker()
        }
        else if Flag == 2{
            Flag = 1
          showPickerCamera()
        }
//        else if Flag == 3{
//            Flag = 4
//            mainVIew.isHidden = true
//            showPicker()
//        }
    }
    
    @IBAction func btnUpdateAction(_ sender: Any) {
        
        loaderView.backgroundColor = .clear
        loaderView.isHidden = false
        indicatorView.startAnimating()
        
        if videoUrlPath.count == 0 {
            Flag = 0
            createPost()
            for (index,image) in self.arrImages.enumerated() {
                print(image)
                
            }
        }
        else {
            Flag = 0
            videoUpload()
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: false, completion: nil)
        if check == "camera" {
            Flag = 0
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: false, completion: nil)
        }
        Flag = 0
        currentTabBar?.setIndex(0)
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
//        let obj = PostVC()
//        self.navigationController?.pushViewController(obj, animated: false)
//        appDel.gotoDashboardController()
//        if let tabBarController = self.navigationController?.tabBarController  {
//            tabBarController.selectedIndex = 2
//        }
        
       
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            txtCaption.text = "Write a Caption"
            txtCaption.textColor = UIColor.lightGray
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
    
    
    @IBAction func btnTagPeople(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChooseFriendViewController")as! ChooseFriendViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnAddLocation(_ sender: Any) {
        if locationBool == true {
//                locationHeight.constant = 40
            locationBool = false
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            self.present(acController, animated: true, completion: nil)
        }
        else {
//                locationHeight.constant = 0
            locationBool = true
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
            let attributedString = NSMutableAttributedString(string:lblName)
            attributedString.append(attrString)
            attributedString.append(name)
            lblTagPeople.attributedText = attributedString
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
            let attributedString = NSMutableAttributedString(string:lblName)
            attributedString.append(attrString)
            attributedString.append(name)
            attributedString.append(andString)
            attributedString.append(finalother)
            lblTagPeople.attributedText = attributedString
        }
    }
}

extension NewPostVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewPostCell
        cell.lblTitle.text = arrPost[indexPath.row]
        cell.imgIcon.image = UIImage(named: arrPost[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ChooseFriendViewController")as! ChooseFriendViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 1 {
            if locationBool == true {
//                locationHeight.constant = 40
                locationBool = false
                let acController = GMSAutocompleteViewController()
                acController.delegate = self
                self.present(acController, animated: true, completion: nil)
            }
            else {
//                locationHeight.constant = 0
                locationBool = true
            }
        }
    }
    
    func createPost() {
        if GroupTimeline_Id == 0 {
            TimelineAll = loggdenUser.value(forKey: TimeLine_id)as! Int
        }
        else {
            TimelineAll = GroupTimeline_Id
        }
//        btnPost.isHidden = true
//        activity.isHidden = false
//        activity.startAnimating()
        
        if txtCaption.text == "Write a Caption" {
            txtCaption.text = " "
        }
        else {
            print("jekil")
        }
        
//        if txtWatchlive.text!.isEmpty {
//            print("jekil")
//        }
//        else {
//            youtube_video_id = txtWatchlive.text!.youtubeID!
//        }
        
        let parameters = ["description" : txtCaption.text!.encodeEmoji,
                          "location": strLocation,
                          "timeline_id": TimelineAll,
                          "youtube_title": "",
                          "youtube_video_id": "",
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
                    print(image)
                    let image = image.resizeWithWidth(width: 800)!
                    let imageData:Data = image.jpegData(compressionQuality: 0.2)!
                    multiPart.append(imageData, withName: "post_images_upload_modified[\(index)]", fileName: "image[\(index)].jpg", mimeType: "image/jpeg")
                }
        },
            usingThreshold: UInt64.init(),to: CREATEPOST, method: .post , headers: headers)
            .responseJSON(completionHandler: { (response) in
                print(response)
//                self.btnPost.isHidden = false
//                self.activity.isHidden = true
//                self.activity.stopAnimating()
                
                
                self.appDel.gotoDashboardController()
                self.loaderView.isHidden = true
                self.indicatorView.stopAnimating()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PostCreat"), object: nil)
                self.dismiss(animated: true, completion: nil)
            })
        }
    
    func videoUpload() {
        if GroupTimeline_Id == 0 {
            TimelineAll = loggdenUser.value(forKey: TimeLine_id)as! Int
        }
        else {
            TimelineAll = GroupTimeline_Id
        }
//        btnPost.isHidden = true
//        activity.isHidden = false
//        activity.startAnimating()
        
        if txtCaption.text == "Write a Caption" {
            txtCaption.text = " "
        }
        else {
            print("jekil")
        }
        
//        if txtWatchlive.text!.isEmpty {
//            print("jekil")
//        }
//        else {
//            youtube_video_id = txtWatchlive.text!.youtubeID!
//        }
        
        let parameters = ["description" : txtCaption.text!.encodeEmoji,
                          "location": strLocation,
                          "timeline_id": TimelineAll,
                          "youtube_title": "",
                          "youtube_video_id": "",
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
                
                multiPart.append(urlvideopath, withName: "post_video_upload", fileName: "album_file\(timestamp).mp4", mimeType: "video/mp4")
                print(urlvideopath)
        },
            usingThreshold: UInt64.init(),to: CREATEPOST, method: .post , headers: headers)
            .responseJSON(completionHandler: { (response) in
                print(response)
//                self.btnPost.isHidden = false
//                self.activity.isHidden = true
//                self.activity.stopAnimating()
                self.appDel.gotoDashboardController()
                
                self.loaderView.isHidden = true
                self.indicatorView.stopAnimating()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PostCreat"), object: nil)
                self.dismiss(animated: true, completion: nil)
            })
    }
    
    func encodeVideo(at videoURL: URL, completionHandler: ((URL?, Error?) -> Void)?)  {
        let avAsset = AVURLAsset(url: videoURL, options: nil)
            
        let startDate = Date()
            
        //Create Export session
        guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
            completionHandler?(nil, nil)
            return
        }
            
        //Creating temp path to save the converted video
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath = documentsDirectory.appendingPathComponent("rendered-Video.mp4")
            
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                completionHandler?(nil, error)
            }
        }
            
        exportSession.outputURL = filePath
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession.timeRange = range
            
        exportSession.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession.status {
            case .failed:
                print(exportSession.error ?? "NO ERROR")
                completionHandler?(nil, exportSession.error)
            case .cancelled:
                print("Export canceled")
                completionHandler?(nil, nil)
            case .completed:
                //Video conversion finished
                let endDate = Date()
                    
                let time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful!")
                print(exportSession.outputURL ?? "NO OUTPUT URL")
                self.videoUrlPath = exportSession.outputURL!.path
                completionHandler?(exportSession.outputURL, nil)
                    
                default: break
            }
                
        })
    }
}


extension NewPostVC : GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? "null")")
        strLocation = place.formattedAddress!
        if arrLocation.contains(strLocation){

        }
        else{
            arrLocation.append(strLocation)
        }
        loggdenUser.setValue(arrLocation, forKey: "AL")
        CollLocation.reloadData()
        lblAddLocation.text = strLocation
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


extension NewPostVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLocation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddLocationCell
        cell.lblPlaceName.text = arrLocation[indexPath.row]
//        cell.backgroundColor = UIColor.lightGray
//        cell.layer.cornerRadius = 5.0
//        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        strLocation = arrLocation[indexPath.row]
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let padding: CGFloat =  30
////        let collectionViewSize = collectionView.frame.size.width - padding
////        print("collectionViewSize: ",collectionViewSize)
//            return CGSize(width: 128, height: 40)
//    }
    
}


extension NewPostVC: YPImagePickerDelegate{
    // MARK: - Configuration
    @objc
    func showPicker() {

        var config = YPImagePickerConfiguration()

        /* Uncomment and play around with the configuration 👨‍🔬 🚀 */

        /* Set this to true if you want to force the  library output to be a squared image. Defaults to false */
//         config.library.onlySquare = true

        /* Set this to true if you want to force the camera output to be a squared image. Defaults to true */
         config.onlySquareImagesFromCamera = false

        /* Ex: cappedTo:1024 will make sure images from the library or the camera will be
           resized to fit in a 1024x1024 box. Defaults to original image size. */
        // config.targetImageSize = .cappedTo(size: 1024)

        /* Choose what media types are available in the library. Defaults to `.photo` */
        config.library.mediaType = .photoAndVideo
        config.library.itemOverlayType = .grid
        /* Enables selecting the front camera by default, useful for avatars. Defaults to false */
        // config.usesFrontCamera = true

        /* Adds a Filter step in the photo taking process. Defaults to true */
        // config.showsFilters = false

        /* Manage filters by yourself */
//        config.filters = [YPFilter(name: "Mono", coreImageFilterName: "CIPhotoEffectMono"),
//                          YPFilter(name: "Normal", coreImageFilterName: "")]
//        config.filters.remove(at: 1)
//        config.filters.insert(YPFilter(name: "Blur", coreImageFilterName: "CIBoxBlur"), at: 1)

        /* Enables you to opt out from saving new (or old but filtered) images to the
           user's photo library. Defaults to true. */
        config.shouldSaveNewPicturesToAlbum = false

        /* Choose the videoCompression. Defaults to AVAssetExportPresetHighestQuality */
        config.video.compression = AVAssetExportPresetMediumQuality

        /* Defines the name of the album when saving pictures in the user's photo library.
           In general that would be your App name. Defaults to "DefaultYPImagePickerAlbumName" */
        // config.albumName = "ThisIsMyAlbum"

        /* Defines which screen is shown at launch. Video mode will only work if `showsVideo = true`.
           Default value is `.photo` */
        config.startOnScreen = .library

        /* Defines which screens are shown at launch, and their order.
           Default value is `[.library, .photo]` */
        config.screens = [.library, .photo, .video]//, .video

        /* Can forbid the items with very big height with this property */
//        config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8

        /* Defines the time limit for recording videos.
           Default is 30 seconds. */
        // config.video.recordingTimeLimit = 5.0

        /* Defines the time limit for videos from the library.
           Defaults to 60 seconds. */
        config.video.libraryTimeLimit = 500.0

        /* Adds a Crop step in the photo taking process, after filters. Defaults to .none */
//        config.showsCrop = .rectangle(ratio: (1/1)) //16/9

        /* Defines the overlay view for the camera. Defaults to UIView(). */
        // let overlayView = UIView()
        // overlayView.backgroundColor = .red
        // overlayView.alpha = 0.3
        // config.overlayView = overlayView

        /* Customize wordings */
        config.wordings.libraryTitle = "Gallery"

        /* Defines if the status bar should be hidden when showing the picker. Default is true */
        config.hidesStatusBar = false

        /* Defines if the bottom bar should be hidden when showing the picker. Default is false */
        config.hidesBottomBar = false

        config.maxCameraZoomFactor = 2.0

        config.library.maxNumberOfItems = 5
        config.gallery.hidesRemoveButton = false

        /* Disable scroll to change between mode */
        // config.isScrollToChangeModesEnabled = false
//        config.library.minNumberOfItems = 2

        /* Skip selection gallery after multiple selections */
        // config.library.skipSelectionsGallery = true

        /* Here we use a per picker configuration. Configuration is always shared.
           That means than when you create one picker with configuration, than you can create other picker with just
           let picker = YPImagePicker() and the configuration will be the same as the first picker. */

        /* Only show library pictures from the last 3 days */
        //let threDaysTimeInterval: TimeInterval = 3 * 60 * 60 * 24
        //let fromDate = Date().addingTimeInterval(-threDaysTimeInterval)
        //let toDate = Date()
        //let options = PHFetchOptions()
        // options.predicate = NSPredicate(format: "creationDate > %@ && creationDate < %@", fromDate as CVarArg, toDate as CVarArg)
        //
        ////Just a way to set order
        //let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        //options.sortDescriptors = [sortDescriptor]
        //
        //config.library.options = options

        config.library.preselectedItems = selectedItems


        // Customise fonts
        //config.fonts.menuItemFont = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        //config.fonts.pickerTitleFont = UIFont.systemFont(ofSize: 22.0, weight: .black)
        //config.fonts.rightBarButtonFont = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        //config.fonts.navigationBarTitleFont = UIFont.systemFont(ofSize: 22.0, weight: .heavy)
        //config.fonts.leftBarButtonFont = UIFont.systemFont(ofSize: 22.0, weight: .heavy)

        let picker = YPImagePicker(configuration: config)

        picker.imagePickerDelegate = self

        /* Change configuration directly */
        // YPImagePickerConfiguration.shared.wordings.libraryTitle = "Gallery2"

        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in

            if cancelled {
                Flag = 0
                print("Picker was canceled")
                picker.dismiss(animated: false, completion: nil)
                
//                if Flag == 4{
                    
                   
//                }
                
                Flag = 0
                
                //self.appDel.gotoDashboardController()
                self.currentTabBar?.setIndex(0)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: false, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }

            self.selectedItems = items
            

            
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    
                    picker.dismiss(animated: false, completion: nil)
                    
//                    let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
//                    let obj = launchStoryBoard.instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
                    print("photo: ",self.selectedItems)
                    print("photoimg: ",items)
                    self.selectedImageV.image = photo.image
                    for i in items{
                        switch i {
                        case .photo(let photo1):
                            self.arrImages.append(photo1.image)
                            break
                            
                        case .video(v: let v):
                            break
                        }
                        
                    }
                    self.imgNewPost.image = self.selectedImageV.image
                    self.encodeVideo(at: URL(fileURLWithPath: self.videoUrlPath), completionHandler: nil)
                    print("arrImages:",self.arrImages)
                    print("videoUrlPath:",self.videoUrlPath)
                    self.mainVIew.isHidden = false
//                    self.present(obj, animated: false, completion: nil)
//                    self.show(obj, sender: self)
//                    self.navigationController?.pushViewController(obj, animated: true)
                case .video(let video):
//                    let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
//                    let obj = launchStoryBoard.instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
                    self.selectedImageV.image = video.thumbnail
                    
                    let assetURL = video.url
                    let playerVC = AVPlayerViewController()
                    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
                    playerVC.player = player
                    
                    self.videoUrlPath = video.url.path
                    
//                    self.navigationController?.pushViewController(obj, animated: false)
//                    self.present(obj, animated: false, completion: nil)
                    self.imgNewPost.image = self.selectedImageV.image
                    self.encodeVideo(at: URL(fileURLWithPath: self.videoUrlPath), completionHandler: nil)
                    print("arrImages:",self.arrImages)
                    print("videoUrlPath:",self.videoUrlPath)
                    self.mainVIew.isHidden = false
                    picker.dismiss(animated: false, completion: { [weak self] in
                        self?.present(playerVC, animated: false, completion: nil)
                        
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                    
                    
                }
            }
        }

        /* Single Photo implementation. */
        // picker.didFinishPicking { [unowned picker] items, _ in
        //     self.selectedItems = items
        //     self.selectedImageV.image = items.singlePhoto?.image
        //     picker.dismiss(animated: true, completion: nil)
        // }

        /* Single Video implementation. */
        //picker.didFinishPicking { [unowned picker] items, cancelled in
        //    if cancelled { picker.dismiss(animated: true, completion: nil); return }
        //
        //    self.selectedItems = items
        //    self.selectedImageV.image = items.singleVideo?.thumbnail
        //
        //    let assetURL = items.singleVideo!.url
        //    let playerVC = AVPlayerViewController()
        //    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
        //    playerVC.player = player
        //
        //    picker.dismiss(animated: true, completion: { [weak self] in
        //        self?.present(playerVC, animated: true, completion: nil)
        //        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
        //    })
        //}

        present(picker, animated: true, completion: nil)
    }
    
    func showPickerCamera() {

        var config = YPImagePickerConfiguration()

        /* Uncomment and play around with the configuration 👨‍🔬 🚀 */

        /* Set this to true if you want to force the  library output to be a squared image. Defaults to false */
//         config.library.onlySquare = true

        /* Set this to true if you want to force the camera output to be a squared image. Defaults to true */
         config.onlySquareImagesFromCamera = false

        /* Ex: cappedTo:1024 will make sure images from the library or the camera will be
           resized to fit in a 1024x1024 box. Defaults to original image size. */
        // config.targetImageSize = .cappedTo(size: 1024)

        /* Choose what media types are available in the library. Defaults to `.photo` */
        config.library.mediaType = .photo
        config.library.itemOverlayType = .grid
        /* Enables selecting the front camera by default, useful for avatars. Defaults to false */
        // config.usesFrontCamera = true

        /* Adds a Filter step in the photo taking process. Defaults to true */
        // config.showsFilters = false

        /* Manage filters by yourself */
//        config.filters = [YPFilter(name: "Mono", coreImageFilterName: "CIPhotoEffectMono"),
//                          YPFilter(name: "Normal", coreImageFilterName: "")]
//        config.filters.remove(at: 1)
//        config.filters.insert(YPFilter(name: "Blur", coreImageFilterName: "CIBoxBlur"), at: 1)

        /* Enables you to opt out from saving new (or old but filtered) images to the
           user's photo library. Defaults to true. */
        config.shouldSaveNewPicturesToAlbum = false

        /* Choose the videoCompression. Defaults to AVAssetExportPresetHighestQuality */
        config.video.compression = AVAssetExportPresetMediumQuality

        /* Defines the name of the album when saving pictures in the user's photo library.
           In general that would be your App name. Defaults to "DefaultYPImagePickerAlbumName" */
        // config.albumName = "ThisIsMyAlbum"

        /* Defines which screen is shown at launch. Video mode will only work if `showsVideo = true`.
           Default value is `.photo` */
        config.startOnScreen = .library

        /* Defines which screens are shown at launch, and their order.
           Default value is `[.library, .photo]` */
        config.screens = [.photo]//, .video

        /* Can forbid the items with very big height with this property */
//        config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8

        /* Defines the time limit for recording videos.
           Default is 30 seconds. */
        // config.video.recordingTimeLimit = 5.0

        /* Defines the time limit for videos from the library.
           Defaults to 60 seconds. */
        config.video.libraryTimeLimit = 500.0

        /* Adds a Crop step in the photo taking process, after filters. Defaults to .none */
//         config.showsCrop = .rectangle(ratio: (16/9))

        /* Defines the overlay view for the camera. Defaults to UIView(). */
        // let overlayView = UIView()
        // overlayView.backgroundColor = .red
        // overlayView.alpha = 0.3
        // config.overlayView = overlayView

        /* Customize wordings */
        config.wordings.libraryTitle = "Gallery"

        /* Defines if the status bar should be hidden when showing the picker. Default is true */
        config.hidesStatusBar = false

        /* Defines if the bottom bar should be hidden when showing the picker. Default is false */
        config.hidesBottomBar = false

        config.maxCameraZoomFactor = 2.0

        config.library.maxNumberOfItems = 5
        config.gallery.hidesRemoveButton = false

        /* Disable scroll to change between mode */
        // config.isScrollToChangeModesEnabled = false
//        config.library.minNumberOfItems = 2

        /* Skip selection gallery after multiple selections */
        // config.library.skipSelectionsGallery = true

        /* Here we use a per picker configuration. Configuration is always shared.
           That means than when you create one picker with configuration, than you can create other picker with just
           let picker = YPImagePicker() and the configuration will be the same as the first picker. */

        /* Only show library pictures from the last 3 days */
        //let threDaysTimeInterval: TimeInterval = 3 * 60 * 60 * 24
        //let fromDate = Date().addingTimeInterval(-threDaysTimeInterval)
        //let toDate = Date()
        //let options = PHFetchOptions()
        // options.predicate = NSPredicate(format: "creationDate > %@ && creationDate < %@", fromDate as CVarArg, toDate as CVarArg)
        //
        ////Just a way to set order
        //let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        //options.sortDescriptors = [sortDescriptor]
        //
        //config.library.options = options

        config.library.preselectedItems = selectedItems


        // Customise fonts
        //config.fonts.menuItemFont = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        //config.fonts.pickerTitleFont = UIFont.systemFont(ofSize: 22.0, weight: .black)
        //config.fonts.rightBarButtonFont = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        //config.fonts.navigationBarTitleFont = UIFont.systemFont(ofSize: 22.0, weight: .heavy)
        //config.fonts.leftBarButtonFont = UIFont.systemFont(ofSize: 22.0, weight: .heavy)

        let picker = YPImagePicker(configuration: config)

        picker.imagePickerDelegate = self

        /* Change configuration directly */
        // YPImagePickerConfiguration.shared.wordings.libraryTitle = "Gallery2"

        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in

            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
//                self.appDel.gotoDashboardController()
                
                if self.check == "camera"{
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: false, completion: nil)
                }
                
                self.currentTabBar?.setIndex(0)
                return
            }
            _ = items.map { print("🧀 \($0)") }

            self.selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    
                    picker.dismiss(animated: false, completion: nil)
                    
//                    let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
//                    let obj = launchStoryBoard.instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
                    print("photo: ",self.selectedItems)
                    print("photoimg: ",items)
                    self.selectedImageV.image = photo.image
                    for i in items{
                        switch i {
                        case .photo(let photo1):
                            self.arrImages.append(photo1.image)
                            break
                            
                        case .video(v: let v):
                            break
                        }
                        
                    }
                    self.imgNewPost.image = self.selectedImageV.image
                    self.encodeVideo(at: URL(fileURLWithPath: self.videoUrlPath), completionHandler: nil)
                    print("arrImages:",self.arrImages)
                    print("videoUrlPath:",self.videoUrlPath)
                    self.mainVIew.isHidden = false
//                    self.present(obj, animated: false, completion: nil)
//                    self.show(obj, sender: self)
//                    self.navigationController?.pushViewController(obj, animated: true)
                case .video(let video):
//                    let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
//                    let obj = launchStoryBoard.instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
                    self.selectedImageV.image = video.thumbnail
                    
                    let assetURL = video.url
                    let playerVC = AVPlayerViewController()
                    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
                    playerVC.player = player
                    
                    self.videoUrlPath = video.url.path
                    
//                    self.navigationController?.pushViewController(obj, animated: false)
//                    self.present(obj, animated: false, completion: nil)
                    self.imgNewPost.image = self.selectedImageV.image
                    self.encodeVideo(at: URL(fileURLWithPath: self.videoUrlPath), completionHandler: nil)
                    print("arrImages:",self.arrImages)
                    print("videoUrlPath:",self.videoUrlPath)
                    self.mainVIew.isHidden = false
                    picker.dismiss(animated: false, completion: { [weak self] in
                        self?.present(playerVC, animated: false, completion: nil)
                        
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                    
                    
                }
            }
        }

        /* Single Photo implementation. */
        // picker.didFinishPicking { [unowned picker] items, _ in
        //     self.selectedItems = items
        //     self.selectedImageV.image = items.singlePhoto?.image
        //     picker.dismiss(animated: true, completion: nil)
        // }

        /* Single Video implementation. */
        //picker.didFinishPicking { [unowned picker] items, cancelled in
        //    if cancelled { picker.dismiss(animated: true, completion: nil); return }
        //
        //    self.selectedItems = items
        //    self.selectedImageV.image = items.singleVideo?.thumbnail
        //
        //    let assetURL = items.singleVideo!.url
        //    let playerVC = AVPlayerViewController()
        //    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
        //    playerVC.player = player
        //
        //    picker.dismiss(animated: true, completion: { [weak self] in
        //        self?.present(playerVC, animated: true, completion: nil)
        //        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
        //    })
        //}

        present(picker, animated: true, completion: nil)
    }
    
    // Support methods
   
        /* Gives a resolution for the video by URL */
        func resolutionForLocalVideo(url: URL) -> CGSize? {
            guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
            let size = track.naturalSize.applying(track.preferredTransform)
            return CGSize(width: abs(size.width), height: abs(size.height))
        }
   

    // YPImagePickerDelegate
  
        func noPhotos() {}

        func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
            return true// indexPath.row != 2
        }
    
}


var Flag = 0
