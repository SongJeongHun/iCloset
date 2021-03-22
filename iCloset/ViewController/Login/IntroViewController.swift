//
//  IntroViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/11.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie
import Action
class IntroViewController: UIViewController,ViewControllerBindableType{
    var viewModel: IntroViewModel!
    @IBOutlet weak var loginPanel:UIView!
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var joinButton:UIButton!
    @IBOutlet weak var findButton:UIButton!
    @IBOutlet weak var socialLogin:UIButton!
    @IBOutlet weak var userID:UITextField!
    @IBOutlet weak var userPassword:UITextField!
    override func viewDidLoad() {
        setUI()
        super.viewDidLoad()
    }
    func bindViewModel() {
        joinButton.rx.action = viewModel.joinAction()
        loginButton.rx.tap
            .throttle(.milliseconds(4000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ _ in
                guard let userID = self.userID.text else { return }
                guard let userPassword = self.userPassword.text else { return }
                self.viewModel.userStorage.login(userID: userID, userPassword: userPassword)
                    .subscribe(onCompleted:{
                        guard let userID = self.userID.text else { return }
                        self.viewModel.loginSuccessAction(userID).execute()
                    }) { error in
                        let alertController = UIAlertController(title: "알림", message: "로그인 실패", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion:  nil)
                    }
            })
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        //Set CornerRadius
        loginPanel.layer.cornerRadius = 7.0
        loginButton.layer.cornerRadius = 7.0
        joinButton.layer.cornerRadius = 7.0
        findButton.layer.cornerRadius = 7.0
        socialLogin.layer.cornerRadius = 7.0
        //Set Shadow
        loginPanel.layer.shadowRadius = 2.0
        loginPanel.layer.shadowOffset = CGSize(width: 2, height: 3)
        loginPanel.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        loginPanel.layer.shadowOpacity = 0.2
        //other
        userPassword.isSecureTextEntry = true
    }
}

