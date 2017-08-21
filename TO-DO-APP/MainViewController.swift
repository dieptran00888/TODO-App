//
//  MainViewController.swift
//  TO-DO-APP
//
//  Created by ha.van.duc on 8/3/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var labelWelcome: UILabel!
    @IBOutlet weak var labelDayTime: UILabel!
    @IBOutlet weak var labelDayName: UILabel!
    @IBOutlet weak var taskTableView: UITableView!

    var arrTasks = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.dataSource = self
        taskTableView.delegate = self
        labelDayTime.text = CommonUtility.formatToString(Date())
        labelDayName.text = CommonUtility.getDayName()
        labelWelcome.text = CommonUtility.getDayInTheDay()
        let query = "SELECT * FROM tasks WHERE tasks.status LIKE 'init'"
        arrTasks = SqliteManager.shared.getDataWithQuery(query: query)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let image = UIImage(named: "background_all_task_in_day.png")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        taskTableView.backgroundView = imageView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        taskTableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}

        if let title = arrTasks[indexPath.row]["title"] as? String,
            let description = arrTasks[indexPath.row]["description"] as? String,
            let fromTime = arrTasks[indexPath.row]["fromTime"] as? String,
            let toTime = arrTasks[indexPath.row]["toTime"] as? String {
                let timeTask = "\(fromTime) - \(toTime)"
                cell.labelTime.text = timeTask
                cell.labelDescription.text = description
                cell.labelTitle.text = title
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createTaskSegue = segue.destination as? CreateTaskViewController {
            createTaskSegue.updateTaskForMainViewController = {(listTask) in
                for task in listTask {
                    var directionTask = [String: Any]()
                    directionTask["title"] = task.titleTask
                    directionTask["description"] = task.descriptionTask
                    directionTask["fromTime"] = task.fromTime
                    directionTask["toTime"] = task.toTime
                    self.arrTasks.append(directionTask)
                    self.taskTableView.reloadData()
                }
            }
        }
    }
}
