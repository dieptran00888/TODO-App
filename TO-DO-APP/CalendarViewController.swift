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
    
    var countTask: Int?
    var taskTemp:[Task]?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fsCalendar.dataSource = self
        fsCalendar.delegate = self
        fsCalendar.firstWeekday = 2
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Calendar"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir", size: 17)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "header_backgroud_create_task"), for: .default)
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "icon_menu")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(onButtonMenuClicked(_:))), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "icon_search")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: nil), animated: true)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func onButtonMenuClicked(_ sender: Any) {
        self.present(UINavigationController(rootViewController: appDelegate.menuViewController!), animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let resultTask = DatabaseManager.shared.fetchDataFromTable() as? [Task] else {return}
        taskTemp = resultTask
        let dates = loadDatesHasTask(resultTask)
        dates.forEach { (date) in
            self.fsCalendar.select(date, scrollToDate: false)
        }
    }
    
    func loadDatesHasTask(_ resultTask: [Task]) -> Set<Date> {
        var dates:Set<Date> = []
        for task in resultTask {
            if task.select_date != nil {
                dates.insert(CommonUtility.formatStringToDate(task.select_date!))
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
