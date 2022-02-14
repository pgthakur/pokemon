//
//  PokemonApp.swift
//  Pokemon WatchKit Extension
//
//  Created by prabhat gaurav on 10/02/22.
//

import SwiftUI

@main
struct PokemonApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
