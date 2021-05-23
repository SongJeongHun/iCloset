//
//  TimeLineViewController.swift
//  CalenDeck
//
//  Created by 송정훈 on 2021/01/22.
//

import UIKit
import RxSwift
import NSObject_Rx
import RxCocoa
import FSCalendar
import Action
class TimeLineViewController: UIViewController,ViewControllerBindableType{
    var viewModel: TimeLineViewModel!
    //    var dateArray:Set<String> = []
    @IBOutlet weak var calendar:FSCalendar!
    @IBOutlet weak var currentDate:UILabel!
    @IBOutlet weak var datePickButton:UIBarButtonItem!
    @IBOutlet weak var calendarHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var foldButton:UIBarButtonItem!
    @IBOutlet weak var timeLine:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarSet()
        foldButton.rx.action = foldAction()
    }
    func bindViewModel() {
        datePickButton.rx.action = viewModel.datePickAction()
        viewModel.selectedDate
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] date in
                let stringDate = viewModel.formatter.string(from: date)
                viewModel.selectedDateString = stringDate
                print("current Date -> \(self.viewModel.selectedDateString)")
                if let selectedDate = calendar.selectedDate{
                    calendar.deselect(selectedDate)
                }
                calendar.select(date)
                calendar.adjustMonthPosition()
                currentDate.text = stringDate
            })
            .disposed(by: rx.disposeBag)
        viewModel.dummyEvent
            .bind(to:timeLine.rx.items){tableView,row,data in
                if !self.viewModel.dummyDateArray.contains(self.viewModel.selectedDateString){
                    self.timeLine.separatorStyle = .none
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! EmptyCell
                    return cell
                }else{
                    self.timeLine.separatorStyle = .singleLine
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as! TimeLineCell
                    cell.content.text = data
                    cell.mainTitle.text = self.viewModel.userID
                    cell.subTitle.text = "이벤트"
                    return cell
                }
                
            }
    }
}
class TimeLineCell:UITableViewCell{
    @IBOutlet weak var mainTitle:UILabel!
    @IBOutlet weak var subTitle:UILabel!
    @IBOutlet weak var content:UILabel!
    @IBOutlet weak var panel:UIView!
    @IBOutlet weak var backgroundPanel:UIView!
    override func awakeFromNib() {
        backgroundPanel.layer.cornerRadius = 7.0
        panel.layer.cornerRadius = 7.0
        super.awakeFromNib()
    }
}
class EmptyCell:UITableViewCell{
    @IBOutlet weak var panel:UIView!
    override func awakeFromNib() {
        panel.layer.cornerRadius = 7.0
        super.awakeFromNib()
    }
}
