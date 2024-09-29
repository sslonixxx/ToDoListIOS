import SwiftUI
import UniformTypeIdentifiers
import UIKit

struct DocumentPickerView: UIViewControllerRepresentable {
    
    @ObservedObject var listViewModel: ListViewModel
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.json])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        
        let parent: DocumentPickerView

        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedFileURL = urls.first else { return }
            
            if FileManager.default.fileExists(atPath: selectedFileURL.path) {
                do {
                    let data = try Data(contentsOf: selectedFileURL)
                    let decoder = JSONDecoder()
                    let decodedItems = try decoder.decode([ItemModel].self, from: data)
                    parent.listViewModel.items = decodedItems // Загружаем данные в модель
                    print("Файл успешно открыт")
                } catch {
                    print("Ошибка при открытии файла: \(error.localizedDescription)")
                }
            }
        }
    }
}
