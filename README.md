# ICloset
<img src = "https://user-images.githubusercontent.com/73823603/128683383-932c0fdf-a2b9-4f33-be35-816a11758ea6.png" width = "10%" height = "10%">
옷장 속의 옷을 찍어 옷들을 한눈에 관리, 조합을 맞춰보는 어플 (2021.3.08 ~ 2021.5.23)

## 폴더구조
* ViewControllers
  * Main
    * TimeLine
      * TimeLine 뷰컨트롤러
    * Closet
      * Closet 뷰컨트롤러
  * Login
    * Loing,Join 뷰컨트롤러
  * 스토리보드 파일
  * 뷰컨트롤러바인딩 프로토콜
* ViewModel
  * Storage
    * Cache
      * 캐시파일
    * ImageStorage
      * 이미지스토리지 파일
    * UserStorage
      * 유저스토리지 파일
  * 뷰모델 파일
  * 뷰모델타입 파일
* Scene
  * 씬 파일
  * 씬 코디네이터 파일
  
  
# 프로젝트 설명
## 사용 라이브러리리
![Generic badge](https://img.shields.io/badge/RxSwift-5.1.2-blue.svg)
![Generic badge](https://img.shields.io/badge/Action-4.2.0-blue.svg)
![Generic badge](https://img.shields.io/badge/Alamofire-5.4.2-blue.svg)
![Generic badge](https://img.shields.io/badge/NSObject+Rx-5.1.0-blue.svg)
![Generic badge](https://img.shields.io/badge/RxFirebase-0.3.8-blue.svg)
![Generic badge](https://img.shields.io/badge/FSCalendar-2.8.2-blue.svg)
![Generic badge](https://img.shields.io/badge/Lottie-3.2.1-blue.svg)
![Generic badge](https://img.shields.io/badge/Mantis-1.6.0-blue.svg)
![Generic badge](https://img.shields.io/badge/SideMenu-6.5.0-blue.svg)
# 샐행화면
## 회원가입
![icloset_3](https://user-images.githubusercontent.com/73823603/129678914-fc683c84-30f3-47ec-90b4-5cfc7dc6937b.gif)  
•아이디는 확인버튼을 통하여 중복확인을 할 수 있습니다.  
•4가지 항목이 모두 정상상태면 확인버튼이 활성화됩니다.
## 로그인
![icloset_2](https://user-images.githubusercontent.com/73823603/129678812-54d3a0c9-054d-4435-8744-3c6997d4c54a.gif)
## 옷 추가
![icloset_1](https://user-images.githubusercontent.com/73823603/129678595-49b2d7f6-e903-47b6-b432-bd06920fb691.gif)   
•배경을 제거할 사진을 앨범또는 카메라로 선택할 수 있습니다.  
•카테고리를 지정할 수 있습니다.  
•배경 제거방식을 자동/수동으로 선택할 수 있습니다.  
•옷이름을 수정할 수 있습니다.  
•추가된 옷은 옷장탭에서 확인 가능합니다.
## 옷장선택
![icloset_4](https://user-images.githubusercontent.com/73823603/129678953-0867992b-21ed-419e-93ae-f53c972bd2a0.gif)  
•옷을 옷장별로 불러올 수 있습니다.


# 주요기능 
## -(Auto)Remove Background
•remove.bg의 api이용  
•Alamofire를 이용하여 downloadProgress와 ImageData를 다운받는다.
```swift
func uploading(source:Data){
        AF.upload(multipartFormData: { builder in
                builder.append(
                    source,
                    withName: "image_file",
                    fileName: "file.jpg",
                    mimeType: "image/jpeg"
                )
            }, to: URL(string: "https://api.remove.bg/v1.0/removebg")!, method: .post, headers: [
                "X-Api-Key": apiKey
            ])
        .downloadProgress{progress in
            self.removeProgress.onNext(progress.fractionCompleted)
        }
        .responseJSON {json in
            if let imageData = json.data{
                guard let img = UIImage(data: imageData) else {
                    self.resultError.onNext(ConvertFail.fail)
                    return
                }
                self.resultImage.onNext(img)
            }
        }
    }
```
## -(Manual)Remove Background
•Mantis프레임워크를 이용  
•모달 형식으로 띄우기 때문에 gestrueRecognizer를 꺼주지 않으면 터치를 할 수 없다
```swift
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
```
## -Image Cropping
•이미지로부터 배경을 자동으로 제거할(투명으로 만들) 경우, 배경의 정도에 따라 이미지 크기가 제각각임  
->따라서 배경을 제거한 후 2차로 투명이된 배경을 삭제해야함  
•전달받은 UIImage 로부터 1픽셀(4바이트R,G,B,A)단위로 쪼개어 색이 존재하는 부분을 2차원 배열에 정보를 넣어주는 메소드
```swift
func findColors(_ image: UIImage) -> [[Int]] {
        var xArray:[Int] = []
        var yArray:[Int] = []
        //Get width height from image
        let pixelWidth = Int(image.size.width)
        let pixelHeight = Int(image.size.height)
        guard let pixelData = image.cgImage?.dataProvider?.data else { return []}
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        for x in 0..<pixelWidth {
            for y in 0..<pixelHeight {
                let point = CGPoint(x: x, y: y)
                let pixelInfo: Int = ((pixelWidth * Int(point.y)) + Int(point.x)) * 4
                //Find origin
                if data[pixelInfo] != 0 {
                    xArray.append(x)
                    yArray.append(y)
                }
            }
        }
        return [xArray,yArray]
    }
```
•색 배열로부터 범위를 추출하여 원본에서 cropping을 하여 만들어진 새로운 UIImage를 리턴한다.
```swift
func cropToBounds(image: UIImage, width: Double, height: Double,x:CGFloat,y:CGFloat) -> UIImage {
        let contextImage = UIImage(cgImage: image.cgImage!)
        let rect = CGRect(x: x, y: y ,width: CGFloat(width), height: CGFloat(height))
        let imageRef = contextImage.cgImage!.cropping(to: rect)!
        let image = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return image
    }
``` 
## -SideMenu
•사이드메뉴 뷰컨트롤러를 불러올 때 사용자 몰입을 위해 음영이 있는 효과를 추가  
•Notification을 사용하여 sideMenu가 appear 될 때 와 disappear될 때 post 해줌
```swift
class ClosetSideMenuNavigation: SideMenuNavigationController,SideMenuNavigationControllerDelegate {
    override func viewDidLoad(){
        sideMenuDelegate = self
        self.presentationStyle = .menuSlideIn
        self.isNavigationBarHidden = true
        super.viewDidLoad()
    }
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        ApplicationNotiCenter.sideMenuWillAppear.post(object: self.menuWidth)
    }
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        ApplicationNotiCenter.sideMenuWillDisappear.post()
    }
}
```
# 아쉬운 점
## 스레드 처리
RxSwift에서 스레드 처리가 미숙하여 가끔 동기화 되지 않은 쓰레드 사용으로 오류가 발생
## 캐싱 처리
캐싱된 이미지를 불러올 때 URL 이미지의 이름으로 저장하는데, 이름이 같은 이미지가 있을 경우 이전 이미지가 사리짐
