import SwiftUI
import UIKit

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    @EnvironmentObject var appSettings: AppSettings

    var body: some View {
        ZStack {
            Color(hex: "#d18eb1")
                .ignoresSafeArea()
            
            VStack {
                if listViewModel.items.isEmpty {
                    Text("No ToDo")
                        .foregroundColor(.white)
                        .font(.headline)
                } else {
                    List {
                        ForEach(listViewModel.items) { item in
                            ListRowView(item: item)
                        }
                        .onDelete(perform: listViewModel.deleteItem)
                        .onMove(perform: listViewModel.moveItem)
                    }
                    .scrollContentBackground(.hidden)
                }
                
                
            }
        }
        .navigationTitle("To-Do List📝")
        .navigationBarItems(
            leading: EditButton(),
            trailing: NavigationLink("Add", destination: AddView())
        )
        .onAppear {
                    listViewModel.fetchItemsFromAPI() 
                }
    }
}
