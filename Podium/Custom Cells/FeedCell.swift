//
//  FeedCell.swift
//  Podium
//
//  Created by Jack Taylor on 30/01/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//
// COVERED IN EP 5
// https://www.youtube.com/watch?v=AIN_bbIku_o
//

import UIKit
import Firebase

class FeedCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    
    var postID : String! 
    
    @IBAction func likeTapped(_ sender: Any) {
        
        let ref = Database.database().reference()
        let postKey = ref.child("posts").childByAutoId().key
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value) { (snapshot) in
            if let post = snapshot.value as? [String : AnyObject] {
                let updateLikes: [String : Any] = ["peopleWhoLike/\(postKey)" : Auth.auth().currentUser?.uid]
                ref.child("posts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reference) in
                    if error == nil {
                        ref.child("posts")
                    }
                })
            }
        }
        
    }
    
    @IBAction func unlikeTapped(_ sender: Any) {
    }
    
    
    
    
    
    
    
    
    
    
}
