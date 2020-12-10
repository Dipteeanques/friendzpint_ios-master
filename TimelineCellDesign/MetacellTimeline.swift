//
//  MetacellTimeline.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 27/07/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import ActiveLabel

class MetacellTimeline: UITableViewCell {

    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var lbltop: NSLayoutConstraint!
    @IBOutlet weak var lblDescription: ActiveLabel!
    @IBOutlet weak var imgMeta: UIImageView!
    @IBOutlet weak var btndislike: UIButton!
    @IBOutlet weak var btndislikeCount: UIButton!
    @IBOutlet weak var btnMetaProfile: UIButton!
    @IBOutlet weak var lblDescMeta: UILabel!
    @IBOutlet weak var lblMetaTitle: UILabel!
    @IBOutlet weak var btnCommentCount: UIButton!
    @IBOutlet weak var viewMeta: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet {
            imgProfile.layer.cornerRadius = 25
            imgProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnMetaMenu: UIButton!
    @IBOutlet weak var btnShareMetaCell: UIButton!
    @IBOutlet weak var btnCommentMetaCell: UIButton!
    @IBOutlet weak var btnLikeMetaCell: UIButton!
    @IBOutlet weak var btnMetaClick: UIButton!
    @IBOutlet weak var lblTitle: TTTAttributedLabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblDescription.text = nil
        lblLocation.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var url: URL?
    var arrMeta: MyTimelineList? {
        didSet {
            
            //MARK: - Profile
            let avatar = arrMeta!.users_avatar
            url = URL(string: avatar)
            imgProfile.sd_setImage(with: url, completed: nil)
            
           //MARK: - Like
           let is_liked = arrMeta!.is_liked
           if is_liked == 1 {
               btnLikeMetaCell.isSelected = true
           }
           else {
               btnLikeMetaCell.isSelected = false
           }
            
            //MARK: - Dislike
            let is_disliked = arrMeta!.is_disliked
            if is_disliked == 1 {
                btndislike.isSelected = true
            }
            else {
                btndislike.isSelected = false
            }
            
            //MARK: - Location
            let strLocation = arrMeta!.location
            if strLocation.count == 0 {
            }
            else {
                lblLocation.text = "at " + strLocation
            }
            
            //MARK: - LikeCount
            let totalLike = arrMeta!.users_liked_count
            let strLikeTotal = String(totalLike) + " Like"
            btnLikeCount.setTitle(strLikeTotal, for: .normal)
            
            //MARK: - DislikeCount
            let totaldislike = arrMeta!.users_disliked_count
            let strDislikeTotal = String(totaldislike) + " Dislike"
            btndislikeCount.setTitle(strDislikeTotal, for: .normal)
            
            //MARK: - CommentCount
            let totalComment = arrMeta!.comments_count
            let strCommentTotal = String(totalComment) + " Comment"
            btnCommentCount.setTitle(strCommentTotal, for: .normal)
            
            //MARK: - Date
            let postDate = arrMeta!.created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            lblTime.text = datavala
            
            //MARK: - Description
            let Metas = arrMeta!.description
            if let url = URL(string: Metas) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                url.fetchPageInfo({ (title, description, previewImage) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                               
                if description == nil {
                    self.lblDescMeta.isHidden = true
                }
                else {
                    self.lblDescMeta.isHidden = false
                    self.lblDescMeta.text = description
                }
                               
                if title == nil {
                    self.lblMetaTitle.isHidden = true
                }
                else {
                    self.lblMetaTitle.isHidden = false
                    self.lblMetaTitle.text = title
                }
                               
                if let imageUrl = previewImage {
                    self.downloadImage(URL(string: imageUrl)!, imageView: self.imgMeta)
                }
                               
                }, failure: { (errorMessage) -> Void in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    print(errorMessage)
                    })
                } 
        }
    }
    
    //MARK: ______________ Meats Data
    
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error)
        }).resume()
    }
    
    func downloadImage(_ url: URL, imageView: UIImageView){
        //print("Download Started")
        //print("lastPathComponent: " + url.lastPathComponent)
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async(execute: {
                guard let data = data , error == nil else { return }
                //print(response?.suggestedFilename ?? "")
               // print("Download Finished")
                imageView.image = UIImage(data: data)
            })
        }
    }
    
    
    
}
