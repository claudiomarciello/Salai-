
import UIKit

struct FixEmptyTarget {

    init() {
        // If you remove this line that makes use of `TodayViewController`, `TodayViewController`
        // (which is referenced in MainInterface.storyboard) will not be accessible at run time,
        // and the following will print to the console when running using the TodayExtension scheme:
        //
        // > Unknown class _TtC19SharedExtensionCode19TodayViewController in Interface Builder file.
        _ = Peppe()
    }
}
