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
        
        self.likeButton.isEnabled = false
        let ref = Database.database().reference()
        let keyToPost = ref.child("artistposts").childByAutoId().key
        
        ref.child("artistposts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let post = snapshot.value as? [String : AnyObject] {
                let updateLikes: [String : Any] = ["peopleWhoLike/\(keyToPost)" : Auth.auth().currentUser!.uid]
                ref.child("artistposts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child("artistposts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let likes = properties["peopleWhoLike"] as? [String : AnyObject] {
                                    let count = likes.count
                                    self.likesLabel.text = "\(count) Likes"
                                    
                                    let update = ["likes" : count]
                                    ref.child("artistposts").child(self.postID).updateChildValues(update)
                                    
                                    self.likeButton.isHidden = true
                                    self.unlikeButton.isHidden = false
                                    self.likeButton.isEnabled = true
                                }
                            }
                        })
                    }
                })
            }
            
            
        })
        
        ref.removeAllObservers()
        
    }
    
    @IBAction func unlikeTapped(_ sender: Any) {
        
        self.unlikeButton.isEnabled = false
        let ref = Database.database().reference()
        
        
        ref.child("artistposts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLike = properties["peopleWhoLike"] as? [String : AnyObject] {
                    for (id,person) in peopleWhoLike {
                        if person as? String == Auth.auth().currentUser!.uid {
                            ref.child("artistposts").child(self.postID).child("peopleWhoLike").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("artistposts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let likes = prop["peopleWhoLike"] as? [String : AnyObject] {
                                                let count = likes.count
                                                self.likesLabel.text = "\(count) Likes"
                                                ref.child("artistposts").child(self.postID).updateChildValues(["likes" : count])
                                            }else {
                                                self.likesLabel.text = "0 Likes"
                                                ref.child("artistposts").child(self.postID).updateChildValues(["likes" : 0])
                                            }
                                        }
                                    })
                                }
                            })
                            
                            self.likeButton.isHidden = false
                            self.unlikeButton.isHidden = true
                            self.unlikeButton.isEnabled = true
                            break
                            
                        }
                    }
                }
            }
            
        })
        ref.removeAllObservers()
    }
}

