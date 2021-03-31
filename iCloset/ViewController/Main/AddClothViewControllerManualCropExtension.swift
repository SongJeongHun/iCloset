//
//  AddClothViewControllerManualCropExtension.swift
//  iCloset
//
//  Created by 송정훈 on 2021/03/31.
//
import Action

import RxSwift
import RxCocoa
import UIKit
extension AddClothViewController {
    func prepareManualCropping(){
        let width = 100
        let height = 100
        let circleRadius = 20
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let circleImage = UIImage(systemName: "circle.fill",withConfiguration: config)
        cropView.frame = CGRect(x: Int(scrollView.bounds.width) / 2 - width / 2, y: Int(scrollView.bounds.height) / 2 - height / 2, width: width, height: height)
        cropTopButton.frame = CGRect(x: Int(cropView.frame.minX) - circleRadius / 2, y: Int(cropView.frame.minY) - circleRadius / 2, width: circleRadius, height: circleRadius)
        cropBottomButton.frame = CGRect(x: Int(cropView.frame.maxX) - circleRadius / 2, y: Int(cropView.frame.maxY) - circleRadius / 2, width: circleRadius, height: circleRadius)
        cropView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 0.5)
        cropView.layer.borderWidth = 1.0
        cropView.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        cropTopButton.setImage(circleImage, for: .normal)
        cropBottomButton.setImage(circleImage, for: .normal)
        cropTopButton.addTarget(self, action: #selector(buttonMoved(_:forEvent:)), for: .touchDragInside)
        cropBottomButton.addTarget(self, action: #selector(buttonMoved(_:forEvent:)), for: .touchDragInside)
        cropTopButton.tintColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        cropBottomButton.tintColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        scrollView.addSubview(cropTopButton)
        scrollView.addSubview(cropBottomButton)
        scrollView.addSubview(cropView)
    }
}
