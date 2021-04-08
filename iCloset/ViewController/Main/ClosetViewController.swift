//
//  ClosetViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/22.
//
import SideMenu
import UIKit
import Action
import RxSwift
import RxCocoa
class ClosetViewController: UIViewController,ViewControllerBindableType, UIScrollViewDelegate {
    var viewModel:ClosetViewModel!
    let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var addClothView:UIView!
    @IBOutlet weak var addClothButton:UIButton!
    @IBOutlet weak var addPresetView:UIView!
    @IBOutlet weak var addPresetButton:UIButton!
    @IBOutlet weak var selectClosetButton:UIBarButtonItem!
    override func viewDidLoad() {
        scrollView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        viewModel.getCLoset()
        viewModel.selectedCloset = "이름 없는 옷장"
        viewModel.currentCloset.onNext(viewModel.selectedCloset)
        prepareShadowView()
        setUI()
        super.viewDidLoad()
    }
    func bindViewModel() {
        addRefreshController()
        selectClosetButton.rx.action = viewModel.popSideMenu()
        addClothButton.rx.action = viewModel.addClothAction()
        ApplicationNotiCenter.sideMenuWillDisappear.addObserver()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext:{_ in
                self.shadowView.isHidden = true
            })
            .disposed(by: rx.disposeBag)
        ApplicationNotiCenter.sideMenuWillAppear.addObserver()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] menuWidth in
                guard let width = menuWidth as? CGFloat else { return }
                self.shadowView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - width, height: UIScreen.main.bounds.height)
                self.shadowView.isHidden = false
            })
            .disposed(by: rx.disposeBag)
        viewModel.currentCloset
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] closetName in
                self.navigationItem.title = closetName
            })
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        topView.layer.cornerRadius = 7.0
        addClothView.layer.cornerRadius = 5.0
        addPresetView.layer.cornerRadius = 5.0
    }
    func prepareShadowView(){
        shadowView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        shadowView.layer.zPosition = 1
        UIApplication.shared.windows.filter{ $0.isKeyWindow }.first?.addSubview(shadowView)
        shadowView.isHidden = true
    }
    @IBAction func refresh(){
        print("refresh,,")
        scrollView.refreshControl?.endRefreshing()
    }
    func addRefreshController(){
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
}
