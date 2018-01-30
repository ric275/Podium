//
//  LaundingViewController.swift
//  Podium
//
//  Created by Jack Taylor on 26/01/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//

import UIKit

class LaundingViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                versionLabel.text = "ver: \(version) \n build: \(build)"
        }
        }
        
    }
    
    func artistErrorAlert() {
        let artistErrorAlert = UIAlertController(title: "Not yet.", message: "Artist accounts are not usable yet!", preferredStyle: .alert)
        let cont = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        artistErrorAlert.addAction(cont)
        self.present(artistErrorAlert, animated: true, completion: nil)
    }
    
    @IBAction func artistTapped(_ sender: Any) {
    
    artistErrorAlert()
    
    }
}
