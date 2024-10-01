import SwiftUI

@main
struct ToDoListMApp: App {
    @StateObject var appSettings = AppSettings()
    @StateObject var listViewModel = ListViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ListView()
            }
            .environmentObject(listViewModel)
            .environmentObject(appSettings)
        }
    }
}
