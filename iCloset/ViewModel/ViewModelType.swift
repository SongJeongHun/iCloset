//
//  ViewModelType.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/12.
//
import Foundation
class ViewModeltype{
    var userID:String
    var sceneCoordinator:Coordinator
    init(sceneCoordinator:Coordinator,userID:String){
        self.userID = userID
        self.sceneCoordinator = sceneCoordinator
    }
}
