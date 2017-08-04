//
//  CalendarViewController.swift
//  TO-DO-APP
//
//  Created by tran.xuan.diep on 8/4/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    @IBOutlet weak var labelNumberTaskOfDay: UILabel!
    @IBOutlet weak var fsCalendar: FSCalendar!
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yy"
        return formatter
    }()
    
    var countTask: Int?
    var taskTemp:[Task]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseManager.shared.connectTable("Task")
        guard let resultTask = DatabaseManager.shared.fetchDataFromTable() as? [Task] else {return}
        taskTemp = resultTask
        fsCalendar.dataSource = self
        fsCalendar.delegate = self
        fsCalendar.firstWeekday = 2
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        let dates = loadDatesHasTask(resultTask)
        dates.forEach { (date) in
            self.fsCalendar.select(date, scrollToDate: false)
        }
        //lay ra cac selected date
//        print(fsCalendar.selectedDates)
        
        //disable selection date
//        fsCalendar.allowsSelection = false
        
    }
    
    func loadDatesHasTask(_ resultTask: [Task]) -> Set<Date> {
        var dates:Set<Date> = []
        for task in resultTask {
            if task.select_date != nil {
                dates.insert(self.dateFormatter.date(from: task.select_date!)!)
            }
        }
        return dates
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        countTask = taskTemp?.filter{$0.select_date == CommonUtility.formatToString(date)}.count
        if (self.countTask != 0) {
            self.labelNumberTaskOfDay.text = "You have \(self.countTask!) planned for this day"
        } else {
            self.labelNumberTaskOfDay.text = "You haven't planned for this day"
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
