import SwiftUI

@main
struct CreativePadApp: App {
    @StateObject var masterSetting = SettingManager()
    @StateObject var masterRec = Recorder()
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
                    .onAppear {
                        createDirectory()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else {
                ContentView()
                    .environmentObject(masterSetting)
                    .environmentObject(masterRec)
            }
        }
    }
}
