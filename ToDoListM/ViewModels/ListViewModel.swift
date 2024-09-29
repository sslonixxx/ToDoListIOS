////  ListViewModel.swift
////  ToDoListIOS
////
////  Created by Софья Гергет on 13.09.2024.
////
//
//import Foundation
//
//class ListViewModel: ObservableObject{
//    
//    @Published var items: [ItemModel] = []
//    
//    
//    func deleteItem(indexSet: IndexSet) {
//        items.remove(atOffsets: indexSet)
//    }
//    func moveItem(from:IndexSet, to: Int) {
//        items.move(fromOffsets: from, toOffset: to)
//    }
//    func addItem(title: String) {
//        let newItem = ItemModel(title: title, isCompleted: false)
//        items.append(newItem)
//    }
//    func updateItem(item: ItemModel) {
//        
//        if let index=items.firstIndex(where: {$0.id == item.id}) {
//            items[index] = item.updateCompletion()
//        }
//    }
//    func updateItemTitle(item: ItemModel, newTitle: String) {
//        if let index = items.firstIndex(where: { $0.id == item.id }) {
//            items[index] = ItemModel(id: item.id, title: newTitle, isCompleted: item.isCompleted)
//        }
//    }
//
//}

import Foundation

class ListViewModel: ObservableObject {
    
    @Published var items: [ItemModel] = []
    
    // Сохранение списка в JSON
    func saveToFile() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            let url = getDocumentsDirectory().appendingPathComponent("items.json")
            try? encoded.write(to: url)
            print("JSON сохранён по пути \(url)")
        }
    }
    
    // Загрузка списка из JSON
    func loadFromFile() {
        let url = getDocumentsDirectory().appendingPathComponent("items.json")
        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ItemModel].self, from: data) {
                self.items = decoded
            }
        }
    }
    
    // Получаем директорию документов
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Другие функции ViewModel
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(title: String) {
        let newItem = ItemModel(title: title, isCompleted: false)
        items.append(newItem)
    }
    
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
        }
    }
    
    func updateItemTitle(item: ItemModel, newTitle: String) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = ItemModel(id: item.id, title: newTitle, isCompleted: item.isCompleted)
        }
    }
}
