//
//  AllSoundViewController.swift
//  FriendzPoint
//
//  Created by Anques on 23/06/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class AllSoundViewController: UIViewController {

    var wc = Webservice.init()
    var arrAllSound : ShowSectionResponseModel?
    
    @IBOutlet weak var tblAllSound: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        GetAllSound()
    }
    

    func GetAllSound(){
        let user_id = UserDefaults.standard.value(forKey: "TimeLine_id")
        let parameters = ["starting_point":"0",
                          "user_id":user_id ?? 0,
                          "sound_section_id":"2"] as [String : Any]
        print("parameters: ",parameters)
        let token = loggdenUser.value(forKey: SHORTTOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Api-Key": ReelsXAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        print("headers: ",headers)
        print("SHOWSECTION: ",SHOWSECTION)
        wc.callSimplewebservice(url: SHOWSECTION, parameters: parameters, headers: headers, fromView: self.view, isLoading: true) { (sucess, response: ShowSectionResponseModel?) in
            print("Favoriteresponse:",response)
//            print(response)
            if sucess {
                
                //                self.transparentView.backgroundColor = .clear//UIColor.black.withAlphaComponent(0.5)
                //                self.imgLogo.isHidden = false
                let sucessMy = response?.code
                if sucessMy == 200{
                    print("hello success..")
                    self.arrAllSound = response
                    self.tblAllSound.reloadData()
                }
                else {
                    
                }
            }
            else {
                print(response)
            }
        }
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated:false, completion: nil)
    }
    
}

extension AllSoundViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAllSound?.msg.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllSoundCell
        let favObj = arrAllSound?.msg[indexPath.row].Sound
        cell.lblMusicTitle.text = favObj?.name
        cell.lblMusicSignerName.text = favObj?.description
        cell.lblMusicTime.text = favObj?.duration
        cell.imgSound.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: favObj!.thum))!), placeholderImage: UIImage(named:"noMusicIcon"))
        
        //        soundCell.btnFav.addTarget(self, action: #selector(allSoundsViewController.btnSoundFavAction(_:)), for:.touchUpInside)
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(btnSelectAction(_:)), for:.touchUpInside)
        cell.btnSelect.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arrAllSound?.msg[indexPath.row].Sound
        loadAudio(audioURL: (AppUtility?.detectURL(ipString: obj?.audio ?? ""))!, ip: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let visiblePaths = tblAllSound.indexPathsForVisibleRows
        
        for i in visiblePaths!  {
            let cell = tblAllSound.cellForRow(at: i) as? AllSoundCell
            //            cell.playImg.image = UIImage(named: "ic_play_icon")
            cell?.imgPlay.image = UIImage(named: "Play")
            cell?.btnSelect.isHidden = true
            
        }
    }
    func loadAudio(audioURL: String,ip:IndexPath) {
        
        let cell = tblAllSound.cellForRow(at: ip) as! AllSoundCell
        
        let kTestImage = "26"
        
        let dictionary: Dictionary <String, AnyObject> = SpringboardData.springboardDictionary(title: "audioP", artist: "audioP Artist", duration: Int (300.0), listScreenTitle: "audioP Screen Title", imagePath: Bundle.main.path(forResource: "Spinner-1s-200px", ofType: "gif") ?? "")
        
        cell.imgPlay.isHidden = true
        cell.loadIndicator.startAnimating()
        
        TPGAudioPlayer.sharedInstance().playPauseMediaFile(audioUrl: URL(string: audioURL)! as NSURL, springboardInfo: dictionary, startTime: 0.0, completion: {(_ , stopTime) -> () in
            //
            cell.imgPlay.isHidden = false
            cell.loadIndicator.stopAnimating()
            //            self.hideLoadingIndicator()
            //            self.setupSlider()
            self.updatePlayButton(ip: ip)
            
            print("there",stopTime)
        } )
    }
    func updatePlayButton(ip:IndexPath) {
        
        let cell = tblAllSound.cellForRow(at: ip) as! AllSoundCell
        
        let playPauseImage = (TPGAudioPlayer.sharedInstance().isPlaying ? UIImage(named: "Pause") : UIImage(named: "Play"))
        
        cell.btnSelect.isHidden = TPGAudioPlayer.sharedInstance().isPlaying ? false : true
        //        self.playButton.setImage(playPauseImage, for: UIControlState())
        cell.imgPlay.image = playPauseImage
    }
    
    //    MARK:- BTN FAV SOUND ACTION
    @objc func btnSoundFavAction(_ sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblAllSound)
        let indexPath = self.tblAllSound.indexPathForRow(at:buttonPosition)
        let cell = self.tblAllSound.cellForRow(at: indexPath!) as! AllSoundCell
        
        //        let btnFavImg = cell.btnFav.currentImage
        //
        //        if btnFavImg == UIImage(named: "btnFavEmpty"){
        //            cell.btnFav.setImage(UIImage(named: "btnFavFilled"), for: .normal)
        //        }else{
        //            cell.btnSelect.setImage(UIImage(named: "btnFavEmpty"), for: .normal)
        //        }
        
        let obj = arrAllSound?.msg[sender.tag]
        
        //            addFavSong(soundID: obj.id, btnFav: cell.favBtn)
    }
    
    //    MARK:- SELECT SOUND ACTION
    @objc func btnSelectAction(_ sender : UIButton) {
        
        TPGAudioPlayer.sharedInstance().player.pause()
        AppUtility?.startLoader(view: self.view)
        print("btnSelect Tapped")
        let newObj = arrAllSound?.msg[sender.tag].Sound
        
        UserDefaults.standard.set(newObj?.audio, forKey: "url")
        UserDefaults.standard.set(newObj?.name, forKey: "selectedSongName")
        
        print("newObj.audioURL,: ",newObj?.audio)
        
        if let audioUrl = URL(string: newObj?.audio ?? "") {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                //                    self.goBack()
                DispatchQueue.main.async {
                    
                    AppUtility?.stopLoader(view: self.view!)
                    //                    NotificationCenter.default.post(name: Notification.Name("dismissController"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
                    //                        self.dismiss(animated: true, completion: nil)
                    
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
                
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder @ loc: ",location)
                        DispatchQueue.main.async {
                            
                            AppUtility?.stopLoader(view: self.view)
                            //                            NotificationCenter.default.post(name: Notification.Name("dismissController"), object: nil)
                            NotificationCenter.default.post(name: Notification.Name("loadAudio"), object: nil)
                            //                                self.dismiss(animated: true, completion: nil)
                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        }
                        
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        AppUtility?.stopLoader(view: self.view)
                    }
                    
                }).resume()
            }
        }
        
    }
}
