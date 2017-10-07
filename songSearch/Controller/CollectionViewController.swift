//
//  CollectionViewController.swift
//  songSearch
//
//  Created by George Bonnici-Carter on 26/09/2017.
//  Copyright © 2017 George Bonnici-Carter. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    //MARK: Properties
    
    var artist: String = ""
    var id: Int = 0
    var albums = [Albums]();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = artist + " - Albums"
        displayAlbums()

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell
        let img = UIImage()
        cell?.albumTitle.text = self.albums[indexPath.row].title
        cell?.albumCover.image = img.getImage(urlString: self.albums[indexPath.row].cover!)
        return cell!
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let img = UIImage()
        viewController.albumName = self.artist + " - " + albums[indexPath.row].title
        viewController.albumImage = img.getImage(urlString: albums[indexPath.row].largeCover!)
        viewController.id = albums[indexPath.row].id
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    
    //MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Extension with private functions

extension CollectionViewController: loadStructArray {
    
    func displayAlbums() {
        let query = "http://api.deezer.com/artist/\(self.id)/albums"
        load(query: query, type: .Albums)
    }
    
    func load(query: String, type: Types) {
        let call = API()
        call.getRequest(matching: query, type: type) { albums, total in
            DispatchQueue.main.async {
                self.albums = albums as! [Albums]
                self.collectionView?.reloadData()
            }
            if total > 25 {
                for i in 25..<total where i%25 == 0 {
                    let query = "http://api.deezer.com/artist/\(self.id)/albums?index=\(i)"
                    call.getRequest(matching: query, type: type) { albums, total in
                        DispatchQueue.main.async {
                            self.albums += albums as! [Albums]
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}
