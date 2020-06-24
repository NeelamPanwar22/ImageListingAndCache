//
//  ImageCache.swift
//  AssignedTask1MG
//
//  Created by neelam panwar on 24/06/20.
//  Copyright © 2020 neelam panwar. All rights reserved.
//

import Foundation

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageCacheView : UIImageView {
    
    var imageURL: URL?
    
    func loadImageWithUrl(_ url: URL , callBack : ((_ cacheContainImage : Bool , _ imageLoaded : Bool) -> Void)?) {
        
        imageURL = url
        
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            
            self.image = imageFromCache
            callBack?(true , true)
            
            return
        }
        
        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    callBack?(false , true)
                })
                return
            }
            DispatchQueue.main.async(execute: {
                
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                callBack?(false , true)
            })
        }).resume()
    }
}
