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
    @IBOutlet weak var getPixelButton:UIButton!
    @IBOutlet weak var reulstView:UIImageView!
    override func viewDidLoad() {
        //Get width height from image
        //Find origin
        let array = findColors(imageView.image!)
        let xArr = array[0]
        let yArr = array[1]
        let minP = CGPoint(x: xArr.min()!, y: yArr.min()!)
        let maxP = CGPoint(x: xArr.max()!, y: yArr.max()!)
        reulstView.image = cropToBounds(image: imageView.image!, width: Double(maxP.x - minP.x), height: Double(maxP.y - minP.y),x:CGFloat(minP.x),y:CGFloat(minP.y))
        reulstView.contentMode = .scaleToFill
        reulstView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0.5)
        super.viewDidLoad()
    }
}
func findColors(_ image: UIImage) -> [[Int]]{
    var imageColors: [UIColor] = []
    var xArray:[Int] = []
    var yArray:[Int] = []
    let pixelsWide = Int(image.size.width)
    let pixelsHigh = Int(image.size.height)
    guard let pixelData = image.cgImage?.dataProvider?.data else { return []}
    let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
    for x in 0..<pixelsWide {
        for y in 0..<pixelsHigh {
            let point = CGPoint(x: x, y: y)
            let pixelInfo: Int = ((pixelsWide * Int(point.y)) + Int(point.x)) * 4
            if data[pixelInfo] != 0 {
                xArray.append(x)
                yArray.append(y)
            }
        }
    }
    return [xArray,yArray]
}
func cropToBounds(image: UIImage, width: Double, height: Double,x:CGFloat,y:CGFloat) -> UIImage {
    let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
    let rect: CGRect = CGRect(x: x, y: y ,width: CGFloat(width), height: CGFloat(height))
    // Create bitmap image from context using the rect
    let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    return image
}
