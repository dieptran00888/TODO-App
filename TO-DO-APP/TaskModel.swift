//
//  Task.swift
//  TO-DO-APP
//
//  Created by ha.van.duc on 8/2/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit

class TaskModel {
    var titleTask = ""
    var descriptionTask = ""
    var allDay = 0
    var location = ""
    var timeRepeat = 0
    var selectDate = Date()
    var fromTime = ""
    var toTime = ""
    var people: String?
    var notification = 0
    var status: String?
    
    init () {
        fromTime = CommonUtility.currentTime()
        toTime = fromTime
        status = "Init"
    }
}
