//
//  AddClothViewController.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/08.
//

import UIKit
import RxSwift
import Lottie
import NSObject_Rx
class AddClothViewController: UIViewController,ViewControllerBindableType,UINavigationControllerDelegate,UIScrollViewDelegate{
    let loadingAnimationView = AnimationView(name: "clothes")
    let progressView = UIProgressView()
    var clothName:String = "이름 없는 옷"
    var viewModel:AddClothViewModel!
    let picker = UIImagePickerController()
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var inputImage:UIImageView!
    @IBOutlet weak var imagePickButton:UIButton!
    @IBOutlet weak var removeBGButton:UIButton!
    @IBOutlet weak var modifyButton:UIButton!
    @IBOutlet weak var saveButton:UIButton!
    override func viewDidLoad() {
        scrollView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        prepareLoading()
        setUI()
        zoomSetting()
        picker.delegate = self
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.sceneCoordinator.currentVC = self.parent!.parent!
        super.viewWillDisappear(animated)
    }
    func bindViewModel() {
        imagePickButton.rx.tap
            .observeOn(MainScheduler.instance)
            .throttle(.milliseconds(3000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ _ in
                self.addThumbnailAlert()
            })
            .disposed(by: rx.disposeBag)
        modifyButton.rx.tap
            .observeOn(MainScheduler.instance)
            .throttle(.milliseconds(3000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ _ in
                let alert = UIAlertController(title: "알림", message: "옷 이름 변경", preferredStyle: .alert)
                alert.addTextField(configurationHandler: nil)
                let ok = UIAlertAction(title: "확인", style: .default, handler: {ok in
                    guard let valStr = alert.textFields?[0].text else { return }
                    self.clothName = valStr
                    if valStr == "" { self.clothName = "이름 없는 옷"}
                    self.navigationItem.rx.title.onNext(self.clothName)
                })
                let cancel = UIAlertAction(title: "취소", style: .default, handler:nil)
                alert.addAction(ok)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        removeBGButton.rx.tap
            .subscribeOn(MainScheduler.instance)
            .throttle(.milliseconds(3000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{
                let removeAlert = UIAlertController(title: "자르기", message: "방법을 선택 하세요", preferredStyle: .actionSheet)
                let auto = UIAlertAction(title: "자동", style: .default){ action in
                    guard let jpgData = self.inputImage.image?.jpegData(compressionQuality: 0.8) else { return }
                    self.viewModel.uploading(source: jpgData)
                    //removeStart
                    self.inputImage.image = nil
                    self.progressView.isHidden = false
                    self.loadingAnimationView.isHidden = false
                    self.loadingAnimationView.play()
                }
                let manual = UIAlertAction(title: "수동", style: .default) { action in
                }
                let cancel = UIAlertAction(title: "취소", style: .default, handler:nil)
                removeAlert.addAction(auto)
                removeAlert.addAction(manual)
                removeAlert.addAction(cancel)
                self.present(removeAlert, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        viewModel.resultImage
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] resultImage in
                let array = self.viewModel.findColors(resultImage)
                let xArr = array[0]
                let yArr = array[1]
                let minP = CGPoint(x: xArr.min()!, y: yArr.min()!)
                let maxP = CGPoint(x: xArr.max()!, y: yArr.max()!)
                self.inputImage.image = self.viewModel.cropToBounds(image: resultImage, width: Double(maxP.x - minP.x), height: Double(maxP.y - minP.y),x:CGFloat(minP.x),y:CGFloat(minP.y))
                self.loadingAnimationView.stop()
                self.loadingAnimationView.isHidden = true
                self.progressView.isHidden = true
            })
            .disposed(by: rx.disposeBag)
        viewModel.resultError
            .subscribe(onNext:{ err in
                print(err)
                self.loadingAnimationView.stop()
                self.progressView.isHidden = true
                self.loadingAnimationView.isHidden = true
            })
            .disposed(by: rx.disposeBag)
    }
    func setUI(){
        inputImage.layer.borderColor = #colorLiteral(red: 0.5791992545, green: 0.5121335983, blue: 0.4514948726, alpha: 1)
        inputImage.layer.borderWidth = 1.0
        modifyButton.layer.cornerRadius = 5.0
        imagePickButton.layer.cornerRadius = 5.0
        removeBGButton.layer.cornerRadius = 5.0
        saveButton.layer.cornerRadius = 5.0
        navigationItem.rx.title.onNext(clothName)
    }
    func prepareLoading(){
        loadingAnimationView.frame = CGRect(x: 0, y: 0, width: Int(inputImage.frame.width), height: Int(inputImage.frame.height) / 2)
        progressView.frame = CGRect(x:0,y:Int(inputImage.frame.height) / 2,width:Int(inputImage.frame.width),height: 80)
        progressView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        loadingAnimationView.contentMode = .scaleAspectFit
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.isHidden = true
        progressView.isHidden = true
        scrollView.addSubview(loadingAnimationView)
        scrollView.addSubview(progressView)
    }
}
