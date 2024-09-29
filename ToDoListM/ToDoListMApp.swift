//
//  ToDoListMApp.swift
//  ToDoListM
//
//  Created by Софья Гергет on 15.09.2024.
//


import SwiftUI

@main
struct ToDoListMApp: App {
    @StateObject var appSettings = AppSettings()
    var listViewModel: ListViewModel=ListViewModel()
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
