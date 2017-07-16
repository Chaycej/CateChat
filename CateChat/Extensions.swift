//
//  Extensions.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/12/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithURLString(URLString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: URLString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: URLString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: URLString as AnyObject)
                    self.image = downloadedImage
                }
            }
        }).resume()
    }
}

