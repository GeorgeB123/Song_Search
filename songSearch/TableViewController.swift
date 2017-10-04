//
//  TableViewController.swift
//  songSearch
//
//  Created by George Bonnici-Carter on 24/09/2017.
//  Copyright © 2017 George Bonnici-Carter. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: - Properties
    
    var artists = [Artists]();
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.artists.count
        }
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath as IndexPath) as! TableViewCell
        let img = UIImage()
        if self.searchController.isActive {
            cell.artistName.text = self.artists[indexPath.row].name
            cell.artistImage.image = img.getImage(urlString: self.artists[indexPath.row].pictureString!)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
        viewController.artist = artists[indexPath.row].name
        viewController.id = artists[indexPath.row].id
        self.navigationController!.pushViewController(viewController, animated: true)
    }
 
    
}

//MARK: - UI Search Results Updating Delegate

extension TableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        var query = searchController.searchBar.text!
        if !query.isEmpty {
            query = query.replacingOccurrences(of: " ", with: "-")
            query = "http://api.deezer.com/search/artist?q=" + query
            let call = API()
            call.getRequest(matching: query, type: 0) { artists, total in
                DispatchQueue.main.async {
                    self.artists = artists as! [Artists]
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

//MARK: - UIImage Extension

extension UIImage {
    
    func getImage(urlString: String) -> UIImage{
        guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else{
            return UIImage()
        }
        let image = UIImage(data: data)!
        return image
    }
    
}


