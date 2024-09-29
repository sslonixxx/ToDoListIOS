import SwiftUI

struct ListRowView: View {
    @State private var isEditing: Bool = false
    @State private var editedTitle: String = ""
    let item: ItemModel
    @EnvironmentObject var listViewModel: ListViewModel
   

    var body: some View {
        
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(item.isCompleted ? .green : .red)
                .onTapGesture {
                    withAnimation {
                        listViewModel.updateItem(item: item)
                    }
                }

            if isEditing {
                TextField("Редактировать элемент...", text: $editedTitle, onCommit: {
                    withAnimation {
                        listViewModel.updateItemTitle(item: item, newTitle: editedTitle)
                        isEditing = false
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(item.title)
                    .onTapGesture {
                        editedTitle = item.title
                        isEditing = true
                    }
            }

            Spacer()
        }
        .font(.title2)
        .padding(.vertical, 8)
    }
}

struct ListRowView_PreViws: PreviewProvider {
    static var item1 = ItemModel(title: "First item", isCompleted: false)
    static var item2 = ItemModel(title: "Second item", isCompleted: true)
    static var previews: some View {
        Group {
            ListRowView(item: item1)
            ListRowView(item: item2)
        }
        .previewLayout(.sizeThatFits)
        .environmentObject(ListViewModel()) 
        .environmentObject(AppSettings())
    }
}
