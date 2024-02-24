import SwiftUI

struct EditView: View {
    @ObservedObject var tracker: ButtonTracker
    @EnvironmentObject var masterSetting: SettingManager
    var speed = [0.75, 1.0, 1.25, 1.5, 2.0]
    var pitch  = [-300.0, -200.0, -100.0, 0, 100.0, 200.0, 300.0]
    init(tracker: ButtonTracker){
        self.tracker = tracker
    }
    

    
    var body: some View {
        if let selected = tracker.selectedButton {
            VStack{
                Button(){
                    tracker.selectedButton?.deleteFile()
                    tracker.selectedButton?.color = .CustomLightGray
                    tracker.unselect()
                    tracker.renew()
                } label: {
                    Text("Delete")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                .padding()
                
                ColorPicker("Choose a Color", selection: Binding<Color>(
                    get: { selected.color },
                    set: { newValue in selected.color = newValue }
                ))
                
                HStack {
                    Text("Volumn")
                    Slider(value: Binding<Float>(
                        get: { selected.volume },
                        set: { newValue in selected.volume = newValue }
                    ))
                }
                HStack {
                    Text("Speed")
                    Picker("Choose a speed", selection: Binding<Double>(
                        get: { selected.speed },
                        set: { newValue in selected.speed = newValue }
                    )) {
                        ForEach(speed, id: \.self) { value in
                            Text("\(String(format: "%g", value))")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                HStack {
                    Text("Pitch")
                    Picker("Choose a pitch", selection: Binding<Double>(
                        get: { selected.pitch },
                        set: { newValue in selected.pitch = newValue }
                    )) {
                        ForEach(pitch, id: \.self) { value in
                            Text("\(formatPitchValue(value))")
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding(3)
            .foregroundColor(.white)
            
            
            Spacer()
        } else {
            Text("please select button")
                .foregroundColor(.white)
        }
        
        
    }

}

func formatPitchValue(_ value: Double) -> String {
    if value > 0 {
        return "+\(String(format: "%g", (value / 100)))"
    } else {
        return "\(String(format: "%g", (value / 100)))"
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        var tracker = ButtonTracker(num: 36)
//        HStack{
//            Toggle("Mute", isOn: Binding<Bool>(
//                               get: { tracker.selectedButton?.isMute ?? false },
//                               set: { newValue in tracker.selectedButton?.isMute = newValue }
//                           ))
//        }
//        .foregroundColor(.white)
        EditView(tracker: tracker)
            .environmentObject(Recorder())
            .environmentObject(SettingManager())
            .scaledToFit()
            .background(.black)
    }
}

#Preview {
    EditView_Previews.previews
}
