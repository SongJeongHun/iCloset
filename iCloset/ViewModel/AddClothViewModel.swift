//
//   AddClothViewModel.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//

import Foundation
import NSObject_Rx
import Action
import RxSwift
import RxAlamofire
import Alamofire
class AddClothViewModel:ViewModeltype{
    lazy var storage = ImageStorage(userID: userID,closet: selectedCloset)
    private let apiKey:String = "BTypKBKYj18bq1QphqJrAqbn"
    var selectedCloset:String = ""
    var resultImage = PublishSubject<UIImage>()
    var resultError = PublishSubject<ConvertFail>()
    var removeProgress = PublishSubject<Double>()
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
    func createName(keys:[String],cloth:Cloth) -> Cloth{
        var newName = cloth.name
        var count = 0
        print(keys)
        while(true){
            if keys.contains(newName){
                count += 1
                newName = "\(cloth.name)_\(count)"
            }else{
                break
            }
        }
        if count == 0 { return cloth }
        else { return Cloth(name: newName, brand: cloth.brand, category: cloth.category, timeCreated: cloth.timeCreated) }
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
        .downloadProgress{progress in
            self.removeProgress.onNext(progress.fractionCompleted)
        }
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

