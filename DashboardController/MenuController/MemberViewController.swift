//
//  MemberViewController.swift
//  FriendzPoint
//
//  Created by Anques Technolabs on 23/06/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import Alamofire

class MemberViewController: UIViewController {

    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var lblActiveDate: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var viewExpiry: UIView!
    @IBOutlet weak var viewActive: UIView!
    @IBOutlet weak var viewCurrent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    
    var arrPlan = [["type":"BASIC","Price":"10 For 30 days"],["type":"STANDARD","Price":"499 For 180 days"],["type":"BASIC","Price":"10 For 30 days"]]
    
    var planData = [DatumAds]()
    var wc = Webservice.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getActivePlan()
        getPlan()
        setDefault()
        // Do any additional setup after loading the view.
    }
    
    func setDefault() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.header.bounds
        
        gradientLayer.colors = [UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor, UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        header.layer.addSublayer(gradientLayer)
        header.addSubview(btnback)
        header.addSubview(lblTitle)
        
        if UIScreen.main.bounds.width == 320 {
        } else if UIScreen.main.bounds.width == 414 {
            gradientLayer.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 414, height: header.bounds.size.height)
        }
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
        
        viewCurrent.layer.borderWidth = 1
        viewCurrent.layer.borderColor = UIColor.blue.cgColor
        viewCurrent.layer.cornerRadius = 8
        viewCurrent.clipsToBounds = true
        
        viewActive.layer.borderWidth = 1
        viewActive.layer.borderColor = UIColor.blue.cgColor
        viewActive.layer.cornerRadius = 8
        viewActive.clipsToBounds = true
        
        viewExpiry.layer.borderWidth = 1
        viewExpiry.layer.borderColor = UIColor.blue.cgColor
        viewExpiry.layer.cornerRadius = 8
        viewExpiry.clipsToBounds = true
    }
    
    func getActivePlan() {
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN,"Xapi": XAPI]
        wc.callGETSimplewebservice(url: ActivePlan, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response: ActivePlanResponsModel?) in
            print(response)
            if success {
                let suc = response?.success
                if suc == true {
                    let data = response?.data
                    self.lblPlan.text = data?.name
                    self.lblActiveDate.text = data?.activationDate
                    self.lblExpiryDate.text = data?.expiryDate
                }
            }
        }
    }
    
    func getPlan() {
        
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization":BEARERTOKEN]
        wc.callGETSimplewebservice(url: Advertise, parameters: [:], headers: headers, fromView: self.view, isLoading: true) { (success, response: AdvertiseResponsModel?) in
            print(response)
            if success {
                let suc = response?.success
                if suc == true {
                    self.planData = response!.data
                    self.tblView.reloadData()
                }
            }
        }
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

extension MemberViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = planData[indexPath.row]
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! tblMemberCell
        cell.lblTitle.text = data.packageName
        let price = data.price
        let disc = " For " + String(data.days) + " days"
        let finalstring = String(price) + disc
        cell.backView.addSubview(cell.lblTitle)
        cell.backView.addSubview(cell.lblPrice)
        cell.backView.addSubview(cell.btnBuy)
        cell.lblPrice.text = rupee + finalstring
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
}


class tblMemberCell: UITableViewCell {
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnBuy: UIButton! {
        didSet {
            btnBuy.layer.cornerRadius = btnBuy.bounds.height / 2
            btnBuy.clipsToBounds = true
        }
    }
    @IBOutlet weak var backView: GradientView! {
        didSet {
            backView.layer.cornerRadius = 10
            backView.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
}


@IBDesignable
open class GradientView: UIView {
    @IBInspectable
    public var startColor = UIColor(red: 79/255, green: 199/255, blue: 249/255, alpha: 1).cgColor {
        didSet {
            gradientLayer.colors = [startColor, endColor]
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var endColor = UIColor(red: 238/255, green: 209/255, blue: 71/255, alpha: 1).cgColor {
        didSet {
            gradientLayer.colors = [startColor, endColor]
            setNeedsDisplay()
        }
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [self.startColor, self.endColor]
        return gradientLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 1)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(gradientLayer, at: 1)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}


import UIKit

@IBDesignable class GradientView1: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    @IBInspectable var topColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = 1
        
    }
    
    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = self.gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        self.gradientLayer?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.gradientLayer?.add(animation, forKey:"animateGradient")
    }
}


@IBDesignable class GradientView2: UIImageView {
    
    private var gradientLayer: CAGradientLayer!
    
    @IBInspectable var topColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        self.gradientLayer = self.layer as? CAGradientLayer
        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = 1
        
    }
    
    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = self.gradientLayer?.colors
        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
        self.gradientLayer?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.gradientLayer?.add(animation, forKey:"animateGradient")
    }
}



import UIKit
@IBDesignable
class LDGradientView: UIView {

    // the gradient start colour
    @IBInspectable var startColor: UIColor? {
        didSet {
            updateGradient()
        }
    }

    // the gradient end colour
    @IBInspectable var endColor: UIColor? {
        didSet {
            updateGradient()
        }
    }

    // the gradient angle, in degrees anticlockwise from 0 (east/right)
    @IBInspectable var angle: CGFloat = 270 {
        didSet {
            updateGradient()
        }
    }

    // the gradient layer
    private var gradient: CAGradientLayer?

    // initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        installGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        installGradient()
    }

    // Create a gradient and install it on the layer
    private func installGradient() {
        // if there's already a gradient installed on the layer, remove it
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = createGradient()
        self.layer.addSublayer(gradient)
        self.gradient = gradient
    }

    // Update an existing gradient
    private func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor ?? UIColor.clear
            let endColor = self.endColor ?? UIColor.clear
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            let (start, end) = gradientPointsForAngle(self.angle)
            gradient.startPoint = start
            gradient.endPoint = end
        }
    }

    // create gradient layer
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }

    // create vector pointing in direction of angle
    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        // get vector start and end points
        let end = pointForAngle(angle)
        //let start = pointForAngle(angle+180.0)
        let start = oppositePoint(end)
        // convert to gradient space
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }

    // get a point corresponding to the angle
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        // convert degrees to radians
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x,y) is in terms unit circle. Extrapolate to unit square to get full vector length
        if (fabs(x) > fabs(y)) {
            // extrapolate x to unit length
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            // extrapolate y to unit length
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }

    // transform point in unit space to gradient space
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        // input point is in signed unit space: (-1,-1) to (1,1)
        // convert to gradient space: (0,0) to (1,1), with flipped Y axis
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }

    // return the opposite point in the signed unit square
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }

    // ensure the gradient gets initialized when the view is created in IB
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        installGradient()
        updateGradient()
    }
}
