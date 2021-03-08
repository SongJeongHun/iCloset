//
//  Coordinator.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//
import UIKit
import Foundation
import RxCocoa
import RxSwift
extension UIViewController{
    var sceneViewController:UIViewController{
        return self.children.first ?? self
    }
}
class Coordinator{
    private let bag = DisposeBag()
    private let window:UIWindow
    var currentVC:UIViewController
    required init(window:UIWindow){
        self.window = window
        currentVC = window.rootViewController!
    }
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let target = scene.instantiate()
        let subject = PublishSubject<Void>()
        switch style{
        case .modal:
            currentVC.present(target, animated: animated){
                subject.onCompleted()
            }
            currentVC = target.sceneViewController
            subject.onCompleted()
        case .push:
            guard let nav = currentVC.children.first as? UINavigationController else{
                subject.onError(TransitionError.navigationMissing)
                break
            }
            nav.rx.willShow
                .subscribe{[unowned self]evt in
                    self.currentVC = currentVC.parent!.parent!
                }
                .disposed(by: bag)
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            subject.onCompleted()
        case .root:
            currentVC = target
            window.rootViewController = target
            subject.onCompleted()
        }
        return subject.ignoreElements()
    }

}
