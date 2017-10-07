//
//  Tracks.swift
//  songSearch
//
//  Created by George Bonnici-Carter on 03/10/2017.
//  Copyright © 2017 George Bonnici-Carter. All rights reserved.
//

import UIKit

struct Tracks {
    
    //MARK: - Properties
    
    let id: Int
    let title: String
    let runTime: Int
    let trackPosition: Int
    
    //MARK: - Initialisation
    
    init(id: Int, title: String, runTime: Int, trackPosition: Int) {
        self.id = id
        self.title = title
        self.runTime = runTime
        self.trackPosition = trackPosition
    }
}

//MARK: - Private Functions

extension Tracks{
    
    static func parse(_ json: [String: Any]) -> Tracks? {
        let id = json["id"] as? Int
        let title = json["title"] as? String
        let duration = json["duration"] as? Int
        let trackPosition = json["track_position"] as? Int ?? 0
        return Tracks(id: id!, title: title!, runTime: duration!, trackPosition: trackPosition)
    }
    
}
