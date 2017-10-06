//
//  ViewController.swift
//  songSearch
//
//  Created by George Bonnici-Carter on 27/09/2017.
//  Copyright © 2017 George Bonnici-Carter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var albumName: String = ""
    var id: Int = 0
    var albumImage: UIImage = UIImage()
    var songs = [Tracks]()
    
    @IBOutlet weak var albumCover: UIImageView!

    @IBOutlet weak var songTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songTable.dataSource = self
        self.title = albumName
        self.albumCover.image = albumImage
        displayTracks()
        songTable.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - UI Table View Data Source

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath as IndexPath) as! SongTableViewCell
        cell.songName.text = self.songs[indexPath.row].title
        cell.trackPosition.text = String(self.songs[indexPath.row].trackPosition) + "."
        cell.runTime.text = secondsToMinutes(seconds: self.songs[indexPath.row].runTime)
        return cell
    }
    
}

//MARK: - Private Methods

extension ViewController: loadStructArray {
    
    func displayTracks() {
        let query = "http://api.deezer.com/album/\(self.id)/tracks"
        load(query: query, type: .Tracks)
        
    }
    
    func load(query: String, type: Types) {
        let call = API()
        call.getRequest(matching: query, type: type) { tracks, total in
            DispatchQueue.main.async {
                self.songs = tracks as! [Tracks]
                self.songTable.reloadData()
            }
            if total > 25 {
                for i in 25..<total where i%25 == 0 {
                    let query = "http://api.deezer.com/album/\(self.id)/tracks?index=\(i)"
                    call.getRequest(matching: query, type: type) { albums, total in
                        DispatchQueue.main.async {
                            self.songs += tracks as! [Tracks]
                            self.songTable.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func secondsToMinutes(seconds: Int) -> String {
        let minutes = seconds/60
        let seconds = seconds%60
        return String(format:"%02d:%02d", minutes, seconds)
    }
    
}
