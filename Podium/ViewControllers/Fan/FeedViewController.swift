//
//  FeedViewController.swift
//  Podium
//
//  Created by Jack Taylor on 30/01/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//
// COVERED IN EP 4
//
// https://www.youtube.com/watch?v=fw7ySRFtX_M
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [SocialPost]()
    var following = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getPosts()
        
    }
    
    func getPosts() {
        
        let ref = Database.database().reference()
        
        //This child needs to be "artists" for artists to see own post but "users" for fans to see anything.
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot) in
            
            //All this code is fine
            
            let artists = snapshot.value as! [String : AnyObject]
            
            for (_, value) in artists {
                if let uid = value["uid"] as? String {
                    if uid == Auth.auth().currentUser?.uid {
                        if let followingUsers = value["following"] as? [String : String] {
                            for (_, artist) in followingUsers {
                                self.following.append(artist)
                            }
                        }
                        
                        self.following.append(Auth.auth().currentUser!.uid)
                        
                        ref.child("artistPosts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                            let postsSnap = snap.value as! [String : AnyObject]
                            
                            for (_, post) in postsSnap {
                                if let userID = post["userID"] as? String {
                                    for each in self.following {
                                        if each == userID {
                                            let createdPost = SocialPost()
                                            if let author = post["author"] as? String, let likes = post["likes"] as? Int, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String {
                                                
                                                createdPost.author = author
                                                createdPost.likes = likes
                                                createdPost.pathToImage = pathToImage
                                                createdPost.postID = postID
                                                createdPost.userID = userID
                                                
                                                if let people = post["likers"] as? [String : AnyObject] {
                                                    for (_,person) in people {
                                                        createdPost.likers.append(person as! String)
                                                    }
                                                }
                                                
                                                self.posts.append(createdPost)
                                                
                                            }
                                        }
                                    }
                                    //this may be useful
                                    self.collectionView.reloadData()
                                }
                            }
                            
                            
                        })
                    }
                }
            }
        }
        
        ref.removeAllObservers()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        cell.image.downloadImage(from: self.posts[indexPath.row].pathToImage)
        cell.authorLabel.text = "\(self.posts[indexPath.row].author!)"
        cell.likesLabel.text = "\(self.posts[indexPath.row].likes!) likes"
        cell.unlikeButton.isHidden = true
        cell.postID = self.posts[indexPath.row].postID
        
        for person in self.posts[indexPath.row].likers {
            if person == Auth.auth().currentUser!.uid {
                cell.likeButton.isHidden = true
                cell.unlikeButton.isHidden = false
                break
            }
        }
        
        return cell
    }
    
    
    @IBAction func searchTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "artists")
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func composeTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "compose")
        
        self.present(vc, animated: true, completion: nil)
    }
}
