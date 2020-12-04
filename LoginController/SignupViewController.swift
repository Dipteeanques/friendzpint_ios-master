//
//  SignupViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 16/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtFullTop: NSLayoutConstraint!
    @IBOutlet weak var txtFullnameHeightCondtraint: NSLayoutConstraint!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblemailAdd: UILabel!
    @IBOutlet weak var lblmobule: UILabel!
    @IBOutlet weak var lblpwd: UILabel!
    @IBOutlet weak var cardheight: NSLayoutConstraint!
    @IBOutlet weak var cardtrailing: NSLayoutConstraint!
    @IBOutlet weak var cardLeading: NSLayoutConstraint!
    @IBOutlet weak var lblCreateAccount: UILabel!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    @IBOutlet weak var logotop: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtEmailTop: NSLayoutConstraint!
    @IBOutlet weak var txtMobileTop: NSLayoutConstraint!
    @IBOutlet weak var txtPwdTop: NSLayoutConstraint!
    @IBOutlet weak var txtConfirmPwdTop: NSLayoutConstraint!
    @IBOutlet weak var btnLoginTop: NSLayoutConstraint!
    @IBOutlet weak var btnSignupTop: NSLayoutConstraint!
    @IBOutlet weak var boxTop: NSLayoutConstraint!
    
    var activityIndicator: UIActivityIndicatorView!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let wc = Webservice.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDeafault()
    }
    
    func setDeafault() {
        if UIScreen.main.bounds.width == 320 {
            viewHeightConstraint.constant = 230
            logotop.constant = 35
            logoWidth.constant = 50
            logoHeight.constant = 50
            lblCreateAccount.font = UIFont.boldSystemFont(ofSize: 15)
            cardLeading.constant = 15
            cardtrailing.constant = 15
            cardheight.constant = 390
            txtFullTop.constant = 14
            txtEmailTop.constant = 14
            txtMobileTop.constant = 14
            txtPwdTop.constant = 14
            txtConfirmPwdTop.constant = 14
            btnSignupTop.constant = 14
            btnLoginTop.constant = 14
            txtFullnameHeightCondtraint.constant = 40
        } else if UIScreen.main.bounds.height == 667 {
            viewHeightConstraint.constant = 270
            logotop.constant = 50
            logoWidth.constant = 60
            logoHeight.constant = 60
            lblCreateAccount.font = UIFont.boldSystemFont(ofSize: 16)
        } else if UIScreen.main.bounds.height == 812 {
            viewHeightConstraint.constant = 350
            logotop.constant = 100
        } else if UIScreen.main.bounds.height == 896 {
            viewHeightConstraint.constant = 380
            logotop.constant = 130
        }

        setPaddingWithImage(image: #imageLiteral(resourceName: "Email"), textField: txtFullname)
        setPaddingWithImage(image: #imageLiteral(resourceName: "emailSignup"), textField: txtEmail)
        setPaddingWithImage(image: #imageLiteral(resourceName: "mobile"), textField: txtMobile)
        setPaddingWithImage(image: #imageLiteral(resourceName: "Password"), textField: txtPwd)
        setPaddingWithImage(image: #imageLiteral(resourceName: "Password"), textField: txtUsername)
        txtFullname.delegate = self
        txtEmail.delegate = self
        txtMobile.delegate = self
        txtPwd.delegate = self
        txtUsername.delegate = self
        btnSignup.layer.cornerRadius = 5
        btnSignup.clipsToBounds = true
        txtEmail.keyboardType = UIKeyboardType.emailAddress
        txtPwd.isSecureTextEntry = true
        txtMobile.keyboardType = UIKeyboardType.numberPad
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    func Indicator() {
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: 10, y: 0, width: 30, height: 48)
        activityIndicator.startAnimating()
        btnSignup.addSubview(activityIndicator)
    }
    
    func register() {
        Indicator()
        if txtFullname.text!.isEmpty {
            txtFullname.layer.borderColor = UIColor.red.cgColor
            txtFullname.layer.borderWidth = 1
            txtFullname.layer.cornerRadius = 5
            lblFullname.textColor = UIColor.red
            lblFullname.isHidden = false
            lblemailAdd.isHidden = true
            lblmobule.isHidden = true
            lblpwd.isHidden = true
            lblUserName.isHidden = true
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtMobile.layer.borderColor = UIColor.lightText.cgColor
            txtMobile.placeholder = "Mobile"
            txtPwd.layer.borderColor = UIColor.lightText.cgColor
            txtPwd.placeholder = "Password"
            txtUsername.layer.borderColor = UIColor.lightText.cgColor
            txtUsername.placeholder = "User Name"
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        else if txtEmail.text!.isEmpty {
            txtEmail.layer.borderColor = UIColor.red.cgColor
            txtEmail.layer.borderWidth = 1
            txtEmail.layer.cornerRadius = 5
            lblemailAdd.textColor = UIColor.red
            lblemailAdd.isHidden = false
            lblFullname.isHidden = true
            lblmobule.isHidden = true
            lblpwd.isHidden = true
            lblUserName.isHidden = true
            txtFullname.layer.borderColor = UIColor.lightText.cgColor
            txtFullname.placeholder = "Full Name"
            txtMobile.layer.borderColor = UIColor.lightText.cgColor
            txtMobile.placeholder = "Mobile"
            txtPwd.layer.borderColor = UIColor.lightText.cgColor
            txtPwd.placeholder = "Password"
            txtUsername.layer.borderColor = UIColor.lightText.cgColor
            txtUsername.placeholder = "User Name"
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        else if txtEmail.text?.isValidEmail() == false {
            txtEmail.layer.borderColor = UIColor.red.cgColor
            txtEmail.layer.borderWidth = 1
            txtEmail.layer.cornerRadius = 5
            lblemailAdd.textColor = UIColor.red
            lblemailAdd.isHidden = false
            lblFullname.isHidden = true
            lblmobule.isHidden = true
            lblpwd.isHidden = true
            lblUserName.isHidden = true
            txtFullname.layer.borderColor = UIColor.lightText.cgColor
            txtFullname.placeholder = "Full Name"
            txtMobile.layer.borderColor = UIColor.lightText.cgColor
            txtMobile.placeholder = "Mobile"
            txtPwd.layer.borderColor = UIColor.lightText.cgColor
            txtPwd.placeholder = "Password"
            txtUsername.layer.borderColor = UIColor.lightText.cgColor
            txtUsername.placeholder = "User Name"
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        else if txtUsername.text!.isEmpty {
            txtUsername.layer.borderColor = UIColor.red.cgColor
            txtUsername.layer.borderWidth = 1
            txtUsername.layer.cornerRadius = 5
            lblUserName.textColor = UIColor.red
            lblUserName.isHidden = false
            lblFullname.isHidden = true
            lblemailAdd.isHidden = true
            lblmobule.isHidden = true
            lblpwd.isHidden = true
            txtFullname.layer.borderColor = UIColor.lightText.cgColor
            txtFullname.placeholder = "Full Name"
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtMobile.layer.borderColor = UIColor.lightText.cgColor
            txtMobile.placeholder = "Mobile"
            txtPwd.layer.borderColor = UIColor.lightText.cgColor
            txtPwd.placeholder = "Password"
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        else if txtPwd.text!.isEmpty {
            txtPwd.layer.borderColor = UIColor.red.cgColor
            txtPwd.layer.borderWidth = 1
            txtPwd.layer.cornerRadius = 5
            lblpwd.textColor = UIColor.red
            lblpwd.isHidden = false
            lblFullname.isHidden = true
            lblemailAdd.isHidden = true
            lblmobule.isHidden = true
            lblUserName.isHidden = true
            txtFullname.layer.borderColor = UIColor.lightText.cgColor
            txtFullname.placeholder = "Full Name"
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtMobile.layer.borderColor = UIColor.lightText.cgColor
            txtMobile.placeholder = "Mobile"
            txtUsername.layer.borderColor = UIColor.lightText.cgColor
            txtUsername.placeholder = "User Name"
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        else {
            
            guard let url = URL(string: REGISTER) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue(ACCEPT, forHTTPHeaderField: "Accept")
            request.addValue(XAPI, forHTTPHeaderField: "Xapi")
            request.httpMethod = "POST"
            let parameters: [String: Any] = [
                "affiliate_code":"",
                "name" : txtFullname.text!,
                "email" : txtEmail.text!,
                "contactno" : txtMobile.text!,
                "username": txtUsername.text!,
                "password": txtPwd.text!
            ]
            request.httpBody = parameters.percentEscaped().data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        let dic = json as! NSDictionary
                        print(dic)
                        let Code = dic.value(forKey: "code")as! Int
                        if Code == 200 {
                            DispatchQueue.main.async {
                                let data = dic.value(forKey: "data")as! NSDictionary
                                let token = data.value(forKey: "token")as! String
                                let name = data.value(forKey: "name")as! String
                                let username = data.value(forKey: "username")as! String
                                let timeline_id = data.value(forKey: "id")as! Int
                                let profile = data.value(forKey: "avatar")as! String
                                let cover = data.value(forKey: "cover")as! String
                                let walletToken = data.value(forKey: "wallet_token")as? String
                                loggdenUser.set(name, forKey: NAMELOgin)
                                loggdenUser.set(token, forKey: TOKEN)
                                loggdenUser.set(true, forKey: Islogin)
                                loggdenUser.set(timeline_id, forKey: TimeLine_id)
                                loggdenUser.set(username, forKey: USERNAME)
                                loggdenUser.set(profile, forKey: PROFILE)
                                loggdenUser.set(cover, forKey: COVER)
                                loggdenUser.set(walletToken, forKey: walletToken ?? "")
                                self.appDel.gotoDashboardController()
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                let message = dic.value(forKey: "message")as! String
                                let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                                self.present(uiAlert, animated: true, completion: nil)
                                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                    self.dismiss(animated: true, completion: nil)
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                }))
                            }
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    @IBAction func btnCheckBoxAction(_ sender: UIButton) {
        if let button = sender as? UIButton {
            if button.isSelected {
                // set deselected
                button.isSelected = false
            } else {
                // set selected
                button.isSelected = true
            }
        }
    }
    @IBAction func btnTermsAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowserCallViewcontroller")as! BrowserCallViewcontroller
        obj.terms = "terms"
        self.navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnPrivacyAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "BrowserCallViewcontroller")as! BrowserCallViewcontroller
        obj.privacy = "privacy"
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnSignupAction(_ sender: UIButton) {
        register()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnBackLoginAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFullname {
            txtFullname.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtFullname.layer.borderWidth = 1
            txtFullname.layer.cornerRadius = 5
            txtFullname.placeholder = ""
            lblFullname.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblFullname.isHidden = false
            lblemailAdd.isHidden = true
            lblmobule.isHidden = true
            lblpwd.isHidden = true
            lblUserName.isHidden = true
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtMobile.layer.borderColor = UIColor.lightText.cgColor
            txtMobile.placeholder = "Mobile"
            txtPwd.layer.borderColor = UIColor.lightText.cgColor
            txtPwd.placeholder = "Password"
            txtUsername.layer.borderColor = UIColor.lightText.cgColor
            txtUsername.placeholder = "User Name"
        }
        
        else if textField == txtEmail {
            txtEmail.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtEmail.layer.borderWidth = 1
            txtEmail.layer.cornerRadius = 5
            txtEmail.placeholder = ""
            lblemailAdd.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblemailAdd.isHidden = false
            lblFullname.isHidden = true
            lblmobule.isHidden = true
            lblpwd.isHidden = true
            lblUserName.isHidden = true
            txtFullname.layer.borderColor = UIColor.lightText.cgColor
            txtFullname.placeholder = "Full Name"
            txtMobile.layer.borderColor = UIColor.lightText.cgColor
            txtMobile.placeholder = "Mobile"
            txtPwd.layer.borderColor = UIColor.lightText.cgColor
            txtPwd.placeholder = "Password"
            txtUsername.layer.borderColor = UIColor.lightText.cgColor
            txtUsername.placeholder = "User Name"
        }
        else if textField == txtMobile {
            txtMobile.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtMobile.layer.borderWidth = 1
            txtMobile.layer.cornerRadius = 5
            txtMobile.placeholder = ""
            lblmobule.isHidden = false
            lblFullname.isHidden = true
            lblemailAdd.isHidden = true
            lblpwd.isHidden = true
            lblUserName.isHidden = true
            txtFullname.layer.borderColor = UIColor.lightText.cgColor
            txtFullname.placeholder = "Full Name"
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtPwd.layer.borderColor = UIColor.lightText.cgColor
            txtPwd.placeholder = "Password"
            txtUsername.layer.borderColor = UIColor.lightText.cgColor
            txtUsername.placeholder = "User Name"
        }
        else if textField == txtPwd {
            txtPwd.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtPwd.layer.borderWidth = 1
            txtPwd.layer.cornerRadius = 5
            txtPwd.placeholder = ""
            lblpwd.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblpwd.isHidden = false
            lblFullname.isHidden = true
            lblemailAdd.isHidden = true
            lblmobule.isHidden = true
            lblUserName.isHidden = true
            txtFullname.layer.borderColor = UIColor.lightText.cgColor
            txtFullname.placeholder = "Full Name"
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtMobile.layer.borderColor = UIColor.lightText.cgColor
            txtMobile.placeholder = "Mobile"
            txtUsername.layer.borderColor = UIColor.lightText.cgColor
            txtUsername.placeholder = "User Name"
        }
        else if textField == txtUsername {
            txtUsername.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtUsername.layer.borderWidth = 1
            txtUsername.layer.cornerRadius = 5
            txtUsername.placeholder = ""
            lblUserName.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblUserName.isHidden = false
            lblFullname.isHidden = true
            lblemailAdd.isHidden = true
            lblmobule.isHidden = true
            lblpwd.isHidden = true
            txtFullname.layer.borderColor = UIColor.lightText.cgColor
            txtFullname.placeholder = "Full Name"
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Email Address"
            txtMobile.layer.borderColor = UIColor.lightText.cgColor
            txtMobile.placeholder = "Mobile"
            txtPwd.layer.borderColor = UIColor.lightText.cgColor
            txtPwd.placeholder = "Password"
        }
    }
}


extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
