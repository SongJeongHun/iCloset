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
        let minP = CGPoint(x: array[0].min()!, y: array[1].min()!)
        let maxP = CGPoint(x: array[0].max()!, y: array[1].max()!)
        super.viewDidLoad()
    }
}
func findColors(_ image: UIImage) -> [[Int]]{
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

