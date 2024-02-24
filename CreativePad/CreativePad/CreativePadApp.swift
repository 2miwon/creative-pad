//
//  CustomTunesApp.swift
//  CustomTunes
//
//  Created by macheewon on 12/13/23.
//

import SwiftUI

@main
struct CreativePadApp: App {
    @StateObject var masterSetting = SettingManager()
    @StateObject var masterMic = Recorder()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(masterSetting)
                .environmentObject(masterMic)
        }
    }
}
