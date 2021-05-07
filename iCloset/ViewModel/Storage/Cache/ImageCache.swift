//
//  ImageCache.swift
//  iCloset
//
//  Created by 송정훈 on 2021/04/06.
//
import UIKit
import Foundation
class ImageCache{
    // NSCache<KeyType,ObjectType>
    private var imageCache = NSCache<NSString,UIImage>()
    var fileManager = FileManager()
    func setCacheObj(url:URL,img:UIImage){
        imageCache.setObject(img, forKey: url.lastPathComponent as NSString)
    }
    func getFile(url:URL) -> UIImage? {
        var urlImage:UIImage? = nil
        //Memory Cache
        if let image = imageCache.object(forKey: url.lastPathComponent as NSString)  {
            print("Memory Cache")
            return image
        }
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return urlImage }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(url.lastPathComponent)
        if !fileManager.fileExists(atPath:filePath.path){
            //Download URL
            DispatchQueue.global(qos: .background).async {
                guard let imageData = try? Data(contentsOf: url) else { return }
                urlImage = UIImage(data:imageData)
                self.setCacheObj(url: url, img: urlImage!)
                self.fileManager.createFile(atPath: filePath.path,contents: imageData, attributes: nil)
            }
        }else{
            //Disk Cache
            print("disk Cache")
            guard let imageData = try? Data(contentsOf: filePath) else { return nil }
            guard let image = UIImage(data:imageData) else { return nil }
            return image
        }
        return urlImage
    }
}
