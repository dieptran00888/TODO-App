//
//  MenuViewController.swift
//  TO-DO-APP
//
//  Created by tran.xuan.diep on 8/1/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    let userDefault = UserDefaults()
    @IBAction func onButtonCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func buttonSwitchTimeline(_ sender: Any) {
        let timelineView = TimelineViewController(nibName: "TimelineViewController", bundle: nil)
        navigationController?.pushViewController(timelineView, animated: true)
    }
    @IBAction func switchGroupButton(_ sender: Any) {
        let timelineView = GroupViewController(nibName: "GroupViewController", bundle: nil)
        navigationController?.pushViewController(timelineView, animated: true)
    }
    
    @IBAction func onButtonLogoutClicked(_ sender: Any) {
        performSegue(withIdentifier: "unwindToSignIn", sender: self)
    }
    
    @IBAction func onSwitchListsClicked(_ sender: Any) {
        let autoView = AutoViewController()
        navigationController?.pushViewController(autoView, animated: true)
    }
    
    @IBAction func onButtonCalendarClicked(_ sender: Any) {
        let calendarView = storyboard?.instantiateViewController(withIdentifier: "calendarView") as? CalendarViewController
        navigationController?.pushViewController(calendarView!, animated: true)
    }
    
    @IBAction func onButtonOverviewClicked(_ sender: Any) {
        let overviewView = storyboard?.instantiateViewController(withIdentifier: "overviewView") as? OverviewViewController
        navigationController?.pushViewController(overviewView!, animated: true)
    }
    
    @IBAction func onButtonProfileClicked(_ sender: Any) {
        let profileView = UserProgressViewController()
        navigationController?.pushViewController(profileView, animated: true)
    }
    
    @IBAction func onButtonSettingsClicked(_ sender: Any) {
        let settingView = storyboard?.instantiateViewController(withIdentifier: "settingView") as? SettingsViewController
        navigationController?.pushViewController(settingView!, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "header_backgroud_create_task"), for: .default)
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "icon_close")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(onButtonCloseClicked(_:))), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "icon_logout")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(onButtonLogoutClicked(_:))), animated: true)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
