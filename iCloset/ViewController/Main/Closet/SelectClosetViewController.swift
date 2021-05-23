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
                    if valStr == "" { closetName = "이름 없는 옷장"}
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
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext:{ [unowned self] closetName in
                self.viewModel.selectedCloset = closetName
                self.viewModel.currentCloset.onNext(self.viewModel.selectedCloset)
                self.dismiss(animated: true, completion: nil)
                let target = self.presentingViewController?.children.last?.children.first
                var i = 0
                for vc in target!.children{
                    let childVC = vc as? ClothItemViewController
                    switch i{
                    case 0:
                        childVC?.imgArray.onNext([])
                        //bottom
                        childVC!.viewModel.storage.getPath(closet: childVC!.viewModel.selectedCloset, category: .bottom)
        //                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                            .subscribe(onNext:{ [unowned self] clothes in
                                childVC!.viewModel.storage.getThumbnail(from: clothes, category: .bottom)
                                    .subscribe(onNext:{ img in
                                        childVC!.imgArray.onNext(img)
                                    })
                                    .disposed(by: self.rx.disposeBag)
                            })
                            .disposed(by: rx.disposeBag)
                    case 1:
                        //shoe
                        childVC?.imgArray.onNext([])
                        childVC!.viewModel.storage.getPath(closet: childVC!.viewModel.selectedCloset, category: .shoe)
        //                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                            .subscribe(onNext:{ [unowned self] clothes in
                                childVC!.viewModel.storage.getThumbnail(from: clothes, category: .shoe)
                                                                .subscribe(onNext:{ img in
                                        childVC!.imgArray.onNext(img)
                                    })
                                    .disposed(by: self.rx.disposeBag)
                            })
                            .disposed(by: rx.disposeBag)
                    case 2:
                        //acc
                        childVC?.imgArray.onNext([])
                        childVC!.viewModel.storage.getPath(closet: childVC!.viewModel.selectedCloset, category: .acc)
        //                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                            .subscribe(onNext:{ [unowned self] clothes in
                                childVC!.viewModel.storage.getThumbnail(from: clothes, category: .acc)
                                    .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                                    .subscribe(onNext:{ img in
                                        childVC!.imgArray.onNext(img)
                                    })
                                    .disposed(by: self.rx.disposeBag)
                            })
                            .disposed(by: rx.disposeBag)
                    case 3:
                        //top
                        childVC?.imgArray.onNext([])
                        childVC!.viewModel.storage.getPath(closet: childVC!.viewModel.selectedCloset, category: .top)
        //                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                            .subscribe(onNext:{ [unowned self] clothes in
                                childVC!.viewModel.storage.getThumbnail(from: clothes, category: .top)
                                    .subscribe(onNext:{ img in
                                        childVC!.imgArray.onNext(img)
                                    })
                                    .disposed(by: self.rx.disposeBag)
                            })
                            .disposed(by: rx.disposeBag)
                    default:
                        break
                    }
                    i += 1
                }
            })
            .disposed(by: rx.disposeBag)
    }
}
class SideMenuCell:UITableViewCell{
    @IBOutlet weak var closetName:UILabel!
}
