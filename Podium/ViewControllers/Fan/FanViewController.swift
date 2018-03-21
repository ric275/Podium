//
//  FanViewController.swift
//  Podium
//
//  Created by Jack Taylor on 21/03/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//

import UIKit
import Firebase

class FanViewController: UIViewController {
    
    let ref = Database.database().reference()
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
