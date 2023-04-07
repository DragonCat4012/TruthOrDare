//
//  AyoApp.swift
//  Ayo
//
//  Created by Kiara on 07.04.23.
//

import SwiftUI

@main
struct AyoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabView{
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Image(systemName: "menucard.fill")
                    }
                SettingsView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Image(systemName: "gear")
                    }
            }
            
        }
    }
}
