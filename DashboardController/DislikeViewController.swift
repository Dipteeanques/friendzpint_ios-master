//
//  LikeViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 04/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class DislikeViewController: UIViewController {
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: LargeFound!
    @IBOutlet weak var tblViewlike: UITableView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var headerview: UIView!
    
    var arrLiked = [postlikelistall]()
    var url : URL?
    var wc = Webservice.init()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var post_id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDeafult()
    }
    
    func setDeafult() {
        self.loaderView.isHidden = false
        self.activity.startAnimating()
        likelist(strPage : "1")
        pageCount = 1
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.headerview.bounds
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerview.layer.addSublayer(gradientLayer)
        headerview.addSubview(btnback)
        headerview.addSubview(lblTitle)
        
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerview.bounds.origin.x, y: headerview.bounds.origin.y, width: 414, height: headerview.bounds.size.height)
        }
        else if UIScreen.main.bounds.height == 812 {
            // txtviewHeightConstraint.constant = 400
        }
        else if UIScreen.main.bounds.width == 320 {
            //txtviewHeightConstraint.constant = 190
        }
        
    }
    
    func likelist(strPage : String) {
        let parameters = ["post_id": post_id,
                          "heading":"Dislike",
                          "page":strPage] as [String : Any]
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: POSTLISKELIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: postlikeresponsemodelall?) in
            if sucess {
                let sucessMy = response?.success
                if sucessMy! {
                    let data = response?.data
                    let arr_dict = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrLiked.append(arr_dict![i])
                        self.tblViewlike.beginUpdates()
                        self.tblViewlike.insertRows(at: [
                            NSIndexPath(row: self.arrLiked.count-1, section: 0) as IndexPath], with: .fade)
                        self.tblViewlike.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblViewlike.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrLiked.count == 0 {
                            self.foundView.isHidden = false
                        }
                        else {
                            self.foundView.isHidden = true
                        }
                    }
                }
                else {
                    self.spinner.stopAnimating()
                    self.tblViewlike.tableFooterView?.isHidden = true
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrLiked.count == 0 {
                        self.foundView.isHidden = false
                    }
                    else {
                        self.foundView.isHidden = true
                    }
                }
            }
            self.spinner.stopAnimating()
            self.tblViewlike.tableFooterView?.isHidden = true
            self.loaderView.isHidden = true
            self.activity.stopAnimating()
            if self.arrLiked.count == 0 {
                self.foundView.isHidden = false
            }
            else {
                self.foundView.isHidden = true
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DislikeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLiked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewlike.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblname = cell.viewWithTag(102)as! UILabel
        let strName = arrLiked[indexPath.row].name
        let strImg = arrLiked[indexPath.row].source
        lblname.text = strName
        let img = cell.viewWithTag(101)as! UIImageView
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        url = URL(string: strImg)
        img.sd_setImage(with: url, completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let selectedUsername = arrLiked[indexPath.row].username
        if selectedUsername == username {
            currentTabBar?.setIndex(4)
        }
        else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "FriendsProfileViewController")as! FriendsProfileViewController
            obj.strUserName = selectedUsername
            loggdenUser.setValue(selectedUsername, forKey: UNAME)
           // self.navigationController?.pushViewController(obj, animated: true)
            self.modalPresentationStyle = .fullScreen
            //self.navigationController?.pushViewController(obj, animated: true)
            self.present(obj, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tblViewlike {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblViewlike.bounds.width, height: CGFloat(44))
                pageCount += 1
                print(pageCount)
                likelist(strPage: "\(pageCount)")
                self.tblViewlike.tableFooterView = spinner
                self.tblViewlike.tableFooterView?.isHidden = false
            }
        }
    }
}
