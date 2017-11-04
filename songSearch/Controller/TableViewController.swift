//
//  TableViewController.swift
//  songSearch
//
//  Created by George Bonnici-Carter on 24/09/2017.
//  Copyright © 2017 George Bonnici-Carter. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath as IndexPath) as? TableViewCell else {
            fatalError("Cell does not exist")
        }
        if self.searchController.isActive {
            cell.artistName.text = self.artists[indexPath.row].name
            cell.artistImage.imageFromURL(urlString: artists[indexPath.row].pictureString!)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController else {
            fatalError("View does not exist")
        }
        viewController.artist = artists[indexPath.row].name
        viewController.id = artists[indexPath.row].id
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
}

//MARK: - UI Search Results Updating Delegate

extension TableViewController: loadStructArray {
    
    func updateSearchResults(for searchController: UISearchController) {
        var query = searchController.searchBar.text!
        if !query.isEmpty {
            query = query.replacingOccurrences(of: " ", with: "-")
            query = Constants.deezerBaseUrl + "search/artist?q=" + query
            loadAPIArray(query: query, type: .Artist)
        }
    }
    
    func loadAPIArray(query: String, type: Types) {
        let call = API()
        call.getRequest(matching: query, type: type) { artists, total in
            DispatchQueue.main.async {
                self.artists = artists as! [Artists]
                self.tableView.reloadData()
            }
        }
    }
    
}




