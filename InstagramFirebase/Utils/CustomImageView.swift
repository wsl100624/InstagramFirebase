//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/3/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit

var imageCatch = [String:UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToDownloadImage : String?
    
    
    func loadImage(urlString: String) {
        
        lastURLUsedToDownloadImage = urlString
        
        if let catchedImage = imageCatch[urlString] {
            self.image = catchedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to download images with imageURL", error)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToDownloadImage {
                return
            }
            
            guard let imageData = data else { return }
            
            let downloadImage = UIImage(data: imageData)
            
            imageCatch[url.absoluteString] = downloadImage
            
            DispatchQueue.main.async {
                self.image = downloadImage
            }
        }.resume()
    }
    
    
    
    
}
