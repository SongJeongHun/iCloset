//
//  PresetViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/05/20.
//

import UIKit
import RxSwift
import RxCocoa
import Action
class PresetViewController: UIViewController,ViewControllerBindableType {
    @IBOutlet weak var cellHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var presetPanel:UIView!
    @IBOutlet weak var topAddButton:UIButton!
    @IBOutlet weak var bottomAddButton:UIButton!
    @IBOutlet weak var shoeAddButton:UIButton!
    var viewModel:ClosetViewModel!
    override func viewDidLoad() {
        cellHeightConstraint.constant = presetPanel.frame.height / 3
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.sceneCoordinator.currentVC = self.parent!.parent!
        super.viewWillDisappear(animated)
    }
    func bindViewModel() {
        topAddButton.rx.tap
            .throttle(.milliseconds(3000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ _ in
                self.viewModel.presetSelectOption = .top
                let presetSelectScene = Scene.presetSelect(self.viewModel)
                self.viewModel.sceneCoordinator.transition(to: presetSelectScene, using: .modal, animated: true)
            })
            .disposed(by: rx.disposeBag)
        bottomAddButton.rx.tap
            .throttle(.milliseconds(3000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ _ in
                self.viewModel.presetSelectOption = .bottom
                let presetSelectScene = Scene.presetSelect(self.viewModel)
                self.viewModel.sceneCoordinator.transition(to: presetSelectScene, using: .modal, animated: true)
            })
            .disposed(by: rx.disposeBag)
        shoeAddButton.rx.tap
            .throttle(.milliseconds(3000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ _ in
                self.viewModel.presetSelectOption = .shoe
                let presetSelectScene = Scene.presetSelect(self.viewModel)
                self.viewModel.sceneCoordinator.transition(to: presetSelectScene, using: .modal, animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
}
