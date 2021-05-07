//
//  ApplicationNotiCenter.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/29.
//
import RxSwift
import Foundation
enum ApplicationNotiCenter:NotificationCenterType{
    case sideMenuWillAppear
    case sideMenuWillDisappear
    case alertControllerAppear
    case alertControllerDisappear
    var name:Notification.Name{
        switch self{
        case .sideMenuWillAppear:
            return Notification.Name("sideMenuWillAppear")
        case .sideMenuWillDisappear:
            return Notification.Name("sideMenuWillDisappear")
        case .alertControllerAppear:
            return Notification.Name("alertControllerAppear")
        case .alertControllerDisappear:
            return Notification.Name("alertControllerDisappear")
        }
    }
}
protocol NotificationCenterType{
    var name:Notification.Name{ get }
}
extension ApplicationNotiCenter{
    func addObserver() -> Observable<Any?>{
        return NotificationCenter.default.rx.notification(self.name).map{$0.object}
    }
    func post(object:Any? = nil){
        NotificationCenter.default.post(name: self.name, object: object,userInfo: nil)
    }
}
