import Foundation
import Combine

class ListViewModel: ObservableObject {
    
    @Published var items: [ItemModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchItemsFromAPI() {
        guard let url = URL(string: "http://localhost:8081/api/tasks") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [ItemModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.items, on: self)
            .store(in: &cancellables)
    }
    

    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let item = items[index]
        guard let id = item.id else { return }
        
        guard let url = URL(string: "http://localhost:8081/api/tasks/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil, error == nil else {
                print("Ошибка при удалении задачи:", error ?? "Неизвестная ошибка")
                return
            }
            
            DispatchQueue.main.async {
                self.items.remove(atOffsets: indexSet)
            }
        }.resume()
    }

    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(description: String) {
        let newTask = CreateTaskDto(description: description)

        guard let url = URL(string: "http://localhost:8081/api/tasks/create") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONEncoder().encode(newTask) else { return }
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Ошибка при добавлении задачи:", error ?? "Неизвестная ошибка")
                return
            }

         
            if let createdTask = try? JSONDecoder().decode(ItemModel.self, from: data) {
                DispatchQueue.main.async {
                    self.items.append(createdTask)
                }
            }
        }.resume()
    }
    
    func updateItem(item: ItemModel) {
        guard let id = item.id else { return }
        let updateStatusDto = UpdateStatusDto(isDone: !item.isDone)

        guard let url = URL(string: "http://localhost:8081/api/tasks/\(id)/status") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONEncoder().encode(updateStatusDto) else { return }
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil, error == nil else {
                print("Ошибка при обновлении статуса:", error ?? "Неизвестная ошибка")
                return
            }
            
            DispatchQueue.main.async {
                if let index = self.items.firstIndex(where: { $0.id == item.id }) {
                    self.items[index] = item.updateCompletion()
                }
            }
        }.resume()
    }

    
    func updateItemTitle(item: ItemModel, newTitle: String) {
        guard let id = item.id else { return }
        let updateDescriptionDto = UpdateDescriptionDto(description: newTitle)

        guard let url = URL(string: "http://localhost:8081/api/tasks/\(id)/description") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONEncoder().encode(updateDescriptionDto) else { return }
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil, error == nil else {
                print("Ошибка при обновлении описания:", error ?? "Неизвестная ошибка")
                return
            }
            
            DispatchQueue.main.async {
                if let index = self.items.firstIndex(where: { $0.id == item.id }) {
                    self.items[index] = ItemModel(id: item.id, description: newTitle, isDone: item.isDone)
                }
            }
        }.resume()
    }


}
