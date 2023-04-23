//
//  RealQuickApp.swift
//  RealQuick
//
//  Created by Matthew Hanlon on 4/10/23.
//

import SwiftUI

@main
struct VoiceLogApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
