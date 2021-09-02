//
//  ApiHandler.swift
//  FriendzPoint
//
//  Created by Anques on 13/07/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

private let SharedInstance = ApiHandler()

class ApiHandler:NSObject{
    
    class var sharedInstance : ApiHandler {
        return SharedInstance
    }
    
    //MARK:- downloadVideo
    func downloadVideo(video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        var parameters = [String : String]()
        parameters = [
            "video_id" : video_id
        ]
        let finalUrl = DOWNLOADVIDEO
        
        print(finalUrl)
        print(parameters)
        AF.request(URL(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("DRes: ",response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:-showReportReasons
    func showReportReasons(completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        
        var parameters = [String : String]()
        parameters = [
            "":""
            
        ]
        
        let finalUrl = SHOWREPORTREASONS
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-reportVideo
    func reportVideo(user_id:String,video_id:String,report_reason_id:String,description:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        let finalUrl = REPORTVIDEO
        var parameters = [String : String]()
        parameters = [
            "user_id"           : user_id,
            "video_id"          : video_id,
            "report_reason_id"  : report_reason_id,
            "description"       : description,
            
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
//    func Search(user_id:String,type:String,keyword:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
//
//        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
//        let BEARERTOKEN = BEARER + token
//        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
//                                    "Accept" : ACCEPT,
//                                    "Authorization":BEARERTOKEN]
//
//        let parameters = [
//                   "user_id"        : user_id,
//                   "type"           : type,
//                   "keyword"        : keyword,
//                   "starting_point" : starting_point
//               ]
//        print(parameters)
//
//        let urlString = DISCOVERYSEARCH
//        print(urlString)
//        AF.request(urlString, method: .post, parameters: parameters,encoding: URLEncoding.default, headers: headers).responseJSON {
//        response in
//            print("Sresponse",response)
//          switch response.result {
//                        case .success:
//                            print(response)
//
//                            break
//                        case .failure(let error):
//
//                            print(error)
//                        }
//        }
//    }
    
//    func Search(user_id:String,type:String,keyword:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
//        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
//        let BEARERTOKEN = BEARER + token
//        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
//                                    "Accept" : ACCEPT,
//                                    "Authorization":BEARERTOKEN]
//        let finalUrl = DISCOVERYSEARCH
////        var parameters = [String : String]()
//        let parameters = [
//            "user_id"        : user_id,
//            "type"           : type,
//            "keyword"        : keyword,
//            "starting_point" : starting_point
//        ]
//        print(finalUrl)
//        print(parameters)
//
//        print(finalUrl)
//        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//            print(response.result)
//            print("SearchR :",response)
//            switch response.result {
//
//            case .success(_):
//                if let json = response.value
//                {
//                    do {
//                        let dict = json as? NSDictionary
//                        print(dict)
//                        completionHandler(true, dict)
//
//                    } catch {
//                        completionHandler(false, nil)
//                    }
//                }
//                break
//            case .failure(let error):
//                if let json = response.value
//                {
//                    do {
//                        let dict = json as? NSDictionary
//                        print(dict)
//                        completionHandler(true, dict)
//
//                    } catch {
//                        completionHandler(false, nil)
//                    }
//                }
//                break
//            }
//        }
//    }
    
    //MARK:- Search
    func Search(user_id:String,type:String,keyword:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "type"           : type,
            "keyword"        : keyword,
            "starting_point" : starting_point
        ]
        let finalUrl = DISCOVERYSEARCH
//        print(headers)
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print("SResponse: ",response.result)
            print("responseS: ",response)

            if JSONSerialization.isValidJSONObject(response.description.data(using: .utf8)!) {
                    print("valid")
            } else {
                    print("invalid")
            }
            switch response.result {

            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print("Ssuccess: ",dict)
                        completionHandler(true, dict)

                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                print(error)
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print("Sfailure: ",dict)
                        completionHandler(true, dict)

                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-addSoundFavourite
    func addSoundFavourite(user_id:String,sound_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            "sound_id"   : sound_id,
            
            
        ]
        let finalUrl = ADDFAVORITESOUND
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- showDiscoverySections
    
    func showDiscoverySections(completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let finalUrl = SHOWDISCOVERYSECTION
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        var parameters = [String : String]()
        parameters = [ "":""
                       
        ]
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- showAppSlider
    func showAppSlider(completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        var parameters = [String : String]()
        parameters = [
            "" : ""
        ]
        let finalUrl = SHOWAPPSLIDER
        
        print(finalUrl)
        print(parameters)
        
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
}
