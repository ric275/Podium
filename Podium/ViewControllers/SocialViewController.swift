//
//  SocialViewController.swift
//  Podium
//
//  Created by Jack Taylor on 27/01/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//
//  ALL COVERED IN EP 2 - FOLLOWERS AND ALL.
//  https://www.youtube.com/watch?v=js3gHOuPb28

import UIKit
import Firebase

class SocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var artists : [Artist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        retrieveArtists()
    }
    
    func retrieveArtists() {
        
        let ref = Database.database().reference()
        
        ref.child("users").queryOrderedByKey().observe(.value) { (snapshot) in
            
            let artists = snapshot.value as! [String : AnyObject]
            
            self.artists.removeAll()
            
            for (_, value) in artists {
                if let uid = value["uid"] as? String {
                    if uid != Auth.auth().currentUser!.uid {
                        let artistToShow = Artist()
                        if let fullName = value["full name"] as? String, let imagePath = value["urlToImage"] as? String {
                            artistToShow.fullName = fullName
                            artistToShow.imagePath = imagePath
                            artistToShow.userID = uid
                            self.artists.append(artistToShow)
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        ref.removeAllObservers()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as! ArtistCell
        
        cell.artistName.text = self.artists[indexPath.row].fullName
        cell.userID = self.artists[indexPath.row].userID
        cell.artistImage.downloadImage(from: self.artists[indexPath.row].imagePath!)
        
        checkFollowing(indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        var isFollower : Bool = false
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot) in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as! String == self.artists[indexPath.row].userID {
                        isFollower = true
                        
                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users").child(self.artists[indexPath.row].userID).child("followers/\(ke)").removeValue()
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                        
                    }
                }
            }
            
            if isFollower == false {
                let following = ["following/\(key)" : self.artists[indexPath.row].userID]
                let followers = ["followers/\(key)" : uid]
                
                ref.child("users").child(uid).updateChildValues(following)
                ref.child("users").child(self.artists[indexPath.row].userID).updateChildValues(followers)
                
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        }
        
        ref.removeAllObservers()
    }
    
    func checkFollowing(indexPath : IndexPath) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot) in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as! String == self.artists[indexPath.row].userID {
                    self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                    
                }
            }
        }
        ref.removeAllObservers()
        
    }
    
    
    @IBAction func composeTapped(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "compose")
        
        self.present(vc, animated: true, completion: nil)
    
    
    
    }
    
    
}

extension UIImageView {
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
