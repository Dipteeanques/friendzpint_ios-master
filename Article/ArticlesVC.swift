//
//  ArticlesVC.swift
//  FriendzPoint
//
//  Created by Anques on 26/05/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire
import AJMessage

class ArticlesVC: UIViewController,UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
   
    @IBOutlet weak var btnBack: UIButton!
    
    
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticlesVC")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }

    @IBOutlet weak var btnCreate: UIButton!{
        didSet{
            btnCreate.layer.cornerRadius = btnCreate.frame.height/2
            btnCreate.clipsToBounds = true
        }
    }
    var wc = Webservice.init()
    var arrArticle = [ArticleListMaindata]()
    var myarrArticle = [MyArticleDatamain]()
    var  post_Id = Int()
    var pageCount = 1
    var noDataLabel = UILabel()
    var Flag = ""
    var CheckVC = ""
    var refreshControl = UIRefreshControl()
    var spinner = UIActivityIndicatorView()
    
    @IBOutlet weak var mainTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        currentTabBar?.setBar(hidden: false, animated: false)
        mainTableView.isPagingEnabled = true
        mainTableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "cell")
        
//        navigationController?.setStatusBar(backgroundColor: .black)
          mainTableView.translatesAutoresizingMaskIntoConstraints = false
          mainTableView.isPagingEnabled = true
          mainTableView.contentInsetAdjustmentBehavior = .never
          mainTableView.showsVerticalScrollIndicator = false
          mainTableView.prefetchDataSource = self
          mainTableView.snp.makeConstraints({ make in
              make.edges.equalTo(self.view)//equalToSuperview()
          })
          
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeRight.direction = .left
            self.mainTableView.addGestureRecognizer(swipeRight)

        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        mainTableView.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(sender:)), name: Notification.Name("MYNoti"), object: nil)
       
        if CheckVC == "MY"{
            btnBack.isHidden = false
            GetMyArticleList(page: 1)
            
        }
        else{
            btnBack.isHidden = true
            GetArticleList(page: 1)
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func refresh(sender:AnyObject) {
        if CheckVC == "MY"{
            GetMyArticleList(page: 1)
        }
        else{
            GetArticleList(page: 1)
        }
    }
    
    
    @IBAction func btnCreateAction(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreateArticlesVC")as! CreateArticlesVC
        obj.modalPresentationStyle = .overFullScreen
        self.present(obj, animated: false, completion: nil)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if gesture is UISwipeGestureRecognizer {
           
            let location = gesture.location(in: mainTableView)
            let swipedIndexPath = mainTableView.indexPathForRow(at: location)
            var swipedCell: UITableViewCell? = nil
            if let swipedIndexPath = swipedIndexPath {
                print("swipedIndexPath: ",swipedIndexPath.row)
                swipedCell = mainTableView.cellForRow(at: swipedIndexPath)
//                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ArticleWebViewVC")as! ArticleWebViewVC
//                obj.strURl = self.arrArticle[swipedIndexPath.row].article_web_link
////                self.navigationController?.pushViewController(obj, animated: false)
//                obj.modalPresentationStyle = .fullScreen
//                self.present(obj, animated: false, completion: nil)
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "ArticleWebViewVC")as! ArticleWebViewVC
                obj.strTitle = self.arrArticle[swipedIndexPath.row].title
                if self.arrArticle[swipedIndexPath.row].video_link == ""{
                    obj.strURl = self.arrArticle[swipedIndexPath.row].link
                }
                else{
                    obj.strURl = self.arrArticle[swipedIndexPath.row].video_link
                }
                obj.modalPresentationStyle = .overFullScreen
                self.present(obj, animated: false, completion: nil)
            }
//            switch swipeGesture.direction {
//            case .right:
//                print("Swiped right")
//            case .down:
//                print("Swiped down")
//            case .left:
//                print("Swiped left")
//            case .up:
//                print("Swiped up")
//            default:
//                break
//            }
        }
    }
  
    
    @IBAction func btnEditAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreateArticlesVC")as! CreateArticlesVC
        let data = self.myarrArticle[sender.tag]
        obj.article_id = data.id
        obj.strtype = data.type
        obj.strtitle = data.title
        obj.strlink = data.link
        obj.strvideo_link = data.video_link
        obj.strtag = data.tag
        obj.Description = data.description
        obj.strimage = data.articleimages.full_url
        obj.CHECK = "Edit"
        obj.modalPresentationStyle = .overFullScreen
        self.present(obj, animated: false, completion: nil)
    }
    
    @IBAction func btnShareAction(_ sender: UIButton) {
        
        
        if CheckVC == "MY"{
            if let indexPath = self.mainTableView.indexPathForView(sender) {
                self.post_Id = self.myarrArticle[sender.tag].id
                let parameters = ["article_id":self.post_Id] as [String : Any]
                self.myarrArticle.remove(at: sender.tag)
                self.mainTableView.deleteRows(at: [indexPath], with: .fade)
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept" : ACCEPT,
                                            "Authorization":BEARERTOKEN]
                self.wc.callSimplewebservice(url: DELETEARTICLE, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ArticleLikeModel?) in
                    if sucess {
                        let suc = response?.success
                        let message = response?.message
                        if suc == true {
                            self.mainTableView.beginUpdates()
                            self.mainTableView.endUpdates()
                            AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                print("did dissmiss")
                            }
                            
                            if self.myarrArticle.count == 0{
                                self.noDataLabel.isHidden = false
                                self.NoData()
                            }
                        }
                        else {
                            self.mainTableView.beginUpdates()
                            self.mainTableView.endUpdates()
                            if self.myarrArticle.count == 0{
                                self.noDataLabel.isHidden = false
                                self.NoData()
                            }
                            AJMessage.show(title: "FriendzPoint", message: message!,position:.top).onHide {_ in
                                print("did dissmiss")
                            }
                        }
                    }
                }
            }
        }
        else{
            if let indexPath = self.mainTableView.indexPathForView(sender) {
                //            let cellfeed = mainTableView.cellForRow(at: indexPath) as! HomeVCCell
                //            post_Id = arrFeed[indexPath.row].id
                var text = String()
                
                if CheckVC == "MY"{
                    text = myarrArticle[indexPath.row].article_web_link
                }
                else{
                    text = arrArticle[indexPath.row].article_web_link
                }
                 ///"This is some text that I want to share."
                
                // set up activity view controller
                let textToShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
                }
        }
        

        
    }
    
    @IBAction func btnLinkAction(_ sender: UIButton) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ArticleWebViewVC")as! ArticleWebViewVC
        
        if CheckVC == "MY"{
            obj.strTitle = self.myarrArticle[sender.tag].title
            if self.myarrArticle[sender.tag].video_link == ""{
                obj.strURl = self.myarrArticle[sender.tag].link
            }
            else{
                obj.strURl = self.myarrArticle[sender.tag].video_link
            }
        }
        else{
            obj.strTitle = self.arrArticle[sender.tag].title
            if self.arrArticle[sender.tag].video_link == ""{
                obj.strURl = self.arrArticle[sender.tag].link
            }
            else{
                obj.strURl = self.arrArticle[sender.tag].video_link
            }
        }

        obj.modalPresentationStyle = .overFullScreen
        self.present(obj, animated: false, completion: nil)
    }
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
        
        if let indexPath = self.mainTableView.indexPathForView(sender) {
            
            let cellfeed = mainTableView.cellForRow(at: indexPath) as! ArticleCell
            var like_count = arrArticle[indexPath.row].like_count
            var likestatus = arrArticle[indexPath.row].is_like
            if CheckVC == "MY"{
                post_Id = myarrArticle[indexPath.row].id
                like_count = myarrArticle[indexPath.row].like_count
                likestatus = myarrArticle[indexPath.row].is_like
            }
            else{
                post_Id = arrArticle[indexPath.row].id
                like_count = arrArticle[indexPath.row].like_count
                likestatus = arrArticle[indexPath.row].is_like
            }
           
            
            if likestatus == 1{
                likestatus = 0
            }
            else{
                likestatus = 1
            }
            let parameters = ["article_id":post_Id, "status":likestatus] as [String : Any]
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let BEARERTOKEN = BEARER + token
            let headers: HTTPHeaders = ["Xapi": XAPI,
                                        "Accept" : ACCEPT,
                                        "Authorization":BEARERTOKEN]
            if let button = sender as? UIButton {
                if button.isSelected {
                    button.isSelected = false
                    
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        cellfeed.btnLike.transform = cellfeed.btnLike.transform.scaledBy(x: 0.7, y: 0.7)
                        cellfeed.btnLike.setImage(UIImage(named: "like"), for: .normal)
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.1, animations: {
                            cellfeed.btnLike.transform = CGAffineTransform.identity
                        })
                    })
                    
                    //                    cellfeed.btnLike.setImage(UIImage(named: "like"), for: .normal)
                    wc.callSimplewebservice(url: LIKEARTICLE, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ArticleLikeModel?) in
                        if sucess {
                            print(response)
                            if response!.message == "Like article." {
                                
                                if self.CheckVC == "MY"{
                                    self.myarrArticle = self.myarrArticle.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_like = 1
                                            mutableBook.like_count = like_count + 1
                                            cellfeed.lblLikeCount.text = String(like_count + 1)
                                        }
                                        return mutableBook
                                    }
                                }
                                else{
                                    if self.CheckVC == "MY"{
                                        self.myarrArticle = self.myarrArticle.map{
                                            var mutableBook = $0
                                            if $0.id == self.post_Id {
                                                mutableBook.is_like = 1
                                                mutableBook.like_count = like_count + 1
                                                cellfeed.lblLikeCount.text = String(like_count + 1)
                                            }
                                            return mutableBook
                                        }
                                    }
                                    else{
                                        self.arrArticle = self.arrArticle.map{
                                            var mutableBook = $0
                                            if $0.id == self.post_Id {
                                                mutableBook.is_like = 1
                                                mutableBook.like_count = like_count + 1
                                                cellfeed.lblLikeCount.text = String(like_count + 1)
                                            }
                                            return mutableBook
                                        }
                                    }

                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    //                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                    self.mainTableView.endUpdates()
                                    
                                    
                                }
                            }
                            else {
                                if self.CheckVC == "MY"{
                                    self.myarrArticle = self.myarrArticle.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_like = 0
                                            if like_count > 0{
                                                mutableBook.like_count = like_count - 1
                                                cellfeed.lblLikeCount.text = String(like_count - 1)
                                                let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                                                cellfeed.btnLike.setImage(image, for: .normal)
                                                cellfeed.btnLike.tintColor = UIColor.gray
                                            }
                                            
                                        }
                                        return mutableBook
                                    }
                                }
                                else{
                                    self.arrArticle = self.arrArticle.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_like = 0
                                            if like_count > 0{
                                                mutableBook.like_count = like_count - 1
                                                cellfeed.lblLikeCount.text = String(like_count - 1)
                                                let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                                                cellfeed.btnLike.setImage(image, for: .normal)
                                                cellfeed.btnLike.tintColor = UIColor.gray
                                            }
                                            
                                        }
                                        return mutableBook
                                    }
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    //                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                                    self.mainTableView.endUpdates()
                                }
                            }
                        }
                    }
                } else {
                    button.isSelected = true
                    //                    cellfeed.btnLike.setImage(UIImage(named: "likefill"), for: .normal)
                    
                    UIView.animate(withDuration: 0.1, animations: {
                        
                        cellfeed.btnLike.transform = cellfeed.btnLike.transform.scaledBy(x: 1.3, y: 1.3)
                        let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                        cellfeed.btnLike.setImage(image, for: .normal)
                        cellfeed.btnLike.tintColor = UIColor(red: 0.93, green: 0.29, blue: 0.34, alpha: 1.00)//UIColor.red
                        
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.1, animations: {
                            cellfeed.btnLike.transform = CGAffineTransform.identity
                        })
                    })
                    
                    wc.callSimplewebservice(url: LIKEARTICLE, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ArticleLikeModel?) in
                        if sucess {
                            print(response)
                            if response!.message == "Like article." {
                                if self.CheckVC == "MY"{
                                    self.myarrArticle = self.myarrArticle.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_like = 1
                                            mutableBook.like_count = like_count + 1
                                            cellfeed.lblLikeCount.text = String(like_count + 1)
                                        }
                                        return mutableBook
                                    }
                                }
                                else{
                                    self.arrArticle = self.arrArticle.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_like = 1
                                            mutableBook.like_count = like_count + 1
                                            cellfeed.lblLikeCount.text = String(like_count + 1)
                                        }
                                        return mutableBook
                                    }
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    //                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                            }
                            else {
                                if self.CheckVC == "MY"{
                                    self.myarrArticle = self.myarrArticle.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_like = 0
                                            if mutableBook.like_count > 0{
                                                mutableBook.like_count = like_count - 1
                                                cellfeed.lblLikeCount.text = String(like_count - 1)
                                                let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                                                cellfeed.btnLike.setImage(image, for: .normal)
                                                cellfeed.btnLike.tintColor = UIColor.gray
                                            }
                                        }
                                        return mutableBook
                                    }
                                }
                                else{
                                    self.arrArticle = self.arrArticle.map{
                                        var mutableBook = $0
                                        if $0.id == self.post_Id {
                                            mutableBook.is_like = 0
                                            if mutableBook.like_count > 0{
                                                mutableBook.like_count = like_count - 1
                                                cellfeed.lblLikeCount.text = String(like_count - 1)
                                                let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                                                cellfeed.btnLike.setImage(image, for: .normal)
                                                cellfeed.btnLike.tintColor = UIColor.gray
                                            }
                                        }
                                        return mutableBook
                                    }
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    //                                    cellfeed.animatedview.isHidden = true
                                    self.mainTableView.beginUpdates()
                                    self.mainTableView.endUpdates()
                                }
                            }
                            
                        }
                    }
                }
                
            }
        }
        
        
    }
    
    func ViewCounter(article_id: Int , indexpath: IndexPath){
        let parameters = ["article_id": article_id] as [String : Any]//"Bottom"
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        print("parameters: ",parameters)
        print("headers: ",headers)
        print("SHOWFEED: ",ARTICLEVIEWCOUNTER)
        wc.callSimplewebservice(url: ARTICLEVIEWCOUNTER, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: ArticleLikeModel?) in
            //            print("response:",response.re)
            if sucess {
                self.arrArticle[indexpath.row].view_count = self.arrArticle[indexpath.row].view_count + 1
                
            }
            else {
                
            }
        }
    }
    
    func GetMyArticleList(page: Int){
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        print("page: ",page)
        
        print("headers: ",headers)
        
        wc.callGETSimplewebservice(url: MYARTICLE, parameters: ["page":page], headers: headers, fromView: self.view, isLoading: true) { (sucess, response: MyArticleResponseModel?) in
            print("response:",response)
            if sucess {
                let arr_dict = response?.data.data
                if arr_dict!.count > 0{
                    self.noDataLabel.isHidden = true
                    if self.Flag == "ok"{
                        
                        
                        for i in 0..<arr_dict!.count
                        {
                            self.myarrArticle.append((arr_dict?[i])!)

                            self.mainTableView.beginUpdates()
                            self.mainTableView.insertRows(at: [
                                NSIndexPath(row: self.arrArticle.count-1, section: 0) as IndexPath], with: .fade)
                            self.mainTableView.endUpdates()
                            self.refreshControl.endRefreshing()
                            self.spinner.stopAnimating()
//                            self.spinner.stopAnimating()
        //                            self.arrFeed.insert(arr_dict![i], at: 0)
                        }
                        self.Flag = ""
                    }
                    else{
                        self.myarrArticle = (response?.data.data)!
                        self.mainTableView.reloadData()
                        self.refreshControl.endRefreshing()
                        self.spinner.stopAnimating()
                    }
                }
                else{
                    self.setBack()
                    self.noDataLabel.isHidden = false
                    self.NoData()
                    self.refreshControl.endRefreshing()
                    self.spinner.stopAnimating()
                }
               

            }
            else {
                self.setBack()
                self.noDataLabel.isHidden = false
                self.NoData()
               
                self.refreshControl.endRefreshing()
                self.spinner.stopAnimating()
            }
        }
    }
    
    func setBack(){
        let image = UIImage(named: "Backarrowv2")?.withRenderingMode(.alwaysTemplate)
        btnBack.setImage(image, for: .normal)
        btnBack.tintColor = UIColor.black
    }
    
    func GetArticleList(page: Int){
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        print("page: ",page)
        
        print("headers: ",headers)
        
        wc.callGETSimplewebservice(url: LISTARTICLE, parameters: ["page":page], headers: headers, fromView: self.view, isLoading: true) { (sucess, response: ArticleListResponsModel?) in
            print("response:",response)
            if sucess {
                let arr_dict = response?.data.data
                if arr_dict!.count > 0{
                    self.noDataLabel.isHidden = true
                    if self.Flag == "ok"{
                        
                        
                        for i in 0..<arr_dict!.count
                        {
                            self.arrArticle.append((arr_dict?[i])!)

                            self.mainTableView.beginUpdates()
                            self.mainTableView.insertRows(at: [
                                NSIndexPath(row: self.arrArticle.count-1, section: 0) as IndexPath], with: .fade)
                            self.mainTableView.endUpdates()
                            self.refreshControl.endRefreshing()
                            self.spinner.stopAnimating()
//                            self.spinner.stopAnimating()
        //                            self.arrFeed.insert(arr_dict![i], at: 0)
                        }
                        self.Flag = ""
                    }
                    else{
                        self.arrArticle = (response?.data.data)!
                        self.mainTableView.reloadData()
                        self.refreshControl.endRefreshing()
                        self.spinner.stopAnimating()
                    }
                }
                else{
                    self.noDataLabel.isHidden = false
                    self.NoData()
                    self.refreshControl.endRefreshing()
                    self.spinner.stopAnimating()
                }
               

            }
            else {
//
                self.noDataLabel.isHidden = false
                self.NoData()
               
                self.refreshControl.endRefreshing()
                self.spinner.stopAnimating()
            }
        }
    }
    
    @IBAction func btnSeemoreAction(_ sender: UIButton) {
        
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "ArticleWebViewVC")as! ArticleWebViewVC
        obj.strURl = self.arrArticle[sender.tag].article_web_link
        obj.strTitle = self.arrArticle[sender.tag].title
