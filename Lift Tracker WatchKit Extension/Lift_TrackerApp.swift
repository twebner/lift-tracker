//
//  Lift_TrackerApp.swift
//  Lift Tracker WatchKit Extension
//
//  Created by Tyler Webner on 3/18/21.
//

import SwiftUI

@main
struct Lift_TrackerApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
