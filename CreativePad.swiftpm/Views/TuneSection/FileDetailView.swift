import SwiftUI

struct FileDetailView: View {
    var body: some View {
            VStack(alignment: .leading) {
                Form {
                    Section("Name") {
//                        TextField("Name", text: "s")
                    }
                    Section("Date") {
                    }
                    Section("Length") {
//                        TextField("")
                    }
                    

                }
                
            }
            .toolbar {
                ToolbarItem {
                    Button("commit") {
                    }
                }
            }
        }
}

struct FileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack() {
            FileDetailView()
        }
    }
}

