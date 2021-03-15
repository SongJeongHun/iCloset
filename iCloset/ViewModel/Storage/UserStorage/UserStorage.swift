//
//  UserStorage.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/13.
//

import Foundation
import RxFirebase
import RxSwift
import Firebase
class UserJoinStorage{
    let bag = DisposeBag()
    let ref = Database.database().reference()
    func userJoin(client:User) -> Completable {
        let subject = PublishSubject<Void>()
        ref.child("users").child(client.userID).rx
            .setValue(["userID":client.userID,"userPassWord":client.userPassword,"userEmail":client.userEmail])
            .subscribe { _ in
                subject.onCompleted()
            } onError: { error in
                subject.onError(error)
            }
            .disposed(by:bag)
        return subject.ignoreElements()
    }
    func userIDValidationCheck(userID:String) -> Observable<Bool> {
        let subject = PublishSubject<Bool>()
        ref.child("users").rx
            .observeSingleEvent(.value)
            .subscribe(onSuccess: {snap in
                guard let data = snap.value! as? Dictionary<String,Any> else {
                    print("error occur")
                    return subject.onError(fatalError())
                }
                if data.keys.contains(userID){
                    subject.onNext(false)
                }else{
                    subject.onNext(true)
                }
            },onError: { error in
                subject.onError(error)
            })
            .disposed(by: bag)
        return subject
    }
    func login(userID:String,userPassword:String) -> Completable{
        let subject = PublishSubject<Void>()
        ref.child("users").child(userID).rx
            .observeSingleEvent(.value)
            .subscribe(onSuccess:{snap in
                if snap.exists(){
                    let data = snap.value! as! Dictionary<String,Any>
                    if data["userPassWord"] as! String == userPassword{
                        subject.onCompleted()
                    }else{
                        subject.onError(UserError.userPasswordMissing)
                    }
                    subject.onError(UserError.userPasswordMissing)
                }else{
                    subject.onError(UserError.userIDMissing)
                }
            })
            .disposed(by: bag)
        return subject.ignoreElements()
    }
}
