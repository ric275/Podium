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
    
    @IBOutlet weak var imageScroll: UIScrollView!
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        images = [#imageLiteral(resourceName: "Podium splash 1"),#imageLiteral(resourceName: "paramore"),#imageLiteral(resourceName: "gameshow"),#imageLiteral(resourceName: "in our bones"),#imageLiteral(resourceName: "true colours"),#imageLiteral(resourceName: "oh my my")]
        
        for i in 0..<images.count {
            
            let imageView = UIImageView()
            imageView.image = images[i]
            imageView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(i)
            
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.imageScroll.frame.width, height: self.imageScroll.frame.height)
            
            imageScroll.contentSize.width = imageScroll.frame.width * CGFloat(i + 1)
            
            imageScroll.addSubview(imageView)
        }
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                versionLabel.text = "ver: \(version) \n build: \(build)"
        }
        }
        
    }
}
