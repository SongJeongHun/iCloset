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
    @IBOutlet weak var imagePickButton:UIButton!
    @IBOutlet weak var removeBG:UIButton!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        picker.delegate = self
    }
    func bindViewModel() {
        imagePickButton.rx.tap
            .observeOn(MainScheduler.instance)
            .throttle(.milliseconds(5000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{_ in
                self.addThumbnailAlert()
            })
            .disposed(by: rx.disposeBag)
        removeBG.rx.tap
            .throttle(.milliseconds(5000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{_ in
                if let source = self.inputImage.image{
                    let jpegSource = source.jpegData(compressionQuality: 0.5)!
                    self.viewModel.uploading(source: jpegSource)
                    self.indicator.isHidden = false
                    self.indicator.startAnimating()
                }
            })
            .disposed(by: rx.disposeBag)
        viewModel.resultImage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{[unowned self]image in
                self.resultImage.image = image
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
            },onError: { error in
                print(error)
            })
            .disposed(by: rx.disposeBag)
    }
    
}
