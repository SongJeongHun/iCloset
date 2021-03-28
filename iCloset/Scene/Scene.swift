//
//  Scene.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//
import UIKit
import Foundation

enum Scene{
    case addCloth(AddClothViewModel)
    case intro(IntroViewModel)
    case join(IntroViewModel)
    case closet(ClosetViewModel)
    case resize
}
extension Scene{
    func instantiate(from storyboard:String = "Main") -> UIViewController{
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        switch self{
        case .addCloth(let viewModel):
            guard var addClothVC = storyboard.instantiateViewController(identifier: "AddCloth") as? AddClothViewController else { fatalError() }
            addClothVC.bind(viewModel: viewModel)
            return addClothVC
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
        case .closet(let viewModel):
            guard let mainTVC = storyboard.instantiateViewController(identifier: "MainTab") as? UITabBarController else { fatalError() }
            guard let historyNav = mainTVC.children.first as? UINavigationController else { fatalError() }
            guard let historyVC = historyNav.children.first as? UIViewController else { fatalError() }
            guard let closetNav = mainTVC.children.last as? UINavigationController else { fatalError() }
            guard var closetVC = closetNav.children.first as? ClosetViewController else { fatalError() }
            for vc in closetVC.children{
                var clothItemVC = vc as! ClothItemViewController
                clothItemVC.bind(viewModel: viewModel)
            }
            closetVC.bind(viewModel: viewModel)
            return mainTVC

        }
    }
}
