//
//  Albums.swift
//  songSearch
//
//  Created by George Bonnici-Carter on 03/10/2017.
//  Copyright © 2017 George Bonnici-Carter. All rights reserved.
//

import UIKit

struct Albums {
    
    //MARK: - Properties
    
    let id: Int
    let title: String
    let largeCover: String?
    
    //MARK: - Initialisation
    
    init(id: Int, title: String, largeCover: String) {
        self.id = id
        self.title = title
        self.largeCover = largeCover
    }
}

//MARK: - Private Functions

extension Albums{
    
    static func parse(_ json: [String: Any]) -> Albums? {
        let id = json["id"] as? Int
        let title = json["title"] as? String
        let largeCover = json["cover_big"] as? String ?? ""
        return Albums(id: id!, title: title!, largeCover: largeCover)
    }
    
}

