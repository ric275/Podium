//
//  PlayerViewController.swift
//  Podium
//
//  Created by Jack Taylor on 02/03/2018.
//  Copyright © 2018 Jack Taylor. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songYear: UILabel!
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var forwardsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songTitle.text = songs[currentSong]
   
    }
    @IBAction func forwards(_ sender: Any) {
        
        if currentSong < songs.count-1 {
            playMusic(song: songs[currentSong+1])
        } else {
            //End of playlist.
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        
        if currentSong == 1 {
        playMusic(song: songs[currentSong-1])
        } else {
            
            
        }
    }
    
    @IBAction func play(_ sender: Any) {
        
        if audioPlayer.isPlaying == false {
            audioPlayer.play()
            
        }
        
    }
    
    @IBAction func pause(_ sender: Any) {
    
        if audioPlayer.isPlaying == true {
            audioPlayer.pause()
        }
    
    }
    
    @IBAction func volume(_ sender: UISlider) {
        
        audioPlayer.volume = sender.value
        
    }
    
    func playMusic(song:String) {
        
        do {
            let audioPath = Bundle.main.path(forResource: song, ofType: ".m4a")
            
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            currentSong += 1
            audioPlayer.play()
            
        }
        catch {
            print("ERROR 12")
        }
        
        
    }
    
    
    
    
    
}
