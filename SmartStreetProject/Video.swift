//
//  Video.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 10/24/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import AVFoundation
import Social
import MobileCoreServices
import AssetsLibrary
import MessageUI
import MediaPlayer
import MobileCoreServices


class Video: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, MFMailComposeViewControllerDelegate  {
    var treeBarcode : String!
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var videoURL: URL!
    var soundFileURL: URL!
    var isVideo : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        playButton.isEnabled = false
        stopButton.isEnabled = false
        
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    
    @IBAction func playVideo(_ sender: Any) {
        startMediaBrowserFromViewController(viewController: self, usingDelegate: self)
        
    }
    @IBAction func recordVideo(_ sender: Any) {
        isVideo = true
        startCameraFromViewController(viewController: self, withDelegate: self)
        
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        if audioRecorder?.isRecording == false {
            playButton.isEnabled = false
            stopButton.isEnabled = true
            audioRecorder?.record()
        }
    }
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func stopAudio(_ sender: AnyObject) {
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
    }
    
    @IBAction func playAudio(_ sender: AnyObject) {
        if audioRecorder?.isRecording == false {
            stopButton.isEnabled = true
            recordButton.isEnabled = false
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf:
                    (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func sendMail (attachmentURL : String){
        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setSubject("This is a voice recorded")
            mailComposer.setMessageBody("This is what they sound like.", isHTML: false)
            mailComposer.delegate = self
            let fileparts = attachmentURL.components(separatedBy: ".")
            let filename = fileparts[0]
            let fileExtention = fileparts[1]
            
            if isVideo{
                mailComposer.setSubject("video recorded")
                mailComposer.setMessageBody("This is a video recorded", isHTML: false)
                if let fileData = NSData(contentsOf: videoURL) {
                    mailComposer.addAttachmentData(fileData as Data, mimeType: "MOV", fileName: "myfile.MOV")
                }
            }
            else{
                
                mailComposer.setSubject("voice recorded")
                mailComposer.setMessageBody("This is a voice recorded", isHTML: false)
                if let fileData = NSData(contentsOf: soundFileURL) {
                    print("File data loaded.")
                    mailComposer.addAttachmentData(fileData as Data, mimeType: fileExtention, fileName: filename)
                }
                
                
            }
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareWithEmail(_ sender: Any) {
        
        sendMail(attachmentURL: "sound.caf")
    }
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismiss(animated: true, completion: nil)
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
    @objc func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func startCameraFromViewController(viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    @IBAction func shareWithFB(_ sender: Any) {
        
        let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        composeSheet?.setInitialText("Hello, Facebook!")
        composeSheet?.add(UIImage(named: "6.png"))
        print(videoURL)
        composeSheet?.add(videoURL)
        
        
        self.present(composeSheet!, animated: true, completion: nil)
    }
    
    
    
    @IBAction func shareWithMessage(_ sender: Any) {
        
    }
    
    func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate) -> Bool {
        // 1
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) == false {
            return false
        }
        
        // 2
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .savedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as NSString as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate
        
        // 3
        present(mediaUI, animated: true, completion: nil)
        return true
    }
}
// MARK: - UIImagePickerControllerDelegate
extension Video: UIImagePickerControllerDelegate {
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 1
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        // 2
        dismiss(animated: true) {
            // 3
            if mediaType == kUTTypeMovie {
                let moviePlayer = AVPlayer(url: (info[UIImagePickerControllerMediaURL] as! NSURL) as URL!)
                moviePlayer.play()
            }
        }
    }
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        videoURL = ((info[UIImagePickerControllerMediaURL] as! NSURL) as URL!)
        
        dismiss(animated: true, completion: nil)
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            guard let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path else { return }
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(Video.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension Video: UINavigationControllerDelegate {
}



