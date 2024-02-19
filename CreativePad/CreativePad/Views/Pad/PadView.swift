import SwiftUI
import Foundation

struct PadView: View {
    @ObservedObject var tracker: ButtonTracker
    private var columns = Array(repeating: GridItem(.flexible(minimum: 0, maximum: 400), spacing: 0, alignment: .center), count: 6)
    
    init(tracker: ButtonTracker) {
        self.tracker = tracker
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(tracker.buttons) { button in
                PadButtonView(buttonObj: button)
            }
        }
        .background(.customGray)
    }
}


struct Pad_Previews: PreviewProvider {
    static var previews: some View {
        PadView(tracker: ButtonTracker(num: 36))
            .scaledToFit()
    }
}

#Preview {
    Pad_Previews.previews
}

