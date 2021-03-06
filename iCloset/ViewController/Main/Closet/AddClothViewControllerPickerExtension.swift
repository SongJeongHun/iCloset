import UIKit
import RxSwift
import NSObject_Rx
extension AddClothViewController:UIImagePickerControllerDelegate{
    func addThumbnailAlert(){
        let alert = UIAlertController(title: "불러오기", message: "사진을 선택 하세요", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "앨범", style: .default) { action in
            self.openLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { action in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .default, handler:nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
        
    }
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.inputImage.image = userImage
            removeBGButton.isHidden = false
            saveButton.isHidden = false
        }
        dismiss(animated: true, completion: nil)
    }
    func zoomSetting(){
        scrollView.maximumZoomScale = 1.0
        scrollView.minimumZoomScale = 0.1
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return inputImage
    }
    
}
