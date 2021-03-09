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
class Coordinator:SceneCoordinatorType{
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
    func close(animated:Bool) -> Completable{
        return Completable.create{[unowned self] com in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated){
                    self.currentVC = presentingVC.sceneViewController
                    com(.completed)
                }
            }else if let nav = self.currentVC.navigationController{
                guard nav.popViewController(animated: animated) != nil else {
                    com(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.children.last!
                com(.completed)
            }else{
                com(.error(TransitionError.unKnownError))
            }
            return Disposables.create()
        }
    }
}
