//
//  PostVC.swift
//  FriendzPoint
//
//  Created by Anques on 26/01/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import YPImagePicker
import AVFoundation
import AVKit
import Photos
import MBProgressHUD

class PostVC: UIViewController {

    let appDel = UIApplication.shared.delegate as! AppDelegate
    var selectedItems = [YPMediaItem]()
//    let selectedImageV = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setStatusBar(backgroundColor: .black)
        
        self.view.backgroundColor = .black
        
//        selectedImageV.contentMode = .scaleAspectFit
//        selectedImageV.frame = CGRect(x: 0,
//                                      y: 0,
//                                      width: UIScreen.main.bounds.width,
//                                      height: UIScreen.main.bounds.height * 0.45)
//        view.addSubview(selectedImageV)
        
//        showPicker()
//        
//        if (loggdenUser.value(forKey: BADGECOUNT) != nil) {
//            let count = loggdenUser.value(forKey: BADGECOUNT)as! Int
//            if count == 0{
//                currentTabBar!.setBadgeText(nil, atIndex: 3)
//            }
//            else{
//                currentTabBar!.setBadgeText(String(count), atIndex: 3)
//            }
//        }

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        showPicker()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Configuration
    @objc
    func showPicker() {

        var config = YPImagePickerConfiguration()

        /* Uncomment and play around with the configuration 👨‍🔬 🚀 */

        /* Set this to true if you want to force the  library output to be a squared image. Defaults to false */
//         config.library.onlySquare = true

        /* Set this to true if you want to force the camera output to be a squared image. Defaults to true */
        // config.onlySquareImagesFromCamera = false

        /* Ex: cappedTo:1024 will make sure images from the library or the camera will be
           resized to fit in a 1024x1024 box. Defaults to original image size. */
        // config.targetImageSize = .cappedTo(size: 1024)

        /* Choose what media types are available in the library. Defaults to `.photo` */
        config.library.mediaType = .photoAndVideo
        config.library.itemOverlayType = .grid
        /* Enables selecting the front camera by default, useful for avatars. Defaults to false */
        // config.usesFrontCamera = true

        /* Adds a Filter step in the photo taking process. Defaults to true */
        // config.showsFilters = false

        /* Manage filters by yourself */
//        config.filters = [YPFilter(name: "Mono", coreImageFilterName: "CIPhotoEffectMono"),
//                          YPFilter(name: "Normal", coreImageFilterName: "")]
//        config.filters.remove(at: 1)
//        config.filters.insert(YPFilter(name: "Blur", coreImageFilterName: "CIBoxBlur"), at: 1)

        /* Enables you to opt out from saving new (or old but filtered) images to the
           user's photo library. Defaults to true. */
        config.shouldSaveNewPicturesToAlbum = false

        /* Choose the videoCompression. Defaults to AVAssetExportPresetHighestQuality */
        config.video.compression = AVAssetExportPresetMediumQuality

        /* Defines the name of the album when saving pictures in the user's photo library.
           In general that would be your App name. Defaults to "DefaultYPImagePickerAlbumName" */
        // config.albumName = "ThisIsMyAlbum"

        /* Defines which screen is shown at launch. Video mode will only work if `showsVideo = true`.
           Default value is `.photo` */
        config.startOnScreen = .library

        /* Defines which screens are shown at launch, and their order.
           Default value is `[.library, .photo]` */
        config.screens = [.library, .photo]//, .video

        /* Can forbid the items with very big height with this property */
//        config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8

        /* Defines the time limit for recording videos.
           Default is 30 seconds. */
        // config.video.recordingTimeLimit = 5.0

        /* Defines the time limit for videos from the library.
           Defaults to 60 seconds. */
        config.video.libraryTimeLimit = 500.0

        /* Adds a Crop step in the photo taking process, after filters. Defaults to .none */
//        config.showsCrop = .rectangle(ratio: (16/9))

        /* Defines the overlay view for the camera. Defaults to UIView(). */
        // let overlayView = UIView()
        // overlayView.backgroundColor = .red
        // overlayView.alpha = 0.3
        // config.overlayView = overlayView

        /* Customize wordings */
        config.wordings.libraryTitle = "Gallery"

        /* Defines if the status bar should be hidden when showing the picker. Default is true */
        config.hidesStatusBar = false

        /* Defines if the bottom bar should be hidden when showing the picker. Default is false */
        config.hidesBottomBar = false

        config.maxCameraZoomFactor = 2.0

        config.library.maxNumberOfItems = 5
        config.gallery.hidesRemoveButton = false

        /* Disable scroll to change between mode */
        // config.isScrollToChangeModesEnabled = false
//        config.library.minNumberOfItems = 2

        /* Skip selection gallery after multiple selections */
        // config.library.skipSelectionsGallery = true

        /* Here we use a per picker configuration. Configuration is always shared.
           That means than when you create one picker with configuration, than you can create other picker with just
           let picker = YPImagePicker() and the configuration will be the same as the first picker. */

        /* Only show library pictures from the last 3 days */
        //let threDaysTimeInterval: TimeInterval = 3 * 60 * 60 * 24
        //let fromDate = Date().addingTimeInterval(-threDaysTimeInterval)
        //let toDate = Date()
        //let options = PHFetchOptions()
        // options.predicate = NSPredicate(format: "creationDate > %@ && creationDate < %@", fromDate as CVarArg, toDate as CVarArg)
        //
        ////Just a way to set order
        //let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        //options.sortDescriptors = [sortDescriptor]
        //
        //config.library.options = options

        config.library.preselectedItems = selectedItems


        // Customise fonts
        //config.fonts.menuItemFont = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        //config.fonts.pickerTitleFont = UIFont.systemFont(ofSize: 22.0, weight: .black)
        //config.fonts.rightBarButtonFont = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        //config.fonts.navigationBarTitleFont = UIFont.systemFont(ofSize: 22.0, weight: .heavy)
        //config.fonts.leftBarButtonFont = UIFont.systemFont(ofSize: 22.0, weight: .heavy)

        let picker = YPImagePicker(configuration: config)

        picker.imagePickerDelegate = self

        /* Change configuration directly */
        // YPImagePickerConfiguration.shared.wordings.libraryTitle = "Gallery2"

        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in

            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: false, completion: nil)
                
