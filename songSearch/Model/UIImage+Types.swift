//
//  Extensions.swift
//  songSearch
//
//  Created by George Bonnici-Carter on 07/10/2017.
//  Copyright © 2017 George Bonnici-Carter. All rights reserved.
//

import UIKit

//MARK - struct types

enum Types {
    case Artist
    case Albums
    case Tracks
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


