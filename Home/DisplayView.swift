//
//  DisplayView.swift
//  FriendzPoint
//
//  Created by Anques on 13/01/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit

class DisplayView: UIView {

    @IBOutlet weak var imgPost: UIImageView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }

//    class func instanceFromNib() -> UIView {
//        return UINib(nibName: "DisplayView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
//     }

        override init(frame: CGRect) {
            super.init(frame: frame)

            //call function
//            loadNib()
           

        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)

//            loadNib()

            //fatalError("init(coder:) has not been implemented")
        }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
           let nib = UINib(nibName: "DisplayView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
           view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           self.addSubview(view);
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

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle: Bundle? = nil) -> UIView? {
      return UINib(
          nibName: nibNamed,
          bundle: bundle
      ).instantiate(withOwner: nil, options: nil)[0] as? UIView
  }
}
