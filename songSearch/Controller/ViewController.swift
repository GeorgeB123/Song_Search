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
    var albumImageUrl: String?
    var songs = [Tracks]()
    
    @IBOutlet weak var albumCover: UIImageView!

    @IBOutlet weak var songTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songTable.dataSource = self
        self.title = albumName
        guard let image = albumImageUrl else {
            self.albumCover.image = UIImage()
            return
        }
        self.albumCover.imageFromURL(urlString: image)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath as IndexPath) as? SongTableViewCell else {
            fatalError("Cell does not exist")
        }
        cell.songName.text = self.songs[indexPath.row].title
        cell.trackPosition.text = String(self.songs[indexPath.row].trackPosition) + "."
        cell.runTime.text = secondsToMinutes(seconds: self.songs[indexPath.row].runTime)
        return cell
    }
    
}

//MARK: - Private Methods

extension ViewController: loadStructArray {
    
    func displayTracks() {
        let query = Constants.deezerBaseUrl + "album/\(self.id)/tracks"
        loadAPIArray(query: query, type: .Tracks)
        
    }
    
    func loadAPIArray(query: String, type: Types) {
        let call = API()
        call.getRequest(matching: query, type: type) { tracks, total in
            DispatchQueue.main.async {
                self.songs = tracks as! [Tracks]
                self.songTable.reloadData()
            }
            if total > Constants.numberOfObjectsPerPage {
                for i in Constants.numberOfObjectsPerPage..<total where i%Constants.numberOfObjectsPerPage == 0 {
                    let query = "http://api.deezer.com/album/\(self.id)/tracks?index=\(i)"
                    call.getRequest(matching: query, type: type) { tracks, total in
                        DispatchQueue.main.async {
                            self.songs += tracks as! [Tracks]
                            self.songTable.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: - Private Method, seconds to minutes conversion

extension ViewController {
    
    func secondsToMinutes(seconds: Int) -> String {
        let minutes = seconds/60
        let seconds = seconds%60
        return String(format:"%02d:%02d", minutes, seconds)
    }
    
}
