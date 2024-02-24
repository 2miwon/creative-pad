import SwiftUI

struct StopwatchUnit: View {
    var timeUnit: Int
    var timeUnitStr: String {
        let timeUnitStr = String(timeUnit)
        return timeUnit < 10 ? "0" + timeUnitStr : timeUnitStr
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack(spacing: 0) {
                    Text(timeUnitStr.substring(index: 0))
                        .font(.system(size: 20))
                        .frame(width: 20)
                    Text(timeUnitStr.substring(index: 1))
                        .font(.system(size: 20))
                        .frame(width: 20)
                }
            }
        }
    }
}

extension String {
    func substring(index: Int) -> String {
        let arrayString = Array(self)
        return String(arrayString[index])
    }
}

struct StopWatchView: View {
    var time: TimeInterval
    
    var minutes: Int {
        Int(abs(time.rounded())) / 60
    }
    var seconds: Int {
        Int(abs(time.rounded()).truncatingRemainder(dividingBy: 60))
    }
    var miliseconds: Int {
        Int(abs(time * 100).rounded().truncatingRemainder(dividingBy: 100))
    }
    @State var dateFormatter = DateFormatter()
        
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                if time < 0 {
                    Text("-")
                }
                StopwatchUnit(timeUnit: minutes)
                Text(":")
                    .font(.system(size: 12))
                StopwatchUnit(timeUnit: seconds)
                Text(":")
                    .font(.system(size: 12))
                StopwatchUnit(timeUnit: miliseconds)
                
            }
            .onAppear {
                dateFormatter.dateFormat = "m:s.SS"
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Current Position \(dateFormatter.string(from: dateFormatter.date(from: "\(minutes):\(seconds).\(miliseconds)") ?? Date()))")
            
        }
    }
}

#Preview {
    StopWatchView(time: 132)
}
