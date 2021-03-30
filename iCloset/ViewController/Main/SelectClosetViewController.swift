//
//  SelectClosetViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/29.
//

import UIKit

class SelectClosetViewController: UIViewController,ViewControllerBindableType{
    var viewModel: ClosetViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.sceneCoordinator.currentVC = presentingViewController!
        super.viewWillDisappear(animated)
    }
    func bindViewModel() {
    }
}
