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

//MARK: - UIImageView extension - couldn't get image caching to work so still there's some flicker on images

extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
    
}

