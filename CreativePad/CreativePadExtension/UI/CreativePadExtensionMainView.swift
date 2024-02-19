//
//  CreativePadExtensionMainView.swift
//  CreativePadExtension
//
//  Created by macheewon on 1/22/24.
//

import SwiftUI

struct CreativePadExtensionMainView: View {
    var parameterTree: ObservableAUParameterGroup
    
    var body: some View {
        ParameterSlider(param: parameterTree.global.gain)
    }
}
