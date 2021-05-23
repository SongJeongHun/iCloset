//
//  DatePickViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/02/07.
//

import UIKit
import RxSwift
import Action
import NSObject_Rx
class DatePickViewController: UIViewController,ViewControllerBindableType{
    var viewModel:TimeLineViewModel!
    @IBOutlet weak var datePicker:UIDatePicker!
    @IBOutlet weak var okButton:UIButton!
    @IBOutlet weak var cancelButton:UIButton!
    @IBOutlet weak var buttonWidthConstraint:NSLayoutConstraint!
    override func viewDidLoad() {
        setUI()
        super.viewDidLoad()
    }
    func bindViewModel() {
        okButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{_ in
                let date = self.datePicker.date
                self.viewModel.selectedDate.onNext(date)
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: rx.disposeBag)
        cancelButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{_ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        buttonWidthConstraint.constant = UIScreen.main.bounds.width / 2
//        okButton.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
//        okButton.layer.borderWidth = 0.5
//        cancelButton.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
//        cancelButton.layer.borderWidth = 0.5
    }
}
