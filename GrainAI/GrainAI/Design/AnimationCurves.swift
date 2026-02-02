import SwiftUI

struct AnimationCurves {
    // Professional, purposeful animations (0.3-0.5s)
    static let standard = Animation.easeInOut(duration: 0.4)
    static let quick = Animation.easeInOut(duration: 0.3)
    static let smooth = Animation.easeInOut(duration: 0.5)
    static let spring = Animation.spring(response: 0.3, dampingFraction: 0.8)
    
    // State transitions
    static let appear = Animation.easeOut(duration: 0.3)
    static let disappear = Animation.easeIn(duration: 0.2)
}
