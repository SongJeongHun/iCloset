//
//   AddClothViewModel.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//

import Foundation
import Action
import RxSwift
import RxAlamofire
import Alamofire
//    override func viewDidLoad() {
       
//        super.viewDidLoad()
//    }
class AddClothViewModel:ViewModeltype{
    private let apiKey:String = "MHjvnaFJKZwjtHpbipfxYMhG"
    var resultImage = PublishSubject<UIImage>()
    var resultError = PublishSubject<ConvertFail>()
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
extension AddClothViewModel{
    func uploading(source:Data){
        AF.upload(multipartFormData: { builder in
                builder.append(
                    source,
                    withName: "image_file",
                    fileName: "file.jpg",
                    mimeType: "image/jpeg"
                )
            }, to: URL(string: "https://api.remove.bg/v1.0/removebg")!, method: .post, headers: [
                "X-Api-Key": apiKey
            ])
        .responseJSON {json in
            if let imageData = json.data{
                print(imageData)
                guard let img = UIImage(data: imageData) else {
                    self.resultError.onNext(ConvertFail.fail)
                    return
                }
                self.resultImage.onNext(img)
            }
        }
    }
}
enum ConvertFail:Error{
    case fail
}

