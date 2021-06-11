//
//  AppDelegate.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 10/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces
import Alamofire
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var wc = Webservice.init()
    var arrtimeline_ad = [TimelineAd]()
    var strFcm = String()
    var encodeData = [Data]()
    var likepageencodeData = [Data]()
    var joingroupencodeData = [Data]()
    var bioencodeData = [Data]()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        UIApplication.shared.statusBarView?.layer.addSublayer(gradientLayer)
        
//        UIApplication.shared.statusBarView?.backgroundColor = .Blue
//
//        if #available(iOS 13.0, *) {
//
//        }
        
//        UIApplication.shared.statusBarStyle = .lightContent
        
        FirebaseApp.configure()
        setNotification(application)
        Messaging.messaging().isAutoInitEnabled = true
        Messaging.messaging().delegate = self
        Fabric.with([Crashlytics()])
        Thread.sleep(forTimeInterval: 0.1)
        IQKeyboardManager.shared.enable = true
        
//        application.statusBarStyle = .lightContent
        let isLogin = loggdenUser.bool(forKey: Islogin)
        if isLogin{
           
            getProfileDetails()
        } else {
            self.extendSplashScreenPresentation()
        }
        
        GMSServices.provideAPIKey("AIzaSyCaupwMul15BWqwMBCZjgCD_GCpJi_-fG8")
        GMSPlacesClient.provideAPIKey("AIzaSyCaupwMul15BWqwMBCZjgCD_GCpJi_-fG8")
        
        
        return true
    }
    
    
    
    func getProfileDetails() {
        let strUsername = loggdenUser.value(forKey: USERNAME)as! String
        strFcm = loggdenUser.value(forKey: FCMTOKEN)as! String
        let parameters = ["username":strUsername,
                          "device_token":strFcm,
                          "device_type":"ios"]
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        wc.callSimplewebservice(url: MYPROFILEDETAILS, parameters: parameters, headers: headers, fromView: self.window!, isLoading: false) { (sucess, response: MyprofileResponsModel?) in
            if sucess {
                let dic = response?.data
                let name = dic?.name
                let profile = dic?.avatar
                let cover = dic?.cover
                let notiBadge = dic?.notificationCounter
               // let is_completed_profile = dic!.p
                self.arrtimeline_ad = dic!.timelineAd
                loggdenUser.set(self.encodeData, forKey: AD)
                loggdenUser.set(name, forKey: NAMELOgin)
                loggdenUser.set(profile, forKey: PROFILE)
                loggdenUser.set(cover, forKey: COVER)
                loggdenUser.set(notiBadge, forKey: BADGECOUNT)
                //loggdenUser.set(is_completed_profile, forKey: UPDATEPROFILE)
                self.getAdBanners()
            }
        }
    }
    
    func getAdBanners() {
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
     
        wc.callGETSimplewebservice(url: GETADSIMAGE, parameters: [:], headers: headers, fromView: self.window!, isLoading: false) { (sucess, response: adsbannersmodel?) in
            if sucess {
                let data = response?.data
                if data?.count == 0 {
                    print("jekil")
                    self.gotoDashboardController()
                }
                else {
                    let timeline = data![0]
                    let likepage = data![1]
                    let joingroup = data![2]
                    let bio = data![3]
                    loggdenUser.removeObject(forKey: ADtimeline)
                    loggdenUser.removeObject(forKey: ADlikepage)
                    loggdenUser.removeObject(forKey: ADjoingroup)
                    loggdenUser.removeObject(forKey: ADbio)
                    let jsonstring = adsData.init(title: timeline.title, link: timeline.link, type: timeline.type, active: timeline.active, image: timeline.image)
                    let encoder = JSONEncoder()
                    if let data = try? encoder.encode(jsonstring) {
                        self.encodeData.append(data)
                        loggdenUser.set(self.encodeData, forKey: ADtimeline)
                    }
                    self.gotoDashboardController()
                    let jsonslikepagetring = adsData.init(title: likepage.title, link: likepage.link, type: likepage.type, active: likepage.active, image: likepage.image)
                    let encoderlikepage = JSONEncoder()
                    if let data = try? encoderlikepage.encode(jsonslikepagetring) {
                        self.likepageencodeData.append(data)
                        loggdenUser.set(self.likepageencodeData, forKey: ADlikepage)
                    }
                    
                    let jsonsjoingroup = adsData.init(title: joingroup.title, link: joingroup.link, type: joingroup.type, active: joingroup.active, image: joingroup.image)
                    let encoderjoingroup = JSONEncoder()
                    if let data = try? encoderjoingroup.encode(jsonsjoingroup) {
                        self.joingroupencodeData.append(data)
                        loggdenUser.set(self.joingroupencodeData, forKey: ADjoingroup)
                    }
                    
                    let jsonsbio = adsData.init(title: bio.title, link: bio.link, type: bio.type, active: bio.active, image: bio.image)
                    let encoderbio = JSONEncoder()
                    if let data = try? encoderbio.encode(jsonsbio) {
                        self.bioencodeData.append(data)
                        loggdenUser.set(self.bioencodeData, forKey: ADbio)
                    }
                }
            }
        }
    }
    


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func extendSplashScreenPresentation(){
        // Get a refernce to LaunchScreen.storyboard
        let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        // Get the splash screen controller
        let splashController = launchStoryBoard.instantiateViewController(withIdentifier: "splashController")
        // Assign it to rootViewController
        self.window?.rootViewController = splashController
        self.window?.makeKeyAndVisible()
        // Setup a timer to remove it after n seconds
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(dismissSplashController), userInfo: nil, repeats: false)
    }

    @objc private func dismissSplashController() {
        // Get a refernce to Main.storyboard
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        // Get initial viewController
        let initController = mainStoryBoard.instantiateViewController(withIdentifier: "Navigation")
        // Assign it to rootViewController
        self.window?.rootViewController = initController
        self.window?.makeKeyAndVisible()
    }
    
    func gotoLoginController() {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "Navigation") as! UINavigationController
        self.window?.rootViewController = homePage
        self.window?.makeKeyAndVisible()
    }
    
    func gotoDashboardController() {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "NavigateDashboard") as! UINavigationController
        self.window?.rootViewController = homePage
        self.window?.makeKeyAndVisible()
    }
    
    func gotoSignupController(){
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "naviSignup") as! UINavigationController
        self.window?.rootViewController = homePage
        self.window?.makeKeyAndVisible()
    }
    
    
    // MARK: - Setup Notification
    func setNotification(_ application: UIApplication) {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            guard error == nil else {
                return
            }
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
            else {
            }
        }
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Notification : \(userInfo)")
        //let data = userInfo["data"] as! NSDictionary
        //print("Dictionary : %@",data)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("user notification : \(response.notification)")
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let messageID = userInfo["gcm.message_id"]
        let username = userInfo["username"]as? String
        let status_group = userInfo["groups_status"]as? String
        let post_privacy = userInfo["post_privacy"]as? String
        let googlecae = userInfo["google.c.a.e"]
        let member_privacy = userInfo["member_privacy"]as? String
        let pageAdmin = userInfo["is_page_admin"]as? String
        let post_id = userInfo["post_id"]as? String
        let name = userInfo["name"]as? String
        let invite_privacy = userInfo["invite_privacy"]as? String
        let event_type = userInfo["event_type"]as? String
        let groups_type = userInfo["groups_type"]as? String
        let type = userInfo["type"]as? String
        let redirect_action = userInfo["redirect_action"]as? String
        let is_guest = userInfo["is_guest"]as? String
        let id = userInfo["id"]as? String
        
        let myprofile = loggdenUser.value(forKey: USERNAME)as! String
        
        if type == "post" {
            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "DetailsPostandComment") as? DetailsPostandComment {
                    viewcontroller.postDetail_id = Int(post_id ?? "")!
                    rootViewController.pushViewController(viewcontroller, animated: true)
                }
            }
        }
        else if type == "message" {
            let object: [String: Any] = ["id": id, "receiverUsername": name,"avatar":redirect_action]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Chatnotification"), object: object)
            
//            if let rootViewController = self.window!.rootViewController as? UINavigationController {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "ChatConversionController") as? ChatConversionController {
//                    viewcontroller.Id = Int(id)!
//                    viewcontroller.receiverUsername = name
//                    viewcontroller.avatar = redirect_action
//                    rootViewController.pushViewController(viewcontroller, animated: true)
//                }
//            }
        }
        else if type == "user" {
            if myprofile == username {
            }
            else {
                loggdenUser.set(username, forKey: FRIENDSUSERNAME)
                if let rootViewController = self.window!.rootViewController as? UINavigationController {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "FriendsProfileViewController") as? FriendsProfileViewController {
                        rootViewController.pushViewController(viewcontroller, animated: true)
                    }
                }
            }
        }
        else if type == "page" {
            if pageAdmin == "0" {
                if let rootViewController = self.window!.rootViewController as? UINavigationController {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "FriendPageProfileController") as? FriendPageProfileController {
                        viewcontroller.strUserName = username ?? ""
                        viewcontroller.onlyPost = post_privacy ?? ""
                        viewcontroller.onlyInvaite = invite_privacy ?? ""
                        rootViewController.pushViewController(viewcontroller, animated: true)
                    }
                }
            }
            else {
                
                if let rootViewController = self.window!.rootViewController as? UINavigationController {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "MypageProfileViewController") as? MypageProfileViewController {
                        loggdenUser.setValue(username, forKey: UNAME)
                        viewcontroller.strUserName = username ?? ""
                        viewcontroller.onlyPost = post_privacy ?? ""
                        viewcontroller.onlyInvaite = invite_privacy ?? ""
                        rootViewController.pushViewController(viewcontroller, animated: true)
                    }
                }
            }
        }
        else if type == "event" {
            if pageAdmin == "0" {
                if event_type == "public" {
                    if invite_privacy == "only_admins" && post_privacy == "only_admins"  {
                        if let rootViewController = self.window!.rootViewController as? UINavigationController {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "PublicEventProfileController") as? PublicEventProfileController {
                                viewcontroller.strUserName = username ?? ""
                                viewcontroller.onlyPost = post_privacy ?? ""
                                viewcontroller.onlyInvaite = invite_privacy ?? ""
                                viewcontroller.is_page_admin = Int(pageAdmin ?? "")!
                                rootViewController.pushViewController(viewcontroller, animated: true)
                            }
                        }
                    }
                    else if invite_privacy == "only_guests" && post_privacy == "only_guests"  {
                        if let rootViewController = self.window!.rootViewController as? UINavigationController {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "publicAndGuestProfileViewController") as? publicAndGuestProfileViewController {
                                viewcontroller.strUserName = username ?? ""
                                viewcontroller.onlyPost = post_privacy ?? ""
                                viewcontroller.onlyInvaite = invite_privacy ?? ""
                                viewcontroller.is_page_admin = Int(pageAdmin ?? "")!
                                rootViewController.pushViewController(viewcontroller, animated: true)
                            }
                        }
                    }
                    else if invite_privacy == "only_admins" && post_privacy == "only_guests"  {
                        if let rootViewController = self.window!.rootViewController as? UINavigationController {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "PublicEventProfileController") as? PublicEventProfileController {
                                viewcontroller.strUserName = username ?? ""
                                viewcontroller.onlyPost = post_privacy ?? ""
                                viewcontroller.onlyInvaite = invite_privacy ?? ""
                                viewcontroller.is_page_admin = Int(pageAdmin ?? "")!
                                rootViewController.pushViewController(viewcontroller, animated: true)
                            }
                        }
                    }
                    else if invite_privacy == "only_guests" && post_privacy == "only_admins" {
                        if let rootViewController = self.window!.rootViewController as? UINavigationController {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "publicAndGuestProfileViewController") as? publicAndGuestProfileViewController {
                                viewcontroller.strUserName = username ?? ""
                                viewcontroller.onlyPost = post_privacy ?? ""
                                viewcontroller.onlyInvaite = invite_privacy ?? ""
                                viewcontroller.is_page_admin = Int(pageAdmin ?? "")!
                                rootViewController.pushViewController(viewcontroller, animated: true)
                            }
                        }
                    }
                    else {
                        if let rootViewController = self.window!.rootViewController as? UINavigationController {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "PublicEventProfileController") as? PublicEventProfileController {
                                viewcontroller.strUserName = username ?? ""
                                viewcontroller.onlyPost = post_privacy ?? ""
                                viewcontroller.onlyInvaite = invite_privacy ?? ""
                                viewcontroller.is_page_admin = Int(pageAdmin ?? "")!
                                rootViewController.pushViewController(viewcontroller, animated: true)
                            }
                        }
                    }
                }
                else {
                    if is_guest == "1" {
                        if invite_privacy == "only_admins" && post_privacy == "only_admins"  {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "PrivateAndMemberController") as? PrivateAndMemberController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = invite_privacy ?? ""
                                    viewcontroller.is_page_admin = Int(pageAdmin ?? "")!
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if invite_privacy == "only_guests" && post_privacy == "only_guests"  {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "PrivateAndMemberController") as? PrivateAndMemberController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = invite_privacy ?? ""
                                    viewcontroller.is_page_admin = Int(pageAdmin ?? "")!
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if invite_privacy == "only_admins" && post_privacy == "only_guests"  {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "PrivateAndMemberController") as? PrivateAndMemberController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = invite_privacy ?? ""
                                    viewcontroller.is_page_admin = Int(pageAdmin ?? "")!
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if invite_privacy == "only_guests" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "PrivateAndMemberController") as? PrivateAndMemberController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = invite_privacy ?? ""
                                    viewcontroller.is_page_admin = Int(pageAdmin ?? "")!
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "PrivateAndMemberController") as? PrivateAndMemberController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = invite_privacy ?? ""
                                    viewcontroller.is_page_admin = Int(pageAdmin ?? "")!
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                    }
                    else {
                        if let rootViewController = self.window!.rootViewController as? UINavigationController {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "PrivateEventController") as? PrivateEventController {
                                viewcontroller.strUserName = username ?? ""
                                viewcontroller.onlyPrivet = "onlyPrivet"
                                rootViewController.pushViewController(viewcontroller, animated: true)
                            }
                        }
                    }
                }
            }
            else {
                if let rootViewController = self.window!.rootViewController as? UINavigationController {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "EventProfileController") as? EventProfileController {
                        viewcontroller.strUserName = username ?? ""
                        viewcontroller.is_page_admin = Int(pageAdmin ?? "")!
                        rootViewController.pushViewController(viewcontroller, animated: true)
                    }
                }
            }
        }
        else if type == "group" {
            if pageAdmin == "0" {
                if groups_type == "closed" {
                    if status_group == "join" {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                    }
                    else if status_group == "pending" {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                    }
                    else if status_group == "joined" {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "NewUserJoinGroupController") as? NewUserJoinGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                    }
                }
                else if groups_type == "open" {
                    if status_group == "joined" {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                    }
                    else {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                    }
                }
                else {
                    if status_group == "joined" {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openAndSecretGroupController") as? openAndSecretGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                    }
                    else {
                        if member_privacy == "only_admins" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "only_admins" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "only_admins" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "members" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                        else if member_privacy == "members" && post_privacy == "everyone" {
                            if let rootViewController = self.window!.rootViewController as? UINavigationController {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openAndSecretGroupController") as? openAndSecretGroupController {
                                    viewcontroller.strUserName = username ?? ""
                                    viewcontroller.onlyPost = post_privacy ?? ""
                                    viewcontroller.onlyInvaite = member_privacy ?? ""
                                    rootViewController.pushViewController(viewcontroller, animated: true)
                                }
                            }
                        }
                    }
                }
            }
            else {
                if groups_type == "closed" {
                    if let rootViewController = self.window!.rootViewController as? UINavigationController {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "GroupProfileViewController") as? GroupProfileViewController {
                            viewcontroller.strUserName = username ?? ""
                            viewcontroller.onlyPost = post_privacy ?? ""
                            viewcontroller.onlyInvaite = member_privacy ?? ""
                            rootViewController.pushViewController(viewcontroller, animated: true)
                        }
                    }
                }
                else if groups_type == "open" {
                    if let rootViewController = self.window!.rootViewController as? UINavigationController {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "openNewuserGroupController") as? openNewuserGroupController {
                            viewcontroller.strUserName = username ?? ""
                            viewcontroller.onlyPost = post_privacy ?? ""
                            viewcontroller.onlyInvaite = member_privacy ?? ""
                            rootViewController.pushViewController(viewcontroller, animated: true)
                        }
                    }
                }
                else {
                    if let rootViewController = self.window!.rootViewController as? UINavigationController {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let viewcontroller = storyboard.instantiateViewController(withIdentifier: "UserJoinedGroupViewController") as? UserJoinedGroupViewController {
                            viewcontroller.strUserName = username ?? ""
                            viewcontroller.onlyPost = post_privacy ?? ""
                            viewcontroller.onlyInvaite = member_privacy ?? ""
                            rootViewController.pushViewController(viewcontroller, animated: true)
                        }
                    }
                }
            }
        }
        else {
            let isLogin = loggdenUser.bool(forKey: Islogin)
            if isLogin{
                getProfileDetails()
                gotoDashboardController()
            } else {
                self.extendSplashScreenPresentation()
            }
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("will present : \(notification.request.content.userInfo)")
        completionHandler(.alert)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM Token : \(fcmToken)")
        loggdenUser.set(fcmToken, forKey: FCMTOKEN)
    }
}


//extension UIApplication {
//    var statusBarView: UIView? {
//        if responds(to: Selector(("statusBar"))) {
//            return value(forKey: "statusBar") as? UIView
//        }
//        return nil
//    }
//}


extension UIApplication {
var statusBarView: UIView? {
    if #available(iOS 13.0, *) {
        let tag = 5111
        if let statusBar = self.keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
            statusBarView.tag = tag

            self.keyWindow?.addSubview(statusBarView)
            return statusBarView
        }
    } else {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil}
}

//extension UINavigationController {
//
//    func setStatusBar(backgroundColor: UIColor) {
//        let statusBarFrame: CGRect
//        if #available(iOS 13.0, *) {
//            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
//        } else {
//            statusBarFrame = UIApplication.shared.statusBarFrame
//        }
//        let statusBarView = UIView(frame: statusBarFrame)
//        statusBarView.backgroundColor = UIColor.white//backgroundColor
//        view.addSubview(statusBarView)
//    }
//
//}


