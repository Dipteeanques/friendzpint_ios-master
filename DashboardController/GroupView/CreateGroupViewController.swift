//
//  CreateGroupViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 22/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Photos
import DKPhotoGallery
import DKImagePickerController
import Alamofire

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var activitybtn: UIActivityIndicatorView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var lastView: UIView!
    @IBOutlet weak var txtEventadd: SWComboxView!
    @IBOutlet weak var txtAddMember: SWComboxView!
    @IBOutlet weak var txtPostOn: SWComboxView!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var hidenView: UIView!
    @IBOutlet weak var tblPrivacy: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtgroupname: UITextField!
    @IBOutlet weak var viewheifgrConstraint: NSLayoutConstraint!
    
    var arrPrivacy = [["img":#imageLiteral(resourceName: "Earth"),"name":"Public","disc":"Anyone can see and join the group."],["img":#imageLiteral(resourceName: "closedOption"),"name":"Closed","disc":"Anyone can see and request to join the group. Requests can be accepted or declined by admins."],["img":#imageLiteral(resourceName: "Secret"),"name":"Secret","disc":"Only members can access the group."]]
    
    var selectedIndex = Int()
    var assets: [DKAsset]?
    var arrSelected = NSMutableArray()
    var strSelected = String()
    var wc = Webservice.init()
    var username = String()
    var url: URL?
    var type = String()
    var membersAdd = String()
    var membersAddAdmin = String()
    var membersPost = String()
    var membersAdmin = String()
    var membersEveryone = String()
    var membersEvent = String()
    var membersEventAdmin = String()
    var member_privacy = String()
    var post_privacy = String()
    var event_privacy = String()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if username.count == 0 {
            lastView.height = 0
            privacyView.isHidden = true
            viewheifgrConstraint.constant = 0
            activitybtn.isHidden = true
        }
        else {
            activitybtn.isHidden = true
            privacyView.isHidden = false
            lblTitle.text = "Setting Group"
            btnCreate.setTitle("Update", for: .normal)
            getGroupSetting()
        }
        setDeafult()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupCombox() {
        txtAddMember.dataSource = self
        txtAddMember.delegate = self
        
        txtPostOn.dataSource = self
        txtPostOn.delegate = self
        
        txtEventadd.dataSource = self
        txtEventadd.delegate = self
    }
    
   // groupsettingGetresponsModel
    override func viewWillAppear(_ animated: Bool) {
            // Give TextViewMessage delegate Method
       
    }
    
    func setDeafult() {
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self,selector: #selector(selectedValueset),name: NSNotification.Name(rawValue: "SelectedFriendZlistInGroup"),object: nil)
//        let gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = self.headerView.bounds
//
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        headerView.layer.addSublayer(gradientLayer)
        headerView.backgroundColor = .white
        headerView.addSubview(btnBack)
        headerView.addSubview(lblTitle)
        headerView.addSubview(btnCreate)
        headerView.addSubview(activitybtn)
        
//        if UIScreen.main.bounds.width == 414 {
//            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
//        }
        
        imgProfile.layer.cornerRadius = 50
        imgProfile.clipsToBounds = true
        txtgroupname.layer.borderWidth = 0.5
        txtgroupname.layer.borderColor = UIColor(red: 142/255, green: 163/255, blue: 190/255, alpha: 1).cgColor
        txtgroupname.layer.cornerRadius = 5
        txtgroupname.clipsToBounds = true
        
        txtUsername.layer.borderWidth = 0.5
        txtUsername.layer.borderColor = UIColor(red: 142/255, green: 163/255, blue: 190/255, alpha: 1).cgColor
        txtUsername.layer.cornerRadius = 5
        txtUsername.clipsToBounds = true
        
        txtAbout.layer.borderWidth = 0.5
        txtAbout.layer.borderColor = UIColor(red: 142/255, green: 163/255, blue: 190/255, alpha: 1).cgColor
        txtAbout.layer.cornerRadius = 5
        txtAbout.clipsToBounds = true
        
        btnDelete.layer.cornerRadius = 5
        btnDelete.clipsToBounds = true
        
        txtAbout.text = "Write Something..."
        txtAbout.textColor = UIColor.lightGray
        txtAbout.delegate = self
    }
    
    func getGroupSetting() {
        let parameters = ["username":username]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: GROUP_SETTINGS_GENERAL, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: groupsettingGetresponsModel?) in
            if sucess {
                print(response)
                let data = response?.data
                let strImg = data?.avatar
                self.url = URL(string: strImg!)
                self.imgProfile.sd_setImage(with: self.url, completed: nil)
                self.txtgroupname.text = data?.name
                self.txtUsername.text = data?.username
                self.txtAbout.text = data?.about
                if self.txtAbout.text.isEmpty {
                    print("jekil")
                }
                else {
                    self.txtAbout.textColor = UIColor.black
                }
                self.member_privacy = data!.member_privacy
                if self.member_privacy == "members" {
                    self.txtAddMember.defaultSelectedIndex = 0
                }
                else {
                    self.txtAddMember.defaultSelectedIndex = 1
                }
                
                self.post_privacy = data!.post_privacy
                if self.post_privacy == "members" {
                    self.txtPostOn.defaultSelectedIndex = 0
                }
                else if self.post_privacy == "only_admins" {
                    self.txtPostOn.defaultSelectedIndex = 1
                }
                else {
                    self.txtPostOn.defaultSelectedIndex = 2
                }
                
                self.event_privacy = data!.event_privacy
                if self.event_privacy == "members" {
                    self.txtEventadd.defaultSelectedIndex = 0
                }
                else {
                    self.txtEventadd.defaultSelectedIndex = 1
                }
                self.setupCombox()
                
                self.type = data!.type
                if self.type == "open" {
                    self.selectedIndex = 0
                    self.tblPrivacy.reloadData()
                }
                else if self.type == "closed" {
                    self.selectedIndex = 1
                    self.tblPrivacy.reloadData()
                }
                else {
                    self.selectedIndex = 2
                    self.tblPrivacy.reloadData()
                }
                
            }
        }
    }
    

    func createGroup() {
        
        if txtAbout.text == "Write Something..." {
            txtAbout.text = " "
        }
        else {
            print("jekil")
        }
        
        btnCreate.isHidden = true
        activitybtn.isHidden = false
        activitybtn.startAnimating()
        if username.count == 0 {
            if strSelected == "Public" {
                strSelected = "open"
            }
            else if strSelected == "Closed" {
                strSelected = "closed"
            }
            else if strSelected == "Secret"  {
                strSelected = "secret"
            }
            let Username = txtUsername.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let parameters = ["name": txtgroupname.text!,
                              "username": Username,
                              "about":txtAbout.text!,
                              "type":strSelected]
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
                    let image = self.imgProfile.image!.resizeWithWidth(width: 800)!
                    let imageData:Data = image.jpegData(compressionQuality: 0.2)!
                    multiPart.append(imageData, withName: "change_avatar", fileName: "image.png", mimeType: "image/png")
            },
                usingThreshold: UInt64.init(),to: CREATEGROUP, method: .post , headers: headers)
                .responseJSON(completionHandler: { (response) in
                    print(response)
                    let dicres = response.value as! NSDictionary
                    let sucess = dicres.value(forKey: "success")as! Bool
                    let message = dicres.value(forKey: "message")as! String
                    if sucess == true {
                        self.btnCreate.isHidden = true
                        self.activitybtn.isHidden = false
                        self.activitybtn.startAnimating()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupCreat"), object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.btnCreate.isHidden = true
                            self.activitybtn.isHidden = false
                            self.activitybtn.startAnimating()
                            self.dismiss(animated: true, completion: nil)
                        }))
                    }
                })
        }
            
        else {
            if strSelected == "Public" {
                strSelected = "open"
            }
            else if strSelected == "Closed" {
                strSelected = "closed"
            }
            else if strSelected == "Secret"  {
                strSelected = "secret"
            }
            let Username = txtUsername.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let parameters = ["name": txtgroupname.text!,
                              "username": Username,
                              "about":txtAbout.text!,
                              "type":strSelected,
                              "member_privacy":membersAdd,
                              "post_privacy":membersPost,
                              "event_privacy":membersEvent]
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
                    let image = self.imgProfile.image!.resizeWithWidth(width: 800)!
                    let imageData:Data = image.jpegData(compressionQuality: 0.2)!
                    multiPart.append(imageData, withName: "change_avatar", fileName: "image.png", mimeType: "image/png")
            },
                usingThreshold: UInt64.init(),to: GROUP_SETTINGS_UPDATEGENERAL, method: .post , headers: headers)
                .responseJSON(completionHandler: { (response) in
                    print(response)
                    let dicres = response.value as! NSDictionary
                    let sucess = dicres.value(forKey: "success")as! Bool
                    let message = dicres.value(forKey: "message")as! String
                    if sucess == true {
                        self.btnCreate.isHidden = true
                        self.activitybtn.isHidden = false
                        self.activitybtn.startAnimating()
                        self.backTwo()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupCreat"), object: nil)
                    }
                    else {
                        let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.btnCreate.isHidden = true
                            self.activitybtn.isHidden = false
                            self.activitybtn.startAnimating()
                            self.dismiss(animated: true, completion: nil)
                        }))
                    }
                })
        }
        
    }
    
    func setGroupImg() {
         let timeline_id = loggdenUser.value(forKey: TimeLine_id)as! Int
         let param = ["timeline_id": timeline_id,
                      "timeline_type": "group"] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers = ["Xapi": XAPI,
                       "Accept" : ACCEPT,
                       "Authorization":BEARERTOKEN]
        
        var image = UIImage()
        image = imgProfile.image!
        let imageData = image.jpegData(compressionQuality: 0.50)
        
       /* Alamofire.upload(
            multipartFormData: { MultipartFormData in
                for (key,value) in param {
                    MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)

                }
                MultipartFormData.append(imageData!, withName: "change_avatar", fileName: "myImage.jpeg", mimeType: "image/jpeg")
                
        },
            to: CHANGEAVATAR,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response)
                        self.createGroup()
                    }
                case .failure(let error):
                    print(error)
                }
                
        })*/
    }
    
    @objc func selectedValueset(_ notification: NSNotification) {
        arrSelected = notification.object as! NSMutableArray
        print("selected:",arrSelected)
    }
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        
        let refreshAlert = UIAlertController(title: "Notification", message: "Are you sure to delete?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let group_id = loggdenUser.value(forKey: GROUPID)as! Int
            let parameters = ["group_id": group_id]as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            self.wc.callSimplewebservice(url: GROUPDELETE, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: GroupDeleteResponsModel?) in
                if sucess {
                    self.backTwo()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupCreat"), object: nil)
                }
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func backTwo() {
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnBackAction(_ sender: UIButton) {
//        if username.count == 0 {
//            self.dismiss(animated: true, completion: nil)
//        }
//        else {
        self.navigationController?.popViewController(animated: true)
        //}
        
    }
    @IBAction func btnPhotoAction(_ sender: UIButton) {
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            let asset = assets[0]
            asset.fetchOriginalImage(completeBlock: { (image, info) in
                self.imgProfile.image = image
                self.hidenView.isHidden = true
                self.indicator.stopAnimating()
            })
        }
        pickerController.showsCancelButton = true
        pickerController.singleSelect = true
        
        self.present(pickerController, animated: true) {
            self.hidenView.isHidden = false
            self.indicator.startAnimating()
        }
    }
    
    @IBAction func btnCreateAction(_ sender: UIButton) {
        if txtgroupname.text!.isEmpty{
            showalert(tlt: "", msg: "Please enter Group Name")
        }
        else{
            if txtUsername.text!.isEmpty{
                showalert(tlt: "", msg: "Please enter User Name")
            }
            else{
                createGroup()
            }
        }
       
    }
    
    
}

