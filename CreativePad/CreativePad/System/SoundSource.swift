import Foundation

typealias SoundSource = String

extension String {
    var urlSound: URL? {
        var resourceURL = Bundle.main.url(forResource: self, withExtension: "caf")
        
#if DEBUG
        if resourceURL == nil {
            for framework in Bundle.allFrameworks {
                resourceURL = framework.url(forResource: self, withExtension: "caf")
                
                if resourceURL != nil {
                    break
                }
            }
        }
#endif
        return resourceURL
    }
}
