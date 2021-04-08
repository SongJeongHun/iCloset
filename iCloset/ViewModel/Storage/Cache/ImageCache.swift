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
    //Memory Cache
    func setCacheObj(url:URL,img:UIImage){
        imageCache.setObject(img, forKey: url.lastPathComponent as NSString)
    }
    //Disk Cache
    func getFile(url:URL) -> UIImage? {
        var urlImage:UIImage? = nil
        if let image = imageCache.object(forKey: url.lastPathComponent as NSString)  { urlImage = image }
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return urlImage }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(url.lastPathComponent)
        if !fileManager.fileExists(atPath:filePath.path){
            print("notExist")
            guard let imageData = try? Data(contentsOf: url) else { return nil }
            guard let image = UIImage(data:imageData) else { return nil }
            setCacheObj(url: url, img: image)
            fileManager.createFile(atPath: filePath.path, contents: imageData, attributes: nil)
            print("saving,,")
        }else{
            print("Exist")
            guard let imageData = try? Data(contentsOf: filePath) else { return nil }
            guard let image = UIImage(data:imageData) else { return nil }
            return image
        }
        return urlImage
    }
}
