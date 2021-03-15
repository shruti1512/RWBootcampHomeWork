//
//  ImageCache.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/19/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit


extension UIImageView {
  
  enum ImageCacheError: Error {
    case noImageFound
  }
  /* Image Caching using URLCache (provides a composite in-memory and on-disk cache)*/
  
  typealias ImageDownloadCompletionHandler = (Result<UIImage, NetworkError>) -> Void
  typealias ImageLoadCompletionHandler = (Result<UIImage, ImageCacheError>) -> Void
  
  public func loadImage(fromURL url: String) {

    guard let imageURL = URL(string: url) else { return }

    let cache = URLCache.shared
    let request = URLRequest(url: imageURL)

    DispatchQueue.global(qos: .utility).async {
      //check image in cache
      if let data = cache.cachedResponse(for: request)?.data,
        let image = UIImage(data: data) {

        //load cached image in the imageview
        DispatchQueue.main.async {
          self.transition(toImage: image)
        }
      }
      //since image doesn't exist in cache, download from the network
      else {
        self.downloadImage(fromURL: imageURL)
      }
    }
  }
  
  private func downloadImage(fromURL url: URL) {
    
    let cache = URLCache.shared
    let request = URLRequest(url: url)

    URLSession.shared.dataTask(with: url) { (data, response, error) in

      guard let data = data,
        let response = response as? HTTPURLResponse,
        (200..<300).contains(response.statusCode) else { return }

      //save the downloaded image in cache
      guard let downloadedImage = UIImage(data: data) else { return }
      let cachedResponse = CachedURLResponse(response: response, data: data)
      cache.storeCachedResponse(cachedResponse, for: request)

      //load the downloaded image in imageview on main thread
      DispatchQueue.main.async {
        self.transition(toImage: downloadedImage)
      }
    }.resume()

  }
  
  private func transition(toImage image: UIImage) {
    UIView.transition(with: self,
                      duration: 0.8,
                      options: .transitionCrossDissolve,
                      animations: {
                        self.image = image },
                      completion: nil)
  }
    
  /* Image Caching using Flyweight Cache Pattern (provides in-memory cache only)*/
  
  //  public static var imageStore: [String: UIImage] = [:]
  //
  //  public func setImage(forUrl url: URL) {
  //
  //    //check to se if an image exists in the cache store and use it
  //    let key = url.absoluteString
  //    if let cachedImage = UIImageView.imageStore[key] {
  //      self.image = cachedImage
  //    }
  //      //else download the image from the server, store it in cache and in turn use the cached image
  //    else {
  //      URLSession.shared.dataTask(with: url) { (data, response, error) in
  //        guard let data = data else { return }
  //        DispatchQueue.main.async {
  //          guard let downloadedImage = UIImage(data: data) else { return }
  //          self.image = downloadedImage
  //          UIImageView.imageStore[key] = downloadedImage
  //        }
  //      }.resume()
  //    }
  //  }
  
}
