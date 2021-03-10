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
            .subscribe(onNext:{ _ in
                self.addThumbnailAlert()
            })
            .disposed(by: rx.disposeBag)
        removeBG.rx.tap
            .throttle(.milliseconds(5000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ _ in
                if let source = self.inputImage.image{
                    self.indicator.isHidden = false
                    self.indicator.startAnimating()
                    let jpegSource = source.jpegData(compressionQuality: 0.5)!
                    self.viewModel.uploading(source: jpegSource)
                }
            })
            .disposed(by: rx.disposeBag)
        viewModel.resultImage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] image in
                self.resultImage.image = image
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
            })
            .disposed(by: rx.disposeBag)
        viewModel.resultError
            .subscribe(onNext:{ _ in
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                let alert = UIAlertController(title: "알림", message: "물체가 너무 많거나 물체를 찾을 수 없습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by:rx.disposeBag)
    }
}
