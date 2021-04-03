//
//  AddClothViewControllerManualCropExtension.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/31.
//

//    }
import Action

import RxSwift
import RxCocoa
import Mantis
import UIKit
extension AddClothViewController:CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        self.inputImage.image = cropped
        self.dismiss(animated: true, completion: nil)
    }
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        self.dismiss(animated: true, completion: nil)
        return
    }
    func prepareManualCropping(image:UIImage){
        let cropViewController = Mantis.cropViewController(image:image)
        cropViewController.delegate = self
        self.present(cropViewController,animated: true){
            cropViewController.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        }
    }
}
