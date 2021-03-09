//
//  LoginViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//


// API TEST ViewController
import UIKit
import RxSwift
import NSObject_Rx
class LoginViewController: UIViewController,ViewControllerBindableType,UINavigationControllerDelegate {
    var viewModel:LoginViewModel!
    let picker = UIImagePickerController()
    @IBOutlet weak var inputImage:UIImageView!
    @IBOutlet weak var resultImage:UIImageView!
    @IBOutlet weak var sendImageButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    func bindViewModel() {
        sendImageButton.rx.tap
            .throttle(.milliseconds(5000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{_ in
                self.addThumbnailAlert()
            })
            .disposed(by: rx.disposeBag)       
        viewModel.resultImage
            .subscribe(onNext:{[unowned self]image in
                self.resultImage.image = image
            },onError: { error in
                print(error)
            })
            .disposed(by: rx.disposeBag)
    }
    
}
