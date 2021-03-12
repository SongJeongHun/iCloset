//
//  AppDelegate.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/04.
//

import UIKit
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let coordinator = Coordinator(window: window!)
        let introVM = IntroViewModel(sceneCoordinator: coordinator, userID: "")
        let introScene = Scene.intro(introVM)
        coordinator.transition(to: introScene, using: .root, animated: true)
        return true
    }
}

