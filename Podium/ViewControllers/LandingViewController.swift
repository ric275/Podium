//
//  LandingViewController.swift
//  Podium
//
//  Created by Jack Taylor on 26/01/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                versionLabel.text = "ver: \(version) \n build: \(build)"
        }
        }
        
    }
}
