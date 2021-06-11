//
//  CreateArticlesVC.swift
//  FriendzPoint
//
//  Created by Anques on 26/05/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import RichEditorView

class CreateArticlesVC: UIViewController, ImagePickerDelegate, UITextFieldDelegate{
    

    
    @IBOutlet weak var txtImage: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtArticleLink: UITextField!
    @IBOutlet weak var txtTags: TextFieldWithPadding!
    @IBOutlet weak var txtDescription: UITextView!{
        didSet{
            txtDescription.layer.cornerRadius = 15
            txtDescription.clipsToBounds = true
            txtDescription.layer.borderColor = UIColor.gray.cgColor
            txtDescription.layer.borderWidth = 0.5
        }
    }
    
    @IBOutlet weak var txtVideoLinkHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtVideoLink: UITextField!
    
    @IBOutlet weak var txtUploadImage: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!{
        didSet{
            btnSubmit.layer.cornerRadius = btnSubmit.frame.height/2
            btnSubmit.clipsToBounds = true
        }
    }
    

    @IBOutlet weak var transparentView: UIView!{
        didSet{
            transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    @IBOutlet weak var subView: UIView!{
        didSet{
            subView.layer.cornerRadius = 5.0
            subView.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgPreview: UIImageView!
    
    @IBOutlet weak var editorView: RichEditorView!{
        didSet{
            editorView.layer.cornerRadius = 5
            editorView.clipsToBounds = true
            editorView.layer.borderColor = UIColor.gray.cgColor
            editorView.layer.borderWidth = 0.5
        }
    }
    var imagePicker: ImagePicker!
    var ArticleImage = UIImage()
    var imgView = UIImageView()
    
    var strtitle = String()
    var Description = String()
    var strtype = String()
    var strvideo_link = String()
    var strlink = String()
    var strtag = String()
    var strimage = String()
    var article_id = Int()
    var CHECK = String()
    
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.txtDescription.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        self.setupLeftImage(txt: txtUploadImage, imageName: "GalleryShape")
        self.txtVideoLink.isHidden = true
        self.txtVideoLinkHeight.constant = -8
        //   self.SetDropDown(txtDrop: self.txtImage, arrayoption: ["Image", "Video"])
        
        //editor
        editorView.delegate = self
        editorView.inputAccessoryView = toolbar
        editorView.placeholder = "Article Short Description..."
        editorView.keyCommands
        editorView.setTextColor(.black)
        toolbar.delegate = self
        toolbar.editor = editorView
        
//        txtTags.delegate = self
        
        // We will create a custom action that clears all the input text when it is pressed
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar.editor?.html = ""
        }
        
                let itemDone = RichEditorOptionItem(image: nil, title: "Done") { (toolBar) in
                            self.view.endEditing(true)
                        }
        
        //        var options = toolbar.options
        //        options.append(itemDone)
        //        toolbar.options = options
        
        toolbar.options = [RichEditorDefaultOption.undo, RichEditorDefaultOption.redo,RichEditorDefaultOption.bold,RichEditorDefaultOption.italic,RichEditorDefaultOption.strike,RichEditorDefaultOption.underline,RichEditorDefaultOption.indent,RichEditorDefaultOption.outdent, RichEditorDefaultOption.orderedList,RichEditorDefaultOption.unorderedList,RichEditorDefaultOption.alignLeft,RichEditorDefaultOption.alignCenter,RichEditorDefaultOption.alignRight,itemDone]//options
        
        if CHECK == "Edit"{
            if strtype == "0"{
                txtImage.text = "Image"
            }
            else{
                txtImage.text = "Video"
            }
            txtTitle.text = strtitle
            txtArticleLink.text = strlink
            txtVideoLink.text = strvideo_link
            txtTags.text = strtag
           // editorView.inputAccessoryView?.textInputMode = Description
            toolbar.editor?.html = Description
            toolbar.editor?.setTextColor(.black)
            
            imgView.kf.setImage(with: URL(string: strimage),placeholder:UIImage(named: "Placeholder"))
            imgPreview.kf.setImage(with: URL(string: strimage),placeholder:UIImage(named: "Placeholder"))
            ArticleImage = imgView.image ?? UIImage()
            
//            if let url = URL(string: strimage) {
////                let withoutExt = url.deletingPathExtension()
//                let name = url.lastPathComponent
//                let result = name.substring(from: name.index(name.startIndex, offsetBy: 5))
//                print(result)
//                self.txtUploadImage.text = result
//            }
            
        }
        
        
    }
    
    func didSelect(image: UIImage?) {
            print("image:",image)
        self.ArticleImage = image ?? UIImage()
        self.imgPreview.image = image
        self.strimage = "ok"
        self.txtUploadImage.text = "\(String(Int(NSDate().timeIntervalSince1970))).jpg"
    }
    
    
    @IBAction func btnUploadAction(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    func SetDropDown(txtDrop: DropDown, arrayoption: [String]) {
        txtDrop.optionArray = arrayoption//["sdjkh", "nsfflk", "jkfx"]
        //txtDrop.optionIds = [1,2,3]
        txtDrop.selectedRowColor = UIColor(red: 0.00, green: 0.45, blue: 1.00, alpha: 1.00)
        txtDrop.checkMarkEnabled = false
        txtDrop.didSelect{(selectedText , index , id) in
            
            if txtDrop == self.txtImage{
                print("templateID: ",id)
                
                print("Text:",selectedText)
                if selectedText == "Image"{
//                    self.txtUploadImage.placeholder = "Upload Image"
                }
                else{
//                    self.txtUploadImage.placeholder = "Upload Video"
                }
            }
        }
        txtDrop.arrowSize = 10
    }
    
    @IBAction func btnOkPreviewAction(_ sender: Any) {
        transparentView.isHidden = true
    }
    @IBAction func btnShowPreviewImageAction(_ sender: Any) {
    
        if strimage != ""{
            transparentView.isHidden = false
        }
        else{
            self.showalert(tlt: "", msg: "Please Select image from gallery")
        }
    }
    
    @IBAction func btnImage(_ sender: Any) {
        // txtImage.touchAction()
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select type of article", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Image", style: .default)
        { _ in
            print("Image")
//            self.txtUploadImage.placeholder = "Upload Image"
            self.txtVideoLink.isHidden = true
            self.txtVideoLinkHeight.constant = -8
            self.txtImage.text = "Image"
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Video", style: .default)
        { _ in
            print("Video")
//            self.txtUploadImage.placeholder = "Upload Video"
            self.txtVideoLink.isHidden = false
            self.txtVideoLinkHeight.constant = 40
            self.txtImage.text = "Video"
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        createPost()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func setupLeftImage(txt: UITextField, imageName:String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 24, height: 24))
        imageView.image = UIImage(named: imageName)
        //  imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        //        imageView.tintColor = UIColor(red: 0.35, green: 0.73, blue: 0.23, alpha: 1.00)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        txt.leftView = imageContainerView
        txt.leftViewMode = .always
        txt.tintColor = .lightGray
        //        txt.layer.borderColor = UIColor(red: 0.35, green: 0.73, blue: 0.23, alpha: 1.00).cgColor
        //        txt.layer.cornerRadius = 5.0
        //        txt.layer.borderWidth = 0.5
        //        txt.clipsToBounds = true
    }
}

extension CreateArticlesVC{
    func createPost() {
        var type = "0"
        if txtImage.text == "Video"{
            type = "1"
        }
        else{
            type = "0"
        }
        
        var parameters = [String:Any]()
        var StrUrl = String()
        if CHECK == "Edit"{
            parameters = ["title" : txtTitle.text ?? "",
                              "description": self.Description,
                              "type": type,
                              "video_link": txtVideoLink.text ?? "",
                              "link": txtArticleLink.text ?? "",
                              "tag":txtTags.text ?? "",
                              "article_id":article_id
                              ]
            StrUrl = EDITARTICLE
        }
        else{
            parameters = ["title" : txtTitle.text ?? "",
                              "description": self.Description,
                              "type": type,
                              "video_link": txtVideoLink.text ?? "",
                              "link": txtArticleLink.text ?? "",
                              "tag":txtTags.text ?? ""
                              ]
            StrUrl = ADDARTICLE
        }
        print(StrUrl)
        
        print(parameters)
        let token = loggdenUser.value(forKey: TOKEN)as! String
        let BEARERTOKEN = BEARER + token
        let headers: HTTPHeaders = ["Xapi": XAPI,
                                    "Accept" : ACCEPT,
                                    "Authorization": BEARERTOKEN]

        AF.upload(
            multipartFormData: { multiPart in
                for (key, value) in parameters {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                                if let num = element as? Int {
                                    let value = "\(num)"
                                    multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }

                
//                for (index,image) in self.arrImages.enumerated() {
//                    print(image)
//                    let image = self.ArticleImage.resizeWithWidth(width: 800)!
                let imageData:Data = self.ArticleImage.pngData() ?? Data()
                multiPart.append(imageData, withName: "image", fileName: "\(String(Int(NSDate().timeIntervalSince1970))).jpg", mimeType: "image/jpeg")
//                }
        },
            usingThreshold: UInt64.init(),to: StrUrl, method: .post , headers: headers)
            .responseJSON(completionHandler: { (response) in
                print(response)
//                self.btnPost.isHidden = false
//                self.activity.isHidden = true
//                self.activity.stopAnimating()


                let JSON = response.result.value as? [String:Any]
                let success = JSON?["success"] as? Bool
                print("success: ",success)
                if success == true{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MYNoti"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    self.showalert(tlt: "", msg: JSON?["message"] as? String ?? "")
                }
               
            })
        }




}

//For image
import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}

extension CreateArticlesVC: RichEditorDelegate, RichEditorToolbarDelegate{

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        print("content: ",content)
        if content.isEmpty {
           // htmlTextView.text = "HTML Preview"
        } else {
           // htmlTextView.text = content
            Description = content
            
        }
    }
    
}


class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 20,
        bottom: 10,
        right: 20
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
