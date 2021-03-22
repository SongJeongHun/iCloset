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
    var userStorage = UserJoinStorage()
    func joinAction() -> CocoaAction{
        return CocoaAction{ _ in
            let joinScene = Scene.join(self)
            return self.sceneCoordinator.transition(to: joinScene, using: .modal, animated: true).asObservable().map { _ in }
        }
    }
    func loginSuccessAction(_ userID:String) -> CocoaAction{
        return CocoaAction{ _ in
            let closetVM = ClosetViewModel(sceneCoordinator: self.sceneCoordinator, userID: userID)
            let closetScene = Scene.closet(closetVM)
            return self.sceneCoordinator.transition(to: closetScene, using: .root, animated: true).asObservable().map { _ in }
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
