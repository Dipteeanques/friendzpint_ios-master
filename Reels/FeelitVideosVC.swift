//
//  FeelitVideosVC.swift
//  FriendzPoint
//
//  Created by Anques on 24/06/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class FeelitVideosVC: UIViewController {

    @IBOutlet weak var btnVideos: UIButton!{
        didSet{
            btnVideos.layer.cornerRadius = 5.0
            btnVideos.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnDrafts: UIButton!{
        didSet{
            btnDrafts.layer.cornerRadius = 5.0
            btnDrafts.clipsToBounds = true
        }
    }
    @IBOutlet weak var CollectionReels: UICollectionView!
    
    @IBOutlet weak var btnVideosHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnDraftHeight: NSLayoutConstraint!
    
    var FlagReel = 0
    var wc = Webservice.init()
    var videosMainArr : ReelsShowRelatedVideosResponseModel?
    
    @IBOutlet weak var btnDraftWidth: NSLayoutConstraint!
    var arrDraftFeelit = [String]()
    
    var noDataLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: Draft) != nil{
            self.arrDraftFeelit = UserDefaults.standard.value(forKey: Draft) as! [String]
//            self.noDataLabel.isHidden = false
            print("arrDraftFeelit: ",self.arrDraftFeelit)
        }
        else{
            self.noDataLabel.isHidden = true
            NoData()
            
        }

        let user_id = UserDefaults.standard.value(forKey: "TimeLine_id")
    
     print("Fuser_id: ",Fuser_id)
     let struser = String(describing: user_id) 
     print("userIDMAIN: ",user_id)
     if (Int(struser) == Int(Fuser_id)){
          btnDrafts.isHidden = false
          btnVideos.isHidden = false
          btnDraftHeight.constant = 40
          btnVideosHeight.constant = 40
     }
     else{
//          btnDraftWidth.constant = 0
          btnDrafts.isHidden = true
          btnVideos.isHidden = true
          btnDraftHeight.constant = 0
          btnVideosHeight.constant = 0
          
     }
        
        GetReels(user_id: Fuser_id, starting_point: 0)
      
    
     
     
     
    }
     
     func getCacheDirectoryPath() -> URL {
          let arrayPaths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
          let cacheDirectoryPath = arrayPaths[0]
          return cacheDirectoryPath
     }
     
    
    func NoData(){
        noDataLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: CollectionReels.bounds.size.width, height: CollectionReels.bounds.size.height))
        noDataLabel.text          = "No Data Found"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        CollectionReels.backgroundView  = noDataLabel
//        CollectionReels.separatorStyle  = .none
    }

    func GetReels(user_id: String,starting_point: Int){
    
        let parameters = ["device_id": "0",
                          "starting_point":starting_point,
                          "user_id":user_id ] as [String : Any]
        print("parameters: ",parameters)
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        print("headers: ",headers)
        print("SHOWRELATEDVIDEOS: ",SHOWRELATEDVIDEOS)
        wc.callSimplewebservice(url: SHOWRELATEDVIDEOS, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: ReelsShowRelatedVideosResponseModel?) in
            print("response:",response?.code)
            print(response)
            if sucess {
                
                //                self.transparentView.backgroundColor = .clear//UIColor.black.withAlphaComponent(0.5)
                //                self.imgLogo.isHidden = false
                let sucessMy = response?.code
                if sucessMy == 200{
                    self.noDataLabel.isHidden = true
                    print("hello success..",self.videosMainArr?.msg.count)
                    if self.videosMainArr?.msg.count == 0 || self.videosMainArr?.msg.count == nil{
                        self.videosMainArr = response
                        self.CollectionReels.reloadData()
                    }
                    else{
                        if self.FlagReel == 1{
                            if (self.videosMainArr?.msg.count)! > 0{
                                self.videosMainArr?.msg.append(contentsOf: response!.msg)
                                
                              
                            }
                            self.FlagReel = 0
                            self.CollectionReels.reloadData()
                        }
                    }
                    
                    
                }
                else {
                    self.NoData()
                    self.noDataLabel.isHidden = false
                }
            }
            else {
                print(response)
                self.NoData()
                self.noDataLabel.isHidden = false
            }
        }
        
    }
    
    @IBAction func btnVideosAction(_ sender: Any) {
        FlagReel = 0
        CollectionReels.reloadData()
        btnVideos.backgroundColor = UIColor(red: 0.12, green: 0.64, blue: 1.00, alpha: 1.00)
        btnDrafts.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        btnVideos.setTitleColor(UIColor.white, for: .normal)
        btnDrafts.setTitleColor(UIColor.gray, for: .normal)
    }
    
    @IBAction func btnDraftsAction(_ sender: Any) {
        FlagReel = 1
        CollectionReels.reloadData()
        btnDrafts.backgroundColor = UIColor(red: 0.12, green: 0.64, blue: 1.00, alpha: 1.00)
        btnVideos.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        btnVideos.setTitleColor(UIColor.gray, for: .normal)
        btnDrafts.setTitleColor(UIColor.white, for: .normal)
    }
    
}

extension FeelitVideosVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if FlagReel == 0{
            return self.videosMainArr?.msg.count ?? 0
        }
        else{
            return arrDraftFeelit.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeelitVideoCell
        
        if FlagReel == 0{
            
            let vidObj = self.videosMainArr?.msg[indexPath.row].Video
          print("FeelitThum: ",vidObj?.thum ?? "")
            cell.imgReels.sd_setImage(with: URL(string: vidObj?.thum ?? ""), placeholderImage: UIImage(named: "Placeholder"), options: [], completed: nil)//sd_setImage(with: URL(string: vidObj?.thum ?? ""), ,completed: nil)
            
            cell.btnTitle.setTitle(vidObj?.like_count.description, for: .normal)
            cell.btnTitle.setImage(UIImage(named: "eyewhite"))
        }
        else{
            print("Thumb: ",self.arrDraftFeelit[indexPath.row])
          
          let Caches = getCacheDirectoryPath()
          print("Caches: ",Caches)
          
          cell.imgReels.image = OptiVideoEditor().generateThumbnail(path: URL(string: Caches.description + arrDraftFeelit[indexPath.row])!)
            cell.btnTitle.setTitle("Draft", for: .normal)
            cell.btnTitle.setImage(nil)
//

        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let yourWidth = ((collectionView.bounds.width/3.0) - 2)
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
}



var Fuser_id = ""
var CheckTab = 0
