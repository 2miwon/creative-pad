import SwiftUI

struct MuteButton: View {
    @EnvironmentObject var masterSetting : SettingManager
    
    var body: some View {
        Button{
            if available() {
                masterSetting.isMute.toggle()
            }
        } label: {
            VStack{
                Image(systemName: "speaker.slash.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(available() ? .white : .CustomGray)
                    .font(.system(size: 60, weight: masterSetting.isMute ? .regular : .thin))
                    .shadow(color: masterSetting.isMute ? .white : .clear, radius: 20, x: 0, y: 0)

                if masterSetting.isMute {
                    Text("Mute")
                        .scaledToFit()
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    func available() -> Bool {
        return
            true
    }
}

struct MuteButton_Previews: PreviewProvider {
    static var previews: some View {
        MuteButton()
            .background(.black)
            .environmentObject(SettingManager())
    }
}

#Preview {
    MuteButton_Previews.previews
}
