//
//  CreatePageViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 30/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import DKPhotoGallery
import DKImagePickerController

class CreatePageViewController: UIViewController {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var heightPrivacy: NSLayoutConstraint!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var txtAddmemberOnthispage: SWComboxView!
    @IBOutlet weak var txtPostOnthispage: SWComboxView!
    @IBOutlet weak var txtAddressView: UITextView!
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtuserName: UITextField!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnCreatePage: UIButton!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var hidenView: UIView!
    
    var wc = Webservice.init()
    var arrCategory = [CategoryData]()
    var arrName = [String]()
    var valueSelected = [CategoryData]()
    var selected_id = Int()
    var membersAdd = String()
    var membersAddAdmin = String()
    var membersPost = String()
    var strPageName = String()
    var url: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDeafult()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func setupCombox() {
        txtPostOnthispage.dataSource = self
        txtPostOnthispage.delegate = self
        
        txtAddmemberOnthispage.dataSource = self
        txtAddmemberOnthispage.delegate = self
    }
    
    func setDeafult() {
        activity.isHidden = true
        if strPageName.count == 0 {
            privacyView.isHidden = true
            mainView.bounds.size.height = 600
            activity.isHidden = true
        }
        else {
            activity.isHidden = true
            lblTitle.text = "Setting Page"
            btnCreatePage.setTitle("Update", for: .normal)
            txtAddressView.text = "Write Something..."
            txtAddressView.textColor = UIColor.lightGray
            txtAddressView.delegate = self
            getEditPage()
        }
        
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.headerView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerView.layer.addSublayer(gradientLayer)
        headerView.addSubview(btnBack)
        headerView.addSubview(lblTitle)
        headerView.addSubview(btnCreatePage)
        headerView.addSubview(activity)
        
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
        }
        txtAbout.layer.borderWidth = 0.5
        txtAbout.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        txtAbout.layer.cornerRadius = 5
        txtAbout.clipsToBounds = true
        
        txtAddressView.layer.borderWidth = 0.5
        txtAddressView.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        txtAddressView.layer.cornerRadius = 5
        txtAddressView.clipsToBounds = true
        
        btnCreatePage.layer.cornerRadius = 5
        btnCreatePage.clipsToBounds = true
        
        btnDelete.layer.cornerRadius = 5
        btnDelete.clipsToBounds = true
        
