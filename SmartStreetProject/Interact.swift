//
//  Interact.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/19/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import AVFoundation
class Interact: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var treeBarcode : String!
    @IBOutlet weak var table: UITableView!
    var musicPlayer : AVAudioPlayer!
    let soundArray = ["swirling_hurricane_storm_wind", "storm_wind", "fierce_thunder_storm_with_wind.mp3", "fire_storm"]
    @IBOutlet weak var treeTitel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAudio()
        table.delegate = self
        table.dataSource = self
        let treeName = PardeTreesFromCSVFile().getTreeNameFromBarcode(barcode: treeBarcode)
        treeTitel.text = "Musics of \(treeName) tree"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //  cell.textLabel?.text = soundArray[indexPath.row]
        return cell;
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    @IBAction func MusicButton(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        }
        else{
            musicPlayer.play()
            sender.alpha = 0.1
        }
        
    }
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string : path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    
    
}
