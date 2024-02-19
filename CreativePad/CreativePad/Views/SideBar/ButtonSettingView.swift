import SwiftUI

struct ButtonSetting: View {
    @EnvironmentObject var masterSetting : SettingManager
    
    var body: some View {
        Button {
            if available() {
                masterSetting.isEditing.toggle()
                masterSetting.isSetting = false
                masterSetting.isFile = false
                if masterSetting.isEditing {
                    masterSetting.isPausing = true
                }
            }
        } label: {
            Image(systemName: "slider.horizontal.2.square")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(available() ? .white : .CustomGray)
                .shadow(color: masterSetting.isEditing ? .white : .clear, radius: 20, x: 0, y: 0)
        }
    }
    
    func available() -> Bool {
        return
            !masterSetting.allRecording
    }
}

struct ButtonSetting_Previews: PreviewProvider {
    static var previews: some View {
        ButtonSetting()
            .background(.black)
            .environmentObject(SettingManager())
    }
}

#Preview {
    ButtonSetting_Previews.previews
}
