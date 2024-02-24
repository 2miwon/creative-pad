import SwiftUI

struct SettingView: View {
    @EnvironmentObject var masterSetting: SettingManager
    
    var body: some View {
        VStack{
            Group {
                HStack {
                    Text("Master Volume")
                    Slider(value: $masterSetting.masterVolumn)
                }
                HStack{
                    Toggle("Mute", isOn: $masterSetting.isMute )
                }
                HStack{
                    Toggle("Mic Record Auto Save", isOn: $masterSetting.autoSave )
                }
                Spacer()
                Text("Made By Heewon Lim")
            }
            .padding(3)
            .foregroundColor(.white)
        }
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(SettingManager())
            .scaledToFit()
            .background(.black)
    }
}

#Preview {
    SettingView_Previews.previews
}
