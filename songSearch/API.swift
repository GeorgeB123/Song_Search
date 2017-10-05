//
//  Artist.swift
//  songSearch
//
//  Created by George Bonnici-Carter on 24/09/2017.
//  Copyright © 2017 George Bonnici-Carter. All rights reserved.
//
//
import UIKit

protocol loadStructArray {
    func load(query: String, type: Int)
}

class API: URLSession {
    
    //MARK: - Send Request
    
    func getRequest(matching query: String, type: Int, completion: @escaping ([Any], Int) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: query)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        session.dataTask(with: request as URLRequest, completionHandler: { data,_,_ in
            var requestArray = [Any]()
            var total = 0
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let array = json?["data"] as? NSArray{
                total = (json?["total"] as? Int)!
                for case let result in array {
                    self.structTypeToAppend(requestArray: &requestArray, type: type, result: result)
                }
            }
            completion(requestArray, total)
        }).resume()
    }
    
    //MARK: - Private Methods
    
    private func structTypeToAppend(requestArray: inout [Any], type: Int, result: Any){
        switch type {
        case 0:
            if let object = Artists.parse(result as! [String : Any]){
                requestArray.append(object)
            }
        case 1:
            if let object = Albums.parse(result as! [String : Any]){
                requestArray.append(object)
            }
        case 2:
            if let object = Tracks.parse(result as! [String : Any]){
                requestArray.append(object)
            }
        default:
            return
        }
    }
    
}




