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
class LoginViewModel{
    private let apiKey:String = "MHjvnaFJKZwjtHpbipfxYMhG"
    var resultImage = PublishSubject<UIImage>()
    func apiTesting(source:Data) -> CocoaAction{
        return CocoaAction{
            self.uploading(source: source)
            return Observable.empty()
        }
    }
}
extension LoginViewModel{
    func uploading(source:Data){
        RxAlamofire
            .upload(multipartFormData: { builder in
                builder.append(
                    source,
                    withName: "test",
                    fileName: "test.jpg",
                    mimeType: "image/jpeg"
                )
            }, to: URL(string: "https://api.remove.bg/v1.0/removebg")!,method: .post, headers: [
                "X-Api-Key": apiKey
            ])
            .subscribe(onNext:{upload in
                upload.responseJSON { imageResponse in
                    guard let imageData = imageResponse.data, let image = UIImage(data: imageData) else { return }
                    self.resultImage.onNext(image)
                }
            },onError:{ error in
                self.resultImage.onError(error)
            })
            .disposed(by: DisposeBag())
    }
}

