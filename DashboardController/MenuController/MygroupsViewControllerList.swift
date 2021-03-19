//
//  MypagesViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 30/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class MygroupsViewControllerList: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var collectionSuggestedGroup: UICollectionView!
    @IBOutlet weak var tblPages: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var foundView: LargeFound!
    
    //MARK: - Variable
    
    var wc = Webservice.init()
    var arrMypage = [MyGroupList]()
    var spinner = UIActivityIndicatorView()
    var pageCount = Int()
    var url: URL?
    var User_Id = Int()
    var username = String()
    var arrSugestgroup = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView.isHidden = false
        activity.startAnimating()
        self.foundView.isHidden = true
        setDeafult()
        NotificationCenter.default.addObserver(self, selector: #selector(MypagesViewController.GetCreatedGroup), name: NSNotification.Name(rawValue: "PageCreat"), object: nil)
    }
    
    @objc func GetCreatedGroup(_ notification: NSNotification) {
        arrMypage.removeAll()
        getMypage(strPage: "1")
        pageCount = 1
    }
    
    func setDeafult() {
        getSuggestedGroup()
        getMypage(strPage: "1")
        pageCount = 1
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.headerView.bounds
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerView.layer.addSublayer(gradientLayer)
        headerView.addSubview(btnback)
        headerView.addSubview(lblTitle)
        
        //        let searchTextField = searchbar.value(forKey: "searchField") as? UITextField
        //        searchTextField?.textColor = UIColor.white
        //        searchTextField?.backgroundColor = UIColor.white
        //        searchTextField?.attributedPlaceholder =  NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        //
        //        searchbar.setImage(#imageLiteral(resourceName: "Searching"), for: UISearchBar.Icon.search, state: .normal)
        //        //clear image
        //        searchbar.setImage(UIImage(named: "icon_search_clear"), for: UISearchBar.Icon.clear, state: .normal)
        
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
        }
    }
    
    func getSuggestedGroup() {
    let token = loggdenUser.value(forKey: TOKEN)as! String
    let BEARERTOKEN = BEARER + token
    let headers: HTTPHeaders = ["Xapi": XAPI,
                                "Accept" : ACCEPT,
                                "Authorization":BEARERTOKEN]
    AF.request(FindsuggestedGroups, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
            print(response)
            let json = response.value as! NSDictionary
            let success = json.value(forKey: "success")as! Bool
            if success == true {
                self.arrSugestgroup = json.value(forKey: "data") as! NSArray
                self.collectionSuggestedGroup.reloadData()
            }
        }
    }

    
    
    func getMypage(strPage : String) {
        let username = loggdenUser.value(forKey: USERNAME)as! String
        
        let parameters = ["username":username,
                          "page":strPage] as [String : Any]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: GROUPLIST, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: MygroupListResponse?) in
            
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
                    let data = response?.data
                    let arr_dict = data?.data
                    for i in 0..<arr_dict!.count
                    {
                        self.arrMypage.insert(arr_dict![i], at: 0)
                        self.tblPages.beginUpdates()
                        self.tblPages.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
                        self.tblPages.endUpdates()
                        self.spinner.stopAnimating()
                        self.tblPages.tableFooterView?.isHidden = true
                        self.loaderView.isHidden = true
                        self.activity.stopAnimating()
                        if self.arrMypage.count == 0 {
//                            self.foundView.isHidden = false
                        }
                        else {
//                            self.foundView.isHidden = true
                        }
                    }
                }
                else {
                    self.spinner.stopAnimating()
                    self.tblPages.tableFooterView?.isHidden = true
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                    if self.arrMypage.count == 0 {
//                        self.foundView.isHidden = false
                    }
                    else {
//                        self.foundView.isHidden = true
                    }
                }
            }
            self.spinner.stopAnimating()
            self.tblPages.tableFooterView?.isHidden = true
            self.loaderView.isHidden = true
            self.activity.stopAnimating()
            if self.arrMypage.count == 0 {
//                self.foundView.isHidden = false
            }
            else {
//                self.foundView.isHidden = true
            }
        }
    }
    
   
    //MARK: - btn Action
    
    @IBAction func btnPageCreateAction(_ sender: UIButton) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController")as! CreateGroupViewController
        self.navigationController?.pushViewController(obj, animated: true)
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

