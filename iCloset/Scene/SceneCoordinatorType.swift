//
//  SceneCoordinatorType.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//
import RxSwift
import Foundation
protocol SceneCoordinatorType{
    func transition(to scene: Scene, using style:TransitionStyle, animated:Bool) -> Completable
    func close(animated:Bool) -> Completable
}
