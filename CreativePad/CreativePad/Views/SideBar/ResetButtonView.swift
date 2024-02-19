import SwiftUI

struct ResetButton: View {
    @EnvironmentObject var masterSetting : SettingManager

    var body: some View {
        Button{
            if available() {
                withAnimation(nil){
                    masterSetting.isPausing = true
                    masterSetting.allRecording = false
                }
            }
        } label: {
            Image(systemName: "gobackward")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(available() ? .white : .CustomGray)
                .font(.system(size: 60, weight: .bold))
        }
        
    }
    
    func available() -> Bool {
        return
            !masterSetting.isEditing &&
            !masterSetting.isSetting
    }
}

struct ResetButton_Previews: PreviewProvider {
    static var previews: some View {
        ResetButton()
            .background(.black)
            .environmentObject(SettingManager())
    }
}

#Preview {
    ResetButton_Previews.previews
}
