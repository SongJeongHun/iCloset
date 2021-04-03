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
    func saveThumbnail(cloth:Cloth,img:UIImage) -> Observable<Double>{
        let subject = PublishSubject<Double>()
        var data = img.jpegData(compressionQuality: 0.8)!
        let ref = storeRef.reference().child("users/\(userID)/\(cloth.category)").child("\(cloth.name)_img")
        let uploadTask = ref.putData(data)
        uploadTask.rx.observe(.progress)
            .subscribe(onNext:{ snapshot in
                subject.onNext(100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount))
            })
        return subject
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
