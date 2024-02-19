import SwiftUI

struct EditView: View {
    @ObservedObject var tracker: ButtonTracker

    init(tracker: ButtonTracker){
        self.tracker = tracker
    }
    
    var body: some View {
        Text("()")
            .background(.blue)
    }
}


struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(tracker: ButtonTracker(num: 36))
            .environmentObject(Recorder())
            .environmentObject(SettingManager())
            .scaledToFit()
    }
}

#Preview {
    EditView_Previews.previews
}
