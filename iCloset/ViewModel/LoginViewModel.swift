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
class LoginViewModel{
    private let apiKey:String = "MHjvnaFJKZwjtHpbipfxYMhG"
    var resultImage = PublishSubject<UIImage>()
}
extension LoginViewModel{
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
                guard let img = UIImage(data: imageData) else {
                    self.resultImage.onError(fatalError())
                }
                self.resultImage.onNext(img)
            }
        }
    }
}

