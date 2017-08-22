//
//  OverviewViewController.swift
//  TO-DO-APP
//
//  Created by ha.van.duc on 8/7/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import UICircularProgressRing

class OverviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var listTasks: [Task]?
    let shared = DatabaseManager.shared
    var total = 0.0
    var completedTask = 0.0
    var snoozedTask = 0.0
    var overdueTask = 0.0
    var monthSelected = 0

    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelPercentOverdue: UILabel!
    @IBOutlet weak var labelNumberOverdue: UILabel!
    @IBOutlet weak var labelPercentSnoozed: UILabel!
    @IBOutlet weak var labelNumberSnoozed: UILabel!
    @IBOutlet weak var labelPercentCompleted: UILabel!
    @IBOutlet weak var labelNumberCompleted: UILabel!
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var circleViewSnoozed: UICircularProgressRingView!
    @IBOutlet weak var circleViewOverdue: UICircularProgressRingView!
    @IBOutlet weak var circleViewCompleted: UICircularProgressRingView!
    @IBOutlet weak var circleViewTotal: UICircularProgressRingView!
    @IBOutlet weak var circleViewOther: UICircularProgressRingView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        collectView.dataSource = self
        collectView.delegate = self
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Overview"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir", size: 17)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "header_backgroud_create_task"), for: .default)
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "icon_menu")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(onButtonMenuClicked(_:))), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "avatar")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: nil), animated: true)
        navigationController?.navigationBar.shadowImage = UIImage()
        let month = CommonUtility.getCurrenMonth()
        if let monthSelected = Int(month) {
            self.monthSelected = monthSelected
        }
        listTasks = DatabaseManager.shared.fetchDataWithQuery(month) as? [Task]
        setDefaultCircleView(listTasks)
        setValueCircleView()
    }
    
    func onButtonMenuClicked(_ sender:Any) {
        self.present(UINavigationController(rootViewController: appDelegate.menuViewController!), animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
            for: indexPath) as! PageMenuCollectionViewCell
        let index = indexPath.row + 1
        if let month = CommonUtility.Months(rawValue: index) {
            cell.labelMonth.text = CommonUtility.getMonth(month)
        } else {
            cell.labelMonth.text = "None"
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row + 1
        listTasks = DatabaseManager.shared.fetchDataWithQuery(String(index)) as? [Task]
        setDefaultCircleView(listTasks)
        monthSelected = index
        setValueCircleView()
    }

    func setDefaultCircleView(_ listTasks: [Task]?) {
        total = 0.0
        completedTask = 0.0
        snoozedTask = 0.0
        overdueTask = 0.0

        if let listTasks = listTasks {
            total = Double(listTasks.count)
            for task in listTasks {
                if let status = task.status {
                    switch status {
                    case "completed":
                        completedTask += 1.0
                    case "snoozed":
                        snoozedTask += 1.0
                    case "overdue":
                        overdueTask += 1.0
                    default:
                        total += 0
                    }
                }

            }
        }
    }

    func setValueCircleView() {
        let percentCompleted = CalculateUtility.percent(completedTask, total)
        let percentSnoozed = CalculateUtility.percent(snoozedTask, total)
        let percentOverdue = CalculateUtility.percent(overdueTask, total)
        let percentOther = 100.0 - percentCompleted - percentSnoozed - percentOverdue


        if let month = CommonUtility.Months(rawValue: monthSelected) {
            labelMonth.text = CommonUtility.getMonth(month)
        } else {
            labelMonth.text = "None"
        }

        labelNumberCompleted.text = "\(Int(completedTask))"
        labelPercentCompleted.text = "\(Int(percentCompleted))%"

        labelNumberSnoozed.text = "\(Int(snoozedTask))"
        labelPercentSnoozed.text = "\(Int(percentSnoozed))%"

        labelNumberOverdue.text = "\(Int(overdueTask))"
        labelPercentOverdue.text =  "\(Int(percentOverdue))%"

        circleViewTotal.value = CGFloat(total)

        circleViewCompleted.value = CGFloat(percentCompleted)
        circleViewCompleted.startAngle = CGFloat(0)

        let radiusSnoozed = percentCompleted * 360 / 100
        circleViewSnoozed.value = CGFloat(percentSnoozed)
        circleViewSnoozed.startAngle = CGFloat(radiusSnoozed)

        let radiusOverdue = radiusSnoozed + (percentSnoozed) * 360 / 100
        circleViewOverdue.value = CGFloat(percentOverdue)
        circleViewOverdue.startAngle = CGFloat(radiusOverdue)

        circleViewOther.value = CGFloat(percentOther)
        let radiusOther = radiusOverdue + (percentOverdue) * 360 / 100
        circleViewOther.startAngle = CGFloat(radiusOther)
    }

}
