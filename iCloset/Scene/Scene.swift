//
//  Scene.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//
import UIKit
import Foundation

enum Scene{
    case test(TestViewModel)
    case intro(IntroViewModel)
    case join(IntroViewModel)
//    case main
    case resize
}
extension Scene{
    func instantiate(from storyboard:String = "Main") -> UIViewController{
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        switch self{
        case .test(let viewModel):
            guard var loginVC = storyboard.instantiateViewController(identifier: "APITest") as? TestViewController else { fatalError() }
            loginVC.bind(viewModel: viewModel)
            return loginVC
        case .intro(let viewModel):
            guard var introVC = storyboard.instantiateViewController(identifier: "Intro") as? IntroViewController else { fatalError() }
            introVC.bind(viewModel: viewModel)
            return introVC
        case .join(let viewModel):
            guard var joinVC = storyboard.instantiateViewController(identifier: "Join") as? JoinViewController else { fatalError() }
            joinVC.bind(viewModel: viewModel)
            return joinVC
        case .resize:
            guard let resizeVC = storyboard.instantiateViewController(identifier: "Resize") as? ResizeViewController else { fatalError() }
            return resizeVC
        }
    }
}
