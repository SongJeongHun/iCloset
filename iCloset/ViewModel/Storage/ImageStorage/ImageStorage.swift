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
    let currentCloset:String
    let bag = DisposeBag()
    let ref = Database.database().reference()
    let storeRef = Storage.storage()
    init (userID:String,closet:String){
        self.userID = userID
        self.currentCloset = closet
    }
    func clothNameValidationCheck(closet:String,cloth:Cloth) -> Observable<[String]>{
        let subject = PublishSubject<[String]>()
        ref.child("users").child(userID).child(closet).child("\(cloth.category)").rx
            .observeSingleEvent(.value)
            .subscribe(onSuccess: { [unowned self] snap in
                guard let data = snap.value! as? Dictionary<String,Any> else {
                    print("error occur")
                    return subject.onError(fatalError())
                }
                subject.onNext(Array(data.keys))
            })
            .disposed(by: bag)
        return subject
    }
    func savePath(closet:String,cloth:Cloth){
        ref.child("users").child(userID).child(closet).child("\(cloth.category)").child(cloth.name).rx
            .setValue(["clothName":cloth.name,"clothBrand":cloth.brand,"clothCategory":"\(cloth.category)"])
            .subscribe { _ in }
            .disposed(by: bag)
    }
    func getPath(closet:String,category:clothCategory) -> Observable<[String]> {
        let subject = PublishSubject<[String]>()
        ref.child("users").child(userID).child(closet).child("\(category)").rx
            .observeSingleEvent(.value)
            .subscribe(onSuccess:{ [unowned self] snap in
                guard let data = snap.value! as? Dictionary<String,Any> else {
                    return
                }
                subject.onNext(Array(data.keys))
            })
        return subject
    }
    func saveThumbnail(closet:String,cloth:Cloth,img:UIImage) -> Observable<Double>{
        let subject = PublishSubject<Double>()
        var data = img.pngData()!
        let ref = storeRef.reference().child("users/\(userID)/\(closet)/\(cloth.category)").child("\(cloth.name)_img")
        let uploadTask = ref.putData(data)
        uploadTask.rx.observe(.progress)
            .subscribe(onNext:{ snapshot in
                subject.onNext(100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount))
            })
            .disposed(by: bag)
        uploadTask.rx.observe(.success)
            .subscribe(onNext:{ _ in
                self.savePath(closet: closet, cloth: cloth)
            })
        return subject
    }
    func getThumbnail(cloth:Cloth) -> Observable<[UIImage]>{
        let subject = PublishSubject<[UIImage]>()
        let ref = storeRef.reference(forURL: "gs://icloset-a4494.appspot.com/users/\(userID)/\(currentCloset)/\(cloth.category)/\(cloth.name)").rx
        ref.downloadURL()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(onNext:{url in
                let data = try! Data(contentsOf: url)
                subject.onNext([UIImage(data: data)!])
            })
            .disposed(by: bag)
        return subject
    }
}
