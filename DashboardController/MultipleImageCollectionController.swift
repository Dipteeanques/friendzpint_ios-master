//
//  MultipleImageCollectionController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 11/06/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import UIKit

class MultipleImageCollectionController: UIViewController {

    @IBOutlet weak var pagecontroller: UIPageControl!
    @IBOutlet weak var collectionImage: UICollectionView!
    var arrImage = [#imageLiteral(resourceName: "LoginBackground"),#imageLiteral(resourceName: "Splash"),#imageLiteral(resourceName: "Login Logo"),#imageLiteral(resourceName: "LoginBackground"),#imageLiteral(resourceName: "Login Logo"),#imageLiteral(resourceName: "Splash"),#imageLiteral(resourceName: "Splash"),#imageLiteral(resourceName: "Splash"),#imageLiteral(resourceName: "Login Logo"),#imageLiteral(resourceName: "Login Logo"),#imageLiteral(resourceName: "Login Logo")]
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pagecontroller.numberOfPages = arrImage.count
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
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

extension MultipleImageCollectionController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionImage.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let img = cell.viewWithTag(101)as! UIImageView
        img.image = arrImage[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionImage.frame.size.width, height: collectionImage.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageWidth = scrollView.frame.width
        self.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.pagecontroller.currentPage = self.currentPage
    }
    
    
}
