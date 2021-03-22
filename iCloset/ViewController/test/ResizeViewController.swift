//
//  ResizeViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/17.
//

import UIKit
import RxSwift
import RxCocoa

class ResizeViewController: UIViewController {
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var reulstView:UIImageView!
    override func viewDidLoad() {
        let array = findColors(imageView.image!)
        let xArr = array[0]
        let yArr = array[1]
        let minP = CGPoint(x: xArr.min()!, y: yArr.min()!)
        let maxP = CGPoint(x: xArr.max()!, y: yArr.max()!)
        reulstView.image = cropToBounds(image: imageView.image!, width: Double(maxP.x - minP.x), height: Double(maxP.y - minP.y),x:CGFloat(minP.x),y:CGFloat(minP.y))
        super.viewDidLoad()
    }
    func findColors(_ image: UIImage) -> [[Int]] {
        var xArray:[Int] = []
        var yArray:[Int] = []
        //Get width height from image
        let pixelWidth = Int(image.size.width)
        let pixelHeight = Int(image.size.height)
        guard let pixelData = image.cgImage?.dataProvider?.data else { return []}
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        for x in 0..<pixelWidth {
            for y in 0..<pixelHeight {
                let point = CGPoint(x: x, y: y)
                let pixelInfo: Int = ((pixelWidth * Int(point.y)) + Int(point.x)) * 4
                //Find origin
                if data[pixelInfo] != 0 {
                    xArray.append(x)
                    yArray.append(y)
                }
            }
        }
        return [xArray,yArray]
    }
    func cropToBounds(image: UIImage, width: Double, height: Double,x:CGFloat,y:CGFloat) -> UIImage {
        let contextImage = UIImage(cgImage: image.cgImage!)
        let rect = CGRect(x: x, y: y ,width: CGFloat(width), height: CGFloat(height))
        let imageRef = contextImage.cgImage!.cropping(to: rect)!
        let image = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return image
    }
}

