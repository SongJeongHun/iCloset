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
//        FirebaseApp.configure()
        let loginVM = LoginViewModel()
        let loginScene = Scene.login(loginVM)
        let coordinator = Coordinator(window: window!)
        coordinator.transition(to: loginScene, using: .root, animated: true)
        return true
    }
}

