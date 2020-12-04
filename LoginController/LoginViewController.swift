//
//  LoginViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 10/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Crashlytics
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var forgoCardLeading: NSLayoutConstraint!
    @IBOutlet weak var forgocardTrailing: NSLayoutConstraint!
    @IBOutlet weak var forgotcardHeight: NSLayoutConstraint!
    @IBOutlet weak var lblForgotEmailadd: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var forgotEmailtxt: UITextField!
    @IBOutlet weak var forgotView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblPwdPlaceholder: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblemailPlaceHolder: UILabel!
    @IBOutlet weak var txtTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardheight: NSLayoutConstraint!
    @IBOutlet weak var cardtrailing: NSLayoutConstraint!
    @IBOutlet weak var cardLeading: NSLayoutConstraint!
    @IBOutlet weak var cardViewTop: NSLayoutConstraint!
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    @IBOutlet weak var logotop: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    
    var activityIndicator: UIActivityIndicatorView!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let wc = Webservice.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
    }
   
    
    func setDefault() {
       // let deviceID = UIDevice.current.identifierForVendor!.uuidString
        txtEmail.delegate = self
        txtPassword.delegate = self
        if UIScreen.main.bounds.width == 320 {
            viewHeightConstraint.constant = 265
            logotop.constant = 70
            logoWidth.constant = 60
            logoHeight.constant = 60
            lblHello.font = UIFont.boldSystemFont(ofSize: 15)
            cardViewTop.constant = 15
            cardLeading.constant = 15
            cardtrailing.constant = 15
            cardheight.constant = 180
            txtTopConstraint.constant = 13
            forgoCardLeading.constant = 15
            forgocardTrailing.constant = 15
            
        } else if UIScreen.main.bounds.height == 896 {
            viewHeightConstraint.constant = 360
            logotop.constant = 110
        } else if UIScreen.main.bounds.width == 414 {
        } else if UIScreen.main.bounds.height == 667 {
            viewHeightConstraint.constant = 270
            logotop.constant = 50
            logoWidth.constant = 60
            logoHeight.constant = 60
            lblHello.font = UIFont.boldSystemFont(ofSize: 16)
        }
        
        setPaddingWithImage(image: #imageLiteral(resourceName: "Email"), textField: txtEmail)
        setPaddingWithImage(image: #imageLiteral(resourceName: "Password"), textField: txtPassword)
        setPaddingWithImage(image: #imageLiteral(resourceName: "emailSignup"), textField: forgotEmailtxt)
        btnLogin.layer.cornerRadius = 5
        btnLogin.clipsToBounds = true
        txtEmail.keyboardType = UIKeyboardType.emailAddress
        forgotEmailtxt.keyboardType = UIKeyboardType.emailAddress
        txtPassword.isSecureTextEntry = true
       // txtEmail.text = "jekildabhoya"
        lblPwdPlaceholder.isHidden = true
        txtPassword.layer.borderColor = UIColor.lightText.cgColor
        txtPassword.placeholder = "Password"
       // txtPassword.text = "jekil2811"
        forgotEmailtxt.placeholder = "Username / E-mail"
        forgotEmailtxt.delegate = self
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.clipsToBounds = true
    }
    
    func Indicator() {
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: 10, y: 0, width: 30, height: 48)
        activityIndicator.startAnimating()
        btnLogin.addSubview(activityIndicator)
    }
    
    
    func loginAPI() {
        Indicator()
        if txtEmail.text!.isEmpty {
            txtEmail.layer.borderColor = UIColor.red.cgColor
            txtEmail.layer.borderWidth = 1
            txtEmail.layer.cornerRadius = 5
            lblemailPlaceHolder.textColor = UIColor.red
            lblemailPlaceHolder.isHidden = false
            lblPwdPlaceholder.isHidden = true
            txtPassword.layer.borderColor = UIColor.lightText.cgColor
            txtPassword.placeholder = "Password"
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        else if txtPassword.text!.isEmpty {
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Username / E-mail"
            lblemailPlaceHolder.isHidden = true
            lblPwdPlaceholder.isHidden = false
            lblPwdPlaceholder.textColor = UIColor.red
            txtPassword.layer.borderColor = UIColor.red.cgColor
            txtPassword.layer.cornerRadius = 5
            txtPassword.layer.borderWidth = 1
            txtPassword.placeholder = ""
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        else {
                guard let url = URL(string: LOGIN) else { return }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue(ACCEPT, forHTTPHeaderField: "Accept")
                request.addValue(XAPI, forHTTPHeaderField: "Xapi")
                request.httpMethod = "POST"
                let parameters: [String: Any] = [
                    "email":txtEmail.text!,
                    "password" : txtPassword.text!,
                    "remember" : ""
                ]
            print(parameters)
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
                                    let walletToken1 = data.value(forKey: "wallet_token")as! String
                                    
                                    loggdenUser.set(name, forKey: NAMELOgin)
                                    loggdenUser.set(token, forKey: TOKEN)
                                    loggdenUser.set(true, forKey: Islogin)
                                    loggdenUser.set(timeline_id, forKey: TimeLine_id)
                                    loggdenUser.set(username, forKey: USERNAME)
                                    loggdenUser.set(profile, forKey: PROFILE)
                                    loggdenUser.set(cover, forKey: COVER)
                                    loggdenUser.set(walletToken1, forKey:walletToken)//
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
       
    
    
    func ForgotPassword() {
        let parameters = ["email":forgotEmailtxt.text!]
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT]
        wc.callSimplewebservice(url: PASSWORD_EMAIL, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ForgotPasswordRespons?) in
            if sucess {
                let message = response?.message
                let uiAlert = UIAlertController(title: "FriendzPoint", message: message, preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.forgotView.isHidden = true
                    self.lblForgotEmailadd.isHidden = true
                    self.dismiss(animated: true, completion: nil)
                }))
            }
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
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if forgotEmailtxt.text!.isEmpty {
            print("sorry")
        }
        else {
            ForgotPassword()
        }
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
       loginAPI()
    }
   
    @IBAction func btnForgotAction(_ sender: UIButton) {
        forgotView.isHidden = false
    }
    @IBAction func btntermsAction(_ sender: UIButton) {
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
        let obj = storyboard?.instantiateViewController(withIdentifier: "SignupViewController")as! SignupViewController
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btncancelAction(_ sender: UIButton) {
        forgotView.isHidden = true
        forgotEmailtxt.layer.borderColor = UIColor.lightText.cgColor
        forgotEmailtxt.placeholder = "Email Address"
        lblForgotEmailadd.isHidden = true
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtEmail {
            txtEmail.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtEmail.layer.borderWidth = 1
            txtEmail.layer.cornerRadius = 5
            txtEmail.placeholder = ""
            lblemailPlaceHolder.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            lblemailPlaceHolder.isHidden = false
            lblPwdPlaceholder.isHidden = true
            txtPassword.layer.borderColor = UIColor.lightText.cgColor
            txtPassword.placeholder = "Password"
        }
            
        else if textField == txtPassword {
            txtEmail.layer.borderColor = UIColor.lightText.cgColor
            txtEmail.placeholder = "Username / E-mail"
            lblemailPlaceHolder.isHidden = true
            lblPwdPlaceholder.isHidden = false
            lblPwdPlaceholder.textColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1)
            txtPassword.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            txtPassword.layer.cornerRadius = 5
            txtPassword.layer.borderWidth = 1
            txtPassword.placeholder = ""
        }
            
        else if textField == forgotEmailtxt {
            forgotEmailtxt.layer.borderColor = UIColor(red: 6/255, green: 111/255, blue: 243/255, alpha: 1).cgColor
            forgotEmailtxt.layer.cornerRadius = 5
            forgotEmailtxt.layer.borderWidth = 1
            forgotEmailtxt.placeholder = ""
            lblForgotEmailadd.isHidden = false
        }
    }
}

func setPaddingWithImage(image: UIImage, textField: UITextField){
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    imageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
    let seperatorView = UIView(frame: CGRect(x: 50, y: 0, width: 10, height: 50))
    view.addSubview(seperatorView)
    textField.leftViewMode = .always
    view.addSubview(imageView)
    textField.leftViewMode = UITextField.ViewMode.always
    textField.leftView = view
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

//print(response)
//if let count = try? response.result.get() {
//    print("\(count) unread messages.")
//    complition(true,count)
//}
//else {
//    complition(false,nil)
//}
