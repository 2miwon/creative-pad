//
//  CustomTunesApp.swift
//  CustomTunes
//
//  Created by macheewon on 12/13/23.
//

import SwiftUI

@main
struct CreativePadApp: App {
    let masterSetting = SettingManager()
    let masterMic = Recorder()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(masterSetting)
                .environmentObject(masterMic)
        }
    }
}