//MARK: - TableView Method
extension MygroupsViewControllerList: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMypage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPages.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblMypagesCell
        cell.lblTitle.text = arrMypage[indexPath.row].name
        let strImg = arrMypage[indexPath.row].avatar_url_custom
        url = URL(string: strImg)
        cell.imgIcon.sd_setImage(with: url, completed: nil)
        cell.imgIcon.layer.cornerRadius = 5
        cell.imgIcon.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strGroup_type = arrMypage[indexPath.row].type_group
        let post_privacy = arrMypage[indexPath.row].post_privacy
        let member_privacy = arrMypage[indexPath.row].member_privacy
        if strGroup_type == "closed" {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "GroupProfileViewController")as! GroupProfileViewController
            obj.strUserName = arrMypage[indexPath.row].username
            obj.groupTimeline_id = arrMypage[indexPath.row].timeline_id
            obj.onlyPost = post_privacy
            obj.onlyInvaite = member_privacy
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "openAndSecretGroupController")as! openAndSecretGroupController
            obj.strUserName = arrMypage[indexPath.row].username
            obj.groupTimeline_id = arrMypage[indexPath.row].timeline_id
            obj.onlyPost = post_privacy
            obj.onlyInvaite = member_privacy
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let refreshAlert = UIAlertController(title: "Notification", message: "Are you sure to delete?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                let page_id = self.arrMypage[indexPath.row].id
                self.arrMypage.remove(at: indexPath.row)
                self.tblPages.deleteRows(at: [indexPath], with: .fade)
                let parameters = ["page_id": page_id]as [String : Any]
                let token = loggdenUser.value(forKey: TOKEN)as! String
                let BEARERTOKEN = BEARER + token
                let headers: HTTPHeaders = ["Xapi": XAPI,
                                            "Accept" : ACCEPT,
                                            "Authorization":BEARERTOKEN]
                self.wc.callSimplewebservice(url: PAGE_DELETE, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: GroupDeleteResponsModel?) in
                    if sucess {
                    }
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == tblPages {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblPages.bounds.width, height: CGFloat(44))
                if arrMypage.count == 9 {
                    print("jekil")
                }
                else {
                    pageCount += 1
                    getMypage(strPage: "\(pageCount)")
                    self.tblPages.tableFooterView = spinner
                    self.tblPages.tableFooterView?.isHidden = false
                }
            }
        }
    }
}


extension MygroupsViewControllerList: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSugestgroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let suggested = arrSugestgroup[indexPath.item]
        let cell = collectionSuggestedGroup.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! MySuggestGroupCell
        let image = (suggested as AnyObject).value(forKey: "avatar_url")as! String
        url = URL(string: image)
        cell.image.sd_setImage(with: url, completed: nil)
        cell.lblTitle.text = (suggested as AnyObject).value(forKey: "name")as? String
        cell.btnjoin.addTarget(self, action: #selector(MygroupsViewControllerList.btnjoinedActionopen), for: .touchUpInside)
        cell.btnClick.tag = indexPath.row
        cell.btnClick.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return cell
    }
    @objc func btnClick(_ sender: UIButton){
        let suggested = arrSugestgroup[sender.tag]
        let username = (suggested as AnyObject).value(forKey: "username")as? String//arrSugestgroup[sender.tag].username
        let group_Type = (suggested as AnyObject).value(forKey: "type_group")as? String//arrSugestgroup[indexPath.row].type_group
//        let status_group = (suggested as AnyObject).value(forKey: "status")as? String//arrSugestgroup[indexPath.row].status
//        let is_page_admin = (suggested as AnyObject).value(forKey: "is_page_admin")as? String//arrSugestgroup[indexPath.row].is_page_admin
        let post_privacy = (suggested as AnyObject).value(forKey: "post_privacy")as? String//arrSugestgroup[indexPath.row].post_privacy
        let member_privacy = (suggested as AnyObject).value(forKey: "member_privacy")as? String//arrSugestgroup[indexPath.row].member_privacy
           // if is_page_admin == 0 {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "openNewuserGroupController")as! openNewuserGroupController
        obj.strUserName = username ?? ""
        obj.onlyPost = post_privacy ?? ""
        obj.onlyInvaite = member_privacy ?? ""
        obj.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(obj, animated: true)
        self.present(obj, animated: false, completion: nil)

        
    }
    
    @objc func btnjoinedActionopen(_ sender: UIButton) {
       if let indexPath = self.collectionSuggestedGroup.indexPathForView(sender) {
        let cell = collectionSuggestedGroup.cellForItem(at: indexPath)as! MySuggestGroupCell
        let groupTimeline_id = (self.arrSugestgroup[indexPath.row]as AnyObject).value(forKey: "timeline_id")as! Int
        
        let parameters = ["timeline_id":groupTimeline_id]
              let token = loggdenUser.value(forKey: TOKEN)as! String
              let BEARERTOKEN = BEARER + token
              let headers: HTTPHeaders = ["Xapi": XAPI,
                                          "Accept" : ACCEPT,
                                          "Authorization":BEARERTOKEN]
              self.wc.callSimplewebservice(url: JOINGROUPREMOVE, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: joinedgroupRemoveReponseModel?) in
                  if sucess {
                      let joined = response?.joined
                      if joined! {
                        cell.btnjoin.setTitle("Joined", for: .normal)
                      }
                      else {
                          cell.btnjoin.setTitle("Join", for: .normal)
                      }
                  }
              }
        }
    }
}

class MySuggestGroupCell: UICollectionViewCell {
    
    @IBOutlet weak var btnjoin: UIButton! {
    didSet {
            btnjoin.layer.cornerRadius = 5
            btnjoin.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var btnClick: UIButton!
}
