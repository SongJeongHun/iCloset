//
//  SelectClosetViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/29.
//

import UIKit
import RxSwift
import RxCocoa
class SelectClosetViewController: UIViewController,ViewControllerBindableType{
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var addClosetButton:UIButton!
    @IBOutlet weak var selectedCloset:UILabel!
    var viewModel: ClosetViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.sceneCoordinator.currentVC = presentingViewController!
        super.viewWillDisappear(animated)
    }
    func bindViewModel() {
        Observable.just(viewModel.selectedCloset)
            .subscribe(onNext:{ [unowned self] closet in
                self.selectedCloset.text = closet
            })
            .disposed(by: rx.disposeBag)
        addClosetButton.rx.tap
            .throttle(.milliseconds(3000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ _ in
                ApplicationNotiCenter.alertControllerAppear.post()
                let alert = UIAlertController(title: "알림", message: "새로운 옷장 추가", preferredStyle: .alert)
                alert.addTextField(configurationHandler: nil)
                let ok = UIAlertAction(title: "확인", style: .default, handler: {ok in
                    guard let valStr = alert.textFields?[0].text else { return }
                    var closetName = valStr
                    if valStr == "" { closetName = "이름 없는 옷"}
                    self.viewModel.storage.saveCloset(closetName: closetName)
                    self.viewModel.storage.getCloset()
                    ApplicationNotiCenter.alertControllerDisappear.post()
                })
                let cancel = UIAlertAction(title: "취소", style: .default){ _ in
                    ApplicationNotiCenter.alertControllerDisappear.post()
                }
                alert.addAction(ok)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        viewModel.storage.getCloset()
            .bind(to:tableView.rx.items){tableview,row,data in
                guard let cell = tableview.dequeueReusableCell(withIdentifier: "SideMenuCell") as? SideMenuCell else { return UITableViewCell() }
                cell.closetName.text = data
                return cell
            }
            .disposed(by: rx.disposeBag)
    }
}
class SideMenuCell:UITableViewCell{
    @IBOutlet weak var closetName:UILabel!
}
