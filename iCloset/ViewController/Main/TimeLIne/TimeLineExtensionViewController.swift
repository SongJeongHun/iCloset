import UIKit
import RxSwift
import NSObject_Rx
import RxCocoa
import FSCalendar
import Action
extension TimeLineViewController:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    func foldAction() -> CocoaAction{
        return CocoaAction{ _ in
            if self.calendar.scope == FSCalendarScope.month{
                self.calendar.setScope(.week, animated: true)
                self.foldButton.image = UIImage(systemName: "chevron.down")
            }else{
                self.calendar.setScope(.month, animated: true)
                self.foldButton.image = UIImage(systemName: "chevron.up")
            }
            return Observable.empty()
        }
    }
    func calendarSet(){
        calendar.layer.cornerRadius = 5.0
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.eventSelectionColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.locale = Locale(identifier: "Ko_kR")
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.selectedDate.onNext(date)
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let stringDate = viewModel.formatter.string(from: date)
        if viewModel.dummyDateArray.contains(stringDate){ return [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)] } else { return [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)] }
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let stringDate = viewModel.formatter.string(from: date)
        if viewModel.dummyDateArray.contains(stringDate){ return 1 } else { return 0 }
    }
}
