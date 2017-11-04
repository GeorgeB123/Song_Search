//
//  Constants.swift
//  songSearch
//
//  Created by George Bonnici-Carter on 28/09/2017.
//  Copyright © 2017 George Bonnici-Carter. All rights reserved.
//

import UIKit

struct Artists {

    //MARK: - Properties
    
    let id: Int
    let name: String
    let pictureString: String?
    
    //MARK: - Initialisation
    
    init(id: Int, name: String, pictureString: String) {
        self.id = id
        self.name = name
        self.pictureString = pictureString
    }
}

//MARK: - Private Functions

extension Artists {
    
    static func parse(_ json: [String: Any]) -> Artists? {
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let pictureString = json["picture_big"] as? String ?? ""
        return Artists(id: id!, name: name!, pictureString: pictureString)
    }
    
}

