//
//  PhotosAlbumViewcontroller.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 06/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class PhotosAlbumViewcontroller: UIViewController {

    @IBOutlet weak var albumCollection: UICollectionView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var foundView: Foundview!
    
    var strUsername = String()
    var wc = Webservice.init()
    var arrAlbum = [albumlistModel]()
    var url: URL?
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

          NotificationCenter.default.addObserver(self, selector: #selector(PhotosAlbumViewcontroller.Photos), name: NSNotification.Name(rawValue: "Photos"), object: nil)
        getAlbum()
    }
    
    @objc func Photos(_ notification: NSNotification) {
        loaderView.isHidden = false
        activity.startAnimating()
        getAlbum()
    }
    
    
    func getAlbum() {
            strUsername = loggdenUser.value(forKey: USERNAME)as! String
            let parameters = ["username":strUsername]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            
            wc.callSimplewebservice(url: ALBUM_MYALBUMLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: albumResponListModel?) in
                if sucess {
                    let res = response?.success
                    if res! {
                        let data = response?.data
                        let arr_dict  = data?.data
                        self.arrAlbum = arr_dict!
                        self.albumCollection.reloadData()
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrAlbum.count == 0 {
                            self.foundView.isHidden = false
                        }
                        else {
                            self.foundView.isHidden = true
                        }
                    }
                }
            }
        }
    
//    func getAlbumlist(strPage: String) {
//        strUsername = loggdenUser.value(forKey: USERNAME)as! String
//        let parameters = ["username":strUsername,
//                          "page" : strPage]
//        let token = loggdenUser.value(forKey: TOKEN)as! String
//        let BEARERTOKEN = BEARER + token
//        let headers: HTTPHeaders = ["Xapi": XAPI,
//                                    "Accept" : ACCEPT,
//                                    "Authorization":BEARERTOKEN]
//
//        wc.callSimplewebservice(url: ALBUM_MYALBUMLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: albumResponListModel?) in
//            if sucess {
//                let res = response?.success
//                if res! {
//                    let data = response?.data
//                    let arr_dict  = data?.data
//                    for i in 0..<arr_dict!.count
//                    {
//                        self.arrAlbum.insert(arr_dict![i], at: 0)
//                        self.albumCollection.reloadData()
//                        self.loaderView.isHidden = true
//                        self.activity.stopAnimating()
//                        if self.arrAlbum.count == 0 {
//                            self.foundView.isHidden = false
//                        }
//                        else {
//                            self.foundView.isHidden = true
//                        }
//                    }
//                }
//            }
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnFlottingAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreateAlbumViewcontroller")as! CreateAlbumViewcontroller
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

extension PhotosAlbumViewcontroller: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = albumCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(101)as! UIImageView
        let lbltitle = cell.viewWithTag(102)as! UILabel
        let lblname = cell.viewWithTag(103)as! UILabel
        let lblDate = cell.viewWithTag(104)as! UILabel
        let strimg = arrAlbum[indexPath.row].avatar_img
        url = URL(string: strimg)
        img.sd_setImage(with: url, completed: nil)
        lbltitle.text = arrAlbum[indexPath.row].name
        lblname.text = arrAlbum[indexPath.row].slug
        let strdate = arrAlbum[indexPath.row].created_at
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: strdate)!
        let dateset = date.getFormattedDate(string: strdate, formatter: "yyyy-MM-dd HH:mm:ss")
        lblDate.text = dateset
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8
        let collectionViewSize = albumCollection.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "userImageListController")as! userImageListController
        obj.Album_id = arrAlbum[indexPath.row].id
        obj.titleName = arrAlbum[indexPath.row].name
        self.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(obj, animated: true)
        self.present(obj, animated: false, completion: nil)
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//        if scrollView == albumCollection {
//            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
//            {
//                spinner = UIActivityIndicatorView(style: .gray)
//                spinner.startAnimating()
//                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: albumCollection.bounds.width, height: CGFloat(44))
//                pageCount += 1
//                print(pageCount)
//                getFeed(strPage: "\(pageCount)")
//                self.albumCollection.tableFooterView = spinner
//                self.albumCollection.tableFooterView?.isHidden = false
//            }
//        }
//    }
}

extension Date {
     func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let date: Date? = dateFormatterGet.date(from: "2018-02-01T19:10:04+00:00")
        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!);
    }
}
