//
//  SettingsViewController.swift
//  TO-DO-APP
//
//  Created by tran.xuan.diep on 8/1/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {


    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var activeProfileTab: UIImageView!
    @IBOutlet weak var activeAlertTab: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func onButtonProfileClicked(_ sender: Any) {
        if self.profileView.isHidden != false {
            self.profileView.isHidden = false
            self.activeProfileTab.isHidden = false
            self.activeAlertTab.isHidden = true
            self.alertView.isHidden = true
        }
    }
    @IBAction func onButtonAlertClicked(_ sender: Any) {
        if self.alertView.isHidden != false {
            self.profileView.isHidden = true
            self.activeProfileTab.isHidden = true
            self.activeAlertTab.isHidden = false
            self.alertView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir", size: 17)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "header_backgroud_create_task"), for: .default)
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "icon_menu")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(onButtonMenuClicked(_:))), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "icon_ellipses")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: nil), animated: true)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.profileView.isHidden = false
        self.activeProfileTab.isHidden = false
        self.activeAlertTab.isHidden = true
        self.alertView.isHidden = true
    }
    
    func onButtonMenuClicked(_ sender: Any) {
        self.present(UINavigationController(rootViewController: appDelegate.menuViewController!), animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
