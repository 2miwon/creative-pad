import SwiftUI

struct ButtonSetting: View {
    @EnvironmentObject var masterSetting : SettingManager
    @ObservedObject var tracker: ButtonTracker
    
    init(tracker: ButtonTracker){
        self.tracker = tracker
    }
    
    var body: some View {
        Button {
            if available() {
                if masterSetting.isEditing {
                    self.off()
                } else {
                    masterSetting.isEditing = true
                }
                masterSetting.isSetting = false
                masterSetting.isFile = false
//                if masterSetting.isEditing {
//                    masterSetting.isPausing = true
//                }
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

    func off(){
        tracker.unselect()
        masterSetting.isEditing = false
    }
    
    func on(){
//        tracker.unselect()
    }
}

struct ButtonSetting_Previews: PreviewProvider {
    static var previews: some View {
        ButtonSetting(tracker: ButtonTracker(num: 36))
            .background(.black)
            .environmentObject(SettingManager())
    }
}

#Preview {
    ButtonSetting_Previews.previews
}
