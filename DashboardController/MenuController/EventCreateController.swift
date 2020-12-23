//
//  DeactiveController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 01/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces
import GoogleMaps

class EventCreateController: UIViewController,GMSMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var viewHight: NSLayoutConstraint!
    @IBOutlet weak var txtPost: SWComboxView!
    @IBOutlet weak var dropView: UIView!
    @IBOutlet weak var txtGusetEvent: SWComboxView!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEnddate: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtType: SWComboxView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let datePicker = UIDatePicker()
    let datePickerEnd = UIDatePicker()
    var type = String()
    var wc = Webservice.init()
    var guestEven = String()
    var postevent = String()
    var strEventUserName = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtLocation.delegate = self
        txtStartDate.delegate = self
        setDeafult()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePickerEnd.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtStartDate {
            txtEnddate.text = " "
        }
        else {
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            self.present(acController, animated: true, completion: nil)
        }
    }
    
    func setDeafult() {
        
        if strEventUserName.count == 0 {
            dropView.isHidden = true
            viewHight.constant = 0
            activity.isHidden = true
            type = "private"
            self.setupCombox()
        }
        else {
            activity.isHidden = true
            lblTitle.text = "Setting Event"
            btnCreate.setTitle("Update", for: .normal)
            guestEven = "only_guests"
            postevent = "only_guests"
            type = "private"
            getEditEvent()
        }
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.headerView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerView.layer.addSublayer(gradientLayer)
        headerView.addSubview(btnBack)
        headerView.addSubview(lblTitle)
        headerView.addSubview(btnCreate)
        headerView.addSubview(activity)
        activity.isHidden = true
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
        }
        
        txtAbout.layer.borderWidth = 0.5
        txtAbout.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        txtAbout.layer.cornerRadius = 5
        txtAbout.clipsToBounds = true
        
        showDatePicker()
        
        txtAbout.text = "Write Something..."
        txtAbout.textColor = UIColor.lightGray
        txtAbout.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupCombox() {
        txtType.dataSource = self
        txtType.delegate = self
        txtPost.dataSource = self
        txtPost.delegate = self
        txtGusetEvent.delegate = self
        txtGusetEvent.dataSource = self
    }
    
    //MARK: - PickerView
    func showDatePicker(){
        //Formate Date
        //datePicker.datePickerMode = .date
        datePicker.datePickerMode = .dateAndTime
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(EventCreateController.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(EventCreateController.cancelDatePicker))
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        datePicker.minimumDate = Date()
        // add toolbar to textField
        txtStartDate.inputAccessoryView = toolbar
        // add datepicker to textField
        txtStartDate.inputView = datePicker
        
    }
    
    
    func showEndDatePicker(){
        //Formate Date
       // datePickerEnd.datePickerMode = .date
        datePickerEnd.datePickerMode = .dateAndTime

        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(EventCreateController.donedatePicker1))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(EventCreateController.cancelDatePicker1))
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:txtStartDate.text!)!
      //  let datetwo = dateFormatter.date(from:txtEnddate.text!)!
        
        datePickerEnd.minimumDate = date
        // add toolbar to textField
        txtEnddate.inputAccessoryView = toolbar
        // add datepicker to textField
        txtEnddate.inputView = datePickerEnd
        
    }
    
    @objc func donedatePicker(){
        //For date formate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
//        formatter.dateStyle = DateFormatter.Style.short
//        formatter.timeStyle = DateFormatter.Style.short
        txtStartDate.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
         showEndDatePicker()
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    @objc func donedatePicker1(){
        //For date formate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        txtEnddate.text = formatter.string(from: datePickerEnd.date)
       
        //dismiss date picker dialog
        self.view.endEditing(true)
        
        
    }
    
    @objc func cancelDatePicker1(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    
    func getEditEvent() {
        let parameters = ["username":strEventUserName]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: EVENT_SETTINGS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: eventProfileResponsModel?) in
            if sucess {
                let res = response?.data
                self.txtName.text = res?.name
               // self.strUserName = res!.username
                self.txtStartDate.text = res?.start_date
                self.txtEnddate.text = res?.end_date
                self.txtLocation.text = res?.location
                self.txtAbout.text = res?.about
                if self.txtAbout.text.isEmpty {
                    print("jekil")
                }
                else {
                    self.txtAbout.textColor = UIColor.black
                }
                self.type = res!.event_type
                if self.type == "private" {
                    self.txtType.defaultSelectedIndex = 0
                }
                else {
                    self.txtType.defaultSelectedIndex = 1
                }
                
                self.guestEven = res!.invite_privacy
                if self.guestEven == "only_guests" {
                    self.txtGusetEvent.defaultSelectedIndex = 0
                }
                else {
                    self.txtGusetEvent.defaultSelectedIndex = 1
                }
                
                self.postevent = res!.timeline_post_privacy
                if self.postevent == "only_guests" {
                    self.txtPost.defaultSelectedIndex = 0
                }
                else {
                    self.txtPost.defaultSelectedIndex = 1
                }
                self.setupCombox()
            }
        }
    }
    
    func createEvent() {
        if strEventUserName.count == 0 {
            btnCreate.isHidden = true
            activity.isHidden = false
            activity.startAnimating()
            let strUserName = loggdenUser.value(forKey: USERNAME)as! String
            let parameters = ["name": txtName.text!,
                              "username": strUserName,
                              "start_date":txtStartDate.text!,
                              "end_date":txtEnddate.text!,
                              "location":txtLocation.text!,
                              "type":type,
                              "about":txtAbout.text!] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            AF.request(CREATE_EVENT, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { response in
                    print(response)
                    let dic = response.value as! NSDictionary
                    let sucess = dic.value(forKey: "success")as! Bool
                    let message = dic.value(forKey: "message")as! String
                    if sucess == true {
                        self.activity.stopAnimating()
                        self.activity.isHidden = true
                        self.btnCreate.isHidden = false
                        self.backTwo()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createdevent"), object: nil)
                    }
                    else
                    {
                        let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.activity.stopAnimating()
                            self.activity.isHidden = true
                            self.btnCreate.isHidden = false
                            self.dismiss(animated: true, completion: nil)
                        }))
                    }
            }
        }
        else {
            
            btnCreate.isHidden = true
            activity.isHidden = false
            activity.startAnimating()
            
            let parameters = ["name": txtName.text!,
                              "username": strEventUserName,
                              "start_date":txtStartDate.text!,
                              "end_date":txtEnddate.text!,
                              "location":txtLocation.text!,
                              "type":type,
                              "about":txtAbout.text!,
                              "invite_privacy":guestEven,
                              "timeline_post_privacy":postevent] as [String : Any]

            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            AF.request(EVENT_SETTINGS_SAVE, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { response in
                    print(response)
                    let dic = response.value as! NSDictionary
                    let sucess = dic.value(forKey: "success")as! Bool
                    let message = dic.value(forKey: "message")as! String
                    
                    if sucess == true {
                        self.activity.stopAnimating()
                        self.activity.isHidden = true
                        self.btnCreate.isHidden = false
                        self.backTwo()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createdevent"), object: nil)
                    }
                    else
                    {
                        let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            self.activity.stopAnimating()
                            self.activity.isHidden = true
                            self.btnCreate.isHidden = false
                            self.dismiss(animated: true, completion: nil)
                        }))
                    }
            }
        }
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    //MARK: - Btn Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStartDateAction(_ sender: UIButton) {
        
        showDatePicker()
    }
    @IBAction func btnEndDateAction(_ sender: UIButton) {
        showEndDatePicker()
    }
    @IBAction func btnCreateAction(_ sender: UIButton) {
        createEvent()
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



//MARK: - Drop Down
extension EventCreateController: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        if combox == txtType {
            return ["Private", "Public"]
        }
        else if combox == txtGusetEvent {
            return ["Guests","Only admin"]
        }
        else {
            return ["Guests","Only admin"]
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
extension EventCreateController : SWComboxViewDelegate {
    //MARK: delegate
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
        print("index - \(index) selected - \(object)")
        if withCombox == txtType {
            if index == 0 {
                type = "private"
            }
            else {
                type = "public"
            }
        }
        else if withCombox == txtGusetEvent {
            if index == 0 {
                guestEven = "only_guests"
            }
            else {
                guestEven = "only_admins"
            }
        }
        else {
            if index == 0 {
                postevent = "only_guests"
            }
            else {
                postevent = "only_admins"
            }
        }
    }
    
    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
        if isOpen {
            if combox == txtType && txtGusetEvent.isOpen && txtPost.isOpen  {
                txtGusetEvent.onAndOffSelection()
            }
            
            if combox == txtType && txtGusetEvent.isOpen && txtPost.isOpen {
                txtType.onAndOffSelection()
            }
            
            if combox == txtType && txtGusetEvent.isOpen && txtPost.isOpen {
                txtPost.onAndOffSelection()
            }
        }
    }
}


extension EventCreateController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? "null")")
        self.txtLocation.text = place.formattedAddress
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


extension EventCreateController: UITextViewDelegate
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