        imageProfile.layer.cornerRadius = 50
        imageProfile.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(CreatePageViewController.SelectedCategory), name: NSNotification.Name(rawValue: "categorySelected"), object: nil)
        
        txtAbout.text = "Write Something..."
        txtAbout.textColor = UIColor.lightGray
        txtAbout.delegate = self
        
        
    }
    
    @objc func SelectedCategory(_ notification: NSNotification) {
        valueSelected = notification.object as! [CategoryData]
        print(valueSelected)
        txtCategory.text = valueSelected[0].name
        selected_id = valueSelected[0].id
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEditPage() {
        let parameters = ["username":strPageName]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: PAGE_GENERAL, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: pageProfileResponsModel?) in
            if sucess {
                let res = response?.data
                let strAvatar = res?.avatar_url
                self.url = URL(string: strAvatar!)
                self.imageProfile.sd_setImage(with: self.url, completed: nil)
                self.txtCategory.text = res?.category_name
                self.selected_id = res!.category_id
                self.txtName.text = res?.name
                self.txtuserName.text = res?.username
                self.txtAbout.text = res?.about
                if self.txtAbout.text.isEmpty {
                    print("jekil")
                }
                else {
                    self.txtAbout.textColor = UIColor.black
                }
                self.txtPhone.text = res?.phone
                self.txtWebsite.text = res?.website
                self.txtAddressView.text = res?.address
                if self.txtAddressView.text.isEmpty {
                    print("jekil")
                }
                else {
                    self.txtAddressView.textColor = UIColor.black
                }
                self.membersPost = res!.timeline_post_privacy
                if self.membersPost == "everyone" {
                    self.txtPostOnthispage.defaultSelectedIndex = 0
                }
                else {
                    self.txtPostOnthispage.defaultSelectedIndex = 1
                }
                self.membersAdd = res!.member_privacy
                if self.membersAdd == "members" {
                    self.txtAddmemberOnthispage.defaultSelectedIndex = 0
                }
                else {
                    self.txtAddmemberOnthispage.defaultSelectedIndex = 1
                }
                self.setupCombox()
            }
        }
    }
    
    
    func CreatePage() {
        if strPageName.count == 0 {
            activity.isHidden = false
            activity.startAnimating()
            btnCreatePage.isHidden = true
            let Username = txtuserName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let parameters = ["name": txtName.text!,
                              "username": Username,
                              "about":txtAbout.text!,
                              "category":selected_id] as [String : Any]
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
                    let image = self.imageProfile.image!.resizeWithWidth(width: 800)!
                    let imageData:Data = image.jpegData(compressionQuality: 0.2)!
                    multiPart.append(imageData, withName: "change_avatar", fileName: "image.png", mimeType: "image/png")
            },
                usingThreshold: UInt64.init(),to: CREATE_PAGE, method: .post , headers: headers)
                .responseJSON(completionHandler: { (response) in
                    print(response)
                    let dicres = response.value as! NSDictionary
                    let sucess = dicres.value(forKey: "success")as! Bool
                    let message = dicres.value(forKey: "message")as! String
                    if sucess == true {
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnCreatePage.isHidden = false
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PageCreat"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                            self.btnCreatePage.isHidden = false
                            self.dismiss(animated: true, completion: nil)
                        }))
                    }
                    
                })
        }
        else {
            activity.isHidden = false
            activity.startAnimating()
            btnCreatePage.isHidden = true
            let Username = txtuserName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let parameters = ["name": txtName.text!,
                              "username": Username,
                              "about":txtAbout.text!,
                              "category":selected_id,
                              "website":txtWebsite.text!,
                              "phone":txtPhone.text!,
                              "address":txtAddressView.text!,
                              "member_privacy":membersAdd,
                              "timeline_post_privacy":membersPost] as [String : Any]
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
                    let image = self.imageProfile.image!.resizeWithWidth(width: 800)!
                    let imageData:Data = image.jpegData(compressionQuality: 0.2)!
                    multiPart.append(imageData, withName: "change_avatar", fileName: "image.png", mimeType: "image/png")
            },
                usingThreshold: UInt64.init(),to: PAGES_UPDATEGENERAL, method: .post , headers: headers)
                .responseJSON(completionHandler: { (response) in
                    print(response)
                    let dicres = response.value as! NSDictionary
                    let sucess = dicres.value(forKey: "success")as! Bool
                    let message = dicres.value(forKey: "message")as! String
                    if sucess == true {
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.btnCreatePage.isHidden = false
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PageCreat"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                            self.btnCreatePage.isHidden = false
                            self.dismiss(animated: true, completion: nil)
                        }))
                    }
                })
        }
    }
    

    
    //MARK: - Btn Action
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btncreatepageAction(_ sender: UIButton) {
        CreatePage()
    }
    @IBAction func btnCategoryAction(_ sender: UIButton) {
        let obj = self.storyboard!.instantiateViewController(withIdentifier: "PageCategoryController") as! PageCategoryController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btngalleryAction(_ sender: UIButton) {
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            let asset = assets[0]
            asset.fetchOriginalImage(completeBlock: { (image, info) in
                self.imageProfile.image = image
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
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Notification", message: "Are you sure to delete?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let page_id = loggdenUser.value(forKey: PAGEID)as! Int
            let parameters = ["page_id": page_id]as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            self.wc.callSimplewebservice(url: PAGE_DELETE, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: GroupDeleteResponsModel?) in
                if sucess {
                    self.backTwo()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PageCreat"), object: nil)
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
    
   
}

extension CreatePageViewController: UITextViewDelegate
{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == txtAbout {
            if txtAbout.textColor == UIColor.lightGray {
                txtAbout.text = ""
                txtAbout.textColor = UIColor.black
            }
        }
        else {
            if txtAddressView.textColor == UIColor.lightGray {
                txtAddressView.text = ""
                txtAddressView.textColor = UIColor.black
            }
        }
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == txtAbout {
            if txtAbout.text == "" {
                txtAbout.text = "Write Something..."
                txtAbout.textColor = UIColor.lightGray
            }
        }
        else {
            if txtAddressView.text == "" {
                txtAddressView.text = "Write Something..."
                txtAddressView.textColor = UIColor.lightGray
            }
        }
    }
}



//MARK: - Drop Down
extension CreatePageViewController: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        if combox == txtPostOnthispage {
            return ["Everyone","Admins"]
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

extension CreatePageViewController : SWComboxViewDelegate {
    //MARK: delegate
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
        print("index - \(index) selected - \(object)")
        
        if withCombox == txtPostOnthispage {
            if index == 0 {
                membersPost = "everyone"
            }
            else {
                membersPost = "only_admins"
            }
        }
        else {
            if index == 0 {
                membersAdd = "members"
            }
            else {
                membersAdd = "only_admins"
            }
        }
    }
    
    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
        if isOpen {
            if combox == txtPostOnthispage && txtAddmemberOnthispage.isOpen  {
                txtPostOnthispage.onAndOffSelection()
            }
            
            if combox == txtPostOnthispage && txtAddmemberOnthispage.isOpen  {
                txtAddmemberOnthispage.onAndOffSelection()
            }
            
        }
    }
}


