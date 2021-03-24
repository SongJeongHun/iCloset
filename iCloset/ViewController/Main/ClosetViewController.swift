//
//  ClosetViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/22.
//

import UIKit

class ClosetViewController: UIViewController,ViewControllerBindableType {
    var viewModel:ClosetViewModel!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var addClothView:UIView!
    @IBOutlet weak var addClothButton:UIButton!
    @IBOutlet weak var addPresetView:UIView!
    @IBOutlet weak var addPresetButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func bindViewModel() {
        setUI()
    }
    func setUI(){
        topView.layer.cornerRadius = 7.0
        addClothView.layer.cornerRadius = 5.0
        addPresetView.layer.cornerRadius = 5.0
    }
}
