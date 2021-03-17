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
    override func viewDidLoad() {
        //Get width height from image
        //Find origin
        let array = findColors(imageView.image!)
        let xArr = array[0] as! [Int]
        let yArr = array[1] as! [Int]
        let colorArr = array[2] as! [UIColor]
        let minP = CGPoint(x: xArr.min()!, y: yArr.min()!)
        let maxP = CGPoint(x: xArr.max()!, y: yArr.max()!)
        var view = UIImageView(frame: CGRect(x: minP.x, y: minP.y, width: maxP.x - minP.x, height: maxP.y - minP.y))
        view.image = cropToBounds(image: imageView.image!, width: Double(maxP.x - minP.x), height: Double(maxP.y - minP.y),x:CGFloat(minP.x),y:CGFloat(minP.y))
        view.contentMode = .scaleToFill
        view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0.5)
        imageView.addSubview(view)
        super.viewDidLoad()
    }
}
func findColors(_ image: UIImage) -> [[Any]]{
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
                let color = UIColor(red: CGFloat(data[pixelInfo]) / 255.0,
                                    green: CGFloat(data[pixelInfo + 1]) / 255.0,
                                    blue: CGFloat(data[pixelInfo + 2]) / 255.0,
                                    alpha: CGFloat(data[pixelInfo + 3]) / 255.0)
                imageColors.append(color)
            }
        }
    }
    return [xArray,yArray,imageColors]
}
func cropToBounds(image: UIImage, width: Double, height: Double,x:CGFloat,y:CGFloat) -> UIImage {
    let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
    let contextSize: CGSize = contextImage.size
    var posX: CGFloat = x
    var posY: CGFloat = y
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)
    let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
    // Create bitmap image from context using the rect
    let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    return image
}
