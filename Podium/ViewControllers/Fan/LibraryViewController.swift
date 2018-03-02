//
//  LibraryViewController.swift
//  Podium
//
//  Created by Jack Taylor on 21/02/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//

import UIKit
import AVFoundation

var songs:[String] = []
var audioPlayer = AVAudioPlayer()

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getSongTitles()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "songCell")
        
        cell.textLabel?.text = songs[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        do {
           let audioPath = Bundle.main.path(forResource: songs[indexPath.row], ofType: ".m4a")
            
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer.play()
            
        }
        catch {
            print("ERROR 1")
        }
        
        
        
        
    }
    
    func getSongTitles() {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)

        do {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for song in songPath {
                var selectedSong = song.absoluteString
                
                if selectedSong.contains(".m4a") {
                    let findString = selectedSong.components(separatedBy: "/")
                    selectedSong = findString[findString.count-1]
                    selectedSong = selectedSong.replacingOccurrences(of: "%20", with: " ")
                    selectedSong = selectedSong.replacingOccurrences(of: ".m4a", with: "")
                    
                    songs.append(selectedSong)
                }
            }
            
            tableView.reloadData()
            
        }
        catch {
            print("ERROR 2")
        }
        
        
        
        
    }
}
