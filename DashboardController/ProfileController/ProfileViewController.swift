//
//  ProfileViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 13/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import MXSegmentedPager
import Photos
import DKPhotoGallery
import DKImagePickerController
import Alamofire

class ProfileViewController: MXSegmentedPagerController {
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }

    
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblFollower: UILabel!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnFriends: UIButton!
    @IBOutlet weak var viewFriendButton: UIView!
    @IBOutlet weak var coverActivity: UIActivityIndicatorView!
    @IBOutlet weak var viewCoverActivity: UIView!
    @IBOutlet weak var viewActivityProfile: UIView!
    @IBOutlet weak var ProActivity: UIActivityIndicatorView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var viewCoverCamera: UIView!
    @IBOutlet weak var btnProfileCamero: UIButton!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var viewImgRound: UIView!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var viewHeght: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblbadge: BadgeLabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var iconSearch: UIImageView!
    @IBOutlet weak var btnCameraleading: NSLayoutConstraint!
    @IBOutlet weak var btnnotitrailing: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var gridentView: UIView!
    @IBOutlet weak var btncamera: UIButton!
    @IBOutlet weak var img_logo: UIImageView!
    
    var url : URL?
    var ustCover : URL?
    var strUserType = String()
    var strUsername = String()
    var wc = Webservice.init()
    var imageUpload = UIImage()
    var uploadProfilePhoto: UploadParameterMode! = nil
    var assets: [DKAsset]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.Profile), name: NSNotification.Name(rawValue: "Profile"), object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.EditProfile), name: NSNotification.Name(rawValue: "SettingsProfile"), object: nil)
        setDefault()
    }
    
    @objc func Profile(_ notification: NSNotification) {
        getProfileDetails()
    }
    
    @objc func EditProfile(_ notification: NSNotification) {
        getProfileDetails()
    }
    
    
    func setDefault() {
        getProfileDetails()
        lblName.text = loggdenUser.value(forKey: NAMELOgin)as? String
        let profile = loggdenUser.value(forKey: PROFILE)as! String
        url = URL(string: profile)
        imgProfile.sd_setImage(with: url, completed: nil)
        let cover = loggdenUser.value(forKey: COVER)as! String
        ustCover = URL(string: cover)
        imgCover.sd_setImage(with: ustCover, completed: nil)
        self.navigationController?.navigationBar.isHidden = true
        segmentedPager.backgroundColor = .white
        
        // Parallax Header
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 180
        segmentedPager.parallaxHeader.minimumHeight = 0
        
        // Segmented Control customization
        segmentedPager.segmentedControl.indicator.linePosition = .bottom
        segmentedPager.segmentedControl.backgroundColor = .white
        //segmentedPager.segmentedControl.
        segmentedPager.segmentedControl.textColor = UIColor(red: 73/255, green: 100/255, blue: 134/255, alpha: 1)
        segmentedPager.segmentedControl.font = UIFont.systemFont(ofSize: 14)
        segmentedPager.segmentedControl.selectedTextColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
       // segmentedPager.segmentedControl.sel
        segmentedPager.segmentedControl.indicatorColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
        segmentedPager.segmentedControl.indicatorHeight = 1.5
        
        viewImgRound.layer.cornerRadius = 60
        viewImgRound.clipsToBounds = true
        imgProfile.layer.cornerRadius = 55
        imgProfile.clipsToBounds = true
        btnProfileCamero.layer.cornerRadius = 15
        btnProfileCamero.clipsToBounds = true
        viewCamera.layer.cornerRadius = 17.5
        viewCamera.clipsToBounds = true
        btnEditProfile.layer.cornerRadius = 5
        btnEditProfile.clipsToBounds = true
        viewCoverCamera.layer.cornerRadius = 15
        viewCoverCamera.clipsToBounds = true
        viewActivityProfile.layer.cornerRadius = 60
        viewActivityProfile.clipsToBounds = true
        btnFriends.layer.cornerRadius = 5
        btnFriends.clipsToBounds = true
        btnMessage.layer.cornerRadius = 5
        btnMessage.clipsToBounds = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gridentView.bounds
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gridentView.layer.addSublayer(gradientLayer)
        gridentView.addSubview(btncamera)
        gridentView.addSubview(btnNotification)
        gridentView.addSubview(lineView)
        gridentView.addSubview(iconSearch)
        gridentView.addSubview(lblSearch)
        gridentView.addSubview(btnSearch)
        gridentView.addSubview(lblbadge)
        gridentView.addSubview(img_logo)
        
        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
            self.lblbadge.badge(text: String(count))
        }
        
        if UIScreen.main.bounds.width == 320 {
            viewHeght.constant = 66
            segmentedPager.parallaxHeader.height = 410
            segmentedPager.parallaxHeader.minimumHeight = 66
            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: 66)
        }
        else {
            segmentedPager.parallaxHeader.height = 440
            segmentedPager.parallaxHeader.minimumHeight = 90
            gradientLayer.frame = CGRect(x: gridentView.bounds.origin.x, y: gridentView.bounds.origin.y, width: 414, height: gridentView.bounds.size.height)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(NewsfeedViewController.BadgeCleare), name: NSNotification.Name(rawValue: "BadgeCleare"), object: nil)
    }
    
    @objc func BadgeCleare(_ notification: NSNotification) {
        self.lblbadge.badge(text: nil)
    }
    
    func getProfileDetails() {
        viewFriendButton.isHidden = true
        btnEditProfile.isHidden = false
        strUsername = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username":strUsername]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
     
        wc.callSimplewebservice(url: MYPROFILEDETAILS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: MyprofileResponseModel?) in
            if sucess {
                
                let dic = response?.data
                self.lblName.text = dic?.name
                self.lblFollower.text = dic?.followers.description
                self.lblFollowing.text = dic?.following.description
                let strAvatar = dic?.avatar
                self.url = URL(string: strAvatar!)
                self.imgProfile.sd_setImage(with: self.url, completed: nil)
                let strCover = dic?.cover
                self.ustCover = URL(string: strCover!)
                self.imgCover.sd_setImage(with: self.ustCover, completed: nil)
                self.strUserType = dic!.type
            }
        }
    }
    
    
    @IBAction func btnFollowingAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "MyfriendsController")as! MyfriendsController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnFollowersAction(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController")as! FollowersViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    /*func ImageUpload(image: UIImage) {

        let image = image.resizeWithWidth(width: 700)!
        let imagedata = image.jpegData(compressionQuality: 0.2)
        print(imagedata)
        let boundary = UUID().uuidString
        let timelin_id = loggdenUser.value(forKey: TimeLine_id)as! Int
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let timeline_id = "timeline_id"
        let timeline_type = "timeline_type"
        let typeSet = self.strUserType

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string:CHANGEAVATAR)!)
        urlRequest.httpMethod = "POST"
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(XAPI, forHTTPHeaderField: "Xapi")
        urlRequest.addValue(ACCEPT, forHTTPHeaderField: "Accept")
        urlRequest.addValue(BEARERTOKEN, forHTTPHeaderField: "Authorization")
       
        var data = Data()
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(timeline_id)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(timelin_id)".data(using: .utf8)!)
        print(data)
        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(timeline_type)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(typeSet)".data(using: .utf8)!)
        print(data)
       
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"change_avatar\"; filename=\"\("filename/")\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(imagedata!)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        print(data)
        
        
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("uploaded to: \(responseString)")
            }
        }).resume()
    }*/
    
    
    //MARK: - Btn Action
    @IBAction func btnMessageAction(_ sender: UIButton) {
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController")as! SearchViewController
        self.navigationController?.pushViewController(obj, animated: false)
        
    }
    @IBAction func btnProfileCameraAction(_ sender: UIButton) {
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            let asset = assets[0]
            asset.fetchOriginalImage(completeBlock: { (image, info) in
                
                self.imgProfile.image = image
                
                let timelin_id = loggdenUser.value(forKey: TimeLine_id)as! Int
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let parameters = ["timeline_id":timelin_id,
                                  "timeline_type": self.strUserType] as [String : Any]

                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept":ACCEPT,
                                            "Authorization":BEARERTOKEN]

                self.viewActivityProfile.isHidden = true
                self.ProActivity.stopAnimating()
                
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
                        let image = self.imgProfile.image!.resizeWithWidth(width: 700)!
                        let imagedata = image.jpegData(compressionQuality: 1)
                        multiPart.append(imagedata!, withName: "change_avatar", fileName: "image.png", mimeType: "image/png")
                },
                    usingThreshold: UInt64.init(),to: CHANGEAVATAR, method: .post , headers: headers)
                    .responseJSON(completionHandler: { (response) in
                        let dic = response.value as! NSDictionary
                        let profile = dic.value(forKey: "data")as! [String]
                        let ProfileImage = profile[0]
                        print(ProfileImage)
                        loggdenUser.removeObject(forKey: PROFILE)
                        loggdenUser.set(ProfileImage, forKey: PROFILE)
                        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProfileImage"), object: nil)
                    })

               // self.ImageUpload(image: image!)
               
            })
        }
        pickerController.showsCancelButton = true
        pickerController.singleSelect = true
        
        self.present(pickerController, animated: true) {
            self.viewActivityProfile.isHidden = false
            self.ProActivity.startAnimating()
        }
    }
    
    

    @IBAction func btnCameraCoverAction(_ sender: UIButton) {
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            let asset = assets[0]
            asset.fetchOriginalImage(completeBlock: { (image, info) in
                self.imgCover.image = image
                let timelin_id = loggdenUser.value(forKey: TimeLine_id)as! Int
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let parameters = ["timeline_id":timelin_id,
                                  "timeline_type": self.strUserType] as [String : Any]
                
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept":ACCEPT,
                                            "Authorization":BEARERTOKEN]

                self.viewCoverActivity.isHidden = true
                self.coverActivity.stopAnimating()
                
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
                        DispatchQueue.main.sync {
                             let image = self.imgCover.image!.resizeWithWidth(width: 700)!
                                                   let imagedata = image.jpegData(compressionQuality: 1)
                                                   multiPart.append(imagedata!, withName: "change_cover", fileName: "image.png", mimeType: "image/png")
                        }
                       
                },
                    usingThreshold: UInt64.init(),to: CHANGECOVER, method: .post , headers: headers)
                    .responseJSON(completionHandler: { (response) in
                        print(response)
                    })
            })
        }
        pickerController.showsCancelButton = true
        pickerController.singleSelect = true
        
        self.present(pickerController, animated: true) {
            self.viewCoverActivity.isHidden = false
            self.coverActivity.startAnimating()
        }
    }
    
    @IBAction func btnCameraAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            self.updateAssets(assets: assets)
        }
        pickerController.showsCancelButton = true
        pickerController.allowMultipleTypes = false
        pickerController.maxSelectableCount = 10
        self.present(pickerController, animated: true) {
        }
    }
    
    func updateAssets(assets: [DKAsset]) {
        print(assets)
        self.assets = assets
        if assets.count == 0 {
            print("null")
        }
        else if assets.count == 1 {
            let obj = storyboard?.instantiateViewController(withIdentifier: "PostViewController")as! PostViewController
            obj.assets = assets
            obj.postSelected = "postSelected"
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
            self.present(naviget, animated: true, completion: nil)
        } else {
            let obj = storyboard?.instantiateViewController(withIdentifier: "PostViewController")as! PostViewController
            obj.assets = assets
            obj.postSelected = "postSelected"
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
            self.present(naviget, animated: true, completion: nil)
        }
    }
    @IBAction func btnEditProfileAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "GeneralSettingsViewController")as! GeneralSettingsViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnNotificationAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController")as! NotificationController
        let naviget: UINavigationController = UINavigationController(rootViewController: obj)
        self.present(naviget, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        print(index)
        return ["Bio data", "Timeline", "Liked pages","Joined groups","Gallery"][index]//,"Friendz"

    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
       // print("progress \(parallaxHeader.progress)")
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelect view: UIView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
    }

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewAt index: Int) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        if index == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Biodata"), object: nil)
        }
        else if index == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileTimeline"), object: nil)
        }
        else if index == 2 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Likedpages"), object: nil)
        }
        else if index == 3 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Joinedgroups"), object: nil)
        }
        else if index == 4 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Photos"), object: nil)
        }
        else if index == 5 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Friends"), object: nil)
        }
//        else if index == 6 {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Guestevents"), object: nil)
//        }
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

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        DispatchQueue.main.sync {
             let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
            imageView.contentMode = .scaleAspectFit
                   imageView.image = self
                   UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
                   guard let context = UIGraphicsGetCurrentContext() else { return nil }
                   imageView.layer.render(in: context)

            guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            return result
        }
    }
}