//                self.navigationController?.pushViewController(obj, animated: false)
        obj.modalPresentationStyle = .overFullScreen
        self.present(obj, animated: false, completion: nil)
    }
    
    @IBAction func btnShowmoreComment(_ sender: UIButton) {
//        DisplayViewMain.isHidden = true
//        mainTableView.isScrollEnabled = false

        if let indexPath = self.mainTableView.indexPathForView(sender) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideopauseReels"), object: nil)
            if CheckVC == "MY"{
                post_Id = myarrArticle[indexPath.row].id
            }
            else{
                post_Id = arrArticle[indexPath.row].id
            }
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewControllers")as! CommentsViewControllers
            obj.postId = self.post_Id
            obj.CHECKTYPE = "ART"
            //self.navigationController?.pushViewController(obj, animated: true)
            let naviget: UINavigationController = UINavigationController(rootViewController: obj)
//            obj.passappDel = "passappDel"
           // self.present(naviget, animated: true, completion: nil)
//            self.navigationController?.pushViewController(obj, animated: false)
            obj.modalPresentationStyle = .overFullScreen
            self.present(naviget, animated: false, completion: nil)
        }
    }
}

extension ArticlesVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CheckVC == "MY"{
            return self.myarrArticle.count
        }
        else{
            return self.arrArticle.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleCell
        
        if CheckVC == "MY"{
            let data = self.myarrArticle[indexPath.row]
            cell.imgArticle.kf.setImage(with: URL(string: data.articleimages.full_url),placeholder:UIImage(named: "Placeholder"))
            
            let formattedString1 = data.title
                                    .htmlAttributedString()
                                    .with(font:UIFont(name: "SFUIText-Semibold", size: 20)!)
            cell.lblArticleTitle.attributedText = formattedString1//data.title
            cell.lblArticleTitle.adjustsFontSizeToFitWidth = false
            cell.lblArticleTitle.lineBreakMode = .byTruncatingTail
    //        cell.lblArticleTitle.text = data.title
            cell.lblCreatedBy.text = data.created_by
            let postDate = data.created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblCreatedAt.text = datavala
            
            let formattedString = data.description
                                    .htmlAttributedString()
                                    .with(font:UIFont(name: "SFUIText-Light", size: 15)!)
            cell.lblDescription.attributedText = formattedString
            
            cell.btnShare.backgroundColor = .red
            cell.btnShare.setImage(UIImage(named: "deleteA"), for: .normal)
            cell.btnShare.layer.cornerRadius = cell.btnShare.frame.height/2
            cell.btnShare.clipsToBounds = true
            
            if data.video_link == ""{
                cell.btnPlay.isHidden = true
            }
            else{
                cell.btnPlay.isHidden = false
            }
            cell.lblDescription.numberOfLines = 6
                    
            cell.lblLikeCount.text = String(data.like_count)
            cell.lblCommentCount.text = String(data.comment_count)
            let is_liked = data.is_like
            if is_liked == 1 {
                cell.btnLike.isSelected = true
    //            cell.btnLike.setImage(UIImage(named: "likefill"), for: .normal)
                
                let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                cell.btnLike.setImage(image, for: .normal)
                cell.btnLike.tintColor = UIColor(red: 0.93, green: 0.29, blue: 0.34, alpha: 1.00)//UIColor.red
            }
            else {
                cell.btnLike.isSelected = false
    //            cell.btnLike.setImage(UIImage(named: "like"), for: .normal)
                let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                cell.btnLike.setImage(image, for: .normal)
                cell.btnLike.tintColor = UIColor.gray
            }
            
            cell.lblView.text = String(data.view_count)
            
            var lineCount = 0
            let textSize = CGSize(width: cell.lblDescription.frame.size.width, height: CGFloat(MAXFLOAT))
            let rHeight = lroundf(Float(cell.lblDescription.sizeThatFits(textSize).height))
            let charSize = lroundf(Float(cell.lblDescription.font.lineHeight))
            lineCount = rHeight / charSize
            print(String(format: "No of lines: %i", lineCount))
            
            if lineCount > 4{
                cell.btnSeemore.isHidden = false
                cell.btnSeemoreHeight.constant = 30
            }
            else{
                cell.btnSeemore.isHidden = true
                cell.btnSeemoreHeight.constant = -8
            }
            cell.btnEdit.isHidden = false
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(btnEditAction(_:)), for: .touchUpInside)
        }
        else{
            let data = self.arrArticle[indexPath.row]
            cell.imgArticle.kf.setImage(with: URL(string: data.articleimages.full_url),placeholder:UIImage(named: "Placeholder"))
            
            cell.btnEdit.isHidden = true
            
            let formattedString1 = data.title
                                    .htmlAttributedString()
                                    .with(font:UIFont(name: "SFUIText-Semibold", size: 20)!)
            cell.lblArticleTitle.attributedText = formattedString1//data.title
            cell.lblArticleTitle.adjustsFontSizeToFitWidth = false
            cell.lblArticleTitle.lineBreakMode = .byTruncatingTail
    //        cell.lblArticleTitle.text = data.title
            cell.lblCreatedBy.text = data.created_by
            let postDate = arrArticle[indexPath.row].created_at
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: postDate)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblCreatedAt.text = datavala
            
            let formattedString = data.description
                                    .htmlAttributedString()
                                    .with(font:UIFont(name: "SFUIText-Light", size: 15)!)
            cell.lblDescription.attributedText = formattedString
            
            if data.video_link == ""{
                cell.btnPlay.isHidden = true
            }
            else{
                cell.btnPlay.isHidden = false
            }
            cell.lblDescription.numberOfLines = 6
                    
            cell.lblLikeCount.text = String(data.like_count)
            cell.lblCommentCount.text = String(data.comment_count)
            let is_liked = data.is_like
            if is_liked == 1 {
                cell.btnLike.isSelected = true
    //            cell.btnLike.setImage(UIImage(named: "likefill"), for: .normal)
                
                let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                cell.btnLike.setImage(image, for: .normal)
                cell.btnLike.tintColor = UIColor(red: 0.93, green: 0.29, blue: 0.34, alpha: 1.00)//UIColor.red
            }
            else {
                cell.btnLike.isSelected = false
    //            cell.btnLike.setImage(UIImage(named: "like"), for: .normal)
                let image = UIImage(named: "likefill")?.withRenderingMode(.alwaysTemplate)
                cell.btnLike.setImage(image, for: .normal)
                cell.btnLike.tintColor = UIColor.gray
            }
            
            cell.lblView.text = String(data.view_count)
            var lineCount = 0
            let textSize = CGSize(width: cell.lblDescription.frame.size.width, height: CGFloat(MAXFLOAT))
            let rHeight = lroundf(Float(cell.lblDescription.sizeThatFits(textSize).height))
            let charSize = lroundf(Float(cell.lblDescription.font.lineHeight))
            lineCount = rHeight / charSize
            print(String(format: "No of lines: %i", lineCount))
            
            if lineCount > 4{
                cell.btnSeemore.isHidden = false
                cell.btnSeemoreHeight.constant = 30
            }
            else{
                cell.btnSeemore.isHidden = true
                cell.btnSeemoreHeight.constant = -8
            }
        }
        
    
        cell.btnShare.tag = indexPath.row
        cell.btnShare.addTarget(self, action: #selector(btnShareAction(_:)), for: .touchUpInside)
        
        cell.btnComment.tag = indexPath.row
        cell.btnComment.addTarget(self, action: #selector(btnShowmoreComment(_:)), for: .touchUpInside)
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(btnLikeAction(_:)), for: .touchUpInside)
        
        cell.btnLink.tag = indexPath.row
        cell.btnLink.addTarget(self, action: #selector(btnLinkAction(_:)), for: .touchUpInside)
        
        cell.btnSeemore.tag = indexPath.row
        cell.btnSeemore.addTarget(self, action: #selector(btnSeemoreAction(_:)), for: .touchUpInside)


        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if CheckVC == "MY"{
            
        }
        else{
            ViewCounter(article_id: arrArticle[indexPath.row].id ,indexpath: indexPath)
        }
        
        
    }
    func NoData(){
        noDataLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: mainTableView.bounds.size.width, height: mainTableView.bounds.size.height))
        noDataLabel.text          = "No Data Found"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        mainTableView.backgroundView  = noDataLabel
        mainTableView.separatorStyle  = .none
    }
}


