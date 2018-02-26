//
//  share.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/19/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import Social
import MessageUI
class share: UIViewController,  UINavigationControllerDelegate, UIImagePickerControllerDelegate,  MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var treeBarcode : String!
    
    @IBAction func showGallery(_ sender: Any) {
        
        if UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, Gallery is not accessible.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    @IBAction func shareWithMessage(_ sender: Any) {
        
        let image = imageView
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func shareWithEmail(_ sender: Any) {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.delegate = self
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.addAttachmentData(UIImageJPEGRepresentation(imageView.image!, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "test.jpeg")
        let treeName = PardeTreesFromCSVFile().getTreeNameFromBarcode(barcode:treeBarcode)
        mailComposeVC.setSubject("Photo for Tree \(treeName)")
        mailComposeVC.setMessageBody("<html><body><p>This is your message</p></body></html>", isHTML: true)
        self.present(mailComposeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            break
        case .failed:
            break
            
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareWithFB(_ sender: Any) {
        
        let screen = UIScreen.main
        
        if let window = UIApplication.shared.keyWindow {
            UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0);
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            composeSheet?.setInitialText("Hello, Facebook!")
            composeSheet?.add(image)
            
            present(composeSheet!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
