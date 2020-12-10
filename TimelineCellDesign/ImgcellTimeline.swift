//
//  ImgcellTimeline.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 26/07/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import ActiveLabel
import TTTAttributedLabel

class ImgcellTimeline: UITableViewCell {

    @IBOutlet weak var imgtopconstraint: NSLayoutConstraint!
    @IBOutlet weak var lbltop: NSLayoutConstraint!
    @IBOutlet weak var btnProImgClick: UIButton!
    @IBOutlet weak var dislike: UIButton!
    @IBOutlet weak var dislikeCount: UIButton!
    @IBOutlet weak var imageProfile: UIImageView! {
        didSet {
            imageProfile.layer.cornerRadius = 25
            imageProfile.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lblDetails: ActiveLabel!
    @IBOutlet weak var btnSingaleImg: UIButton!
    @IBOutlet weak var imgpostHeight: NSLayoutConstraint!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnImgLike: UIButton!
    @IBOutlet weak var btnSingaleImageMenu: UIButton!
    @IBOutlet weak var btnpostComment: UIButton!
    @IBOutlet weak var btnLikeImgCell: UIButton!
    @IBOutlet weak var btnShareimgCell: UIButton!
    @IBOutlet weak var lblSingaleImgDate: UILabel!
    @IBOutlet weak var lblSingaleTitle: TTTAttributedLabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    
    var url: URL?
    var rowHeights:[Int:CGFloat] = [:]
    var arrImages = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // imgPost.translatesAutoresizingMaskIntoConstraints = false
       // lblSingaleTitle.font = UIFont.systemFont(ofSize: 15)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    internal var aspectConstraint : NSLayoutConstraint? {
//        didSet {
//            if oldValue != nil {
//                imgPost.removeConstraint(oldValue!)
//            }
//            if aspectConstraint != nil {
//                aspectConstraint?.priority = UILayoutPriority(999)
//                imgPost.addConstraint(aspectConstraint!)
//            }
//        }
//    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
       // aspectConstraint = nil
        lblDetails.text = nil
        lblLocation.text = nil
        //imgPost.image = nil
        imgPost.image = UIImage(named: "Placeholder")
        imgpostHeight.constant = 333
    }
    
    func setImagestring(strImg: String){
        let cellFrame = contentView.frame.size
        url = URL(string: strImg)
        imgPost.sd_setImage(with: url, placeholderImage: nil, options: [], completed: { (theImage, error, cache, url) in
            self.imgpostHeight.constant = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
        })
    }
    
//    func setCustomImage(image : UIImage) {
//        let aspect = image.size.width / image.size.height
//        let constraint = NSLayoutConstraint(item: imgPost!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imgPost, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0.0)
//        constraint.priority = UILayoutPriority(rawValue: 999)
//        aspectConstraint = constraint
//        imgPost.image = image
//    }
    
    
    func getAspectRatioAccordingToiPhones(cellImageFrame:CGSize,downloadedImage: UIImage)->CGFloat {
        let widthOffset = downloadedImage.size.width - cellImageFrame.width
        let widthOffsetPercentage = (widthOffset*100)/downloadedImage.size.width
        let heightOffset = (widthOffsetPercentage * downloadedImage.size.height)/100
        let effectiveHeight = downloadedImage.size.height - heightOffset
        return(effectiveHeight)
    }
    // MARK: Optional function for resize of image
    func resizeHighImage(image:UIImage)->UIImage {
        let size = image.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    var arrSingaleImage: MyTimelineList? {
        didSet {
            //MARK: - Profile
            let avatar = arrSingaleImage!.users_avatar
            url = URL(string: avatar)
            imageProfile.sd_setImage(with: url, completed: nil)
            
//            //MARK: - ImagePost
//            arrImages = arrSingaleImage!.images
//            for item in arrImages {
//            let source_url = item
//                setImagestring(strImg: source_url)
//            }
            
            //MARK: - Like
            let is_liked = arrSingaleImage!.is_liked
            if is_liked == 1 {
               btnLikeImgCell.isSelected = true
            }
            else {
               btnLikeImgCell.isSelected = false
            }
            
            //MARK: - Dislike
            let is_disliked = arrSingaleImage!.is_disliked
            if is_disliked == 1 {
                dislike.isSelected = true
            }
            else {
                dislike.isSelected = false
            }
            
            //MARK: - Location
            let strLocation = arrSingaleImage!.location
            if strLocation == "" {
            }
            else {
                lblLocation.text = "at " + strLocation
            }
            
            //MARK: - Date
            let postDate = arrSingaleImage!.created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            lblSingaleImgDate.text = datavala
            
            //MARK: - LikeCount
            let totalLike = arrSingaleImage!.users_liked_count
            let strLikeTotal = String(totalLike) + " Like"
            btnImgLike.setTitle(strLikeTotal, for: .normal)
            
            //MARK: - DislikeCount
            let totaldislike = arrSingaleImage!.users_disliked_count
            let strDislikeTotal = String(totaldislike) + " Dislike"
            dislikeCount.setTitle(strDislikeTotal, for: .normal)
            
            //MARK: - CommentCount
            let totalComment = arrSingaleImage!.comments_count
            let strCommentTotal = String(totalComment) + " Comment"
            btnComment.setTitle(strCommentTotal, for: .normal)
            
            //MARK: - Description
            let strdescription = arrSingaleImage!.description
            if strdescription.count == 0 {
                lbltop.constant = 0
                imgtopconstraint.constant = 0
            }
            else {
                lbltop.constant = 8
                imgtopconstraint.constant = 8
                lblDetails.text = strdescription.decodeEmoji
                lblDetails.enabledTypes = [.mention, .hashtag, .url]
                lblDetails.hashtagColor = .black
                lblDetails.hashtagSelectedColor = .blue
            }
        }
    }
}
