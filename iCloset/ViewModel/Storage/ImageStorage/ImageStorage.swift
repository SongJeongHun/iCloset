//
//  ImageStorage.swift
//  iCloset
//
//  Created by 송정훈 on 2021/04/03.
//
import RxSwift
import Action
import Firebase
import RxFirebaseDatabase
import NSObject_Rx
import RxFirebaseStorage
import Foundation
class ImageStorage{
    private let userID:String
    let bag = DisposeBag()
    let ref = Database.database().reference()
    let storeRef = Storage.storage()
    init (userID:String){
        self.userID = userID
    }
    func saveThumbnail(cloth:Cloth,img:UIImage) -> Completable{
        let subject = PublishSubject<Void>()
        var data = img.jpegData(compressionQuality: 0.8)!
        let ref = storeRef.reference().child("users/\(userID)/\(cloth.category)").child("\(cloth.name)_img").rx
            .putData(data)
            .subscribe(onNext:{metadata in
                subject.onCompleted()
            }) { error in
                subject.onError(error)
            }
            .disposed(by: bag)
        return subject.ignoreElements()
    }
//    func getThumbnail(cloth:Cloth) -> Observable<UIImage>{
//        let subject = PublishSubject<UIImage>()
//        let ref = storeRef.reference(forURL: "gs://calendeck-e28b2.appspot.com/users/\(userID)/cardsThumbnail/\(card.title)_thumbnail").rx
//        ref.downloadURL()
//            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
//            .subscribe(onNext:{url in
//                let data = try! Data(contentsOf: url)
//                subject.onNext(UIImage(data: data)!)
//            }) { error in
//                print(error)
//            }
//            .disposed(by: bag)
//        return subject
//    }
}
