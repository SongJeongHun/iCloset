//
//  PresetSelectViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import Action
class PresetSelectViewController: UIViewController,ViewControllerBindableType {
    @IBOutlet weak var collectionView:UICollectionView!
    var imgArr:[ClothItem] = []
    var imgArray = PublishSubject<[ClothItem]>()
    var viewModel:ClosetViewModel!
    var backVC:PresetViewController!
    override func viewDidLoad() {
        backVC = viewModel.sceneCoordinator.currentVC as! PresetViewController
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.sceneCoordinator.currentVC = backVC
        super.viewWillDisappear(animated)
    }
    func bindViewModel() {
        imgArray
            .bind(to:collectionView.rx.items(cellIdentifier: "presetSelectCell", cellType: presetSelectCell.self)){ row,element,cell in
                cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.layer.borderWidth = 0.5
                cell.thumbNail.image = element.img
            }
            .disposed(by: rx.disposeBag)
        switch viewModel.presetSelectOption {
        case .top:
            viewModel.storage.getPath(closet: viewModel.selectedCloset, category: .top)
                .subscribe(onNext:{ [unowned self] clothes in
                    self.viewModel.storage.getThumbnail(from: clothes, category: .top)
                        .subscribe(onNext:{ [unowned self] img in
                            self.imgArray.onNext(img)
                        })
                        .disposed(by: self.rx.disposeBag)
                })
                .disposed(by: rx.disposeBag)
        case .bottom:
            viewModel.storage.getPath(closet: viewModel.selectedCloset, category: .bottom)
                .subscribe(onNext:{ [unowned self] clothes in
                    self.viewModel.storage.getThumbnail(from: clothes, category: .bottom)
                        .subscribe(onNext:{ [unowned self] img in
                            self.imgArray.onNext(img)
                        })
                        .disposed(by: self.rx.disposeBag)
                })
                .disposed(by: rx.disposeBag)
        case .shoe:
            viewModel.storage.getPath(closet: viewModel.selectedCloset, category: .shoe)
                .subscribe(onNext:{ [unowned self] clothes in
                    self.viewModel.storage.getThumbnail(from: clothes, category: .shoe)
                        .subscribe(onNext:{ [unowned self] img in
                            self.imgArray.onNext(img)
                        })
                        .disposed(by: self.rx.disposeBag)
                })
                .disposed(by: rx.disposeBag)
        }
    }
}
class presetSelectCell:UICollectionViewCell{
    @IBOutlet weak var thumbNail:UIImageView!
}
