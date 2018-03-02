//
//  SignUpViewController.swift
//  Podium
//
//  Created by Jack Taylor on 23/01/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    
    let picker = UIImagePickerController()
    var userStorage : StorageReference!
    var ref  : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let storage = Storage.storage().reference(forURL: "gs://podiumbic.appspot.com/")
        
        userStorage = storage.child("users")
        ref = Database.database().reference()
        
        nameText.delegate = self
        emailText.delegate = self
        passwordText.delegate = self
        passwordConfirm.delegate = self
        
    }
    
    @IBAction func selectImage(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.picture.image = image
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    //Hide keyboard when user taps done.
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameText.resignFirstResponder()
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        passwordConfirm.resignFirstResponder()

        return (true)
    }
    
    func noImageAlert() {
        let noImageAlert = UIAlertController(title: "Hold on a second!", message: "Please select a profile picture.", preferredStyle: .alert)
        let cont = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        noImageAlert.addAction(cont)
        self.present(noImageAlert, animated: true, completion: nil)
    }
    
    func emptyErrorAlert() {
        let emptyErrorAlert = UIAlertController(title: "Hold on a second!", message: "You have to fill in all the fields before creating an account.", preferredStyle: .alert)
        let cont = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        emptyErrorAlert.addAction(cont)
        self.present(emptyErrorAlert, animated: true, completion: nil)
    }
    
    func passwordErrorAlert() {
        let passwordErrorAlert = UIAlertController(title: "Passwords do not match!", message: "Please double check and try again.", preferredStyle: .alert)
        let cont = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        passwordErrorAlert.addAction(cont)
        self.present(passwordErrorAlert, animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        if self.picture.image == nil {
            noImageAlert()
        } else {
            
            guard nameText.text != "", emailText.text != "", passwordText.text != "", passwordConfirm.text != "" else { return emptyErrorAlert()}
            
            if passwordText.text == passwordConfirm.text {
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    
                    AppDelegate.instance().showActivityIndicator()
                    
                    if let error = error {
                        print("ERROR 1: \(error.localizedDescription)")
                    }
                    
                    if let user = user {
                        
                        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                        changeRequest.displayName = self.nameText.text!
                        changeRequest.commitChanges(completion: nil)
                        
                        let imageRef = self.userStorage.child("\(user.uid).jpg")
                        
                        let data = UIImageJPEGRepresentation(self.picture.image!, 0.5)
                        
                        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
                            if err != nil {
                                print("ERROR 2: \(err!.localizedDescription)")
                            }
                            
                            imageRef.downloadURL(completion: { (url, er) in
                                if er != nil {
                                    print("ERROR 3: \(er!.localizedDescription)")
                                }
                                
                                if let url = url {
                                    
                                    let userInfo: [String : Any] = ["uid" : user.uid,
                                                                    "full name" : self.nameText.text!,
                                                                    "urlToImage" : url.absoluteString]
                                    
                                    self.ref.child("users").child(user.uid).setValue(userInfo)
                                    
                                    AppDelegate.instance().dissmissActivityIndicator()
                                    
                                    
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "root")
                                    
                                    self.present(vc, animated: true, completion: nil)
                                }
                            })
                        })
                        uploadTask.resume()
                    }
                })
                
            } else {
                passwordErrorAlert()
            }
        }
    }
}
