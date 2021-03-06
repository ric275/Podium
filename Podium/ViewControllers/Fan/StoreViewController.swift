//
//  StoreViewController.swift
//  Podium
//
//  Created by Jack Taylor on 27/01/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//

import UIKit
import Firebase

class StoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logOut(_ sender: Any) {
        
        do
        {
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home")
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
}
