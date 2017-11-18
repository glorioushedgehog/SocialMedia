//
//  ImageService.swift
//  SocialMedia
//
//  Created by Paul Devlin on 11/15/17.
//  Copyright © 2017 Paul Devlin. All rights reserved.
//

import UIKit

// retrieve images for the imageURL's in messages
class ImageService {
    
    // avoid making new instance of ImageService for every image request
    static var shared = ImageService()

    // caches URLs to UIImages or nil
    let imageCache = URLCache()
    
    // return the image downloaded from the given url or from the cache if the image
    // is cached
    func imageForURL(url: URL?, completion: @escaping (UIImage?, URL?) -> ()) {
        
        // do nothing if the url is invalid
        guard let url = url else { completion(nil, nil); return }

        // check if the response to the url is already cached and return it if it is
        if let aCachedResponse = imageCache.cachedResponse(for: URLRequest(url: url)) {
            let image = UIImage(data: aCachedResponse.data)
            completion(image, url)
            return
        }
        let task = URLSession(configuration: .ephemeral).dataTask(with: url) { (data, response, error) in

            // return if image retrieval fails
            guard data != nil else { completion(nil, nil); return }
            if error != nil { completion(nil, nil); return }
            
            let image = UIImage(data: data!)
            
            // cache image whether it is a UIImage or nil
            let cacheResponse = CachedURLResponse(response: response!, data: data!)
            self.imageCache.storeCachedResponse(cacheResponse, for: URLRequest(url: url))

            DispatchQueue.main.async {
                completion(image, url)
            }
        }
        task.resume()
    }
}
