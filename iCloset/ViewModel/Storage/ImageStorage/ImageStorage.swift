//
//  ImageStorage.swift
//  iCloset
//
//  Created by 송정훈 on 2021/04/03.
//observeOn은 Observable이 작업할 스레드 지정, subscribeOn은 구독이 작업할 스레드 지정합니다.
//subscribeOn은 구독 앞에서 호출해도 되지만, observeOn보다 먼저 호출하여 어떤 스레드에서 구독 작업을 하는지 지정하는 것도 좋습니다.
//
import RxSwift
import Action
import DropDown
import Firebase
import RxFirebaseDatabase
import NSObject_Rx
import RxFirebaseStorage
import Foundation
class ImageStorage{
    var formatter:DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy.MM.dd,hh:mm"
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    var imageCache = ImageCache()
    private let userID:String
    var currentCloset:String
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
            .subscribe(onSuccess: { snap in
                guard let data = snap.value! as? Dictionary<String,Any> else {
                    return subject.onNext(Array())
                }
                subject.onNext(Array(data.keys))
            })
            .disposed(by: bag)
        return subject
    }
    func saveCloset(closetName:String){
        ref.child("users").child(userID).child("closets").child(closetName).rx
            .setValue(formatter.string(from:Date()))
            .subscribe { _ in }
            .disposed(by: bag)
    }
    func getCloset() -> Observable<[String]>{
        let subject = PublishSubject<[String]>()
        var keyArray : [String] = []
        ref.child("users").child(userID).child("closets").rx
            .observeSingleEvent(.value)
            .subscribe(onSuccess:{ [unowned self] snap in
                guard let data = snap.value! as? Dictionary<String,String> else {
                    print("fail")
                    return
                }
                let sortedData = data.sorted{formatter.date(from: $0.value)! < formatter.date(from: $1.value)!}
                for i in sortedData{
                    keyArray.append(i.key)
                }
                subject.onNext(keyArray)
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
    func getPath(closet:String,category:clothCategory) -> Observable<[Cloth]> {
        let subject = PublishSubject<[Cloth]>()
        var clothArr:[Cloth] = []
        ref.child("users").child(userID).child(closet).child("\(category)").rx
            .observeSingleEvent(.value)
            .subscribe(onSuccess:{ [unowned self] snap in
                guard let data = snap.value! as? Dictionary<String,Any> else { return }
                for i in data.values{
                    guard let stringData = i as? Dictionary<String,String> else { return }
                    let category:clothCategory
                    switch stringData["clothCategory"]{
                    case "top":
                        category = clothCategory.top
                    case "botoom":
                        category = clothCategory.bottom
                    case "shoe":
                        category = clothCategory.shoe
                    case "acc":
                        category = clothCategory.acc
                    default:
                        return
                    }
                    let cloth = Cloth(name: stringData["clothName"]!, brand: stringData["clothBrand"]!, category:category,timeCreated: Date())
                    clothArr.append(cloth)
                }
                subject.onNext(clothArr)
            })
        return subject
    }
    func getThumbnail(from path:[Cloth],category:clothCategory) -> Observable<[ClothItem]>{
        let subject = PublishSubject<[ClothItem]>()
        var items:[ClothItem] = []
        for i in path {
            let ref = storeRef.reference(forURL: "gs://icloset-a4494.appspot.com/users/\(userID)/\(currentCloset)/\(category)/\(i.name)_img").rx
            Observable.combineLatest(ref.downloadURL(), ref.getMetadata())
//                .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                .map{
                    let image = self.imageCache.getFile(url: $0)
                    let time = $1.value(forKey: "timeCreated") as! Date
                    let item = ClothItem(cloth: i, img: image ?? UIImage(), createdTime: time)
                    items.append(item)
                    items.sort(by:{ $0.createdTime < $1.createdTime })
                    return items
                }
                .subscribe(onNext:{ items in
                    subject.onNext(items)
                })
                .disposed(by:bag)
        }
        return subject
    }
    func saveThumbnail(closet:String,cloth:Cloth,img:UIImage) -> Observable<Double>{
        let subject = PublishSubject<Double>()
        let data = img.pngData()!
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
}
