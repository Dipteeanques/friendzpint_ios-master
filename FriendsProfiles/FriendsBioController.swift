//
//  BiodataViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 24/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class FriendsBioController: UIViewController {
    
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var viewFooterBanner: UIView!
    @IBOutlet weak var tblBiodata: UITableView!
    @IBAction func btnBannerClickAction(_ sender: UIButton) {
         UIApplication.shared.openURL(NSURL(string: linkAD)! as URL)
    }
    
    var strUserName = String()
    var arrBio = NSMutableArray()
    var wc = Webservice.init()
    var decodedData = [Data]()
    var linkAD = String()
    var url: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(FriendsBioController.FriendsView), name: NSNotification.Name(rawValue: "FriendsView"), object: nil)
       
        if (loggdenUser.value(forKey: ADbio) != nil) {
            decodedData = loggdenUser.value(forKey: ADbio) as! [Data]
            for i in 0..<decodedData.count
            {
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode(adsData.self, from: decodedData[i])
                let strImage = decoded?.image
                linkAD = decoded!.link
                let active = decoded?.active
                if active == 1 {
                    url = URL(string: strImage!)
                    imgBanner.sd_setImage(with: url, completed: nil)
                }
                else {
                    viewFooterBanner.height = 0
                }
            }
        }
    }
    
    @objc func FriendsView(_ notification: NSNotification) {
        strUserName = notification.object as! String
        getProfileDetails()
    }
    
   
    func getProfileDetails() {
        let parameters = ["username":strUserName]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: MYPROFILEDETAILS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: MyprofileResponseModel?) in
            if sucess {
                let dic = response?.data
                let username = dic?.username
                let gender = dic?.gender
                let hobbies = dic?.hobbies
                let interests = dic?.interests
                let city = dic?.city
                let country = dic?.country
                let birthday = dic?.birthday
                let designation = dic?.designation
                let about = dic?.about
                
                if username?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "Business"),"username":username!])
                }
                
                if gender?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "TagShape"),"username":gender!])
                }
                
                if hobbies?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "Business"),"username":hobbies!])
                }
                
                if interests?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "Business"),"username":interests!])
                }
                
                if city?.count == 0 {
                    print("jekil")
                }
                else {
                    let location = city! + "," + country!
                    self.arrBio.add(["img":#imageLiteral(resourceName: "Earth"),"username":location])
                }
                
                if birthday?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "Business"),"username":birthday!])
                }
                
                if designation?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "Business"),"username":designation!])
                }
                
                if about?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "Business"),"username":about!])
                }
                self.tblBiodata.reloadData()
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
    
}

extension FriendsBioController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblBiodata.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblname = cell.viewWithTag(102)as! UILabel
        let Img = cell.viewWithTag(101)as! UIImageView
        Img.image = (self.arrBio[indexPath.row]as! AnyObject).value(forKey: "img") as! UIImage
        lblname.text = (self.arrBio[indexPath.row]as! AnyObject).value(forKey: "username") as! String
        return cell
    }
    
    
}
