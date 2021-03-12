//
//  Scene.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//
import UIKit
import Foundation

enum Scene{
    case login(LoginViewModel)
    case intro(IntroViewModel)
}
extension Scene{
    func instantiate(from storyboard:String = "Main") -> UIViewController{
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        switch self{
        case .login(let viewModel):
            guard var loginVC = storyboard.instantiateViewController(identifier: "Login") as? LoginViewController else { fatalError() }
            loginVC.bind(viewModel: viewModel)
            return loginVC
        case .intro(let viewModel):
            guard var introVC = storyboard.instantiateViewController(identifier: "Intro") as? IntroViewController else { fatalError() }
            introVC.bind(viewModel: viewModel)
            return introVC
        }
    }
}
