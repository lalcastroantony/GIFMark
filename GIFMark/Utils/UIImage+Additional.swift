//
//  UIImage+Additional.swift
//  GIFMark
//
//  Created by Lal Castro on 15/07/22.
//

import UIKit

class ImageDownloadCache: NSObject {
    static var imageCache: [String: Data] = [:]
    static var imageCacheUrls: [String] = []
    static func downloadImage(urlStr: String, completion: @escaping (Data?, String) -> ()) -> Data? {
        if imageCacheUrls.contains(urlStr) {
            return imageCache[urlStr]!
        }
        else if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        completion(nil, urlStr)
                        return
                    }
                    completion(data, urlStr)
                    imageCache[urlStr] = data
                    if imageCacheUrls.contains(urlStr) == false {
                        imageCacheUrls.append(urlStr)
                    }
                    
                    if imageCacheUrls.count > 50 {
                        imageCache[imageCacheUrls[0]] = nil
                        imageCacheUrls.removeFirst()
                    }
                }
                }.resume()
        }
        return nil
    }
}