extension CreateGroupViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPrivacy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPrivacy.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let imgIcon = cell.viewWithTag(101)as! UIImageView
        let lblName = cell.viewWithTag(102)as! UILabel
        let lblDesc = cell.viewWithTag(103)as! UILabel
        let btnRadio = cell.viewWithTag(104)as! UIButton
        imgIcon.image = (self.arrPrivacy[indexPath.row]as AnyObject).value(forKey: "img") as? UIImage
        lblName.text = (self.arrPrivacy[indexPath.row]as AnyObject).value(forKey: "name") as? String
        lblDesc.text = (self.arrPrivacy[indexPath.row]as AnyObject).value(forKey: "disc") as? String
        btnRadio.addTarget(self, action: #selector(CreateGroupViewController.btnRadioAction), for: UIControl.Event.touchUpInside)
        if selectedIndex == indexPath.row {
            btnRadio.setImage(#imageLiteral(resourceName: "Radioblue"), for: UIControl.State.normal)
            strSelected = lblName.text!
        }
        else {
            btnRadio.setImage(#imageLiteral(resourceName: "Radio"), for: UIControl.State.normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tblPrivacy.reloadData()
    }
    
    @objc func btnRadioAction(_ sender: UIButton) {
//        if let indexPath = self.tblPrivacy.indexPathForView(sender) {
//                let cellfeed = tblPrivacy.cellForRow(at: indexPath)
//            let btnradio = cellfeed?.viewWithTag(104)as! UIButton
//            selectedIndex = indexPath.row
//            if selectedIndex == indexPath.row {
//                btnradio.setImage(#imageLiteral(resourceName: "Radioblue"), for: UIControl.State.normal)
//            }
//            else {
//                btnradio.setImage(#imageLiteral(resourceName: "Radio"), for: UIControl.State.normal)
//            }
//        }
    }
}


extension CreateGroupViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtAbout.textColor == UIColor.lightGray {
            txtAbout.text = ""
            txtAbout.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtAbout.text == "" {
            
            txtAbout.text = "Write Something..."
            txtAbout.textColor = UIColor.lightGray
        }
    }
}



//MARK: - Drop Down
extension CreateGroupViewController: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        if combox == txtAddMember {
            return ["Members","Admins"]
        }
        else if combox == txtPostOn {
            return ["Members","Admins","Everyone"]
        }
        else {
            return ["Members","Admins"]
        }
    }
    
    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
        return SWComboxTextSelection()
    }
    
    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
}

//members,only_admins
//only_admins,everyone
//only_admins,members

extension CreateGroupViewController : SWComboxViewDelegate {
    //MARK: delegate
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
        print("index - \(index) selected - \(object)")
        
        if withCombox == txtAddMember {
            if index == 0 {
                membersAdd = "members"
            }
            else {
                membersAdd = "only_admins"
            }
        }
        else if withCombox == txtPostOn {
            if index == 0 {
                membersPost = "members"
            }
            else if index == 1 {
                membersPost = "only_admins"
            }
            else {
                membersPost = "everyone"
            }
        }
        else {
            if index == 0 {
                membersEvent = "members"
            }
            else {
                membersEvent = "only_admins"
            }
        }
    }
    
    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
        if isOpen {
            if combox == txtAddMember && txtPostOn.isOpen && txtEventadd.isOpen  {
                txtAddMember.onAndOffSelection()
            }
            
            if combox == txtAddMember && txtPostOn.isOpen && txtEventadd.isOpen {
                txtPostOn.onAndOffSelection()
            }
            
            if combox == txtAddMember && txtPostOn.isOpen && txtEventadd.isOpen  {
                txtEventadd.onAndOffSelection()
            }
        }
    }
}


