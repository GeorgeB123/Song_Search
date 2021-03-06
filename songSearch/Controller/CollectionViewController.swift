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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            fatalError("Cell does not exist")
        }
        cell.albumTitle.text = self.albums[indexPath.row].title
        cell.albumCover.imageFromURL(urlString: albums[indexPath.row].largeCover!)
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.albumName = self.artist + " - " + albums[indexPath.row].title
        viewController.albumImageUrl = albums[indexPath.row].largeCover!
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
        let query = Constants.deezerBaseUrl + "artist/\(self.id)/albums"
        loadAPIArray(query: query, type: .Albums)
    }
    
    func loadAPIArray(query: String, type: Types) {
        let call = API()
        call.getRequest(matching: query, type: type) { albums, total in
            DispatchQueue.main.async {
                self.albums = albums as! [Albums]
                self.collectionView?.reloadData()
            }
            if total > Constants.numberOfObjectsPerPage {
                for i in Constants.numberOfObjectsPerPage..<total where i%Constants.numberOfObjectsPerPage == 0 {
                    let query = "http://api.deezer.com/artist/\(self.id)/albums?index=\(i)"
                    call.getRequest(matching: query, type: type) { albums, total in
                        DispatchQueue.main.async {
                            self.albums += albums as! [Albums]
                            self.collectionView?.reloadData()
                            self.collectionView?.scrollRectToVisible(CGRect.zero, animated: false)
                        }
                    }
                }
            }
        }
    }
    
}
