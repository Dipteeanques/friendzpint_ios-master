//
//  BiodataViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 24/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class BiodataViewController: UIViewController {

    @IBOutlet weak var viewFooterAd: UIView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var tblBiodata: UITableView!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblStudy: UILabel!
    @IBOutlet weak var lbllocation: UILabel!
    @IBOutlet weak var lblRelation: UILabel!
    @IBOutlet weak var lblHobies: UILabel!
    @IBOutlet weak var lbleating: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblgmail: UILabel!
    
  
    var arrBio = NSMutableArray()
    var strUserName = String()
    var wc = Webservice.init()
    var decodedData = [Data]()
    var linkAD = String()
    var url: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       getProfileDetails()
        
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
                    viewFooterAd.height = 0
                }
            }
        }
    }
    
    func getProfileDetails() {
        strUserName = loggdenUser.value(forKey: USERNAME)as! String
            let parameters = ["username":strUserName]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                           "Accept" : ACCEPT,
                           "Authorization":BEARERTOKEN]
        wc.callSimplewebservice(url: MYPROFILEDETAILS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: MyprofileResponseModel?) in
            if sucess {
                print(response)
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
                    self.lblOwner.text = username
                }
                
                if gender?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "TagShape"),"username":gender!])
                    self.lblGender.text = gender
                }
                
                if hobbies?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "Business"),"username":hobbies!])
                    self.lblHobies.text = hobbies
                }
                
                if interests?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "Business"),"username":interests!])
                    self.lbleating.text = interests
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
                    self.lbldate.text = birthday
                }
                
                if designation?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "Business"),"username":designation!])
                    self.lblStudy.text = designation
                }
                
                if about?.count == 0 {
                    print("jekil")
                }
                else {
                    self.arrBio.add(["img":#imageLiteral(resourceName: "Business"),"username":about!])
                    self.lblgmail.text = about
                }
                self.tblBiodata.reloadData()
            }
        }
    }

    @IBAction func btnBannerAction(_ sender: UIButton) {
         UIApplication.shared.openURL(NSURL(string: linkAD)! as URL)
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


extension BiodataViewController: UITableViewDelegate,UITableViewDataSource {
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
