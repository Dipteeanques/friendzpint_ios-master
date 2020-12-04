//
//  ChooseFriendViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 25/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class ChooseFriendViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var tblFriendZList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnBext: UIButton!
    
    var arrFriendzList = [["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Mayur Godhani"],["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Jekil Dabhoya"],["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Dipak Kukadiya"],["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Manan Kathiriya"],["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Maulik Bhuva"],["img":#imageLiteral(resourceName: "LoginBackground"),"name":"Piyush Prajapati"]]
    var arrSelected = NSMutableArray()
    var selectedTag = [TagList]()
    
    var strSearchTxt = String()
    var arrResults = [TagList]()
    var wc = Webservice.init()
    var url: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setDefault()
    }
    
    func setDefault() {
        tblFriendZList.allowsMultipleSelection = true
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.headerView.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        headerView.layer.addSublayer(gradientLayer)
        headerView.addSubview(btnback)
        headerView.addSubview(lblHeaderTitle)
        headerView.addSubview(btnBext)
        
        if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: headerView.bounds.origin.x, y: headerView.bounds.origin.y, width: 414, height: headerView.bounds.size.height)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        strSearchTxt = searchText
        getSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        searchBar.endEditing(true)
        getSearch()
    }
    
    func getSearch() {
        let trimmed = strSearchTxt.trimmingCharacters(in: .whitespacesAndNewlines)
        let parameters = ["query": trimmed]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                       "Accept" : ACCEPT,
                       "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: USER_SEARCH_TAG, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: TageSearchResponseModel?) in
            if sucess {
                let resSuccess = response?.success
                if resSuccess! {
                    self.arrResults = response!.data
                    self.tblFriendZList.reloadData()
                }
            }
        }
        
       /* Alamofire.request(searchApi,method: .get, parameters: nil,headers: headers).responseJSON { response in
            print(response)
            let dic = response.value as! NSDictionary
            let success = dic.value(forKey: "success")as! Bool
            if success {
                self.arrResults = dic.value(forKey: "data")as! NSArray
                self.tblFriendZList.reloadData()
            }
        }*/
    }

    @IBAction func btnbackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNextAction(_ sender: UIButton) {
        print(selectedTag)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectedFriendZlistInGroup"), object: arrSelected)
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

extension ChooseFriendViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFriendZList.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblCellFriendzListGroup
        cell.lblName.text = arrResults[indexPath.row].name
        cell.imgprofile.layer.cornerRadius = 15
        cell.imgprofile.clipsToBounds = true
        let imgstr = arrResults[indexPath.row].image
        url = URL(string: imgstr)
        cell.imgprofile.sd_setImage(with: url, completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tblFriendZList.cellForRow(at: indexPath)as! tblCellFriendzListGroup
        if(!arrSelected.contains(arrResults[indexPath.row])){
            arrSelected.add(arrResults[indexPath.row])
            selectedTag.append(arrResults[indexPath.row])
            print("selected:",arrSelected)
           // cell.btnCheckuncheck.setImage(#imageLiteral(resourceName: "cheackBox"), for: UIControl.State.normal)
        }else{
            arrSelected.remove(arrResults[indexPath.row])
            selectedTag.remove(at: indexPath.row)
           // cell.btnCheckuncheck.setImage(#imageLiteral(resourceName: "box"), for: UIControl.State.normal)
        }
            if cell.accessoryType == .checkmark
            {
                cell.accessoryType = .none
            }
            else
            {
                cell.accessoryType = .checkmark
            }
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //let cell = tblFriendZList.cellForRow(at: indexPath)as! tblCellFriendzListGroup
        arrSelected.remove(arrResults[indexPath.row])
        selectedTag.remove(at: indexPath.row)
        //cell.btnCheckuncheck.setImage(#imageLiteral(resourceName: "box"), for: UIControl.State.normal)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
