import SwiftUI
import Blackbird

@main
struct RealQuickApp: App {
    @StateObject var database = Database.shared
    
    var body: some Scene {
        WindowGroup {
            EntryList()
                .environment(\.blackbirdDatabase, database)
        }
    }
}
