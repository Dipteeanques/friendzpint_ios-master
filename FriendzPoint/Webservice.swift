//
//  LoginViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 10/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class Webservice: NSObject {
    
    func webservice(name: String) -> String {
        return name
    }
    
    //MARK: - Simple webservice Method
    func callSimplewebservice<T: Decodable>(url: String, parameters:[String: Any],headers:HTTPHeaders, fromView: UIView, isLoading: Bool, complition: @escaping (_ success: Bool, _ response: (T)?) -> Void) {
        
        let activityIndicator = UIActivityIndicatorView()
        if isLoading {
            activityIndicator.style = .whiteLarge
            activityIndicator.center = fromView.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            fromView.addSubview(activityIndicator)
        }
        let mutable = NSMutableDictionary()
        mutable.addEntries(from: parameters as [String : Any])
//        print(mutable)
        var header = HTTPHeaders()
        header = headers
        AF.request(url, method: .post, parameters: mutable as? Parameters, encoding: URLEncoding.default, headers: header).responseDecodable { (response: DataResponse<T>) in

           // print("R1: ",response)
            if isLoading {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
            }
            switch response.result {
            case .success(_):
                complition(true, response.result.value)
                break
            case .failure(_):
                 complition(false, response.result.value)
                break
            }
        }
    }
    
    //MARK: - Simple GET webservice Method
    func callGETSimplewebservice<T: Decodable>(url: String,parameters:[String: Any],headers: HTTPHeaders, fromView: UIView, isLoading: Bool, complition: @escaping (_ success: Bool, _ response: (T)?) -> Void) {
        
        let activityIndicator = UIActivityIndicatorView()
        if isLoading {
            activityIndicator.style = .gray//.whiteLarge
            activityIndicator.center = fromView.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            fromView.addSubview(activityIndicator)
        }
        let mutable = NSMutableDictionary()
        mutable.addEntries(from: parameters)
        AF.request(url, method: .get, parameters:mutable as? Parameters, encoding: URLEncoding.default, headers: headers).responseDecodable { (response: DataResponse<T>) in
            print(response)
            if isLoading {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
            }
            switch response.result {
            case .success(_):
                complition(true, response.result.value)
            case .failure(_):
                complition(false, response.result.value)
            }
        }
    }
    
    //MARK: - Multiple image upload webservice method
    func callMultimplewebservice<T: Decodable>(url: String, methods:String, parameters:[String: Any],headers:HTTPHeaders ,uploadData:[UploadParameterMode], fromView: UIView, isLogin: Bool, isLoading: Bool, complition: @escaping (_ success: Bool, _ response: (T)?) -> Void) {
        
        let activityIndicator = UIActivityIndicatorView()
        if isLoading {
            activityIndicator.style = .whiteLarge
            activityIndicator.center = fromView.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            fromView.addSubview(activityIndicator)
        }
        
        let mutable = NSMutableDictionary()
        mutable.addEntries(from: parameters as [String : Any])
        
        let finalURL = url
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in mutable {
                
                if let quantity = value as? NSNumber {
                    let assdsad = quantity.stringValue
                    //print(key + " : " + assdsad)
                    multipartFormData.append(assdsad.data(using: String.Encoding.utf8)!, withName: key as! String)
                } else if let quantity = value as? CGFloat {
                    let assdsad = String(format: "%f",quantity)
                    //print(key + " : " + assdsad)
                    multipartFormData.append(assdsad.data(using: String.Encoding.utf8)!, withName: key as! String)
                }
                else if let quantity = value as? String {
                    //print(key + " : " + quantity)
                    multipartFormData.append(quantity.data(using: String.Encoding.utf8)!, withName: key as! String)
                }
                
            }
            
            for mUpload in uploadData {
                print(mUpload.parameterName,mUpload.parameterData)
                multipartFormData.append(mUpload.parameterData, withName: mUpload.parameterName, fileName: mUpload.fileName, mimeType: mUpload.fileMime)
            }
        }, usingThreshold: UInt64.init(), to: finalURL, method: .post, headers: headers).responseDecodable { (response: DataResponse<T>) in
            
            if isLoading {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
            }
            switch response.result {
            case .success(_):
                complition(true, response.result.value)
                break
            case .failure(_):
                complition(false, nil)
                break
            }
        }
    }
    
    //MARK: - Single upload webservice method
    func calluploadwebservice<T: Decodable>(url: String, methods:String, parameters:[String: Any],headers:HTTPHeaders,uploadData:UploadParameterMode, fromView: UIView, isLogin: Bool, isLoading: Bool, complition: @escaping (_ success: Bool, _ response: (T)?) -> Void) {
        
        let activityIndicator = UIActivityIndicatorView()
        if isLoading {
            activityIndicator.style = .whiteLarge
            activityIndicator.center = fromView.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            fromView.addSubview(activityIndicator)
        }
        let finalURL = url
        let mutable = NSMutableDictionary()
        mutable.addEntries(from: parameters as [String : Any])
        
        var header = HTTPHeaders()
        header = headers
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in mutable {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key as! String)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                }
            }
            print(uploadData.parameterName,uploadData.parameterData)
            multipartFormData.append(uploadData.parameterData, withName: uploadData.parameterName, fileName: uploadData.fileName, mimeType: uploadData.fileMime)
            print("Multiplard Data : \(multipartFormData)")
            
        },usingThreshold: UInt64.init(), to: finalURL, method: .post, headers: header).responseDecodable { (response: DataResponse<T>) in
            
            print(response)
            if isLoading {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
            }
            switch response.result {
            case .success(_):
                complition(true, response.result.value)
                break
            case .failure(_):
                complition(false, nil)
                break
            }
        }
    }
}
    

