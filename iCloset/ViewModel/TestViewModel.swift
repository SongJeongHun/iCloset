//
//  LoginViewModel.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//

import Foundation
import Action
import RxSwift
import RxAlamofire
import Alamofire
class TestViewModel{
    private let apiKey:String = "MHjvnaFJKZwjtHpbipfxYMhG"
    var resultImage = PublishSubject<UIImage>()
    var resultError = PublishSubject<ConvertFail>()
    func test(img:UIImage) -> UIImage{
        
        return UIImage()
    }
}
extension TestViewModel{
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

