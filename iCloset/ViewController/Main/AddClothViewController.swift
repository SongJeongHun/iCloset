//
//  AddClothViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//

import UIKit
import RxSwift
import NSObject_Rx
class AddClothViewController: UIViewController,ViewControllerBindableType,UINavigationControllerDelegate,UIScrollViewDelegate{
    var viewModel:AddClothViewModel!
    let picker = UIImagePickerController()
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var inputImage:UIImageView!
    @IBOutlet weak var imagePickButton:UIButton!
    @IBOutlet weak var removeBGButton:UIButton!
    @IBOutlet weak var modifyButton:UIButton!
    @IBOutlet weak var saveButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        zoomSetting()
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
        scrollView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        modifyButton.layer.cornerRadius = 5.0
        imagePickButton.layer.cornerRadius = 5.0
        removeBGButton.layer.cornerRadius = 5.0
        saveButton.layer.cornerRadius = 5.0
        navigationItem.title = "이름 없는 옷"
    }
}
extension AddClothViewController{
    func zoomSetting(){
        scrollView.maximumZoomScale = 1.0
        scrollView.minimumZoomScale = 0.1
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return inputImage
    }
    
}
