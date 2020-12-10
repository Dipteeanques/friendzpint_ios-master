//
//  YoutubeVideoPlaycell.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 20/08/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import ActiveLabel
import AVFoundation
import AVKit
import youtube_ios_player_helper_swift
import TTTAttributedLabel

class YoutubeVideoPlaycell: UITableViewCell {
   
    @IBOutlet weak var plyerviewTop: NSLayoutConstraint!
    @IBOutlet weak var lblTop: NSLayoutConstraint!
    @IBOutlet weak var btndislike: UIButton!
    @IBOutlet weak var btndislikeCount: UIButton!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnVideoprofile: UIButton!
    @IBOutlet weak var lblDesc: ActiveLabel!
    @IBOutlet weak var imgProfile: UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 25
            imgProfile.clipsToBounds = true
        }
    }
    @IBOutlet weak var btncommentcount: UIButton!
    @IBOutlet weak var btnLikeCount: UIButton!
    @IBOutlet var shotImageView: UIImageView!
    @IBOutlet weak var btnVideoMenu: UIButton!
    @IBOutlet weak var btnshareVideoCell: UIButton!
    @IBOutlet weak var btnCommentVideoCell: UIButton!
    @IBOutlet weak var btnLikeVideoCell: UIButton!
    @IBOutlet weak var btnmute: UIButton!
    @IBOutlet weak var lblTitle: TTTAttributedLabel!
    @IBOutlet weak var lblLocation: UILabel!
    

    var url: URL?
    var type = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playerView.delegate = self
         NotificationCenter.default.addObserver(self, selector: #selector(YoutubeVideoPlaycell.Videopause), name: NSNotification.Name(rawValue: "Videopause"), object: nil)
    }
    
    @objc func Videopause(_ notification: NSNotification) {
        playerView.stopVideo()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblDesc.text = nil
        lblLocation.text = nil
    }
    
//    "controls" : "0",
//    "showinfo" : "0",
//    "autoplay": "0",
//    "modestbranding": "0",
//    "iv_load_policy" : "3",
//    "fs": "0",
    
    func Youtube(youtube_id : String) {
        let playerVars = ["playsinline": 1, "autohide": 1, "showinfo": 0, "controls":1, "origin" : "http://youtube.com"] as [String : Any]
        print(youtube_id)
        let strVideoUrl: String = "https://www.youtube.com/watch?v=\(youtube_id)"
        let strYoutubeKey = extractYoutubeIdFromLink(link: strVideoUrl)
        _ = playerView.load(videoId: strYoutubeKey!, playerVars: playerVars)
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func extractYoutubeIdFromLink(link: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
    
    var arrYoutube: MyTimelineList? {
        didSet {
            
            //MARK: - Profile
            let avatar = arrYoutube!.users_avatar
            url = URL(string: avatar)
            imgProfile.sd_setImage(with: url, completed: nil)
            
            //MARK: - youtubeShow
            let youtube_video_id = arrYoutube!.youtube_video_id
            Youtube(youtube_id : youtube_video_id)
            
            //MARK: - Description
            let strdescription = arrYoutube!.description
            if strdescription.count == 0 {
                lblTop.constant = 0
                plyerviewTop.constant = 0
            }
            else {
                lblTop.constant = 8
                plyerviewTop.constant = 8
                lblDesc.text = strdescription.decodeEmoji
                lblDesc.enabledTypes = [.mention, .hashtag, .url]
                lblDesc.hashtagColor = .black
                lblDesc.hashtagSelectedColor = .blue
            }
            
            //MARK: - like
            let is_liked = arrYoutube!.is_liked
            if is_liked == 1 {
                btnLikeVideoCell.isSelected = true
            }
            else {
                btnLikeVideoCell.isSelected = false
            }
            
            //MARK: - Dislike
            let is_disliked = arrYoutube!.is_disliked
            if is_disliked == 1 {
                btndislike.isSelected = true
            }
            else {
                btndislike.isSelected = false
            }
            
            //MARK: - Location
            let strLocation = arrYoutube!.location
            if strLocation.count == 0 {
            }
            else {
                lblLocation.text = "at " + strLocation
            }
            
            //MARK: - LikeCount
            let totalLike = arrYoutube!.users_liked_count
            let strLikeTotal = String(totalLike) + " Like"
            btnLikeCount.setTitle(strLikeTotal, for: .normal)
            
            //MARK: - DislikeCount
            let totaldislike = arrYoutube!.users_disliked_count
            let strDislikeTotal = String(totaldislike) + " Dislike"
            btndislikeCount.setTitle(strDislikeTotal, for: .normal)
            
            //MARK: - CommentCount
            let totalComment = arrYoutube!.comments_count
            let strCommentTotal = String(totalComment) + " Comment"
            btncommentcount.setTitle(strCommentTotal, for: .normal)
            
            //MARK: - Date
            let postDate = arrYoutube!.created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            lblTime.text = datavala
        }
    }
    
    
}

extension YoutubeVideoPlaycell: YTPlayerViewDelegate{
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        //  print(state)
    }
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        //  print(playTime)
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        // print(playerView)
    }
}


