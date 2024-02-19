import SwiftUI

struct FileListView: View {
    @State private var fileURLs: [URL] = []
    @State var showAlert = false
    @State private var deletionIndexSet: IndexSet?
    
    func delete(at offsets: IndexSet) {
        showAlert = true
        deletionIndexSet = offsets
    }

    func deleteFile(at index: Int) {
        let fileURL = fileURLs[index]
        do {
            try FileManager.default.removeItem(at: fileURL)
            fileURLs.remove(at: index)
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        ZStack{
            List {
                ForEach(fileURLs, id: \.self) { fileURL in
                    ShareLink(item: MusicURL(text: fileURL.lastPathComponent).url) {
                        Text(fileURL.lastPathComponent)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color.white)
                        
                    }
                    .listRowBackground(Color.black)
                }
                .onDelete(perform: delete)
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    showAlert.toggle()
                } label: {
                    Label("Delete", systemImage: "trash.circle")
                }
                .tint(.red)
                .accessibilityLabel("Delete")
                .padding()
            }
            .alert("Are you sure you want to delete this file?", isPresented: $showAlert, actions: {
                Button("Delete", role: .destructive) {
                    if let indexSet = deletionIndexSet {
                        for index in indexSet {
                            deleteFile(at: index)
                        }
                    }
                }
            })
            .background(.customGray)
            .scrollContentBackground(.hidden)
            .onAppear {
                DispatchQueue.global().async {
                    if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        do {
                            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
                            self.fileURLs = fileURLs
                        } catch {
                            print("Error while enumerating files \(documentsUrl.path): \(error.localizedDescription)")
                        }
                    }
                }
            }
            if fileURLs.isEmpty{
                Text("has no file")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color.white)
            }
        }
    }
}


struct FileListView_Previews: PreviewProvider {
    static var previews: some View {
        FileListView()
    }
}

#Preview {
    RecordingView_Previews.previews
}
