//
//  GeneralSettingsViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 31/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class GeneralSettingsViewController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var txtTimezonw: UITextField!
    @IBOutlet weak var txtContectNumber: UITextField!
    @IBOutlet weak var gendetview: SWComboxView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var btnSaveChange: UIButton!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtDesignation: UITextField!
    @IBOutlet weak var txtHobby: UITextField!
    @IBOutlet weak var txtIntrest: UITextField!
    
    //MARK: - Variable
    let datePicker = UIDatePicker()
    var gender = String()
    var wc = Webservice.init()
    var arrTimeZone = [String]()
    var selectedTimezone = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
         NotificationCenter.default.addObserver(self, selector: #selector(GeneralSettingsViewController.Timezone), name: NSNotification.Name(rawValue: "Timezone"), object: nil)
        setDeafult()
    }
    
    @objc func Timezone(_ notification: NSNotification) {
        let selectedtime = notification.object as! String
        txtTimezonw.text = selectedtime
    }
    

    func setDeafult() {
        getGeneralSetting()
        self.activity.isHidden = true
        txtFirstName.isUserInteractionEnabled = false
        txtEmail.isUserInteractionEnabled = false
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.headerView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerView.layer.addSublayer(gradientLayer)
        headerView.addSubview(btnback)
        headerView.addSubview(lblTitle)
        
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
        }
        
        txtAbout.layer.borderWidth = 0.5
        txtAbout.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        txtAbout.layer.cornerRadius = 5
        txtAbout.clipsToBounds = true
        
        btnSaveChange.layer.cornerRadius = 5
        btnSaveChange.clipsToBounds = true
        
        showDatePicker()
    }
    
    //MARK: - PickerView
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(GeneralSettingsViewController.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(GeneralSettingsViewController.cancelDatePicker))

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        datePicker.maximumDate = Date()
        // add toolbar to textField
        txtDate.inputAccessoryView = toolbar
        // add datepicker to textField
        txtDate.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        txtDate.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCombox() {
        gendetview.dataSource = self
        gendetview.delegate = self
        //category.showMaxCount = 4
    }
    
  //
 
//    func getTimeZone() {
//        var request = URLRequest(url: URL(string: Domain + "/timezonelist")!)
//        request.httpMethod = "POST"
//        request.httpBody = try? JSONSerialization.data(withJSONObject: [:], options: [])
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let session = URLSession.shared
//        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
//            print(response!)
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!) as? [String: AnyObject]
//                let dic = json!["data"] as! NSDictionary
//                self.arrTimeZone.add(dic)
//                print(self.arrTimeZone)
//                self.tblTimezone.reloadData()
//            } catch {
//                print("error")
//            }
//        })
//
//        task.resume()
//    }
    
    
    func getGeneralSetting(){
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                       "Accept" : ACCEPT,
                       "Authorization":BEARERTOKEN]
        
        wc.callGETSimplewebservice(url: GETUSERGENERALSETTING, parameters: [:], headers: headers, fromView: self.view, isLoading: false) { (sucess, response: UsergenralSettingModel?) in
            if sucess {
                let res = response?.data
                self.txtFirstName.text = res?.username
                self.txtLastName.text = res?.name
                self.txtAbout.text = res?.about
                self.txtEmail.text = res?.email
                self.txtDate.text = res?.birthday
                self.txtCountry.text = res?.country
                self.txtCity.text = res?.city
                self.txtDesignation.text = res?.designation
                self.txtHobby.text = res?.hobbies
                self.txtIntrest.text = res?.interests
                self.txtContectNumber.text = res?.contactno
                self.txtTimezonw.text = res?.timezone
                self.gender = res!.gender
                if self.gender == "Male" {
                    self.gendetview.defaultSelectedIndex = 0
                }
                else if self.gender == "Female" {
                    self.gendetview.defaultSelectedIndex = 1
                }
                else {
                    self.gendetview.defaultSelectedIndex = 2
                }
                 self.setupCombox()
            }
        }
    }
    
    func updateGeneralSetting() {
        btnSaveChange.isHidden = true
        self.activity.isHidden = false
        activity.startAnimating()
        let parameters = ["username": txtFirstName.text!,
                          "name" : txtLastName.text!,
                          "about": txtAbout.text!,
                          "email": txtEmail.text!,
                          "gender":gender,
                          "country":txtCountry.text!,
                          "city":txtCity.text!,
                          "birthday": txtDate.text!,
                          "designation":txtDesignation.text!,
                          "hobbies":txtHobby.text!,
                          "interests":txtIntrest.text!,
                          "contactno":txtContectNumber.text!,
                          "timezone":txtTimezonw.text!,
                          "facebook_link":" ",
                          "youtube_link":" ",
                          "twitter_link": " ",
                          "instagram_link": " ",
                          "dribbble_link": " ",
                          "linkedin_link": " "]as [String : Any]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                       "Accept" : ACCEPT,
                       "Authorization":BEARERTOKEN]
        
        self.wc.callSimplewebservice(url: SAVEUSERGENERALSETTINGS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: UsergenralSettingModel?) in
            if sucess {
                let message = response?.message
                let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.btnSaveChange.isHidden = false
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                    self.dismiss(animated: true, completion: nil)
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SettingsProfile"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
            }
        }
    }
    
    
    //MARK: - Btn Action
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSaveChangeAction(_ sender: UIButton) {
        updateGeneralSetting()
    }
    
    @IBAction func btnTimezoneAction(_ sender: UIButton) {
        let obj = self.storyboard!.instantiateViewController(withIdentifier: "TimezoneController") as! TimezoneController
        self.present(obj, animated:true, completion: nil)
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
extension GeneralSettingsViewController: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        return ["Male", "Female", "Other"]
    }
    
    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
        return SWComboxTextSelection()
    }
    
    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
}

extension GeneralSettingsViewController : SWComboxViewDelegate {
    //MARK: delegate
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
        print("index - \(index) selected - \(object)")
        if index == 0 {
            gender = "Male"
        }
        else if index == 1 {
            gender = "Female"
        }
        else {
            gender = "Other"
        }
    }
    
    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
        if isOpen {
            gendetview.onAndOffSelection()
        }
    }
}




