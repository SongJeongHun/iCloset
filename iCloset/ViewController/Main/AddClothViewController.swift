//
//  AddClothViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//

import UIKit
import RxSwift
import NSObject_Rx
class AddClothViewController: UIViewController,ViewControllerBindableType,UINavigationControllerDelegate {
    var viewModel:AddClothViewModel!
    let picker = UIImagePickerController()
    @IBOutlet weak var inputImage:UIImageView!
    @IBOutlet weak var imagePickButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        picker.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.sceneCoordinator.currentVC = self.parent!.parent!
        super.viewWillDisappear(animated)
    }
    func bindViewModel() {
        imagePickButton.rx.tap
            .observeOn(MainScheduler.instance)
            .throttle(.milliseconds(5000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ _ in
                self.addThumbnailAlert()
            })
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        imagePickButton.layer.cornerRadius = 5.0
    }
}
