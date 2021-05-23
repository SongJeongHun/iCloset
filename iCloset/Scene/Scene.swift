//
//  Scene.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//
import UIKit
import Foundation
import Mantis

enum Scene{
    case datePick(TimeLineViewModel)
    case addCloth(AddClothViewModel)
    case intro(IntroViewModel)
    case join(IntroViewModel)
    case closet(ClosetViewModel,TimeLineViewModel)
    case resize
    case selectCloset(ClosetViewModel)
    case cropping(UIImage)
    case preset(ClosetViewModel)
    case presetSelect(ClosetViewModel)
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
        case .closet(let viewModel,let timeLineViewModel):
            guard let mainTVC = storyboard.instantiateViewController(identifier: "MainTab") as? UITabBarController else { fatalError() }
            guard let historyNav = mainTVC.children.first as? UINavigationController else { fatalError() }
            guard var historyVC = historyNav.children.first as? TimeLineViewController else { fatalError() }
            historyVC.bind(viewModel: timeLineViewModel)
            guard let closetNav = mainTVC.children.last as? UINavigationController else { fatalError() }
            guard var closetVC = closetNav.children.first as? ClosetViewController else { fatalError() }
            for vc in closetVC.children{
                var clothItemVC = vc as! ClothItemViewController
                clothItemVC.bind(viewModel: viewModel)
            }
            closetVC.bind(viewModel: viewModel)
            return mainTVC
        case .selectCloset(let viewModel):
            guard let closetSideNav = storyboard.instantiateViewController(identifier: "ClosetSideNav") as? ClosetSideMenuNavigation else { fatalError() }
            guard var selectClosetVC = closetSideNav.children.first! as? SelectClosetViewController else { fatalError() }
            selectClosetVC.bind(viewModel: viewModel)
            return closetSideNav
        case .cropping(let image):
            let cropViewController = Mantis.cropViewController(image:image)
            return cropViewController
        case .datePick(let timeLineViewModel):
            guard var dateVC = storyboard.instantiateViewController(identifier: "datePick") as? DatePickViewController else { fatalError() }
            dateVC.bind(viewModel: timeLineViewModel)
            return dateVC
        case .preset(let presetViewModel):
            guard var presetVC = storyboard.instantiateViewController(identifier: "Preset") as? PresetViewController else { fatalError() }
            presetVC.bind(viewModel: presetViewModel)
            return presetVC
        case .presetSelect(let viewModel):
            guard var presetSelectVC = storyboard.instantiateViewController(identifier: "PresetSelect") as? PresetSelectViewController else { fatalError() }
            presetSelectVC.bind(viewModel: viewModel)
            return presetSelectVC
        }
    }
}