                //self.appDel.gotoDashboardController()
                self.currentTabBar?.setIndex(0)
                return
            }
            _ = items.map { print("🧀 \($0)") }

            self.selectedItems = items
            

            
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    
                    picker.dismiss(animated: false, completion: nil)
                    let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let obj = launchStoryBoard.instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
                    print("photo: ",self.selectedItems)
                    print("photoimg: ",items)
                    obj.selectedImageV.image = photo.image
                    for i in items{
                        switch i {
                        case .photo(let photo1):
                            obj.arrImages.append(photo1.image)
                            break
                            
                        case .video(v: let v):
                            break
                        }
                        
                    }
                    obj.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(obj, animated: false, completion: nil)
//                    self.show(obj, sender: self)
//                    self.navigationController?.pushViewController(obj, animated: true)
                case .video(let video):
                    let launchStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let obj = launchStoryBoard.instantiateViewController(withIdentifier: "NewPostVC") as! NewPostVC
                    obj.selectedImageV.image = video.thumbnail
                    
                    let assetURL = video.url
                    let playerVC = AVPlayerViewController()
                    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
                    playerVC.player = player
                    
                    obj.videoUrlPath = video.url.path
                    
//                    self.navigationController?.pushViewController(obj, animated: false)
                    obj.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(obj, animated: false, completion: nil)

                    picker.dismiss(animated: false, completion: { [weak self] in
                        self?.present(playerVC, animated: false, completion: nil)
                        
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                    
                    
                }
            }
        }

        /* Single Photo implementation. */
        // picker.didFinishPicking { [unowned picker] items, _ in
        //     self.selectedItems = items
        //     self.selectedImageV.image = items.singlePhoto?.image
        //     picker.dismiss(animated: true, completion: nil)
        // }

        /* Single Video implementation. */
        //picker.didFinishPicking { [unowned picker] items, cancelled in
        //    if cancelled { picker.dismiss(animated: true, completion: nil); return }
        //
        //    self.selectedItems = items
        //    self.selectedImageV.image = items.singleVideo?.thumbnail
        //
        //    let assetURL = items.singleVideo!.url
        //    let playerVC = AVPlayerViewController()
        //    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
        //    playerVC.player = player
        //
        //    picker.dismiss(animated: true, completion: { [weak self] in
        //        self?.present(playerVC, animated: true, completion: nil)
        //        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
        //    })
        //}

        present(picker, animated: true, completion: nil)
    }

}

// Support methods
extension PostVC {
    /* Gives a resolution for the video by URL */
    func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}

// YPImagePickerDelegate
extension PostVC: YPImagePickerDelegate {
    func noPhotos() {}

    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true// indexPath.row != 2
    }
}
