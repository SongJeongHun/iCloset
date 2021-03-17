//
//  JoinViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/12.
//
import UIKit
import NSObject_Rx
import RxCocoa
import RxSwift
import Lottie
class JoinViewController: UIViewController,ViewControllerBindableType,UIGestureRecognizerDelegate {
    var viewModel:IntroViewModel!
    let clothAnimationView = AnimationView(name: "clothes")
//    @IBOutlet weak var confirmComment:UILabel!
    @IBOutlet weak var checkImage:UIImageView!
    @IBOutlet weak var confirmButton:UIButton!
    @IBOutlet weak var joinPanel:UIView!
    @IBOutlet weak var userID:UITextField!
    @IBOutlet weak var userIDValidationCheckButton:UIButton!
    @IBOutlet weak var userPassword:UITextField!
    @IBOutlet weak var userPasswordConfirm:UITextField!
    @IBOutlet weak var userEmail:UITextField!
    var userIDValidationCheck = false
    var userValidationList:[Bool] = [false,false,false,false,false]
    lazy var userValidation = BehaviorSubject<[Bool]>(value: userValidationList)
    override func viewWillAppear(_ animated: Bool) {
        setUI()
        setGesture()
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.sceneCoordinator.currentVC = presentingViewController!
        super.viewWillDisappear(animated)
    }
    func setGesture(){
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    func bindViewModel() {
        userID.rx.text
            .subscribe(onNext:{ [unowned self] text in
                if let ID = text{
                    if ID.count > 3 && ID.count < 13{
                        self.userValidationList[0] = true
                        self.userValidation.onNext(self.userValidationList)
                        self.userIDValidationCheckButton.isEnabled = true
                        self.userIDValidationCheckButton.backgroundColor = #colorLiteral(red: 0.8157966137, green: 0.7181168199, blue: 0.5808442235, alpha: 1)
                        self.userID.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    }else{
                        self.userValidationList[0] = false
                        self.userValidation.onNext(self.userValidationList)
                        self.userIDValidationCheckButton.backgroundColor = #colorLiteral(red: 0.8157966137, green: 0.7181168199, blue: 0.5808442235, alpha: 0.5)
                        self.userIDValidationCheckButton.isEnabled = false
                        self.userID.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        Observable.combineLatest(userPassword.rx.text,userPasswordConfirm.rx.text)
            .subscribe(onNext:{ [unowned self] pwd,pwdConfirm in
                if let password = pwd, let passwordConfirm = pwdConfirm{
                    if password != passwordConfirm{
                        self.userValidationList[2] = false
                        self.userValidation.onNext(self.userValidationList)
                        self.userPasswordConfirm.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    }
                    if password.count > 6{
                        if password == passwordConfirm{
                            self.userValidationList[2] = true
                            self.userValidation.onNext(self.userValidationList)
                            self.userPasswordConfirm.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                        }
                        self.userValidationList[1] = true
                        self.userValidation.onNext(self.userValidationList)
                        self.userPassword.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    }else{
                        self.userValidationList[1] = false
                        self.userValidation.onNext(self.userValidationList)
                        self.userPassword.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        userEmail.rx.text
            .subscribe(onNext:{ [unowned self] text in
                if let email = text{
                    if self.viewModel.isValidEmail(testStr: email){
                        self.userValidationList[3] = true
                        self.userValidation.onNext(self.userValidationList)
                        self.userEmail.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    }else{
                        self.userValidationList[3] = false
                        self.userValidation.onNext(self.userValidationList)
                        self.userEmail.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        userValidation
            .subscribe(onNext:{valid in
                if !valid.contains(false){
                    self.confirmButton.backgroundColor = #colorLiteral(red: 0.8157966137, green: 0.7181168199, blue: 0.5808442235, alpha: 1)
                    self.confirmButton.isEnabled = true
                }else{
                    self.confirmButton.backgroundColor = #colorLiteral(red: 0.8157966137, green: 0.7181168199, blue: 0.5808442235, alpha: 0.5)
                    self.confirmButton.isEnabled = false
                }
            })
            .disposed(by: rx.disposeBag)
        confirmButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{
                let client = User(userID: self.userID.text!, userPassword: self.userPassword.text!, userEmail: self.userEmail.text!)
                self.viewModel.userStorage.userJoin(client: client)
                    .subscribe {_ in
                        let alertController = UIAlertController(title: "알림", message: "가입 성공!", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "확인", style: .default, handler: {_ in
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(ok)
                        self.present(alertController,animated: true,completion:nil)
                    }
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
        userIDValidationCheckButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{
                self.viewModel.userStorage.userIDValidationCheck(userID: self.userID.text!)
                    .subscribe(onNext:{[unowned self]valid in
                        if valid{
                            let alertController = UIAlertController(title: "알림", message: "사용 하실수 있는 아이디 입니다.", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alertController.addAction(ok)
                            self.present(alertController,animated: true,completion: nil)
                            self.checkImage.isHidden = false
                            self.userIDValidationCheckButton.titleLabel?.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                            self.userValidationList[4] = true
                            self.userID.isEnabled = false
                            self.userValidation.onNext(self.userValidationList)
                        }else{
                            let alertController = UIAlertController(title: "알림", message: "이미 있는 아이디 입니다.", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alertController.addAction(ok)
                            self.present(alertController,animated: true,completion: nil)
                            self.userIDValidationCheckButton.titleLabel?.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                            self.userValidationList[4] = false
                            self.userValidation.onNext(self.userValidationList)
                        }
                    })
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        checkImage.isHidden = true
        userIDValidationCheckButton.layer.cornerRadius = 5.0
        confirmButton.layer.cornerRadius = 5.0
        joinPanel.layer.cornerRadius = 5.0
        userPassword.isSecureTextEntry = true
        userPasswordConfirm.isSecureTextEntry = true
        userPassword.layer.cornerRadius = 5.0
        userPasswordConfirm.layer.cornerRadius = 5.0
        userID.layer.cornerRadius = 5.0
        userEmail.layer.cornerRadius = 5.0
        userID.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        userID.layer.borderWidth = 1.0
        userPasswordConfirm.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        userPasswordConfirm.layer.borderWidth = 1.0
        userPassword.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        userPassword.layer.borderWidth = 1.0
        userEmail.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        userEmail.layer.borderWidth = 1.0
        //Shadow Effect
        joinPanel.layer.shadowRadius = 2.0
        joinPanel.layer.shadowOffset = CGSize(width: 2, height: 3)
        joinPanel.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        joinPanel.layer.shadowOpacity = 0.2
        //Lottie Animation
    }
}
extension JoinViewController{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
