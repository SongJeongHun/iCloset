//
//  TimeLineViewModel.swift
//  iCloset
//
//  Created by 송정훈 on 2021/05/16.
//

import Foundation
import RxSwift
import RxCocoa
import Action
class TimeLineViewModel:ViewModeltype{
    var dummyEvent = BehaviorSubject(value: ["124sjh 님이 상의를 추가하였습니다.","124sjh 님이 신발을 추가하였습니다."])
    let dummyDate = BehaviorSubject(value:["2021.05.16","2021.05.16"])
    let dummyDateArray = ["2021.05.16","2021.05.15"]
    var formatter:DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy.MM.dd"
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    var selectedDate = BehaviorSubject<Date>(value: Date())
    var selectedDateString = ""
    func datePickAction() -> CocoaAction{
        return CocoaAction{_ in
            let datePickScene = Scene.datePick(self)
            return self.sceneCoordinator.transition(to: datePickScene, using: .push, animated: true).asObservable().map{ _ in }
        }
    }
}
