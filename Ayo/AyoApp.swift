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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
