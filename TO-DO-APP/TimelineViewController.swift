//
//  TimelineViewController.swift
//  TO-DO-APP
//
//  Created by ha.van.duc on 8/9/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var timelineCollectionView: UICollectionView!
    @IBOutlet weak var labelNumberDay: UILabel!
    @IBOutlet weak var labelNameDay: UILabel!
    @IBOutlet weak var labelFullDay: UILabel!

    var listTask = [[String : Any]]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        timelineCollectionView.dataSource = self
        timelineCollectionView.delegate = self
        let nidName = UINib(nibName: "TimelineCollectionViewCell", bundle: nil)
        timelineCollectionView.register(nidName, forCellWithReuseIdentifier: "Cell")

        let currentDay = Date()
        let query = "SELECT * FROM tasks WHERE tasks.selectedDate = '\(CommonUtility.formatToString(currentDay))'"
        listTask = SqliteManager.shared.getDataWithQuery(query: query)

        labelFullDay.text = CommonUtility.getMonthInYear(currentDay)
        labelNameDay.text = CommonUtility.getDayName(currentDay)
        labelNumberDay.text = CommonUtility.getNumberDay(currentDay)

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "header_backgroud_create_task"), for: .default)
        navigationItem.title = "Timeline"
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "icon_menu")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(openMenuSidebar(_:))), animated: true)

        var image = UIImage(named: "avatar.png")
        image = image?.withRenderingMode(.alwaysOriginal)

        navigationItem.setRightBarButton(UIBarButtonItem(image: image, style: .done, target: self, action: nil), animated: true)
    }

    func openMenuSidebar(_ sender: Any) {
        self.present(UINavigationController(rootViewController: appDelegate.menuViewController!), animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTask.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TimelineCollectionViewCell
        if let fromTime = listTask[indexPath.row]["fromTime"] as? String,
            let toTime = listTask[indexPath.row]["toTime"] as? String,
            let title = listTask[indexPath.row]["title"] as? String,
            let description = listTask[indexPath.row]["description"] as? String,
            let status = listTask[indexPath.row]["status"] as? String {
                let timeTask = "\(fromTime) - \(toTime)"
                cell.update(timeTask: timeTask, title: title, description: description, status: status)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}
