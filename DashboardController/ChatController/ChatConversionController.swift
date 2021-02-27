//
//  ChatConversionController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 08/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import PusherSwift
import Alamofire

class ChatConversionController: UIViewController,PusherDelegate {
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var textEntry: UITextField!
    
    
    var pusher: Pusher! = nil
    var strMessage = String()
    var strUsername = String()
    var arrAllMessage: NSMutableArray = []
    var wc = Webservice.init()
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var viewMsg: UIView!{
        didSet{
            viewMsg.layer.cornerRadius = viewMsg.frame.height/2
            viewMsg.clipsToBounds = true
        }
    }
    
    @IBAction func onSendClicked(_ sender: Any) {
        sendMessage()
    }
    
    var Id = Int()
    var arrMessage = NSArray()
    var user_id = Int()
    var receiverUsername = String()
    var avatar = String()
    var url: URL?
    var arrMSGrespons = [MessageReponse]()
    var arrValue = NSMutableArray()
    var pageCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setStatusBar(backgroundColor: .black)
        
         NotificationCenter.default.addObserver(self, selector: #selector(ChatConversionController.chatnotification), name: NSNotification.Name(rawValue: "Chatnotification"), object: nil)
        
        loaderView.isHidden = false
        activity.startAnimating()
        refreshControl.addTarget(self, action: #selector(ChatConversionController.refresh), for: UIControl.Event.valueChanged)
        tblChat.addSubview(refreshControl)
        
       let pusherClientOptions = PusherClientOptions(authMethod: .inline(secret: "ac49393c005ff1183990"))
        pusher = Pusher(key: "7d3dbc7b989d409135c6", options: pusherClientOptions)
//                // Use this if you want to try out your auth endpoint
        let optionsWithEndpoint = PusherClientOptions(
            authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: AuthRequestBuilder()),host: .cluster("ap2")
                )
        pusher = Pusher(key: "7d3dbc7b989d409135c6", options: optionsWithEndpoint)

       strUsername = loggdenUser.value(forKey: USERNAME)as! String
        
        let strchannel = (strUsername + "-message-created")
        
        let channel = pusher.subscribe(strchannel)
        
        let _ = channel.bind(eventName: "App\\Events\\MessagePublished", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                print(data)
                if let message = data["message"] as? NSDictionary {
                    print(message)
                    let body = message.value(forKey: "body")as! String
                    let created_at = message.value(forKey: "created_at")as! String
                    let thread_id = message.value(forKey: "thread_id")as! Int
                    let updated_at = message.value(forKey: "updated_at")as! String
                    let user_id = message.value(forKey: "user_id")as! Int
                    
                    if thread_id == self.Id {
                         let obj = MessageReponse(thread_id: thread_id, user_id: user_id, body: body, created_at: created_at, updated_at: updated_at)
                        self.arrMSGrespons.append(obj)
                        self.reloadData()
                    }
                    else {
                        if let sender = data["sender"]as? NSDictionary {
                            let senderName = sender.value(forKey: "name")as! String
                            let avatar = sender.value(forKey: "avatar")as! String
                            let strFcm = loggdenUser.value(forKey: FCMTOKEN)as! String
                            //MARK: notification set
                            let parameters = ["title":senderName,
                                              "body":body,
                                              "thread_id":thread_id,
                                              "image":avatar,
                                              "devicetoken":strFcm] as [String : Any]
                            let token = loggdenUser.value(forKey: TOKEN)as! String
                            let BEARERTOKEN = BEARER + token
                            let headers: HTTPHeaders = ["Xapi": XAPI,
                                                        "Accept" : ACCEPT,
                                                        "Authorization":BEARERTOKEN]
                            
                            self.wc.callSimplewebservice(url: CHATNOTIFICATION, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: chatNotiResponsModel?) in
                                if sucess {
                                }
                            }
                        }
                    }
                }
            }
        })
        
        pusher.connection.delegate = self
        pusher.connect()
        setDeafult()
    }
    
    @objc func refresh(sender:AnyObject) {
        pageCount += 1
        print(pageCount)
        chat(strpage: "\(pageCount)")
    }
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        // print the old and new connection states
        print("old: \(old.stringValue()) -> new: \(new.stringValue())")
    }
    
    func subscribedToChannel(name: String) {
        print("Subscribed to \(name)")
    }
    
    func debugLog(message: String) {
        //print(message)
    }
    @objc func chatnotification(_ notification: NSNotification) {
        if let object = notification.object as? [String: Any] {
            if let id = object["id"] as? Int {
                Id = id
            }
            if let name = object["receiverUsername"] as? String {
                lblUserName.text = name
            }
            
            if let avatar = object["avatar"] as? String {
                url = URL(string: avatar)
                imgProfile.sd_setImage(with: url, completed: nil)
            }
        }
        loaderView.isHidden = false
        activity.startAnimating()
        pageCount = 1
        chat()
    }
    
    
    func setDeafult() {
        pageCount = 1
        chat()
        tblChat.rowHeight = UITableView.automaticDimension;
        tblChat.estimatedRowHeight = 44;
//        let gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = self.header.bounds
//
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        header.layer.addSublayer(gradientLayer)
//        header.addSubview(btnBack)
//        header.addSubview(lblUserName)
//        header.addSubview(imgProfile)
        lblUserName.text = receiverUsername
        url = URL(string: avatar)
        imgProfile.sd_setImage(with: url, completed: nil)
        imgProfile.layer.cornerRadius = 17.5
        imgProfile.clipsToBounds = true
//        if UIScreen.main.bounds.width == 414 {
//            gradientLayer.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 414, height: header.bounds.size.height)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func sendMessage() {
        strMessage = textEntry.text!.encodeEmoji
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        AF.request(POST_MESSAGE + "/" + String(Id), method: .post, parameters: ["message":strMessage], encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
            let json = response.value as! NSDictionary
            let message = json.value(forKey: "data")as! NSDictionary
            let body = message.value(forKey: "body")as! String
            let created_at = message.value(forKey: "created_at")as! String
            let thread_id = message.value(forKey: "thread_id")as! Int
            let updated_at = message.value(forKey: "updated_at")as! String
            let user_id = message.value(forKey: "user_id")as! Int
            let obj = MessageReponse(thread_id: thread_id, user_id: user_id, body: body, created_at: created_at, updated_at: updated_at)
            self.arrMSGrespons.append(obj)
            self.reloadData()
            self.textEntry.text = nil
        }
    }
    
    func chat(strpage: String) {
        
        let parameters = ["page":strpage]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        let url = GET_CONVERSATION + "/" + String(Id) + "?apicall=true"
        
        wc.callSimplewebservice(url: url, parameters: parameters, headers: headers, fromView: self.view, isLoading: false) { (sucess, response: messageResponsemodel?) in
            if sucess {
                let data = response?.data
                let arr_dict = data?.data
                for i in 0..<arr_dict!.count
                {
                    self.arrMSGrespons.insert(arr_dict![i], at: 0)
                    self.tblChat.beginUpdates()
                    self.tblChat.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                    self.refreshControl.endRefreshing()
                    self.tblChat.endUpdates()
                }
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
            }
            else {
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
            }
        }
    }
    
    
    
    func callChat() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        let url = GET_CONVERSATION + "/" + String(Id) + "?apicall=true"
        
        wc.callSimplewebservice(url: url, parameters: [:], headers: headers, fromView: self.view, isLoading: false) { (sucess, response: messageResponsemodel?) in
            if sucess {
                let data = response?.data
                let arr_dict = data?.data
                for i in 0..<arr_dict!.count
                {
                    self.arrMSGrespons.append(arr_dict![i])
                    self.reloadData()
                }
            }
        }
    }
    
    func convertToDictionary(from text: String) throws -> [String: String] {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }
    
    func chat() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        let url = GET_CONVERSATION + "/" + String(Id) + "?apicall=true"
        
        wc.callSimplewebservice(url: url, parameters: [:], headers: headers, fromView: self.view, isLoading: false) { (sucess, response: messageResponsemodel?) in
            if sucess {
                let data = response?.data
                let arr_dict = data?.data
                for i in 0..<arr_dict!.count
                {
                    self.arrMSGrespons.append(arr_dict![i])
                    self.reloadData()
                    self.loaderView.isHidden = true
                    self.activity.stopAnimating()
                }
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
            }
            else {
                self.loaderView.isHidden = true
                self.activity.stopAnimating()
            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func reloadData(){
        tblChat.reloadData()
        DispatchQueue.main.async {
            let indexPath = NSIndexPath(row: self.arrMSGrespons.count - 1, section: 0)
            self.tblChat.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
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

}

extension ChatConversionController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMSGrespons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = arrMSGrespons[indexPath.row]
        let id = message.user_id
        if id == user_id {
            let cell = tblChat.dequeueReusableCell(withIdentifier: "reciverCell", for: indexPath)as! tblConversionCell
            cell.viewRecive.layer.cornerRadius = 8
            cell.viewRecive.clipsToBounds = true
            let strLatmessage = message.body
            let created_at = message.created_at
            cell.lblrecivetxt.text = strLatmessage.decodeEmoji
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: created_at)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblrecivetextTime.text = datavala
            return cell
        }
        else {
            let cell = tblChat.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath)as! tblConversionCell
            cell.viewSendertxt.layer.cornerRadius = 8
            cell.viewSendertxt.clipsToBounds = true
            let strLatmessage = message.body
            let created_at = message.created_at
            cell.lblSender.text = strLatmessage.decodeEmoji
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: created_at)!
            let datavala = Date().timeAgoSinceDate(date, numericDates: true)
            cell.lblsendertxtTime.text = datavala
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let lastRowIndex = tblChat.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            tblChat.scrollToBottom(animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class AuthRequestBuilder: AuthRequestBuilderProtocol {
    func requestFor(socketID: String, channelName: String) -> URLRequest? {
        var request = URLRequest(url: URL(string: "http://localhost:9292/pusher/auth")!)
        request.httpMethod = "POST"
        request.httpBody = "socket_id=\(socketID)&channel_name=\(channelName)".data(using: String.Encoding.utf8)
        return request
    }
}

