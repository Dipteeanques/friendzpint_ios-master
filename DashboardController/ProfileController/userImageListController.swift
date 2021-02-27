//
//  userImageListController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 06/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class userImageListController: UIViewController {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var collectionImage: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    var Album_id = Int()
    var arrImage = [imagelist]()
    var url: URL?
    var wc = Webservice.init()
    var selected = Int()
    var arrselected = [imagelist]()
    var selectedMedia = [String]()
    var titleName = String()
    var friendsAlbum = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionImage.allowsMultipleSelection = true
        loaderView.isHidden = false
        activity.startAnimating()
        setDeafult()
    }
    
    func setDeafult() {
        getPhotos()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.headerView.bounds
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerView.layer.addSublayer(gradientLayer)
        headerView.addSubview(btnBack)
        headerView.addSubview(lblTitle)
        headerView.addSubview(btnDelete)
        headerView.addSubview(btnEdit)
        lblTitle.text = titleName
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
        }
        if friendsAlbum == "friendsAlbum" {
            btnEdit.isHidden = true
            btnDelete.isHidden = true
        }
        else {
            btnEdit.isHidden = false
            btnDelete.isHidden = false
        }
    }

    func getPhotos() {
        let parameters = ["id":Album_id]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: ALBUM_MYALBUMDETAILS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: allImageresponseModel?) in
            if sucess {
                let res = response?.success
                if res! {
                    let data = response?.data
                    self.arrImage = data!.data
                    self.collectionImage.reloadData()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
            }
        }
    }
    
    
    func deleteAlbum() {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        let parameters = ["username": username,
                          "id":Album_id] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: ALBUM_DELETE, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: albumdeleteResponsemodel?) in
            if sucess {
                let res = response?.success
                if res! {
                     self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Photos"), object: nil)
                }
            }
        }
    }
    
    func deletePhoto() {
        for i in 0..<arrselected.count
        {
            let media_id = arrselected[i].media_id
            let strMedia = String(media_id)
            selectedMedia.append(strMedia)
        }
        let strPhoto_id = selectedMedia.joined(separator: ",")
        let parameters = ["photos_ids": strPhoto_id]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]

        wc.callSimplewebservice(url: ALBUM_DELETE_PHOTOS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: PhotosDeleteResponsModel?) in
            if sucess {
                let res = response?.success
                if res! {
                    self.getPhotos()
                }
            }
        }
    }
    @IBAction func btnEditAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreateAlbumViewcontroller")as! CreateAlbumViewcontroller
        obj.Album_id = Album_id
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        if arrselected.count == 0 {
            deleteAlbum()
        }
        else {
           deletePhoto()
        }
    }
    
    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

extension userImageListController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionImage.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(101)as! UIImageView
        let btnRound = cell.viewWithTag(102)as! UIButton
        if friendsAlbum == "friendsAlbum" {
            btnRound.isHidden = true
        }
        else {
            btnRound.isHidden = false
            btnRound.setImage(#imageLiteral(resourceName: "whiteRound"), for: UIControl.State.normal)
        }
        let strimage = arrImage[indexPath.row].avatar_img
        url = URL(string: strimage)
        img.sd_setImage(with: url, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.row
        if friendsAlbum == "friendsAlbum" {
            print("jekil")
        }
        else {
            let cell = collectionImage.cellForItem(at: indexPath)
            let btnRound = cell!.viewWithTag(102)as! UIButton
            btnRound.setImage(#imageLiteral(resourceName: "blueCheck"), for: UIControl.State.normal)
            arrselected.append(arrImage[indexPath.row])
            print(arrselected)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if friendsAlbum == "friendsAlbum" {
            print("jekil")
        }
        else {
            let cell = collectionImage.cellForItem(at: indexPath)
            let btnRound = cell!.viewWithTag(102)as! UIButton
            btnRound.setImage(#imageLiteral(resourceName: "whiteRound"), for: UIControl.State.normal)
            let media_id = arrImage[indexPath.item].media_id
            var deselectedIndex = Int()
            for (index,value) in arrselected.enumerated()
            {
                if value.media_id == media_id {
                    deselectedIndex = index
                }
            }
            arrselected.remove(at: deselectedIndex)
            print(arrselected)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 1
        let collectionViewSize = collectionImage.frame.size.width - padding
        return CGSize(width: collectionViewSize/3, height: 125)
    }
}
