import SwiftUI
import UIKit

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    @EnvironmentObject var appSettings: AppSettings
    
    @State private var showDocumentPicker = false
    @State private var showExportAlert = false
    @State private var showImportErrorAlert = false
    @State private var errorMessage = ""

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
                
                HStack {
                    Button(action: saveToJSON) {
                        Text("Save JSON")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 35)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Button(action: { showDocumentPicker = true }) {
                        Text("Open JSON")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 35)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
            }
        }
        .navigationTitle("To Do List📝")
        .navigationBarItems(
            leading: EditButton(),
            trailing: NavigationLink("Add", destination: AddView())
        )
        .fileImporter(isPresented: $showDocumentPicker, allowedContentTypes: [.json], allowsMultipleSelection: false, onCompletion: importJSON)
        .alert(isPresented: $showExportAlert) {
            Alert(title: Text("Экспорт выполнен"), message: Text("Файл JSON успешно сохранен."), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showImportErrorAlert) {
            Alert(title: Text("Ошибка"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func saveToJSON() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(listViewModel.items)
            let url = getDocumentsDirectory().appendingPathComponent("ToDoList.json")
            try jsonData.write(to: url)
            
            let documentPicker = UIDocumentPickerViewController(forExporting: [url], asCopy: true)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(documentPicker, animated: true, completion: nil)
            }
        } catch {
            print("Error saving JSON: \(error)")
        }
    }
    
    func importJSON(result: Result<[URL], Error>) {
        do {
            let selectedFile = try result.get().first!
            let data = try Data(contentsOf: selectedFile)
            let decoder = JSONDecoder()
            let decodedItems = try decoder.decode([ItemModel].self, from: data)
            listViewModel.items = decodedItems
        } catch {
            errorMessage = "Ошибка при загрузке файла JSON: \(error.localizedDescription)"
            showImportErrorAlert = true
            print("Error loading JSON: \(error)")
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
