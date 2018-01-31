//
//  ComposePostViewController.swift
//  Podium
//
//  Created by Jack Taylor on 29/01/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//
//  ALL COVERED IN EP 3
//  https://www.youtube.com/watch?v=x_vny_M6iYs

import UIKit
import Firebase

class ComposePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var chooseImageButton: UIButton!
    
    @IBOutlet weak var picture: UIImageView!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.picture.image = image
            chooseImageButton.isHidden = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func noImageErrorAlert() {
        let noImageErrorAlert = UIAlertController(title: "Hold on!", message: "You need a picture!", preferredStyle: .alert)
        let cont = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        noImageErrorAlert.addAction(cont)
        self.present(noImageErrorAlert, animated: true, completion: nil)
    }
    
    @IBAction func postTapped(_ sender: Any) {
        
        if self.picture.image == nil {
            
            noImageErrorAlert()
            
        } else {
            
            AppDelegate.instance().showActivityIndicator()
        
            print("POST")
            
            let ref = Database.database().reference()
            let uid = Auth.auth().currentUser!.uid
            let storage = Storage.storage().reference(forURL: "gs://podiumbic.appspot.com/")
            let key = ref.child("artistPosts").childByAutoId().key
            let imgRef = storage.child("artistPosts").child(uid).child("\(key).jpg")
            let data = UIImageJPEGRepresentation(self.picture.image!, 0.6)
            
            let uploadTask = imgRef.putData(data!, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("ERROR: \(error!.localizedDescription)")
                    AppDelegate.instance().dissmissActivityIndicator()
                    return
                }
            
                imgRef.downloadURL(completion: { (url, error) in
                    if let url = url {
                        let feed = ["userID" : uid,
                                    "pathToImage" : url.absoluteString,
                                    "likes" : 0,
                                    "author" : Auth.auth().currentUser!.displayName,
                                    "postID" : key] as [String : Any]
                        
                        let postFeed = ["\(key)" : feed]
                        
                        ref.child("artistPosts").updateChildValues(postFeed)
                        
                        AppDelegate.instance().dissmissActivityIndicator()

                        
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            })
            uploadTask.resume()
        }
    }
        
        
        @IBAction func cancelTapped(_ sender: Any) {
            
            self.dismiss(animated: true, completion: nil)
        }
}
