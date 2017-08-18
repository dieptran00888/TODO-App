//
//  Notification.swift
//  TO-DO-APP
//
//  Created by ha.van.duc on 8/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private var badge = 0

    private init () {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
            didAllow, error in
        })
    }

    func getNumberBadge () -> Int {
        return badge
    }

    func updateBadge () -> Int {
        badge -= 1
        return badge
    }

    func addNotification (title: String, subtitle: String, body: String, date: Date) {
        badge += 1
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badge as NSNumber

        let calendar = Calendar(identifier: .gregorian)
        if let timeZone = TimeZone(secondsFromGMT: 0) {
            let component = calendar.dateComponents(in: timeZone, from: date)
            let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: component.month, day: component.day, hour: component.hour, minute: component.minute)

            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
            let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}
