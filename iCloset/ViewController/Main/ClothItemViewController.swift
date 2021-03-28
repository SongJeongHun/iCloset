//
//  ClothItemViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/24.
//

import UIKit
import RxSwift
import RxCocoa

class ClothItemViewController: UIViewController ,ViewControllerBindableType,UICollectionViewDelegate{
    var viewModel:ClosetViewModel!
    @IBOutlet weak var collectionView:UICollectionView!
    override func viewDidLoad() {
        collectionView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        super.viewDidLoad()
    }
    func bindViewModel() {
        viewModel.dummyData
            .bind(to:collectionView.rx.items){collectionView,row,data in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clothCell", for:indexPath) as? clothCell else { return UICollectionViewCell() }
                cell.layer.cornerRadius = 5.0
                cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                return cell
            }
            .disposed(by: rx.disposeBag)
    }
}
class clothCell:UICollectionViewCell{
    @IBOutlet weak var thumbnail:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


