//
//  IntroViewModel.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/12.
//
import RxSwift
import Action
import Foundation
class IntroViewModel:ViewModeltype{
    func joinAction() -> CocoaAction{
        return CocoaAction{ _ in
            let joinScene = Scene.join(self)
            return self.sceneCoordinator.transition(to: joinScene, using: .modal, animated: true).asObservable().map { _ in }
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
