//
//  PreviewVC.swift
//  FriendzPoint
//
//  Created by Anques on 13/02/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import FSPagerView
import AVFoundation

class PreviewVC: UIViewController,ASAutoPlayVideoLayerContainer,UIScrollViewDelegate{

    @IBOutlet weak var imageviewBackground: UIImageView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var shotImageView: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
        }
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var countView: UIView!{
        didSet{
            countView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            countView.layer.cornerRadius = countView.frame.height/2
            countView.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblPageCount: UILabel!
    var images = [String]()
    
    var type = String()
    var source_url = String()
    var video_poster = String()
    
    //MARK: For Video Player
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        scrollView.removeFromSuperview()
//        imageview.removeFromSuperview()
//        navigationController?.setStatusBar(backgroundColor: .black)'
        modalPresentationCapturesStatusBarAppearance = false
        setStatusBar1(backgroundColor: .black)
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1

        scrollView.delegate = self
        scrollView.frame = CGRect(x: self.pagerView.frame.origin.x, y: self.pagerView.frame.origin.y, width: self.pagerView.frame.width, height: self.pagerView.frame.height)

        imageview.frame = CGRect(x: self.pagerView.frame.origin.x, y: self.pagerView.frame.origin.y, width: self.pagerView.frame.width, height: self.pagerView.frame.height)
        self.scrollView.addSubview(imageview)
        imageview.contentMode = .scaleAspectFit
        self.pagerView.addSubview(scrollView)
  
//        print("currentTabBar?.tabBarHeight: ß",currentTabBar?.tabBarHeight)
//        currentTabBar?.tabBarHeight = 0
//        currentTabBar?.setBar(hidden: true, animated: false)
//        currentTabBar?.hidesBottomBarWhenPushed = true
//        currentTabBar?.tabBarController?.tabBar.isHidden = true
//        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationBar.barStyle = .black
        
//        tabBarController?.tabBar.isHidden = true
        shotImageView.imageURL = nil
        videoLayer.frame = CGRect(x: 0, y: 0, width: shotImageView.frame.size.width, height: shotImageView.frame.size.height)

        shotImageView.layer.cornerRadius = 5
        shotImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        shotImageView.clipsToBounds = true
        shotImageView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        shotImageView.layer.borderWidth = 0.5
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        shotImageView.layer.addSublayer(videoLayer)
        blurImage(img: imageviewBackground)
        pagerView.addSubview(countView)
        pagerView.delegate = self
        pagerView.dataSource = self
        
        pagerView.addSubview(btnBack)
        pagerView.addSubview(imgLogo)
        
        setDefault()
        self.navigationController?.navigationBar.isHidden = true
        setStatusBar1(backgroundColor: .black)
    }
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
////        navigationController?.setStatusBar(backgroundColor: .black)
//            //Change status bar color
//        setStatusBar1(backgroundColor: .black)
//        navigationController?.setStatusBar(backgroundColor: .black)
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setNeedsStatusBarAppearanceUpdate()
//    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        .lightContent
//    }

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageview
    }
    

    func setDefault(){
        switch type {
        case "image":
//
//                cell.btnclick.isHidden = false
            countView.isHidden = true
//                cell.pagerView.isHidden = true
//                cell.pageControl.isHidden = true
            scrollView.isHidden = false
            imageview.isHidden = false
            imageviewBackground.isHidden = false
            shotImageView.isHidden = true
//                cell.btn_play.isHidden = true
//                cell.imageview.contentMode = .scaleAspectFit
           images = []
            pagerView.reloadData()

            
              imageviewBackground.kf.setImage(with: URL(string: source_url),placeholder:UIImage(named: "Placeholder"))
//                    blurImage(img: cell.imageviewBackground)
                
               imageview.kf.setImage(with: URL(string: source_url),placeholder:UIImage(named: "Placeholder"))
           
            
        
            break

        case "multi_image" :

            
          countView.isHidden = false
            scrollView.isHidden = true
//                cell.pageControl.isHidden = true
//                cell.pagerView.isHidden = false
           shotImageView.isHidden = true
          imageview.isHidden = true
           imageviewBackground.isHidden = true
//                cell.btn_play.isHidden = true
//                cell.countView.isHidden = false
//           images = arrFeed[indexPath.row].images
//                cell.pageControl.numberOfPages = arrFeed[indexPath.row].images.count
           lblPageCount.text = "1" + "/" + String(images.count)
//                cell.btnclick.isHidden = true
           pagerView.reloadData()
            break

        case "video":
           

            images = []
            pagerView.reloadData()
//                cell.btnclick.isHidden = false
//                cell.pagerView.isHidden = true
//                cell.pageControl.isHidden = true
            scrollView.isHidden = true
          imageview.isHidden = true
          imageviewBackground.isHidden = false
//                cell.btn_play.isHidden = false
        countView.isHidden = true
            shotImageView.isHidden = false
//                cell.imageview.contentMode = .scaleToFill
//                cell.imageview.layer.cornerRadius = 5
//                cell.imageview.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
//                cell.imageview.clipsToBounds = true
//                cell.imageview.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
//                cell.imageview.layer.borderWidth = 0.5
//                cell.videoLayer.backgroundColor = UIColor.black.cgColor
//                cell.videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                cell.imageview.layer.addSublayer(cell.videoLayer)
//                cell.selectionStyle = .none
            
         
               configureCell(imageUrl:video_poster, description: "Video", videoUrl:source_url)
            
            break
        default:
            break
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
    @IBAction func btnBackAction(_ sender: Any) {
       // self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension PreviewVC{
    //MARK: For Video
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
//        self.descriptionLabel.text = description
        self.shotImageView.imageURL = imageUrl
        self.videoURL = videoUrl
    }

    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.view?.superview?.convert(shotImageView.frame, from: shotImageView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = view?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
}

extension PreviewVC: FSPagerViewDataSource,FSPagerViewDelegate{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        //        cell.imageView?.image = UIImage(named: self.images[index])
        cell.imageView?.kf.setImage(with: URL(string: self.images[index]),placeholder:UIImage(named: "Placeholder"))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        //        cell.textLabel?.text = index.description+index.description
        return cell
    }
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        self.pageControl.currentPage = targetIndex
        lblPageCount.text = String(targetIndex+1) + "/" + String(images.count)
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
//        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    
    
}


extension UIViewController{
    func setStatusBar1(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
}
