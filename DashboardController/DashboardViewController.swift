//
//  DashboardViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 11/05/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit
import Photos
import DKPhotoGallery
import DKImagePickerController

class DashboardViewController: UIViewController,AZTabBarDelegate {
    
    var counter = 0
    var tabController:AZTabBarController!
    var audioId: SystemSoundID!

    @IBOutlet weak var lblbadge: BadgeLabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabCollection: UICollectionView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var iconSearch: UIImageView!
    @IBOutlet weak var btnCameraleading: NSLayoutConstraint!
    @IBOutlet weak var btnnotitrailing: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var gridentView: UIView!
    @IBOutlet weak var btncamera: UIButton!
    
    //MARK: - Variable
    var arrtab = [#imageLiteral(resourceName: "Feed"),#imageLiteral(resourceName: "Friend"),#imageLiteral(resourceName: "Group"),#imageLiteral(resourceName: "chat"),#imageLiteral(resourceName: "Profile"),#imageLiteral(resourceName: "menu")]
    var arrtabBlue = [#imageLiteral(resourceName: "FeedBlue"),#imageLiteral(resourceName: "FriendBlue"),#imageLiteral(resourceName: "GroupBlue"),#imageLiteral(resourceName: "ChatBlue"),#imageLiteral(resourceName: "ProfileBlue"),#imageLiteral(resourceName: "MenuBlue")]
    var selectedIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func createGradientLayer() {
         audioId = createAudio()
        var icons = [UIImage]()
        icons.append(#imageLiteral(resourceName: "Feed"))
        icons.append(#imageLiteral(resourceName: "Friend"))
        icons.append(#imageLiteral(resourceName: "Group"))
        icons.append(#imageLiteral(resourceName: "chat"))
        icons.append(#imageLiteral(resourceName: "Profile"))
        icons.append(#imageLiteral(resourceName: "menu"))
        
        var sIcons = [UIImage]()
        sIcons.append(#imageLiteral(resourceName: "FeedBlue"))
        sIcons.append(#imageLiteral(resourceName: "FriendBlue"))
        sIcons.append(#imageLiteral(resourceName: "GroupBlue"))
        sIcons.append(#imageLiteral(resourceName: "ChatBlue"))
        sIcons.append(#imageLiteral(resourceName: "ProfileBlue"))
        sIcons.append(#imageLiteral(resourceName: "MenuBlue"))
        
        tabController = .insert(into: self, withTabIcons: icons, andSelectedIcons: sIcons)
        tabController.delegate = self
        tabController.setViewController(NewsfeedViewController.instance(), atIndex: 0)
        tabController.setViewController(FriendsViewController.instance(), atIndex: 1)
        tabController.setViewController(GroupsViewController.instance(), atIndex: 2)
        tabController.setViewController(ChatViewController.instance(), atIndex: 3)
        tabController.setViewController(ProfileViewController.instance(), atIndex: 4)
        tabController.setViewController(MenuViewController.instance(), atIndex: 5)
    }
    
    func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int) -> UIStatusBarStyle {
        return (index % 2) == 0 ? .default : .lightContent
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int) -> Bool {
        return true//index != 2 && index != 3
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldAnimateButtonInteractionAtIndex index: Int) -> Bool {
        return false
    }
    
    func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int) {
        print("didMoveToTabAtIndex \(index)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
    }
    
    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int) {
        print("didSelectTabAtIndex \(index)")
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        if index == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Timeline"), object: nil)
            currentTabBar?.setIndex(0)
        }
        else if index == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FriendsRequest"), object: nil)
            currentTabBar?.setIndex(1)
        }
        else if index == 2 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Group"), object: nil)
            currentTabBar?.setIndex(2)
        }
        else if index == 3 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Chat"), object: nil)
            currentTabBar?.setIndex(3)
        }
        else if index == 4 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Profile"), object: nil)
            currentTabBar?.setIndex(4)
        }
        else if index == 5 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Menu"), object: nil)
            currentTabBar?.setIndex(5)
        }
    }
    
    func tabBar(_ tabBar: AZTabBarController, willMoveToTabAtIndex index: Int) {
        print("willMoveToTabAtIndex \(index)")
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        if index == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Timeline"), object: nil)
            currentTabBar?.setIndex(0)
        }
        else if index == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FriendsRequest"), object: nil)
            currentTabBar?.setIndex(1)
        }
        else if index == 2 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Group"), object: nil)
            currentTabBar?.setIndex(2)
        }
        else if index == 3 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Chat"), object: nil)
            currentTabBar?.setIndex(3)
        }
        else if index == 4 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Profile"), object: nil)
            currentTabBar?.setIndex(4)
        }
        else if index == 5 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Menu"), object: nil)
            currentTabBar?.setIndex(5)
        }
    }
    
    func tabBar(_ tabBar: AZTabBarController, didLongClickTabAtIndex index: Int) {
        print("didLongClickTabAtIndex \(index)")
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
    }
    
    
    func tabBar(_ tabBar: AZTabBarController, systemSoundIdForButtonAtIndex index: Int) -> SystemSoundID? {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Videopause"), object: nil)
        return tabBar.selectedIndex == index ? nil : audioId
    }
    
    func createAudio()->SystemSoundID{
        var soundID: SystemSoundID = 0
        let soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "Tab" as CFString?, "mp3" as CFString?, nil)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        return soundID
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

