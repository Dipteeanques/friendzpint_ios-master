//
//  ReelPostVC.swift
//  FriendzPoint
//
//  Created by Anques on 23/06/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ReelPostVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var btndraft: UIButton!{
        didSet{
            btndraft.layer.cornerRadius = btndraft.frame.height/2
            btndraft.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnpost: UIButton!{
        didSet{
            btnpost.layer.cornerRadius = btnpost.frame.height/2
            btnpost.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var txtMsg: UITextView!
    @IBOutlet weak var btnfriends: UIButton!{
        didSet{
            btnfriends.layer.cornerRadius = btnfriends.frame.height/2
            btnfriends.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnhastags: UIButton!{
        didSet{
            btnhastags.layer.cornerRadius = btnhastags.frame.height/2
            btnhastags.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var PrivacyView: UIView!
    
    @IBOutlet weak var viewHasTag: UIView!
    
    @IBOutlet weak var tblHasTag: UITableView!
    
    @IBOutlet weak var tblFriends: UITableView!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var friendsView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var VideoUrl : URL?
    var hashTagDataArr = [hashTagMVC]()
    var allowComments = "true"
    var privacyType = "Public"
    
    var userDataArr = [userMVC]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrDraft = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMsg.delegate = self
        self.tblHasTag.isHidden = true
        self.viewHasTag.isHidden = true
        imgVideo.image = OptiVideoEditor().generateThumbnail(path: VideoUrl!)
        let privayOpt = UITapGestureRecognizer(target: self, action:  #selector(self.privacyOptionsList))
        self.PrivacyView.addGestureRecognizer(privayOpt)// Do any additional setup after loading the view.
        getHashtagsData(keyword: "", sp: "0")
        getUserData(keyword: "", sp: "0")
        
        if UserDefaults.standard.value(forKey: Draft) != nil{
            self.arrDraft = UserDefaults.standard.value(forKey: Draft) as! [String]
            print("arrDraftPost: ",self.arrDraft)
        }
       
        friendsView.isHidden = true
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        friendsView.isHidden = true
    }
    
    @objc func privacyOptionsList(sender : UITapGestureRecognizer) {
        actionSheetFunc()
    }

    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDraftAction(_ sender: Any) {
       
       
        
        CacheManager.shared.getFileWith(stringUrl: VideoUrl!.absoluteString) { result in

                switch result {
                case .success(let url):
                    print("VURl: ",url)
                    let name = url.lastPathComponent
                    self.arrDraft.append(name)
                    UserDefaults.standard.setValue(self.arrDraft, forKey: Draft)
                    self.appDelegate.gotoDashboardController()
                   
                     // do some magic with path to saved video
                case .failure(let error):
                    // handle errror
                print("Verror: ",error)
                }
            }

    }
    

    
    @IBAction func btnPostAction(_ sender: Any) {
        uploadData()
    }
    
    @IBAction func btnFriendsAction(_ sender: Any) {
        friendsView.isHidden = false
    }
    
    @IBAction func btnhastagAction(_ sender: Any) {
        self.tblHasTag.isHidden = false
        self.viewHasTag.isHidden = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtMsg.text == "Your Description is Write here"{
            txtMsg.text = ""
            
        }
        print("textview Begin Editing")
        ChangeTextColor(strMsg: txtMsg.text, preFix: "@")
        ChangeTextColor(strMsg: txtMsg.text, preFix: "#")
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        ChangeTextColor(strMsg: txtMsg.text, preFix: "@")
        ChangeTextColor(strMsg: txtMsg.text, preFix: "#")
    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//
//        print("textview End Editing")
//        ChangeTextColor()
//
//    }
    
    
    // MARK:- ACTION SHEET FOR CROSS BUTTON
        func actionSheetFunc(){
            // create an actionSheet
            let actionSheetController: UIAlertController = UIAlertController(title: "Who can seen your post", message: nil, preferredStyle: .actionSheet)

            // create an action
            let startOver: UIAlertAction = UIAlertAction(title: "Followings", style: .default) { action -> Void in
                print("startOver pressed")
//                self.dismiss(animated: true, completion: nil)
                self.lblStatus.text = "Followings"
                self.privacyType = "privacy"
            }

            let discard: UIAlertAction = UIAlertAction(title: "Everyone", style: .default) { action -> Void in

                self.lblStatus.text = "Everyone"
                self.privacyType = "public"
                print("Discard Action pressed")
//                self.dismiss(animated: true, completion: nil)
            }

            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

//            startOver.setValue(UIColor.red, forKey: "titleTextColor")      // add actions
            actionSheetController.addAction(startOver)
            actionSheetController.addAction(discard)
            actionSheetController.addAction(cancelAction)


            // present an actionSheet...
            // present(actionSheetController, animated: true, completion: nil)   // doesn't work for iPad

            actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad

            present(actionSheetController, animated: true) {
                print("option menu presented")
            }
        }
    
    func getHashtagsData(keyword:String,sp:String){
        hashTagDataArr.removeAll()
        let userid = UserDefaults.standard.string(forKey: "TimeLine_id")!
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.Search(user_id: userid, type: "hashtag", keyword: keyword, starting_point: sp) { (isSuccess, response) in
            if isSuccess{
                
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let hashObjMsg = response?.value(forKey: "msg") as! NSArray
                    
                    for hashObject in hashObjMsg{
                        let hashObj = hashObject as! NSDictionary
                        
                        let hashtag = hashObj.value(forKey: "Hashtag") as! NSDictionary
                        
                        let id = hashtag.value(forKey: "id") as! String
                        let name = hashtag.value(forKey: "name") as! String
                        let views = hashtag.value(forKey: "views") as? NSNumber
                        let favourite = hashtag.value(forKey: "favourite") as? NSNumber
                        
                        let obj = hashTagMVC(id: id, name: name, views: "\(views ?? 0)", favourite: "\(favourite ?? 0)")
                        
                        self.hashTagDataArr.append(obj)
                    }
                    
                }
                AppUtility?.stopLoader(view: self.view)
                print("hashTagDataArr: ",self.hashTagDataArr)
                if self.hashTagDataArr.isEmpty{
                    //                    self.hashTagWhoopsView.isHidden = false
                }else{
                    //                    self.hashTagWhoopsView.isHidden = true
                }
                self.tblHasTag.reloadData()
            }
        }
    }
    
    func getUserData(keyword:String,sp:String){
        userDataArr.removeAll()
        
//        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.Search(user_id: UserDefaults.standard.string(forKey: "TimeLine_id")!, type: "user", keyword: keyword, starting_point: sp) { (isSuccess, response) in
            if isSuccess{
                
                print("responseAllUser: ",response)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSArray
                    
                    for userObject in userObjMsg{
                        let userObj = userObject as! NSDictionary
                        
                        let user = userObj.value(forKey: "User") as! NSDictionary
                        
                        let userID = (user.value(forKey: "id") as? String)!
                        let userImage = (user.value(forKey: "profile_pic") as? String)!
                        let userName = (user.value(forKey: "username") as? String)!
                        let followers = "\(user.value(forKey: "followers_count") ?? "")"
                        let followings = "\(user.value(forKey: "following_count") ?? "")"
                        let likesCount = "\(user.value(forKey: "likes_count") ?? "")"
                        let videoCount = "\(user.value(forKey: "video_count") ?? "")"
//                        let firstName = (user.value(forKey: "first_name") as? String)!
//                        let lastName = (user.value(forKey: "last_name") as? String)!
                        let gender = (user.value(forKey: "gender") as? String)!
//                        let bio = (user.value(forKey: "bio") as? String)!
//                        let dob = (user.value(forKey: "dob") as? String)!
//                        let website = (user.value(forKey: "website") as? String)!
                        
                        let obj = userMVC(userID: userID, first_name: "", last_name: "", gender: gender, bio: "", website: "", dob: "dob", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage, role: "", username: userName, social: "", device_token: "", videoCount: videoCount, likesCount: likesCount, followers: followers, following: followings, followBtn: "")
                        
                        self.userDataArr.append(obj)
                    }
                    
                }
                
                AppUtility?.stopLoader(view: self.view)
                if self.userDataArr.isEmpty{
//                    self.userWhoopsView.isHidden = false
                }else{
//                    self.userWhoopsView.isHidden = true
                }
                self.tblFriends.reloadData()
            }
            else{
                AppUtility?.stopLoader(view: self.view)
            }
        }
    }
    
    func uploadData(){
        
        AppUtility?.startLoader(view: self.view)
        //        let  sv = HomeViewController.displaySpinner(onView: self.view)
        if(UserDefaults.standard.string(forKey: "sid") == nil || UserDefaults.standard.string(forKey: "sid") == ""){
            
            UserDefaults.standard.set("null", forKey: "sid")
        }
        
        //        let url : String = self.appDelegate.baseUrl!+self.appDelegate.uploadMultipartVideo!
        let url : String = POSTVIDEO
        
        let cmnt = self.allowComments
        //        let allwDuet = self.allowDuet
        //        let prv = self.privacyType
        var des = String()
        if txtMsg.text != "Your Description is Write here" {
            des = txtMsg.text
        }else{
            des = ""
        }
        
        print("cmnt",cmnt)
        //        print("allwDuet",allwDuet)
        //        print("prv",prv)
        print("des",des)
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "TimeLine_id")!,
                                        "sound_id":"",
                                        "description":des,
                                        "privacy_type":self.privacyType,
                                        "allow_comments":cmnt,
                                        "allow_duet":"0"]
        
        let uidString = UserDefaults.standard.string(forKey: "TimeLine_id")!
        let soundIDString = "null"
        
        print(url)
        print(parameter!)
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        
        let serializer = DataResponseSerializer(emptyResponseCodes: Set([200, 204, 205]))
        AF.upload(multipartFormData: { MultipartFormData in
            
            for (key,value) in parameter! {
                MultipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            
            print("uidString: ",uidString)
            
            print("soundIDString: ",soundIDString)
            
            print("video url:-",self.VideoUrl)
            do{
                let vid = try NSData(contentsOf: self.VideoUrl!, options: .alwaysMapped)
                MultipartFormData.append(self.VideoUrl!, withName: "video")
                
                print("vid: ",vid)
            }catch{
                print("catch err: ",error)
            }
            
        }, to: url, method: .post, headers: headers)
        .responseJSON { (response) in
            //                HomeViewController.removeSpinner(spinner: sv)
            //                AppUtility?.stopLoader(view: self.view)
            switch response.result{
            
            case .success(let value):
                
                print("progress: ",Progress.current())
                let json = value
                let dic = json as! NSDictionary
                
                print("response:- ",response)
                if(dic["code"] as! NSNumber == 200){
                    print("200")
                    debugPrint("SUCCESS RESPONSE: \(response)")
                    //                                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                    //                                // terminaing app in background
                    //                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    //exit(EXIT_SUCCESS)
                    
                    
                    //                        if self.saveV == "1"{
                    //                            self.saveVideoToAlbum(self.VideoUrl!) { (err) in
                    //
                    //                                if err != nil{
                    //                                    //                                    AppUtility?.stopLoader(view: self.view)
                    //                                    print("Unable to save video to album dur to: ",err!)
                    //                                    self.showToast(message: "Unable to save video to album dur to:", font: .systemFont(ofSize: 12))
                    //                                }else{
                    //                                    //                                    HomeViewController.removeSpinner(spinner: sv)
                    //
                    //                                    print("video saved to gallery")
                    //                                    self.showToast(message: "video saved to gallery", font: .systemFont(ofSize: 12))
                    //                                }
                    //
                    //                            }
                    //                        }
                    AppUtility?.stopLoader(view: self.view)
                    print("Dict: ",dic)
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    // })
                    
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    print(dic)
                    
                }
            case .failure(let error):
                print("\n\n===========Error===========")
                print("Error Code: \(error._code)")
                print("Error Messsage: \(error.localizedDescription)")
                if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                    print("Server Error: " + str)
                }
                debugPrint(error as Any)
                print("===========================\n\n")
            //  self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            //        AppUtility?.stopLoader(view: self.view)
            //     self.showToast(message: "Not Posted", font: .systemFont(ofSize: 12))
            }
            
        }
        .response(responseSerializer: serializer) { response in
            // Process response.
            switch response.result{
            case .success(let value):
                let json = value
                let dic = json as? NSDictionary
                let code = dic?["code"] as? NSString
                
                print("value: ",value)
                print("response",response)
                if(code == "200"){
                    print("200")
                    debugPrint("SUCCESS RESPONSE: \(response)")
                }else{
                    print("dic: ",dic)
                    
                }
                
            //                if self.saveV == "1"{
            //                    self.saveVideoToAlbum(self.videoUrl!) { (err) in
            //
            //                        if err != nil{
            //                            //                                    AppUtility?.stopLoader(view: self.view)
            //                            print("Unable to save video to album dur to: ",err!)
            //                            self.showToast(message: "Unable to save video to album dur to:", font: .systemFont(ofSize: 12))
            //                            AppUtility?.stopLoader(view: self.view)
            //                        }else{
            //                            //                                    HomeViewController.removeSpinner(spinner: sv)
            //
            //                            print("video saved to gallery")
            //                            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            //                            AppUtility?.stopLoader(view: self.view)
            ////                            self.showToast(message: "video saved to gallery", font: .systemFont(ofSize: 12))
            //                        }
            //
            //                    }
            //                }
            
            
            case .failure(let error):
                print("\n\n===========Error===========")
                print("Error Code: \(error._code)")
                print("Error Messsage: \(error.localizedDescription)")
                if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                    print("Server Error: " + str)
                }
                debugPrint(error as Any)
                print("===========================\n\n")
                
            }
        }
    }
}



extension ReelPostVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblFriends{
            return self.userDataArr.count
        }
        else{
            return hashTagDataArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblFriends{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendsTableViewCell
            cell.lblUserName.text = self.userDataArr[indexPath.row].username
            cell.lblEmail.text = self.userDataArr[indexPath.row].userEmail
            cell.imgUser.sd_setImage(with: URL(string: self.userDataArr[indexPath.row].userProfile_pic), placeholderImage: UIImage(named: "Placeholder"), options: [], completed: nil)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HasTagCell
            
            let hashObj = hashTagDataArr[indexPath.row]
            cell.lblHasTagName.text = hashObj.name
            //        cell.countLbl.text = hashObj.views
            
            //        if hashObj.favourite == "1"{
            //            hashCell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
            //        }else{
            //            hashCell.btnFav.setImage(UIImage(named:"btnFavEmpty"), for: .normal)
            //        }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        if txtMsg.text == "Your Description is Write here"{
            txtMsg.text = ""
            
        }
        
        if tableView == tblFriends{
            let hastagname = "@" + userDataArr[indexPath.row].username + " "
            txtMsg.text = txtMsg.text.appending(hastagname)
            
            ChangeTextColor(strMsg: txtMsg.text, preFix: "@")
            
//            self.tblHasTag.isHidden = true
            self.friendsView.isHidden = true
        }
        else{
            let hastagname = "#" + hashTagDataArr[indexPath.row].name + " "
            txtMsg.text = txtMsg.text.appending(hastagname)
            
            ChangeTextColor(strMsg: txtMsg.text, preFix: "#")
            
            self.tblHasTag.isHidden = true
            self.viewHasTag.isHidden = true
        }

    }
    
    func ChangeTextColor(strMsg: String, preFix: String){
        let string = NSMutableAttributedString(string: strMsg)
        
        let words = strMsg.components(separatedBy: .whitespacesAndNewlines)
        
        for word in words {
            if word.hasPrefix("#") || word.hasPrefix("@") {
                let nsRange = NSString(string: strMsg).range(of: word, options: String.CompareOptions.caseInsensitive)
                
                //                let range = txtMsg.text.range(of: word)
                // string.addAttribute(.foregroundColor, value: UIColor.red, range: range)
                string.addAttribute(.foregroundColor, value: UIColor.blue, range: nsRange)
            }
        }
        txtMsg.attributedText = string
    }
}


let Draft = "draft"


//
public enum ResultM<T> {
    case success(T)
    case failure(NSError)
}

class CacheManager {

    static let shared = CacheManager()

    private let fileManager = FileManager.default

    private lazy var mainDirectoryUrl: URL = {

        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()

    func getFileWith(stringUrl: String, completionHandler: @escaping (ResultM<URL>) -> Void ) {


        let file = directoryFor(stringUrl: stringUrl)

        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            completionHandler(ResultM.success(file))
            return
        }

        DispatchQueue.global().async {

            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)

                DispatchQueue.main.async {
                    completionHandler(ResultM.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(ResultM.failure(NSError(domain: "Can't download video", code: 200, userInfo: [:])))
//                    NSError(domain: "SomeErrorDomain", code: -2001 /* some error code */, userInfo: ["description": "Can't download video"])

                }
            }
        }
    }

    private func directoryFor(stringUrl: String) -> URL {

        let fileURL = URL(string: stringUrl)!.lastPathComponent

        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)

        return file
    }
}
