//
//  ArtistLoginViewController.swift
//  Podium
//
//  Created by Jack Taylor on 02/03/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//

import UIKit
import Firebase

class ArtistLoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func loginPressed(_ sender: Any) {
        
        guard emailText.text != "", passwordText.text != "" else {return EmptyErrorAlert()}
        
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
            
            if let error = error {
                self.AccountErrorAlert()
                print("ERROR 1:\(error.localizedDescription)")
            }
            
            if let user = user {
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "artistRoot")
                
                self.present(vc, animated: true, completion: nil)
                
                
            }
            
            
        }
        
    }
    
    func EmptyErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Hold on a second!", message: "You have to fill in both fields before logging in.", preferredStyle: .alert)
        let cont = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        sendMailErrorAlert.addAction(cont)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func AccountErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Account not recognised", message: "Please double check email and password then try again.", preferredStyle: .alert)
        let cont = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        sendMailErrorAlert.addAction(cont)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
}
