import SwiftUI

struct MasterSetting: View {
    @EnvironmentObject var masterSetting : SettingManager

    var body: some View {
        Button {
            if available() {
                masterSetting.isSetting.toggle()
                masterSetting.isEditing = false
                masterSetting.isFile = false
            }
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(available() ? .white : .CustomGray)
                .shadow(color: masterSetting.isSetting ? .white : .clear, radius: 20, x: 0, y: 0)

        }
    }
    
    func available() -> Bool {
        return
            !masterSetting.allRecording
    }
}

struct MasterSetting_Previews: PreviewProvider {
    static var previews: some View {
        MasterSetting()
            .background(.black)
            .environmentObject(SettingManager())
    }
}

#Preview {
    MasterSetting_Previews.previews
}