//extension String {
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = data(using: .utf8) else { return nil }
//        do {
//            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            return nil
//        }
//    }
//    var htmlToString: String {
//        return htmlToAttributedString?.string ?? ""
//    }
//}
extension String {
    func htmlAttributedString() -> NSMutableAttributedString {

            guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
                else { return NSMutableAttributedString() }

            guard let formattedString = try? NSMutableAttributedString(data: data,
                                                            options: [.documentType: NSAttributedString.DocumentType.html,
                                                                      .characterEncoding: String.Encoding.utf8.rawValue],
                                                            documentAttributes: nil )

                else { return NSMutableAttributedString() }

            return formattedString
    }

}


extension NSMutableAttributedString {

    func with(font: UIFont) -> NSMutableAttributedString {
        self.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, self.length), options: .longestEffectiveRangeNotRequired, using: { (value, range, stop) in
            let originalFont = value as! UIFont
            if let newFont = applyTraitsFromFont(originalFont, to: font) {
                self.addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
            }
        })
        return self
    }

    func applyTraitsFromFont(_ f1: UIFont, to f2: UIFont) -> UIFont? {
        let originalTrait = f1.fontDescriptor.symbolicTraits

        if originalTrait.contains(.traitBold) {
            var traits = f2.fontDescriptor.symbolicTraits
            traits.insert(.traitBold)
            if let fd = f2.fontDescriptor.withSymbolicTraits(traits) {
                return UIFont.init(descriptor: fd, size: 0)
            }
        }
        return f2
    }
}


// MARK: - ScrollView Extension
extension ArticlesVC {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        let index = mainTableView.indexPathsForVisibleRows
        for index1 in index ?? [] {
            print("count:",arrArticle.count)
            print("indexV:",index1.row)

            if ((index1.row + 1) == arrArticle.count){
//                mainTableView.reloadData()
                print("scrollindex:", index1.row )

                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: mainTableView.bounds.width, height: CGFloat(44))
                if Flag == ""{
                    Flag = "ok"
                    pageCount = pageCount + 1
                    if CheckVC == "MY"{
                        GetMyArticleList(page: pageCount)
                    }
                    else{
                        GetArticleList(page: pageCount)
                    }
                    
                }
              
            }
        }
        
    }
    
}
